{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    optionalString
    escapeShellArg
    ;

  cfg = config.services.obsidianBackup;

  backupScript = pkgs.writeShellApplication {
    name = "obsidian-backup";
    runtimeInputs = with pkgs; [
      bash
      coreutils
      findutils
      gnutar
      gzip
      git
      systemd
      libnotify
      hostname
      openssh
    ];

    text = ''
      set -Eeuo pipefail

      SOURCE_DIR=${escapeShellArg cfg.sourceDir}
      REPO_DIR=${escapeShellArg cfg.repoDir}
      BACKUP_DIR="$REPO_DIR/${escapeShellArg cfg.backupSubdir}"
      STATE_DIR="''${XDG_STATE_HOME:-$HOME/.local/state}/obsidian-backup"
      RETRY_FILE="$STATE_DIR/retry-count"

      HOSTNAME_SHORT="$(hostname -s)"
      TIMESTAMP="$(date '+%Y-%m-%dT%H-%M-%S')"
      ARCHIVE_NAME="obsidian-$HOSTNAME_SHORT-$TIMESTAMP.tar.gz"
      TMP_ARCHIVE="$(mktemp "/tmp/$ARCHIVE_NAME.XXXXXX")"
      FINAL_ARCHIVE="$BACKUP_DIR/$ARCHIVE_NAME"

      notify() {
        local title="$1"
        local body="$2"
        if command -v notify-send >/dev/null 2>&1; then
          notify-send "$title" "$body"
        fi
      }

      cleanup() {
        rm -f "$TMP_ARCHIVE"
      }
      trap cleanup EXIT

      get_retry_count() {
        if [[ -f "$RETRY_FILE" ]]; then
          cat "$RETRY_FILE"
        else
          echo 0
        fi
      }

      set_retry_count() {
        mkdir -p "$STATE_DIR"
        printf '%s' "$1" > "$RETRY_FILE"
      }

      clear_retry_count() {
        rm -f "$RETRY_FILE"
      }

      next_delay_hours() {
        local retry_count="$1"
        local hours=$(( 2 ** (retry_count - 1) ))
        local max_hours=${toString cfg.maxRetryHours}
        if (( hours > max_hours )); then
          hours="$max_hours"
        fi
        echo "$hours"
      }

      setup_git_ssh() {
        export GIT_TERMINAL_PROMPT=0
        ${optionalString (cfg.sshKeyPath != null) ''
          export GIT_SSH_COMMAND="ssh -F /dev/null -i ${escapeShellArg cfg.sshKeyPath} \
                    -o IdentitiesOnly=yes \
                    -o IdentityAgent=none \
                    -o BatchMode=yes \
                    -o PreferredAuthentications=publickey"
        ''}
      }

      schedule_retry() {
        local retry_count
        retry_count="$(get_retry_count)"
        retry_count=$(( retry_count + 1 ))
        set_retry_count "$retry_count"

        local delay_hours
        delay_hours="$(next_delay_hours "$retry_count")"

        systemd-run --user \
          --unit=obsidian-backup-retry \
          --on-active="$''${delay_hours}h" \
          systemctl --user start obsidian-backup.service

        notify \
          "Obsidian backup failed" \
          "Retry #$retry_count scheduled in $delay_hours hour(s)."
      }

      run_backup() {
        mkdir -p "$BACKUP_DIR" "$STATE_DIR"

        if [[ ! -d "$SOURCE_DIR" ]]; then
          echo "Source directory does not exist: $SOURCE_DIR" >&2
          return 1
        fi

        if [[ ! -d "$REPO_DIR/.git" ]]; then
          echo "Backup repository is not a git repository: $REPO_DIR" >&2
          return 1
        fi

        tar \
          --exclude='./.stfolder' \
          --exclude='./.stversions' \
          --exclude='./.trash' \
          -C "$SOURCE_DIR" \
          -czf "$TMP_ARCHIVE" .
        mv "$TMP_ARCHIVE" "$FINAL_ARCHIVE"

        cd "$REPO_DIR"

        ${optionalString (cfg.maxBackups != null) ''
          find "$BACKUP_DIR" -maxdepth 1 -type f -name '*.tar.gz' -printf '%T@ %p\n' \
            | sort -nr \
            | tail -n +$(( ${toString cfg.maxBackups} + 1 )) \
            | cut -d' ' -f2- \
            | xargs -r rm -f --
        ''}

        git add ${escapeShellArg cfg.backupSubdir}

        if ! git diff --cached --quiet; then
          if ! git commit -m "Obsidian backup $TIMESTAMP"; then
            echo "git commit failed" >&2
            return 1
          fi
        fi

        setup_git_ssh

        if ! git_push_output="$(git push --porcelain origin HEAD 2>&1)"; then
          echo "git push failed: $git_push_output" >&2
          return 1
        fi

        clear_retry_count

        systemctl --user stop obsidian-backup-retry.timer 2>/dev/null || true
        systemctl --user stop obsidian-backup-retry.service 2>/dev/null || true
        systemctl --user reset-failed obsidian-backup-retry.timer 2>/dev/null || true
        systemctl --user reset-failed obsidian-backup-retry.service 2>/dev/null || true

        notify \
          "Obsidian backup succeeded" \
          "Archive created and pushed successfully."
      }

      if ! output="$(run_backup 2>&1)"; then
        echo "$output" >&2
        notify "Obsidian backup failed" "$output"
        schedule_retry
        exit 1
      fi

      echo "$output"
    '';
  };

in
{
  options.services.obsidianBackup = {
    enable = mkEnableOption "scheduled Obsidian backup to a git repository";

    sourceDir = mkOption {
      type = types.str;
      default = "${config.home.homeDirectory}/.local/sync/obsidian";
      description = "Directory to archive.";
    };

    repoDir = mkOption {
      type = types.str;
      default = "${config.home.homeDirectory}/.local/share/obsidian-backup-repo";
      description = "Local clone of the private git repository receiving backups.";
    };

    backupSubdir = mkOption {
      type = types.str;
      default = "backups";
      description = "Subdirectory inside repoDir where archives are stored.";
    };

    interval = mkOption {
      type = types.str;
      default = "7d";
      example = "7d";
      description = "Regular backup interval for the systemd user timer.";
    };

    maxRetryHours = mkOption {
      type = types.int;
      default = 24;
      description = "Maximum retry delay in hours for exponential backoff.";
    };

    maxBackups = mkOption {
      type = types.nullOr types.int;
      default = 8;
      description = "How many newest archives to keep. Null keeps all.";
    };

    sshKeyPath = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "${config.home.homeDirectory}/.ssh/github-obsidian-backup";
      description = "Optional SSH key path used for unattended git push.";
    };

    startOnBootDelay = mkOption {
      type = types.str;
      default = "10min";
      description = "Delay after boot before the timer becomes active.";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.obsidian-backup = {
      Unit = {
        Description = "Obsidian backup";
        After = [ "network-online.target" ];
        Wants = [ "network-online.target" ];
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${backupScript}/bin/obsidian-backup";
      };
    };

    systemd.user.timers.obsidian-backup = {
      Unit = {
        Description = "Scheduled Obsidian backup";
      };

      Timer = {
        OnBootSec = cfg.startOnBootDelay;
        OnUnitActiveSec = cfg.interval;
        Persistent = true;
        Unit = "obsidian-backup.service";
      };

      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
  };
}
