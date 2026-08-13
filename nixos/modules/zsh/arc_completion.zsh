#compdef arc

_arc() {
  local state line desc modes context curcontext="$curcontext" ret=1
  local words_orig=("${words[@]}")
  local current_orig="$((CURRENT - 1))"
  local prefix_orig="$PREFIX"
  local suffix_orig="$SUFFIX"

  _arguments -C \
    '(- : *)'{-h,--help}'[show help information]' \
    '(- : *)'{-v,--version}'[display version information]' \
    '(- : *)--svnrevision[show build information]' \
    '(-v --version -h --help --svnrevision)1: :->modes' \
    '(-v --version -h --help --svnrevision)*:: :->args' \
    && ret=0

  case $state in
    modes)
      desc='modes'
      modes=(
      )

      desc='start a working area'
      modes=(
        'mount':'Initialize environment with virtual working tree'
        'unmount':'Close environment for a local repository with virtual working tree'
        'sync':'Synchronize working copy with remote one'
        'init':'Initialize environment for a local or bare repository'
        'monitor':'Monitor file events in working tree for a local or bare repository to speed up status'
      )
      _describe -t 'mode-group-1' $desc modes

      desc='work on the current change'
      modes=(
        'add':'Add file contents to the index'
        'clean':'Remove untracked files from the working tree'
        'cp':'Copy a file, a directory, or a symlink'
        'encrypt':'Encrypt file'
        'mergetool':'Run merge conflict resolution tools to resolve merge conflicts'
        'mv':'Move or rename a file, a directory, or a symlink'
        'reset':'Reset current HEAD to the specified state'
        'rm':'Remove files from the working tree and from the index'
        'stash':'Stash changes, list or apply existing stashes'
        'copy-info':'Modify copy info of a single file or directory'
      )
      _describe -t 'mode-group-2' $desc modes

      desc='examine the history and state'
      modes=(
        'bisect':'Use binary search to find the commit that introduced a bug'
        'blame':'Show what revision and author last modified each line of a file'
        'praise':'Show what revision and author last modified each line of a file to praise them'
        'describe':'Describe a commit using the most recent tag reachable from it'
        'diff':'Show changes between commits, commit and working tree, etc'
        'difftool':'View diff using difftools'
        'ls-files':'Show information about files in the index and the working tree'
        'log':'Show commit logs'
        'reflog':'Show reflogs'
        'merge-base':'Show commits'' merge base'
        'root':'Show working tree root'
        'show':'Show various types of objects'
        'status':'Show the working tree status'
      )
      _describe -t 'mode-group-3' $desc modes

      desc='grow, mark and tweak your common history'
      modes=(
        'branch':'Manage branches\: list, create, delete, etc'
        'checkout':'Switch to another branch, commit or revision. Or restore working tree files, e.g. undo changes'
        'cherry-pick':'Apply the changes introduced by some existing commits'
        'commit':'Record changes to the repository'
        'rebase':'Forward-port local commits to the updated upstream head'
        'revert':'Revert some existing commits'
        'tag':'Create or list tags'
      )
      _describe -t 'mode-group-4' $desc modes

      desc='collaborate'
      modes=(
        'submit':'Submit changes for review'
        'up':'Update to the freshest trunk'
        'fetch':'Download refs from remote repository'
        'unfetch':'Remove local entries of remote refs'
        'pr':'Create, discard, list or checkout pull-requests'
        'pull':'Fetch from remote repository and integrate with a local branch'
        'push':'Update remote refs along with associated objects'
      )
      _describe -t 'mode-group-5' $desc modes

      desc='verify, analyse and manage objects'
      modes=(
        'fsck':'Verifies the connectivity and validity of the objects in the database'
        'export':'Exports a named tree'
        'gc':'Cleanup object store'
      )
      _describe -t 'mode-group-6' $desc modes

      desc='internal operations'
      modes=(
        'config':'Manage user configuration'
        'dump':'Various debug information'
        'gen-key':'Generate new encryption key and store it in YAV'
        'help':'Show documentation'
        'info':'Show current branch information'
        'ls-tree':'List the contents of a tree object'
        'rev-parse':'Parse revision or revision range'
        'token':'Acquire arc oauth token with ssh key'
        'internal':'Internal operations'
        'prefetch-files':'Prefetch files'
        'repair-command'
        'list-commands':'List arc commands in JSON'
        'user-info':'Show information about current user'
        'completion':'generate autocompletion files'
      )
      _describe -t 'mode-group-7' $desc modes

      desc='launcher operations'
      modes=(
        '--update':'Update arc client'
        '--has-update':'Check whether arc client update is available'
        '--set-channel':'Set arc client release channel \[stable, prestable, unstable, testing\]'
        '--is-launcher':'Check whether arc client is run through launcher script'
        '--remove-unused-versions':'Remove old arc client releases'
      )
      _describe -t 'mode-group-8' $desc modes

      ;;
    args)
      case $line[1] in
        'mount')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--server)--server[address of vcs data service]: :_default' \
            '(--port -p)'{'-p','--port'}'[port of vcs data service]: :_default' \
            '(--ssl)--ssl[use ssl connection to server]: :_default' \
            '(--log)--log[path to log file]: :_default' \
            '(--json-trace)--json-trace[path to json trace (chromium format) file]: :_default' \
            '(--store-config --object-store-type)--object-store-type[object store type (possible values\: ''default'', ''sharded'')]: :_default' \
            '(--pull-server)--pull-server[address of vcs pull service]: :_default' \
            '(--pull-port)--pull-port[port of vcs pull service]: :_default' \
            '(--pull-ssl)--pull-ssl[use ssl connection to pull service]: :_default' \
            '(--arcanum-url)--arcanum-url[arcanum api endpoint url]:URL:_default' \
            '(-r --repository)'{'-r','--repository'}'[name of the repository]:NAME:_default' \
            '(--local)--local[initialize local repository]' \
            '(-m --mount)'{'-m','--mount'}'[mount path]:PATH:_default' \
            '(--foreground -F)'{'-F','--foreground'}'[run FUSE in foreground mode]' \
            '(--debug -D)'{'-D','--debug'}'[enable debug logs]' \
            '(--allow-root)--allow-root[allow root access to the mounted filesystem; cannot be used with --allow-other]' \
            '(--allow-other)--allow-other[all users (including root) can access the files in FUSE; cannot be used with --allow-root]' \
            '(--no-auto-unmount)--no-auto-unmount[disable auto_unmount option]' \
            '(--read-only)--read-only[mount filesystem read-only]' \
            '(-o)-o[extra mount option (advanced)]:OPTION:_default' \
            '(--vfs-version)--vfs-version[\[DEPRECATED\] Does nothing]:VERSION:_default' \
            '(--inode-cache-size)--inode-cache-size[inode cache items]:NUM:_default' \
            '(--overlay-rocks-block-cache-size)--overlay-rocks-block-cache-size[overlay rocksdb block cache size]:BYTES:_default' \
            '(--fuse-threads)--fuse-threads[number of FUSE io threads]:NUM:_default' \
            '(--fuse-timeout)--fuse-timeout[timeout for fuse operations]:TIME:_default' \
            '(--no-aggressive-delete)--no-aggressive-delete[(mac only) do not delete data after last RELEASE or UNLINK, wait until FORGET]' \
            '(--invalidate-inodes)--invalidate-inodes[(mac only) invalidate inodes on closing files]' \
            '(--checkout-prepared-timeout)--checkout-prepared-timeout[timeout before prepared checkout is destroyed]: :_default' \
            '(--object-store)--object-store[shared store for storing objects of multiple mounts]:PATH:_default' \
            '(--override-object-store)--override-object-store[allow override object store path using ''--object-store'' option]' \
            '(--path-filter)--path-filter[(experimental) path filter for selective checkout]:PATH:_default' \
            '(-C --cache-size)'{'-C','--cache-size'}'[memory size for cache in bytes]:BYTES:_default' \
            '(--monitoring-port)--monitoring-port[start monitoring server on port]::PORT:_default' \
            '(--ssh-tokens --no-ssh-tokens)--ssh-tokens[force arc to use ssh to get YAV and ARC tokens \[optionally specify path to ssh key\]]::PATH:_default' \
            '(--ssh-tokens --no-ssh-tokens)--no-ssh-tokens[force disable arc to use ssh to get YAV and ARC tokens]' \
            '(--disable-mount-manager)--disable-mount-manager[do not manage given mount point and disable mount checks]::BOOL:_default' \
            '(--new-overlay)--new-overlay[creates new overlay to decrease local repository load]:: :(( ''disabled''\:''disable creating new overlay'' ''backup''\:''create new overlay and store old as backup'' ''no-backup''\:''create new overlay without backup''))' \
            '(--list -l)'{'-l','--list'}'[show list of managed mount points]' \
            '(--json)--json[output in json format]' \
            '(--auth-type)--auth-type[authentication type (possible values\: passport)]: :_default' \
            '(--preset)--preset[preset containing default config values]: :_default' \
            '1:\[MOUNT_POINT\]:_default' \
            && ret=0
          ;;
        'unmount'|'umount')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--forget)--forget[\[USE WITH CAUTION\] remove mount from .arc/moint-points and remove corresponding storage]' \
            '(--list -l)'{'-l','--list'}'[show list of mounted and unmounted repositories]' \
            '(--force -f)'{'-f','--force'}'[force unmount repository]' \
            '1:ARG:_default' \
            && ret=0
          ;;
        'sync'|'wave-stash')
          _arguments -C \
            '(- : *)'{-h,--help}'[show help information]' \
            '(-v --version -h --help --svnrevision)1: :->modes' \
            '(-v --version -h --help --svnrevision)*:: :->args' \
            && ret=0

          case $state in
            modes)
              desc='modes'
              modes=(
                'start':'start sync'
                'follow':'follow'
                'stop':'stop sync'
                'status':'sync status'
                'update':'do force update'
              )
              _describe -t 'mode-group-0' $desc modes

              ;;
            args)
              case $line[1] in
                'start'|'begin')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--include-untracked -u)'{'-u','--include-untracked'}'[sync untracked files]' \
                    '(--domain --wave-branch)--wave-branch[use special branch for synchronization]: :_default' \
                    '(--domain --wave-branch)--domain[prefix automatically generated branch with the given token (e. g. codenv)]: :_default' \
                    '(--foreground -f)'{'-f','--foreground'}'[run sync in foreground mode]' \
                    '(-n --interval)'{'-n','--interval'}'[sync interval]:SECONDS:_default' \
                    '(--remote-follow -r)'{'-r','--remote-follow'}'[also try to run follower on the remote host using PATH. Run ssh-agent before using it.]:HOST[\:PORT]\:PATH:_default' \
                    '(--force-follow)--force-follow[discard all changes for the remote follower when using option `--remote-follow`]' \
                    && ret=0
                  ;;
                'follow')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(-n --interval)'{'-n','--interval'}'[poll interval]:SECONDS:_default' \
                    '(--foreground -f)'{'-f','--foreground'}'[run following in foreground]' \
                    '(--force)--force[discard all local changes]' \
                    '(--wait-wave)--wait-wave[wait for wave-branch to appear if it does not exist]:SECONDS:_default' \
                    '(--remote -r)'{'-r','--remote'}'[run this command on the remote host. If REF is not specified, will follow current sync-master.]:HOST[\:PORT]\:PATH:_default' \
                    '1:REF:_default' \
                    && ret=0
                  ;;
                'stop'|'finish')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--force -f)'{'-f','--force'}'[force stop synchronization]' \
                    '(--no-wait)--no-wait[do not wait for the actual completion of the sync]' \
                    '(--remote -r)'{'-r','--remote'}'[run this command on the remote host. Run ssh-agent before using it.]:HOST[\:PORT]\:PATH:_default' \
                    && ret=0
                  ;;
                'status'|'st')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--json)--json[print status in json format]' \
                    '(--remote -r)'{'-r','--remote'}'[run this command on the remote host. Run ssh-agent before using it.]:HOST[\:PORT]\:PATH:_default' \
                    && ret=0
                  ;;
                'update'|'up')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(-r --wait-remote)'{'-r','--wait-remote'}'[wait for remote repository to update. Run ssh-agent before using it]:HOST[\:PORT]\:PATH:_default' \
                    && ret=0
                  ;;
              esac
              ;;
          esac
          ;;
        'init')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--server -s)'{'-s','--server'}'[address of arc service]: :_default' \
            '(--port -p)'{'-p','--port'}'[port of arc data service]: :_default' \
            '(--ssl)--ssl[use ssl connection to server]: :_default' \
            '(-r --repository)'{'-r','--repository'}'[name of the repository]: :_default' \
            '(--store-config -c --object-store-type)--object-store-type[object store type (possible values\: ''default'', ''sharded'')]: :_default' \
            '(--bare --local)--bare[initialize bare repository]' \
            '(--object-store)--object-store[shared store for storing objects of multiple mounts]:PATH:_default' \
            '(--auth-type)--auth-type[authentication type (possible values\: passport)]: :_default' \
            '(--preset)--preset[preset containing default config values]: :_default' \
            '(--branch -b --at)--at[initial branch/commit/revision (use this instead of `--branch`)]: :_default' \
            '(--skip-prefetch)--skip-prefetch[skip prefetch files when branch is being checkouted]' \
            '(--path-filter-file --path-filter)--path-filter[path filter for selective checkout]:PATH:_default' \
            '(--path-filter-file --path-filter)--path-filter-file[path filter file for selective checkout]:PATH:_default' \
            '1:ARG:_default' \
            && ret=0
          ;;
        'monitor')
          _arguments -C \
            '(- : *)'{-h,--help}'[show help information]' \
            '(-v --version -h --help --svnrevision)1: :->modes' \
            '(-v --version -h --help --svnrevision)*:: :->args' \
            && ret=0

          case $state in
            modes)
              desc='modes'
              modes=(
                'start':'start monitoring'
                'stop':'stop monitoring'
                'setup':'on/off monitoring for repository'
              )
              _describe -t 'mode-group-0' $desc modes

              ;;
            args)
              case $line[1] in
                'start')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--foreground -f)'{'-f','--foreground'}'[run monitor in foreground mode]' \
                    '(--new-index)--new-index[recreate file index database]' \
                    && ret=0
                  ;;
                'stop')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--force -f)'{'-f','--force'}'[force stop FsMonitor]' \
                    '(--no-wait)--no-wait[do not wait for stopping FsMonitor]' \
                    && ret=0
                  ;;
                'setup')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--on --auto --off)--on[enable FsMonitor for repository]' \
                    '(--on --auto --off)--off[disable FsMonitor for repository]' \
                    '(--on --off --auto)--auto[enable and autorestart FsMonitor for repository]' \
                    && ret=0
                  ;;
              esac
              ;;
          esac
          ;;
        'add')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--chmod -F --all -A)'{'-A','--all'}'[add changes from all tracked and untracked files]' \
            '(--dry-run -n)'{'-n','--dry-run'}'[dry run]' \
            '(--force -f)'{'-f','--force'}'[add even ignored files]' \
            '(--chmod -p -F --patch)'{'-p','--patch'}'[interactively choose hunks of patch]' \
            '(--chmod -F -u --update)'{'-u','--update'}'[update tracked files]' \
            '(-v --verbose)'{'-v','--verbose'}'[be verbose]' \
            '(--ignore-removal)--ignore-removal[ignore paths removed in the working tree]' \
            '(-p --chmod --patch -u --all -A --update)--chmod[(\+x|-x) Override executable flag only in stage. File content is untouched in stage and on disk. New files are added with their content.]: :_default' \
            '(-p --patch -F -u --all -A --update)-F[add content of file to index, usually used to stage partial changes of file]:path:_default' \
            '*:PATH:_default' \
            && ret=0
          ;;
        'clean')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(-q --quiet)'{'-q','--quiet'}'[do not print names of files removed]' \
            '(--dry-run -n)'{'-n','--dry-run'}'[dry run]' \
            '(-d)-d[remove untracked directories]' \
            '(-x)-x[remove ignored files, too]' \
            '(-X)-X[remove only ignored files]' \
            '*:ARG:_default' \
            && ret=0
          ;;
        'cp')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--force -f)'{'-f','--force'}'[force copy even if target exists]' \
            '(-r)-r[allow recursive copy]' \
            '(--cached)--cached[record a copy that has already occurred (copy in index), not applicable with -r option]' \
            '*:ARG:_default' \
            && ret=0
          ;;
        'encrypt')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '1:SECRETID:_default' \
            '*:PATH:_default' \
            && ret=0
          ;;
        'mergetool')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(-t --tool)'{'-t','--tool'}'[specify tool to run]: :_default' \
            '(--tool-help)--tool-help[list available merge tools]' \
            '(--no-prompt -y)'{'-y','--no-prompt'}'[do not prompt]' \
            '*:ARG:_default' \
            && ret=0
          ;;
        'mv')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--force -f)'{'-f','--force'}'[force move/rename even if target exists]' \
            '(-k)-k[skip move/rename errors]' \
            '(--cached)--cached[record a rename that has already occurred (move in index)]' \
            '*:ARG:_default' \
            && ret=0
          ;;
        'reset')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--hard --mixed --soft --clean)--hard[reset HEAD, index and working tree]' \
            '(--hard --soft --mixed --clean)--mixed[reset HEAD and index]' \
            '(-q --quiet)'{'-q','--quiet'}'[be quiet, only report errors]' \
            '(--hard --mixed --soft --clean)--soft[reset only HEAD]' \
            '(--force -f)'{'-f','--force'}'[Reset even if prohibited by config]' \
            '1:BRANCH:_arc__completer_1' \
            '*:PATH:_default' \
            && ret=0
          ;;
        'rm')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--dry-run -n)'{'-n','--dry-run'}'[dry run]' \
            '(-q --quiet)'{'-q','--quiet'}'[do not list removed files]' \
            '(--cached)--cached[only remove from the index]' \
            '(-r)-r[allow recursive removal]' \
            '(--force -f)'{'-f','--force'}'[override the up-to-date check]' \
            '(--ignore-unmatch)--ignore-unmatch[exit with a zero status even if nothing matched]' \
            '*:ARG:_default' \
            && ret=0
          ;;
        'stash')
          _arguments -C \
            '(- : *)'{-h,--help}'[show help information]' \
            '(-v --version -h --help --svnrevision)1: :->modes' \
            '(-v --version -h --help --svnrevision)*:: :->args' \
            && ret=0

          case $state in
            modes)
              desc='modes'
              modes=(
                'apply':'apply a stash entry, not removing it from stack'
                'branch':'create and check out a new branch and apply stash entry'
                'clear':'remove all entries from stash stack'
                'drop':'remove stash entry from stack'
                'list':'list current stash stack'
                'pop':'apply stash entry and remove it from stack'
                'push':'create a stash entry and push it onto stack (default)'
                'show':'show diff between the stash entry and the commit back when the stash entry was first created'
              )
              _describe -t 'mode-group-0' $desc modes

              ;;
            args)
              case $line[1] in
                'apply')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(-q --quiet)'{'-q','--quiet'}'[be quiet]' \
                    '(--index)--index[restore index state]' \
                    '1:ARG:_default' \
                    && ret=0
                  ;;
                'branch')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(-q --quiet)'{'-q','--quiet'}'[suppress progress reporting]' \
                    '1:<branchname>:_default' \
                    '2::<stash>:_default' \
                    && ret=0
                  ;;
                'clear')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '*:ARG:_default' \
                    && ret=0
                  ;;
                'drop')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(-q --quiet)'{'-q','--quiet'}'[be quiet]' \
                    '1:ARG:_default' \
                    && ret=0
                  ;;
                'list')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--json)--json[output in json format]' \
                    '(--grep)--grep[show stashes with message matching specified value]:REGEX:_default' \
                    '(-i --ignore-case)'{'-i','--ignore-case'}'[ignore case differences between the patterns and the files]' \
                    '*:ARG:_default' \
                    && ret=0
                  ;;
                'pop')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(-q --quiet)'{'-q','--quiet'}'[be quiet]' \
                    '(--index)--index[restore index state]' \
                    '1:ARG:_default' \
                    && ret=0
                  ;;
                'push')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(-q --quiet)'{'-q','--quiet'}'[be quiet]' \
                    '(-k --keep-index)'{'-k','--keep-index'}'' \
                    '(--include-untracked -u)'{'-u','--include-untracked'}'' \
                    '(-a --all)'{'-a','--all'}'' \
                    '(--message -m)'{'-m','--message'}': :_default' \
                    '(--no-cleanup)--no-cleanup[do not revert modifications]' \
                    '*:ARG:_default' \
                    && ret=0
                  ;;
                'show')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(-U --unified)'{'-U','--unified'}'[generate diffs with <n> lines of context.]: :_default' \
                    '(--include-untracked -u)'{'-u','--include-untracked'}'[add untracked files to show]' \
                    '(--only-untracked)--only-untracked[add only untracked files to show]' \
                    '(--name-only)--name-only[show only names of changed files]' \
                    '(--name-status)--name-status[show only names and status of changed files]' \
                    '(--svn)--svn[use svn compatible diff format]' \
                    '(--git)--git[use git compatible diff format]' \
                    '(--json)--json[output in json format]' \
                    '1:ARG:_default' \
                    && ret=0
                  ;;
              esac
              ;;
          esac
          ;;
        'copy-info'|'history')
          _arguments -C \
            '(- : *)'{-h,--help}'[show help information]' \
            '(-v --version -h --help --svnrevision)1: :->modes' \
            '(-v --version -h --help --svnrevision)*:: :->args' \
            && ret=0

          case $state in
            modes)
              desc='modes'
              modes=(
                'set':'set copy-info'
                'remove':'remove copy-info from index'
              )
              _describe -t 'mode-group-0' $desc modes

              ;;
            args)
              case $line[1] in
                'set')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(-a --auto-add)'{'-a','--auto-add'}'[add the specified paths to the index before performing the operation]' \
                    '1:ARG:_default' \
                    '2:ARG:_default' \
                    '3:ARG:_default' \
                    && ret=0
                  ;;
                'remove')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '1:PATH:_default' \
                    '*:PATH:_default' \
                    && ret=0
                  ;;
              esac
              ;;
          esac
          ;;
        'bisect')
          _arguments -C \
            '(- : *)'{-h,--help}'[show help information]' \
            '(-v --version -h --help --svnrevision)1: :->modes' \
            '(-v --version -h --help --svnrevision)*:: :->args' \
            && ret=0

          case $state in
            modes)
              desc='modes'
              modes=(
                'start':'reset bisect state and start bisection'
                'good':'mark current commit as good'
                'bad':'mark current commit as bad'
                'reset':'reset bisect state'
                'run':'automatically bisect by running a command on each commit'
                'head':'get current bisect head'
              )
              _describe -t 'mode-group-0' $desc modes

              ;;
            args)
              case $line[1] in
                'start')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--no-checkout)--no-checkout[do not checkout at each iteration of bisection process, the current head is accessible via ''arc bisect head'']' \
                    '(--first-parent)--first-parent[follow only the first parent commit upon seeing a merge commit]' \
                    '1:BAD:_arc__completer_2' \
                    '2:GOOD:_arc__completer_3' \
                    && ret=0
                  ;;
                'good')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '*:ARG:_default' \
                    && ret=0
                  ;;
                'bad')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '*:ARG:_default' \
                    && ret=0
                  ;;
                'reset')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '*:ARG:_default' \
                    && ret=0
                  ;;
                'run')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '1:<cmd>:_arc__completer_4' \
                    '*:ARG:_default' \
                    && ret=0
                  ;;
                'head')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    && ret=0
                  ;;
              esac
              ;;
          esac
          ;;
        'blame')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--revisions -r)'{'-r','--revisions'}'[show revision numbers]' \
            '(-s)-s[suppress author name and timestamp]' \
            '(--json)--json[output in json format]' \
            '(-w)-w[ignore whitespace when comparing lines]' \
            '(--ignore-rev)--ignore-rev[ignore changes made by the provided revisions when assigning blame]: :_default' \
            '(--ignore-revs-file)--ignore-revs-file[ignore changes made by revisions listed in provided file. When specifying a relative path, the path to the file is calculated relative current working directory. If optional path is not specified then .arc-blame-ignore-revs at repository root directory will be used.]::PATH:_default' \
            '(--show-pulls)--show-pulls[also consider merge commits that are not TREESAME to the first parent but are TREESAME to a later parent]' \
            '(-L)-L[annotate only the specified lines. Can be used multiple times. <start> and <end> are optional. If <start> is ommited, it will default to the first line. If <end> is ommited, it will default to the last line. Otherwise line number must be used (count starts from 1)]:<start>,<end>:_default' \
            '(--linear-trunk --first-parent --full-topo)--first-parent[walk through first parent only]' \
            '(--linear-trunk --first-parent --full-topo)--full-topo[full topology history walk]' \
            '1:ARG:_default' \
            '2:ARG:_default' \
            && ret=0
          ;;
        'praise')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--revisions -r)'{'-r','--revisions'}'[show revision numbers]' \
            '(-s)-s[suppress author name and timestamp]' \
            '(--json)--json[output in json format]' \
            '(-w)-w[ignore whitespace when comparing lines]' \
            '(--ignore-rev)--ignore-rev[ignore changes made by the provided revisions when assigning blame]: :_default' \
            '(--ignore-revs-file)--ignore-revs-file[ignore changes made by revisions listed in provided file. When specifying a relative path, the path to the file is calculated relative current working directory. If optional path is not specified then .arc-blame-ignore-revs at repository root directory will be used.]::PATH:_default' \
            '(--show-pulls)--show-pulls[also consider merge commits that are not TREESAME to the first parent but are TREESAME to a later parent]' \
            '(-L)-L[annotate only the specified lines. Can be used multiple times. <start> and <end> are optional. If <start> is ommited, it will default to the first line. If <end> is ommited, it will default to the last line. Otherwise line number must be used (count starts from 1)]:<start>,<end>:_default' \
            '(--linear-trunk --first-parent --full-topo)--first-parent[walk through first parent only]' \
            '(--linear-trunk --first-parent --full-topo)--full-topo[full topology history walk]' \
            '1:ARG:_default' \
            '2:ARG:_default' \
            && ret=0
          ;;
        'describe')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--all)--all[use any ref]' \
            '(--long)--long[always use long format]' \
            '(--first-parent)--first-parent[only follow first parent]' \
            '(--exact-match)--exact-match[only output exact matches]' \
            '(--match)--match[only consider tags matching <pattern>]:<pattern>:_default' \
            '(--exclude)--exclude[do not consider tags matching <pattern>]:<pattern>:_default' \
            '(--always)--always[show abbreviated commit object as fallback]' \
            '(--dirty)--dirty[append <mark> on dirty working tree]::<mark>:_default' \
            '(--candidates)--candidates[consider <n> most recent tags (default\: 10)]:<n>:_default' \
            '(--svn)--svn[use svn revisions as tags]' \
            '*:ARG:_default' \
            && ret=0
          ;;
        'diff')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(-U --unified)'{'-U','--unified'}'[generate diffs with <n> lines of context.]: :_default' \
            '(--cached)--cached[calculate diff with index]' \
            '(--staged)--staged[calculate diff with index]' \
            '(--patience)--patience[generate a diff using the ''patience diff'' algorithm.]' \
            '(--no-patience)--no-patience[generate a diff without using the ''patience diff'' algorithm.]' \
            '(--name-only)--name-only[show only names of changed files]' \
            '(--name-status)--name-status[show only names and status of changed files]' \
            '(--color)--color[set color mode\: always, never or auto]::auto|always|never:_default' \
            '(--no-color)--no-color[set color mode never]' \
            '(--resolve-moves)--resolve-moves[(experimental) resolve and show path copies & moves]: :_default' \
            '(--svn)--svn[use svn compatible diff format]' \
            '(--git)--git[use git compatible diff format]' \
            '(--binary)--binary[output a binary diff in ''GIT binary patch'' format (base85)]' \
            '(--stat)--stat[show diffstat]' \
            '(-B --base)'{'-B','--base'}'[show changes between merge-base(FROM_ID, TO_ID) and TO_ID. By default, FROM_ID\=trunk, TO_ID\=HEAD]' \
            '(--json)--json[output in json format]' \
            '(--ignore-all-space -w)'{'-w','--ignore-all-space'}'[ignore whitespace when comparing lines]' \
            '(--ignore-space-change -b)'{'-b','--ignore-space-change'}'[ignore changes in amount of whitespace]' \
            '(--ignore-space-at-eol)--ignore-space-at-eol[ignore changes in whitespace at EOL]' \
            '(-R --reverse)'{'-R','--reverse'}'[(experimental) reverse diff sides]' \
            '(--relative)--relative[exclude changes outside <path> and show pathnames relative to it. If <path> starts with ''/'' it is considered to be path from the repository root, otherwise it is relative to CWD. To enable passing over space use `arc config diff-log-show.relativeArgSpaceParse true`.]:path:_default' \
            '1:ARG:_arc__completer_5' \
            '*:ARG:_default' \
            && ret=0
          ;;
        'difftool')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(-t --tool)'{'-t','--tool'}'[specify tool to run]: :_default' \
            '(--tool-help)--tool-help[list available diff tools]' \
            '(--no-prompt -y)'{'-y','--no-prompt'}'[do not prompt]' \
            '*:ARG:_default' \
            && ret=0
          ;;
        'ls-files')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(-c --cached)'{'-c','--cached'}'[show cached files in the output]' \
            '(--deleted -d)'{'-d','--deleted'}'[show deleted files in the output]' \
            '(-m --modified)'{'-m','--modified'}'[show modified files in the output]' \
            '(--others -o)'{'-o','--others'}'[show other files in the output]' \
            '*:ARG:_default' \
            && ret=0
          ;;
        'log')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--max-count -n)'{'-n','--max-count'}'[number of commits to output]: :_default' \
            '(--oneline)--oneline[print commit info in one line]' \
            '(--json --graph --pretty --format --json-lines)--json[output in json format]' \
            '(--json --graph --pretty --format --json-lines)--json-lines[output in json format as recieved]' \
            '(--no-walk)--no-walk[only show the given commits]' \
            '(--stat)--stat[show the diffstat]' \
            '(--author)--author[show commits of specified author]:REGEX:_default' \
            '(--grep)--grep[show commits with message matching specified value]:REGEX:_default' \
            '(--json --pretty --format --graph --json-lines)--graph[show the graph]' \
            '(--no-decorate)--no-decorate[do not print branch info if any]' \
            '(--search -S)'{'-S','--search'}'[show commits which has specified string in changes]:REGEX:_default' \
            '(--after)--after[show commits recent than a specific date]: :_default' \
            '(--before)--before[show commits older than a specific date]: :_default' \
            '(--name-only)--name-only[show only names of changed files]' \
            '(--name-status)--name-status[show only names and status of changed files]' \
            '(-p --patch)'{'-p','--patch'}'[generate patch]' \
            '(--color)--color[set color mode\: always, never or auto]::auto|always|never:_default' \
            '(--no-color)--no-color[set color mode never]' \
            '(-U --unified)'{'-U','--unified'}'[generate diffs with <n> lines of context.]: :_default' \
            '(--resolve-moves)--resolve-moves[(experimental) resolve and show path copies & moves]' \
            '(--first-parent --full-topo)--first-parent[walk through first parent only]' \
            '(--first-parent --full-topo)--full-topo[full topology history walk]' \
            '(--show-pulls)--show-pulls[include merge commits that are not TREESAME to the first parent but are TREESAME to a later parent]' \
            '(--follow)--follow[continue listing the history of a file beyond implicit renames]' \
            '(--attrs)--attrs[show attributes]' \
            '(--json --graph --format --json-lines)--format[(experimental) pretty-formats commits according to a pattern]: :_default' \
            '(--json --graph --pretty --json-lines)--pretty[same as --format]: :_default' \
            '(--relative)--relative[exclude changes outside <path> and show pathnames relative to it. If <path> starts with ''/'' it is considered to be path from the repository root, otherwise it is relative to CWD. To enable passing over space use `arc config diff-log-show.relativeArgSpaceParse true`.]:path:_default' \
            '*:ARG:_default' \
            && ret=0
          ;;
        'reflog')
          _arguments -C \
            '(- : *)'{-h,--help}'[show help information]' \
            '(-v --version -h --help --svnrevision)1: :->modes' \
            '(-v --version -h --help --svnrevision)*:: :->args' \
            && ret=0

          case $state in
            modes)
              desc='modes'
              modes=(
                'show':'shows the log of the reference provided in the command-line (or HEAD, by default)'
                'expire':'prunes older reflog entries'
                'delete':'deletes single entries from the reflog'
                'exists':'checks whether a ref has a reflog'
              )
              _describe -t 'mode-group-0' $desc modes

              ;;
            args)
              case $line[1] in
                'show')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--max-count -n)'{'-n','--max-count'}'[number of commits to output]: :_default' \
                    '(--stat)--stat[show the diffstat]' \
                    '(--author)--author[show commits of specified author]: :_default' \
                    '(--grep)--grep[show commits with message matching specified value]: :_default' \
                    '(--no-decorate)--no-decorate[do not print branch info if any]' \
                    '(--after)--after[show commits recent than a specific date]: :_default' \
                    '(--before)--before[show commits older than a specific date]: :_default' \
                    '(--json)--json[output in json lines format]' \
                    '1:ARG:_default' \
                    && ret=0
                  ;;
                'expire')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--expire)--expire[prune entries older than the specified time]: :_default' \
                    '(--updateref)--updateref[update the reference to the value of the top reflog entry(i.e. <ref>@{0}) if the previous top entry was pruned]' \
                    '(--rewrite)--rewrite[if a reflog entry’s predecessor is pruned, adjust its \"old\" SHA-1 to be equal to the \"new\" SHA-1 field of the entry that now precedes it]' \
                    '(--dry-run -n)'{'-n','--dry-run'}'[do not actually prune any entries; just show what would have been pruned.]' \
                    '(-v --verbose)'{'-v','--verbose'}'[print extra information on screen.]' \
                    '*:ARG:_default' \
                    && ret=0
                  ;;
                'delete')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--updateref)--updateref[update the reference to the value of the top reflog entry(i.e. <ref>@{0}) if the previous top entry was pruned]' \
                    '(--rewrite)--rewrite[if a reflog entry’s predecessor is pruned, adjust its \"old\" SHA-1 to be equal to the \"new\" SHA-1 field of the entry that now precedes it]' \
                    '(--dry-run -n)'{'-n','--dry-run'}'[do not actually prune any entries; just show what would have been pruned.]' \
                    '(-v --verbose)'{'-v','--verbose'}'[print extra information on screen.]' \
                    '*:ARG:_default' \
                    && ret=0
                  ;;
                'exists')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '1:ARG:_default' \
                    && ret=0
                  ;;
              esac
              ;;
          esac
          ;;
        'merge-base')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(-q --quiet)'{'-q','--quiet'}'[be quiet]' \
            '(--first-parent --leftmost)--leftmost[follow first parent for left commit, full-topo for right commit]' \
            '(--force-local)--force-local[force local computation of merge-base (slow)]' \
            '(--json)--json[output in json format]' \
            '1:ARG:_default' \
            '2:ARG:_default' \
            && ret=0
          ;;
        'root')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--from-cwd)--from-cwd[Relative path to current work dir]' \
            && ret=0
          ;;
        'show')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(-q --quiet)'{'-q','--quiet'}'[suppress diff output]' \
            '(-U --unified)'{'-U','--unified'}'[generate diffs with <n> lines of context.]: :_default' \
            '(--patience)--patience[generate a diff using the ''patience diff'' algorithm.]' \
            '(--name-only)--name-only[show only names of changed files]' \
            '(--name-status)--name-status[show only names and status of changed files]' \
            '(--oneline)--oneline[print commit info in one line]' \
            '(--color)--color[set color mode\: always, never or auto]::auto|always|never:_default' \
            '(--no-color)--no-color[set color mode never]' \
            '(--no-decorate)--no-decorate[do not print branch info if any]' \
            '(--resolve-moves)--resolve-moves[(experimental) resolve and show path copies & moves]: :_default' \
            '(-R --reverse)'{'-R','--reverse'}'[(experimental) reverse diff sides]' \
            '(--svn)--svn[use svn compatible diff format]' \
            '(--git)--git[use git compatible diff format]' \
            '(--binary)--binary[output a binary diff]' \
            '(--stat)--stat[show diffstat]' \
            '(--json)--json[output in json format]' \
            '(--attrs)--attrs[show attributes]' \
            '(--relative)--relative[exclude changes outside <path> and show pathnames relative to it. If <path> starts with ''/'' it is considered to be path from the repository root, otherwise it is relative to CWD. To enable passing over space use `arc config diff-log-show.relativeArgSpaceParse true`.]:path:_default' \
            '1:COMMIT:_arc__completer_6' \
            '*:ARG:_default' \
            && ret=0
          ;;
        'status'|'st')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--branch -b)'{'-b','--branch'}'[show branch information]' \
            '(-s --short)'{'-s','--short'}'[show status concisely]' \
            '(--json)--json[output in json format]' \
            '(-u)-u[show untracked files]::all, no, normal:_default' \
            '(--ignored)--ignored[show ignored files]' \
            '(--no-ahead-behind)--no-ahead-behind[do not display detailed ahead/behind counts]' \
            '(--no-sync-status)--no-sync-status[do not display status of current synchronization process]' \
            '(--no-bisect-status)--no-bisect-status[do not display status of current bisection]' \
            '*:ARG:_default' \
            && ret=0
          ;;
        'branch'|'br')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(-v --verbose)'{'-v','--verbose'}'[show hash and subject, give twice for upstream branch]' \
            '(-q --quiet)'{'-q','--quiet'}'[suppress informational messages]' \
            '(--set-upstream-to -u)'{'-u','--set-upstream-to'}'[change the upstream info]: :_arc__completer_7' \
            '(--unset-upstream)--unset-upstream[unset the upstream info]' \
            '(-a --all)'{'-a','--all'}'[list both remote-tracking and local branches]' \
            '(--move -m)'{'-m','--move'}'[move/rename branch]' \
            '(-M)-M[shortcut for --move --force]' \
            '(-d --delete)'{'-d','--delete'}'[delete branch if all its commits are pushed to remote. If remote branch does not exist, delete branch if all its commits exist in current HEAD]:: :_arc__completer_8' \
            '(-D)-D[force delete branch]' \
            '(--list -l)'{'-l','--list'}'[list branch names]' \
            '(--force -f)'{'-f','--force'}'[force creation, move/rename, deletion]' \
            '(--merged)--merged[print only branches that are merged]::commit:_default' \
            '(--points-at)--points-at[print only branches of the object]: :_default' \
            '(--json)--json[output in json format]' \
            '(--desc)--desc[branch description]: :_default' \
            '1:BRANCH:_arc__completer_9' \
            '2:START:_arc__completer_10' \
            '*:ARG:_arc__completer_11' \
            && ret=0
          ;;
        'checkout'|'co')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(-b)-b[create and checkout a new branch]: :_default' \
            '(--force -f)'{'-f','--force'}'[force checkout (throw away local modifications)]' \
            '(-q --quiet)'{'-q','--quiet'}'[suppress progress reporting]' \
            '(--no-track)--no-track[do not set up upstream configuration]' \
            '(--ours --upstream)'{'--ours','--upstream'}'[Checkout our version for unmerged paths.]' \
            '(--branch --theirs)'{'--theirs','--branch'}'[Checkout their version for unmerged paths.]' \
            '(--resolve-upstream --resolve-ours)'{'--resolve-ours','--resolve-upstream'}'[When checking out paths from the index, resolve conflicts with ours as favor]' \
            '(--resolve-theirs --resolve-branch)'{'--resolve-theirs','--resolve-branch'}'[When checking out paths from the index, resolve conflicts with theirs as favor]' \
            '1:BRANCH:_arc__completer_12' \
            '*:PATH:_default' \
            && ret=0
          ;;
        'cherry-pick')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(-q --quiet)'{'-q','--quiet'}'[be quiet]' \
            '(--no-commit -n)'{'-n','--no-commit'}'[don''t automatically commit]' \
            '(--edit -e)'{'-e','--edit'}'[edit the commit message]' \
            '(-m --mainline)'{'-m','--mainline'}'[parent number]: :_default' \
            '*-X[pass the argument through to the merge strategy]: :_default' \
            '(-x)-x[append commit name]' \
            '(--allow-empty-message)--allow-empty-message[allow commits with empty messages]' \
            '(--abort)--abort[abort and check out the original branch]' \
            '(--continue)--continue[resume cherry-pick sequence]' \
            '(--skip)--skip[skip current commit and continue]' \
            '(--allow-empty)--allow-empty[make cherry-pick commit even if cherry-pick-commit has same tree as parent]' \
            '(--force -f)'{'-f','--force'}'[Cherry-pick even if prohibited by config]' \
            '(--dont-resolve-moves)--dont-resolve-moves[Do not resolve moves during this rebase]' \
            '1:COMMIT:_arc__completer_13' \
            '*:ARG:_default' \
            && ret=0
          ;;
        'commit'|'ci')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--file -F)'{'-F','--file'}'[read message from file]: :_default' \
            '(--message -m)'{'-m','--message'}'[commit message]: :_default' \
            '(--edit -e)'{'-e','--edit'}'[further edit message taken from file with -F, command line with -m]' \
            '(--no-edit)--no-edit[use the selected commit message without launching an editor]' \
            '(--fixup --squash)--squash[Automatically squash this commit with COMMIT in `arc rebase --autosquash`]:COMMIT:_default' \
            '(--squash --fixup)--fixup[Automatically mark this commit as a fixup of COMMIT in `arc rebase --autosquash`]:COMMIT:_default' \
            '(-a --all)'{'-a','--all'}'[commit all changed files]' \
            '(--dry-run)--dry-run[show what would be committed]' \
            '(--allow-empty-message)--allow-empty-message[allow to create a commit with an empty commit message]' \
            '(--amend)--amend[amend previous commit]' \
            '(--no-verify -n)'{'-n','--no-verify'}'[Bypass pre-commit hooks. It doesn''t disable prepare-commit-msg-hook, to disable them use --skip-hook]' \
            '(--skip-hook)--skip-hook[Skip specific pre-commit hook]:HOOK_NAME:_default' \
            '(--force -f)'{'-f','--force'}'[Commit even if prohibited by config]' \
            '(--reset-author)--reset-author[Discard original author when used with --amend]' \
            '*:PATH:_default' \
            && ret=0
          ;;
        'rebase')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(-q --quiet)'{'-q','--quiet'}'[be quiet]' \
            '*-X[pass the argument through to the merge strategy]: :_default' \
            '(--onto)--onto[rebase onto given branch instead of upstream]:NEWBASE:_arc__completer_14' \
            '(--abort)--abort[abort and check out the original branch]' \
            '(--continue)--continue[restart the rebasing process after having resolved a merge conflict.]' \
            '(--skip)--skip[restart the rebasing process by skipping the current patch.]' \
            '(--virtual --checkout-conflicts)--checkout-conflicts[checkout on branch if rebase conflict occurred, no checkout on branch if rebase successful]' \
            '(--virtual --checkout-conflicts)--virtual[abort if rebase conflict occured, no checkout on branch if rebase successful]' \
            '(--interactive -i)'{'-i','--interactive'}'[let the user edit the list of commits to rebase]' \
            '(--autosquash)--autosquash[automatically modify the todo list of rebase -i so that the commit marked for squashing (by squash!/fixup!) comes right after the commit to be modified.]' \
            '(--empty)--empty[whether to keep commits which do not change anything after rebase. Valid values are {drop,keep}.]: :_default' \
            '(--force -f)'{'-f','--force'}'[Rebase even if prohibited by config]' \
            '(--all-parents)--all-parents[Consider all parents instead of only first one. Might be useful for rebasing external history]' \
            '(--include-merges)--include-merges[Include merge commits into rebase. However it does not preserve full topology, so use with care]' \
            '(--dont-resolve-moves)--dont-resolve-moves[Do not resolve moves during this rebase]' \
            '1:UPSTREAM:_arc__completer_15' \
            '2:BRANCH:_arc__completer_16' \
            && ret=0
          ;;
        'revert')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(-q --quiet)'{'-q','--quiet'}'[be quiet]' \
            '(--no-commit -n)'{'-n','--no-commit'}'[don''t automatically commit]' \
            '(--no-edit)--no-edit[don''t edit the commit message]' \
            '(--edit -e)'{'-e','--edit'}'[edit the commit message]' \
            '(-m --mainline)'{'-m','--mainline'}'[parent number]: :_default' \
            '*-X[pass the argument through to the merge strategy]: :_default' \
            '(--abort)--abort[abort and check out the original branch]' \
            '(--continue)--continue[resume revert sequence]' \
            '(--skip)--skip[skip current commit and continue]' \
            '(--allow-empty)--allow-empty[make revert commit even if revert-commit has same tree as parent]' \
            '(--force -f)'{'-f','--force'}'[Revert even if prohibited by config or if it is not in the current branch]' \
            '*:ARG:_default' \
            && ret=0
          ;;
        'tag')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--list -l)'{'-l','--list'}'[list tags]' \
            '(-a --all)'{'-a','--all'}'[list both remote-tracking and local tags]' \
            '(-d --delete)'{'-d','--delete'}'[delete tag]: :_default' \
            '(--force -f)'{'-f','--force'}'[set tag even if it exists]' \
            '(--points-at)--points-at[print only tags of the object]: :_default' \
            '1:ARG:_default' \
            '2:ARG:_default' \
            && ret=0
          ;;
        'submit')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--code-review --auto -A --no-code-review)'{'-A','--auto'}'[shortcut for --publish --no-code-review --merge. Merge PR after all checks except Code Review was passed]' \
            '(--merge -M)'{'-M','--merge'}'[enable automatic merging]' \
            '(--publish)--publish[enable auto publish setting for pull request, which means each push to remote branch will be published in Arcanum automatically]:: :(( ''disabled''\:''disable auto publish of pull request'' ''upload''\:''auto publish of pull request when new iteration is uploaded'' ''ci-success''\:''auto publish of pull request when auto checks of new iteration is success''))' \
            '(--code-review --auto -A --no-code-review)--code-review[enable arcanum Code Review check]' \
            '(--code-review --auto -A --no-code-review)--no-code-review[disable arcanum Code Review check]' \
            '(--view)--view[open the pull request in a web browser]' \
            '(--reviewer -r)'{'-r','--reviewer'}'[add reviewer to the pull request, can be used multiple times. If given user doesn''t exist, it will be ignored]:USER:_default' \
            '(--label)--label[add label to the pull request, can be used multiple times]:LABEL:_default' \
            '(--to)--to[target branch]:BRANCH:_default' \
            '(--file -F)'{'-F','--file'}'[read message from file]: :_default' \
            '(--message -m)'{'-m','--message'}'[commit message]: :_default' \
            '(--edit -e)'{'-e','--edit'}'[further edit message taken from file with -F, command line with -m]' \
            '(--no-edit)--no-edit[use the selected commit message without launching an editor]' \
            '(--all)--all[submit untracked files]' \
            '(--abort --new)--new[create new PR from current unsubmitted changes]' \
            '(--abort --stack)--stack[create new PR that includes current submitted and unsubmitted changes]' \
            '(--new --abort --stack)--abort[abort and check out the original state]' \
            '(--no-verify -n)'{'-n','--no-verify'}'[Bypass pre-commit hooks. It doesn''t disable prepare-commit-msg-hook, to disable them use --skip-hook]' \
            '(--skip-hook)--skip-hook[Skip specific pre-commit hook]:HOOK_NAME:_default' \
            '(--skip-linter)--skip-linter[skip specific linter in format <glob>\:<linter-id>]:LINTER_NAME:_default' \
            '*:PATH:_default' \
            && ret=0
          ;;
        'up')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--abort)--abort[Abort the current conflict resolution process, and try to reconstruct the state before arc up]' \
            '(--no-squash)--no-squash[(not supported yet) Don''t squash commits]' \
            '(--to)--to[Update to given branch or commit, you can use as value\: branch, commit, revision, other hash value (branch~N, HEAD@{N}, so on)]:UPSTREAM:_arc__completer_17' \
            && ret=0
          ;;
        'fetch')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--my)--my[also fetch all current user branches]' \
            '(--verbose)--verbose[print updated refs to stdout]' \
            '*:ARG:_default' \
            && ret=0
          ;;
        'unfetch')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--force -f)'{'-f','--force'}'[force unfetch over sanity checks (e.g., allow unfetching trunk)]' \
            '1:REMOTE_REF:_arc__completer_18' \
            && ret=0
          ;;
        'pr')
          _arguments -C \
            '(- : *)'{-h,--help}'[show help information]' \
            '(-v --version -h --help --svnrevision)1: :->modes' \
            '(-v --version -h --help --svnrevision)*:: :->args' \
            && ret=0

          case $state in
            modes)
              desc='modes'
              modes=(
                'changes':'view PR changes'
                'checkout':'checkout pull request or review'
                'create':'create new pull request'
                'discard':'discard open pull request'
                'history':'view PR changes history'
                'list':'list pull requests'
                'merge':'change pull request merge settings'
                'publish':'publish draft pull request'
                'share':'manage shared access to a pull request'
                'status':'extended status information about pull request'
                'view':'view pull request in the browser'
                'select':'open text interface to checkout PR'
              )
              _describe -t 'mode-group-0' $desc modes

              ;;
            args)
              case $line[1] in
                'changes')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(-S --submitted)'{'-S','--submitted'}'[View changes of last submitted to PR]' \
                    '1:PR:_default' \
                    && ret=0
                  ;;
                'checkout'|'co')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(-q --quiet)'{'-q','--quiet'}'[be quiet]' \
                    '(--force -f)'{'-f','--force'}'[force checkout (throw away local modifications)]' \
                    '(--dirty)--dirty[reset changes in PR, they''ll be moved to stage, useful to see diff of whole PR, this flag also enables --detached]' \
                    '(--iteration -i)'{'-i','--iteration'}'[iteration of a pull request (latest is default)]:NUM:_default' \
                    '(--detached -d)'{'-d','--detached'}'[do not checkout to a branch, checkout just to detached HEAD, useful when you don''t want to create many branches]' \
                    '1:ARG:_default' \
                    && ret=0
                  ;;
                'create'|'c')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--code-review --auto -A --no-code-review)'{'-A','--auto'}'[shortcut for --publish --no-code-review --merge. Merge PR after all checks except Code Review was passed]' \
                    '(--merge -M)'{'-M','--merge'}'[enable automatic merging]' \
                    '(--publish)--publish[enable auto publish setting for pull request, which means each push to remote branch will be published in Arcanum automatically]:: :(( ''disabled''\:''disable auto publish of pull request'' ''upload''\:''auto publish of pull request when new iteration is uploaded'' ''ci-success''\:''auto publish of pull request when auto checks of new iteration is success''))' \
                    '(--code-review --auto -A --no-code-review)--code-review[enable arcanum Code Review check]' \
                    '(--code-review --auto -A --no-code-review)--no-code-review[disable arcanum Code Review check]' \
                    '(--json --view)--view[open the pull request in a web browser]' \
                    '(--reviewer -r)'{'-r','--reviewer'}'[add reviewer to the pull request, can be used multiple times. If given user doesn''t exist, it will be ignored]:USER:_default' \
                    '(--label)--label[add label to the pull request, can be used multiple times]:LABEL:_default' \
                    '(--to)--to[target branch]:BRANCH:_default' \
                    '(--file -F)'{'-F','--file'}'[read message from file]: :_default' \
                    '(--message -m)'{'-m','--message'}'[commit message]: :_default' \
                    '(--edit -e)'{'-e','--edit'}'[further edit message taken from file with -F, command line with -m]' \
                    '(--no-edit)--no-edit[use the selected commit message without launching an editor]' \
                    '(-q --quiet)'{'-q','--quiet'}'[be quiet]' \
                    '(--no-commits)--no-commits[do not include commit messages to pull request''s description]' \
                    '(--force -f)'{'-f','--force'}'[force creation of pull request]' \
                    '(--json --wait --follow -w)--follow[trace status of the pull request and wait until it will be merged]' \
                    '(--no-push --push)--push[push local commits and/or create a remote branch (default)]::BRANCH:_default' \
                    '(--push --no-push)--no-push[don''t push local commits and don''t create a remote branch]' \
                    '(--keep-branch)--keep-branch[keep source remote branch after successful merging]' \
                    '(--wait --follow -w)'{'-w','--wait'}'[wait until PR will be uploaded to Arcanum]' \
                    '(--view --json --follow)--json[output in json format]' \
                    '(--no-verify)--no-verify[do not run pre-push hooks]' \
                    && ret=0
                  ;;
                'discard')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--allow-other)--allow-other[discard other user''s PR]' \
                    '1:ARG:_default' \
                    && ret=0
                  ;;
                'history')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(-S --submitted)'{'-S','--submitted'}'[View history only of submitted PR changes]' \
                    '(--json)--json[Output in json format]' \
                    '1:PR:_default' \
                    && ret=0
                  ;;
                'list')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(-o --in -i --all --out)'{'-i','--in'}'[show incoming PRs where you are subscriber]' \
                    '(--in -o --author -i -A --all --out)'{'-o','--out'}'[show outgoing PRs (default if no other filters set) where you are author or coauthor]' \
                    '(-o --in -i --all --out)--all[all PRs (default if any other filter set)]' \
                    '(-d --draft)'{'-d','--draft'}'[show only draft PRs]' \
                    '(--no-draft)--no-draft[don''t show draft PRs]' \
                    '(-o --author -A --out)'{'-A','--author'}'[filter by author, use !VAL for negation]: :_default' \
                    '(--reviewer -R)'{'-R','--reviewer'}'[filter by reviewer, use !VAL for negation]: :_default' \
                    '(--status -S)'{'-S','--status'}'[filter by PR status\: all, open, merged, discarded (default\: open)]: :_default' \
                    '(--owner)--owner[filter by owner, use !VAL for negation]: :_default' \
                    '(--subscriber)--subscriber[filter by subscriber, use !VAL for negation]: :_default' \
                    '(--ticket)--ticket[filter by ticket, use !VAL for negation]: :_default' \
                    '(--label)--label[filter by label, use !VAL for negation]: :_default' \
                    '(--shipper)--shipper[filter by shipper, show PRs that were already shipped by VAL, use !VAL for negation]: :_default' \
                    '(--limit -l)'{'-l','--limit'}'[limit the number of displayed PRs]: :_default' \
                    '(--as)--as[view as other user]: :_default' \
                    '(--sort)--sort[sort PRs by\: status, date, summary, id]: :_default' \
                    '(--desc --asc)--asc[ascending sort order]' \
                    '(--desc --asc)--desc[descending sort order]' \
                    '(--json)--json[output in jsonl (stream of json objects) format]' \
                    '1:ARG:_default' \
                    && ret=0
                  ;;
                'merge')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--wait --now --no-auto --auto -A)'{'-A','--auto'}'[enable automatic merging (automerge)]' \
                    '(--wait --now --no-auto --auto -A)--no-auto[disable automatic merging (automerge)]' \
                    '(--now --no-auto --auto -A)--now[try to merge PR now (if requirements are satisfied)]' \
                    '(--force)--force[force merge PR, ignore any checks. Works only if `--now` set.]' \
                    '(--json)--json[output in json format]' \
                    '(--wait --no-auto --auto -A)--wait[synchronous mode – wait for PR to be merged]' \
                    '(--timeout)--timeout[time to wait for PR to be merged]: :_default' \
                    '1:ARG:_default' \
                    && ret=0
                  ;;
                'publish')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '1:ARG:_default' \
                    && ret=0
                  ;;
                'share')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--with-all --with --reset)--with[share the pull request with the given user, can be used multiple times]:LOGIN:_default' \
                    '(--with-all --with --reset)--with-all[share the pull request with everyone]' \
                    '(--with-all --with --reset)--reset[revoke shared access (set shared_type to ''for_owner'')]' \
                    '(-q --quiet)'{'-q','--quiet'}'[be quiet]' \
                    '1:PR_ID_OR_BRANCH:_default' \
                    && ret=0
                  ;;
                'status'|'st')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--json -s --short)'{'-s','--short'}'[show status concisely]' \
                    '(--json --follow -s --short)--json[output in json format]' \
                    '(--json --follow)--follow[trace status of the pull request]' \
                    '1:ARG:_default' \
                    && ret=0
                  ;;
                'view')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '1:ARG:_default' \
                    && ret=0
                  ;;
                'select')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '*:ARG:_default' \
                    && ret=0
                  ;;
              esac
              ;;
          esac
          ;;
        'pull')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(-q --quiet)'{'-q','--quiet'}'[do not print names of files removed]' \
            '(--force -f)'{'-f','--force'}'[force checkout (throw away local modifications)]' \
            '(--ff-only)--ff-only[abort if fast-forward is not possible]' \
            '(-r --rebase)'{'-r','--rebase'}'[rebase if branches diverge]::false|true|interactive:_default' \
            '1:BRANCH:_arc__completer_19' \
            && ret=0
          ;;
        'push')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(-q --quiet)'{'-q','--quiet'}'[suppress diff output]' \
            '(-d --delete)'{'-d','--delete'}'[delete branch on server]:NAME:_default' \
            '(--set-upstream -u)'{'-u','--set-upstream'}'[add upstream (tracking) reference]:NAME:_default' \
            '(--all)--all[push all refs]' \
            '(--force -f)'{'-f','--force'}'[force updates]' \
            '(--no-verify)--no-verify[disable the pre-push hook]' \
            '(--wait)--wait[wait until PR is updated]' \
            '(-p --publish)'{'-p','--publish'}'[publish the latest diff-set in PR]' \
            '*:ARG:_default' \
            && ret=0
          ;;
        'fsck')
          _arguments -C \
            '(- : *)'{-h,--help}'[show help information]' \
            '(-v --version -h --help --svnrevision)1: :->modes' \
            '(-v --version -h --help --svnrevision)*:: :->args' \
            && ret=0

          case $state in
            modes)
              desc='modes'
              modes=(
                'objects':'check consistency of vcs objects'
                'overlay':'check consistency of vfs overlay'
              )
              _describe -t 'mode-group-0' $desc modes

              ;;
            args)
              case $line[1] in
                'objects')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '*:ARG:_default' \
                    && ret=0
                  ;;
                'overlay')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--log)--log[path to log file]: :_default' \
                    '(-v --verbose)'{'-v','--verbose'}'[verbose output]' \
                    '(--no-progress)--no-progress[do not print progress to stderr]' \
                    '(--load-objects)--load-objects[load non-local vcs objects required for hash check (slower, but more accurate)]' \
                    '(--dry-run -n)'{'-n','--dry-run'}'[check, but do not change anything]' \
                    '(--no-prompt -y)'{'-y','--no-prompt'}'[assume an answer of ''yes'' to all questions, will correct all found errors automatically]' \
                    '1:ARG:_default' \
                    && ret=0
                  ;;
              esac
              ;;
          esac
          ;;
        'export')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(-v --verbose)'{'-v','--verbose'}'[Report progress to stderr]' \
            '(--to)--to[File system path where the files will be exported]: :_default' \
            '(--overwrite)--overwrite[Overwrite existing files]' \
            '*:ARG:_default' \
            && ret=0
          ;;
        'gc')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--truncate --dry-run -n)'{'-n','--dry-run'}'[show what would be collected]' \
            '(--dry-run --truncate -n)--truncate[\[USE WITH CAUTION\] truncate storage without checking object presense on the server]' \
            && ret=0
          ;;
        'config')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--list -l)'{'-l','--list'}'[List existing options]' \
            '(--unset)--unset[Unset option]' \
            '(--remove-section)--remove-section[Remove section with all its options]' \
            '(--name-only)--name-only[Show only names for --list]' \
            '(--file)--file[Config file used to set values]: :_default' \
            '1:KEY:_arc__completer_20' \
            '2:VALUE:_default' \
            && ret=0
          ;;
        'dump')
          _arguments -C \
            '(- : *)'{-h,--help}'[show help information]' \
            '(-v --version -h --help --svnrevision)1: :->modes' \
            '(-v --version -h --help --svnrevision)*:: :->args' \
            && ret=0

          case $state in
            modes)
              desc='modes'
              modes=(
                'changelist':'create merge commit and show it'
                'changeset':'dump list of changed objects'
                'debug':'dump debugging information'
                'trees-diff':'dump difference between trees'
                'entry':'dump tree entry'
                'has-changes':'check vfs changes'
                'merge-files':'three-way merge of a single file'
                'four-way-merge':'create commits for diff between iterations'
                'object':'dump object'
                'object-db':'dump object-db (server cache)'
                'rev-graph':'save revision graph to blobref'
                'sequencer':'dump sequencer state, can be used only on conflicts resolving stage'
                'server-reflog':'dump server reflog for given branch'
                'stage':'dump stage'
                'vfs':'dump vfs internals'
              )
              _describe -t 'mode-group-0' $desc modes

              ;;
            args)
              case $line[1] in
                'changelist')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--resolve)--resolve[try to resolve copy/move operations]' \
                    '(--filter-symlinks)--filter-symlinks' \
                    '(--json)--json[print changelist as json]' \
                    '(--compare-as-is)--compare-as-is[compare two commits as-is\: (from, to) \[default is (from, merge(from, to))\]]' \
                    '(--svn-mode)--svn-mode[svn-mode resolving]' \
                    '(--no-move-detect)--no-move-detect[disable move detection]' \
                    '(--trunk-svn-path)--trunk-svn-path[svn path to prefix]:PATH:_default' \
                    '(--resolve-copy-while-merge)--resolve-copy-while-merge[resolve all copy-info while creating merge commit]' \
                    '1:ARG:_default' \
                    '2:ARG:_default' \
                    && ret=0
                  ;;
                'changeset')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '1:ARG:_default' \
                    '2:ARG:_default' \
                    && ret=0
                  ;;
                'debug')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(-b --bundle)'{'-b','--bundle'}'[create debug bundle]' \
                    '(-c --changed)'{'-c','--changed'}'[include .overlay_v2 and .changed]' \
                    '(-o --output)'{'-o','--output'}'[write bundle to FILE instead of temporary file]:FILE:_default' \
                    '(--debug-commit)--debug-commit[Push stage and untracked files as commits to server]' \
                    '(--no-sample)--no-sample[Do not collect mount sample]' \
                    && ret=0
                  ;;
                'trees-diff')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--path)--path[path the diff should be built for]: :_default' \
                    '1:ARG:_default' \
                    '2:ARG:_default' \
                    && ret=0
                  ;;
                'entry')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--cached -r --ref)'{'-r','--ref'}'[show entry from commit]: :_default' \
                    '(-r --cached --ref)--cached[show entry from stage index]' \
                    '(--json)--json[output in json format]' \
                    '1:ARG:_default' \
                    && ret=0
                  ;;
                'has-changes')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '*:ARG:_default' \
                    && ret=0
                  ;;
                'merge-files')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--favor-ours)--favor-ours[chose ''ours'' side in conflict resolution]' \
                    '(--favor-theirs)--favor-theirs[chose ''theirs'' side in conflict resolution]' \
                    '(-v --verbose)'{'-v','--verbose'}'[print all sides]' \
                    '1:Ours file (trunk):_default' \
                    '2:Theirs file (branch):_default' \
                    '3:Merge-base:_default' \
                    && ret=0
                  ;;
                'four-way-merge')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--resolve-moves)--resolve-moves[resolve moves]' \
                    '(--leftmost)--leftmost[find base commits using leftmost merge-base]' \
                    '(--first-base)--first-base[first base commit id (if known)]: :_default' \
                    '(--second-base)--second-base[second base commit id (if known)]: :_default' \
                    '1:\[First iteration''s commit\]:_default' \
                    '2:\[Second iteration''s commit\]:_default' \
                    '3:\[Branch where the iterations will be merged\]:_default' \
                    && ret=0
                  ;;
                'object')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--json)--json[print object as json]' \
                    '*:ARG:_default' \
                    && ret=0
                  ;;
                'object-db')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--info)--info[show information about object db (server cache)]' \
                    '(--to-disk-store)--to-disk-store[copy object-db store to disk store]' \
                    '(--from-disk-store)--from-disk-store[copy disk store to object-db store]' \
                    '(--object-stats)--object-stats[dump object stats]' \
                    '(--json-files)--json-files[dump all object files to json]' \
                    '(--json-db)--json-db[dump all objects from db to json]' \
                    && ret=0
                  ;;
                'rev-graph')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--make-commit)--make-commit[Return a commit with loaded revgraph instead of revgraph itself]' \
                    '(--v2)--v2[Save/load graph using v2 format]' \
                    && ret=0
                  ;;
                'sequencer')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--json)--json[output in json format]' \
                    && ret=0
                  ;;
                'server-reflog')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--limit)--limit[limit number of entries]:NUM:_default' \
                    '(--min-seq-no)--min-seq-no[minimal seqNo to query]:NUM:_default' \
                    '(-r --repository)'{'-r','--repository'}'[name of the repository]:NAME:_default' \
                    '1:ARG:_default' \
                    && ret=0
                  ;;
                'stage')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--json)--json[output in json format]' \
                    && ret=0
                  ;;
                'vfs')
                  _arguments -C \
                    '(- : *)'{-h,--help}'[show help information]' \
                    '(-v --version -h --help --svnrevision)1: :->modes' \
                    '(-v --version -h --help --svnrevision)*:: :->args' \
                    && ret=0

                  case $state in
                    modes)
                      desc='modes'
                      modes=(
                        'overlay':'dump inode metadata from store'
                        'metrics':'dump vfs daemon metrics'
                        'inode':'dump inode debug info from live mount'
                      )
                      _describe -t 'mode-group-0' $desc modes

                      ;;
                    args)
                      case $line[1] in
                        'overlay')
                          _arguments -s \
                            '(* : -)--svnrevision[print svn version]' \
                            '(* : -)'{'-h','--help'}'[print usage]' \
                            '(--store -S)'{'-S','--store'}'[path to arc store]:PATH:_default' \
                            '(--all)--all[dump all inodes]' \
                            '(--no-traverse-parents)--no-traverse-parents' \
                            '(--no-dentries)--no-dentries' \
                            '(--no-xattrs)--no-xattrs' \
                            '(-v --verbose)'{'-v','--verbose'}'' \
                            '(--no-verify)--no-verify[disable checksum verification]' \
                            '*:INODE:_default' \
                            && ret=0
                          ;;
                        'metrics')
                          _arguments -s \
                            '(* : -)--svnrevision[print svn version]' \
                            '(* : -)'{'-h','--help'}'[print usage]' \
                            '(--json)--json[dump as json]' \
                            && ret=0
                          ;;
                        'inode')
                          _arguments -s \
                            '(* : -)--svnrevision[print svn version]' \
                            '(* : -)'{'-h','--help'}'[print usage]' \
                            '*:ARG:_default' \
                            && ret=0
                          ;;
                      esac
                      ;;
                  esac
                  ;;
              esac
              ;;
          esac
          ;;
        'gen-key')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            && ret=0
          ;;
        'help')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--format)--format[output format, supported\: man, simple, troff]: :_default' \
            '1:ARG:_default' \
            && ret=0
          ;;
        'info')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--json)--json[output in json format]' \
            '(--mount)--mount[output mount-specific info]' \
            '(--ahead-behind)--ahead-behind[display detailed ahead/behind counts]' \
            && ret=0
          ;;
        'ls-tree')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(-d)-d[only show trees (implies -t)]' \
            '(-r)-r[recurse into subtrees]' \
            '(-t)-t[show trees when recursing]' \
            '(--name-only)--name-only[list only filenames]' \
            '(--full-name)--full-name[use full path names]' \
            '(--json)--json[output in json format]' \
            '(--traverse-blobrefs)--traverse-blobrefs[show blobref parts]' \
            '1:ARG:_default' \
            '2:ARG:_default' \
            && ret=0
          ;;
        'rev-parse')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--sq)--sq[makes output a single line, properly quoted for consumption by shell]' \
            '(--sq-quote)--sq-quote[mode that does only quoting (nothing else is done to command input)]' \
            '(--not)--not[when showing object names, prefix them with ^ and strip ^ prefix from the object names that already have one]' \
            '(--default)--default[if there is no parameter given by the user, use ARG instead.]:ARG:_default' \
            '(--quiet)--quiet[only meaningful in --verify mode. Do not output an error message if the first argument is not a valid object name]' \
            '(--arc-dir)--arc-dir' \
            '(--is-inside-arc-dir)--is-inside-arc-dir' \
            '(--is-inside-work-tree)--is-inside-work-tree' \
            '(--is-bare-repository)--is-bare-repository' \
            '(--is-local-repository)--is-local-repository' \
            '(--show-prefix)--show-prefix' \
            '(--show-toplevel)--show-toplevel' \
            '*:ARG:_default' \
            && ret=0
          ;;
        'token')
          _arguments -C \
            '(- : *)'{-h,--help}'[show help information]' \
            '(-v --version -h --help --svnrevision)1: :->modes' \
            '(-v --version -h --help --svnrevision)*:: :->args' \
            && ret=0

          case $state in
            modes)
              desc='modes'
              modes=(
                'store':'store token to ~/.arc/token'
                'show':'print token'
              )
              _describe -t 'mode-group-0' $desc modes

              ;;
            args)
              case $line[1] in
                'store')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--ask)--ask[ask for token to store]' \
                    '(--force)--force[suppress safety warnings]' \
                    && ret=0
                  ;;
                'show')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--force-ssh)--force-ssh[force using SSH key for acquiring Arc token]' \
                    '(--json)--json[output in json format]' \
                    && ret=0
                  ;;
              esac
              ;;
          esac
          ;;
        'internal')
          _arguments -C \
            '(- : *)'{-h,--help}'[show help information]' \
            '(-v --version -h --help --svnrevision)1: :->modes' \
            '(-v --version -h --help --svnrevision)*:: :->args' \
            && ret=0

          case $state in
            modes)
              desc='modes'
              modes=(
                'arcadia-rules':'Check commit itself against arcadia rules'
                'change-filter':'Change filter for outstaff/selective checkout'
                'commit':'Commit operations'
                'experiment':'Inspect info about experiments'
                'inode':'Inode operations'
                'join-histories':'Create merge commit'
                'lint':'Run linters'
                'make-loose-commit':'Evalute root inode hash and create loose commit'
                'object':'Manual object manipulations'
                'rate-limiter':'Arc Rate Limiter settings'
                'hot-config':'Change value in hot_config'
              )
              _describe -t 'mode-group-0' $desc modes

              ;;
            args)
              case $line[1] in
                'arcadia-rules')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--limit)--limit[limit history depth to search commit with violations]: :_default' \
                    '1:ARG:_default' \
                    && ret=0
                  ;;
                'change-filter')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--file)--file[Path filter file for selective checkout]:PATH:_default' \
                    '*:ARG:_default' \
                    && ret=0
                  ;;
                'commit')
                  _arguments -C \
                    '(- : *)'{-h,--help}'[show help information]' \
                    '(-v --version -h --help --svnrevision)1: :->modes' \
                    '(-v --version -h --help --svnrevision)*:: :->args' \
                    && ret=0

                  case $state in
                    modes)
                      desc='modes'
                      modes=(
                        'substitute':'Create substitution commit'
                        'reindex':'Reindex commit path index'
                      )
                      _describe -t 'mode-group-0' $desc modes

                      ;;
                    args)
                      case $line[1] in
                        'substitute')
                          _arguments -s \
                            '(* : -)--svnrevision[print svn version]' \
                            '(* : -)'{'-h','--help'}'[print usage]' \
                            '(--target-commit)--target-commit[commit, that should be substituted]: :_default' \
                            '(--target-path)--target-path[path, that should be substituted]: :_default' \
                            '(--copy-info-commit)--copy-info-commit[commit, where copy-info should point to]: :_default' \
                            '(--copy-info-path)--copy-info-path[path, where copy-info should point to]: :_default' \
                            '(--dry-run)--dry-run[create substitution commit, but do not perform a real substitution]' \
                            '(--override --append)--append[add provided path to existed substitution]' \
                            '(--override --append)--override[override an existed substitution]' \
                            && ret=0
                          ;;
                        'reindex')
                          _arguments -s \
                            '(* : -)--svnrevision[print svn version]' \
                            '(* : -)'{'-h','--help'}'[print usage]' \
                            '1:COMMIT_HASH:_default' \
                            && ret=0
                          ;;
                      esac
                      ;;
                  esac
                  ;;
                'experiment')
                  _arguments -C \
                    '(- : *)'{-h,--help}'[show help information]' \
                    '(-v --version -h --help --svnrevision)1: :->modes' \
                    '(-v --version -h --help --svnrevision)*:: :->args' \
                    && ret=0

                  case $state in
                    modes)
                      desc='modes'
                      modes=(
                        'list':'List all current experiments and check if they are enabled for you (or any user)'
                        'helpers':'Show the results of IsDevtools and IsInPercent helpers for given user and exp'
                        'enable':'Enable experiment'
                        'disable':'Disable experiment'
                        'default':'Use default value, calculated using exp epoch in experiment list'
                      )
                      _describe -t 'mode-group-0' $desc modes

                      ;;
                    args)
                      case $line[1] in
                        'list')
                          _arguments -s \
                            '(* : -)--svnrevision[print svn version]' \
                            '(* : -)'{'-h','--help'}'[print usage]' \
                            '(--user -u)'{'-u','--user'}'[User to check if exps are enabled for him, default - current user (you)]:USER:_default' \
                            && ret=0
                          ;;
                        'helpers')
                          _arguments -s \
                            '(* : -)--svnrevision[print svn version]' \
                            '(* : -)'{'-h','--help'}'[print usage]' \
                            '(--user -u)'{'-u','--user'}': :_default' \
                            '(--exp -e)'{'-e','--exp'}': :_default' \
                            '(--percent -p)'{'-p','--percent'}': :_default' \
                            '*:ARG:_default' \
                            && ret=0
                          ;;
                        'enable')
                          _arguments -s \
                            '(* : -)--svnrevision[print svn version]' \
                            '(* : -)'{'-h','--help'}'[print usage]' \
                            '1:exp:_default' \
                            && ret=0
                          ;;
                        'disable')
                          _arguments -s \
                            '(* : -)--svnrevision[print svn version]' \
                            '(* : -)'{'-h','--help'}'[print usage]' \
                            '1:exp:_default' \
                            && ret=0
                          ;;
                        'default')
                          _arguments -s \
                            '(* : -)--svnrevision[print svn version]' \
                            '(* : -)'{'-h','--help'}'[print usage]' \
                            '1:exp:_default' \
                            && ret=0
                          ;;
                      esac
                      ;;
                  esac
                  ;;
                'inode')
                  _arguments -C \
                    '(- : *)'{-h,--help}'[show help information]' \
                    '(-v --version -h --help --svnrevision)1: :->modes' \
                    '(-v --version -h --help --svnrevision)*:: :->args' \
                    && ret=0

                  case $state in
                    modes)
                      desc='modes'
                      modes=(
                        'dematerialize':'Dematerialize inodes'
                      )
                      _describe -t 'mode-group-0' $desc modes

                      ;;
                    args)
                      case $line[1] in
                        'dematerialize')
                          _arguments -s \
                            '(* : -)--svnrevision[print svn version]' \
                            '(* : -)'{'-h','--help'}'[print usage]' \
                            '1:PATH:_default' \
                            '*:ARG:_default' \
                            && ret=0
                          ;;
                      esac
                      ;;
                  esac
                  ;;
                'join-histories')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--file -F)'{'-F','--file'}'[read message from file]: :_default' \
                    '(--message -m)'{'-m','--message'}'[commit message]: :_default' \
                    '(--edit -e)'{'-e','--edit'}'[further edit message taken from file with -F, command line with -m]' \
                    '(--no-edit)--no-edit[use the selected commit message without launching an editor]' \
                    '(--abort)--abort[abort the current in-progress merge]' \
                    '(--quit)--quit[--abort but leave index and working tree alone]' \
                    '(--continue)--continue[continue the current in-progress merge]' \
                    '(--no-commit)--no-commit[stop just before creating a commit to add changes]' \
                    '*:COMMIT:_default' \
                    && ret=0
                  ;;
                'lint')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '1:ARG:_default' \
                    '2:ARG:_default' \
                    && ret=0
                  ;;
                'make-loose-commit')
                  _arguments -s \
                    '(* : -)--svnrevision[print svn version]' \
                    '(* : -)'{'-h','--help'}'[print usage]' \
                    '(--timeout)--timeout[maximum duration for which vfs would be blocked]: :_default' \
                    && ret=0
                  ;;
                'object')
                  _arguments -C \
                    '(- : *)'{-h,--help}'[show help information]' \
                    '(-v --version -h --help --svnrevision)1: :->modes' \
                    '(-v --version -h --help --svnrevision)*:: :->args' \
                    && ret=0

                  case $state in
                    modes)
                      desc='modes'
                      modes=(
                        'ban':'Mark object as banned (blob only!)'
                        'unban':'Un-mark object as banned'
                        'check-ban':'Check object ban status and reason (if any)'
                        'mark-valid':'Mark object as valid'
                      )
                      _describe -t 'mode-group-0' $desc modes

                      ;;
                    args)
                      case $line[1] in
                        'ban')
                          _arguments -s \
                            '(* : -)--svnrevision[print svn version]' \
                            '(* : -)'{'-h','--help'}'[print usage]' \
                            '(--reason)--reason[ban reason with ticket]: :_default' \
                            '1:HASH_ID:_default' \
                            && ret=0
                          ;;
                        'unban')
                          _arguments -s \
                            '(* : -)--svnrevision[print svn version]' \
                            '(* : -)'{'-h','--help'}'[print usage]' \
                            '1:HASH_ID:_default' \
                            && ret=0
                          ;;
                        'check-ban')
                          _arguments -s \
                            '(* : -)--svnrevision[print svn version]' \
                            '(* : -)'{'-h','--help'}'[print usage]' \
                            '1:HASH_ID:_default' \
                            && ret=0
                          ;;
                        'mark-valid')
                          _arguments -s \
                            '(* : -)--svnrevision[print svn version]' \
                            '(* : -)'{'-h','--help'}'[print usage]' \
                            '1:HASH_ID:_default' \
                            && ret=0
                          ;;
                      esac
                      ;;
                  esac
                  ;;
                'rate-limiter')
                  _arguments -C \
                    '(- : *)'{-h,--help}'[show help information]' \
                    '(-v --version -h --help --svnrevision)1: :->modes' \
                    '(-v --version -h --help --svnrevision)*:: :->args' \
                    && ret=0

                  case $state in
                    modes)
                      desc='modes'
                      modes=(
                        'update':'Update rate limiter settings for given quota key'
                        'get':'Print current rate limiter settings'
                        'delete':'Delete limiting of given quota key'
                      )
                      _describe -t 'mode-group-0' $desc modes

                      ;;
                    args)
                      case $line[1] in
                        'update')
                          _arguments -s \
                            '(* : -)--svnrevision[print svn version]' \
                            '(* : -)'{'-h','--help'}'[print usage]' \
                            '(--user)--user[User to limit]: :_default' \
                            '(--method)--method[Method to limit]: :_default' \
                            '(--method-shards-count)--method-shards-count[Set method shards count]: :_default' \
                            '(--reason)--reason[reason to limit]: :_default' \
                            '(--rps)--rps[Set RPS limit]: :_default' \
                            '(--low-burst)--low-burst[Set low burst]: :_default' \
                            '(--high-burst)--high-burst[Set high burst. If you set just low burst, high burst will be equal to ''2 * low burst''.]: :_default' \
                            && ret=0
                          ;;
                        'get')
                          _arguments -s \
                            '(* : -)--svnrevision[print svn version]' \
                            '(* : -)'{'-h','--help'}'[print usage]' \
                            '(--raw)--raw[Just print server response wo beautfying]' \
                            && ret=0
                          ;;
                        'delete')
                          _arguments -s \
                            '(* : -)--svnrevision[print svn version]' \
                            '(* : -)'{'-h','--help'}'[print usage]' \
                            '(--user)--user[User to change limits]: :_default' \
                            '(--method)--method[Method to change limits]: :_default' \
                            && ret=0
                          ;;
                      esac
                      ;;
                  esac
                  ;;
                'hot-config')
                  _arguments -C \
                    '(- : *)'{-h,--help}'[show help information]' \
                    '(-v --version -h --help --svnrevision)1: :->modes' \
                    '(-v --version -h --help --svnrevision)*:: :->args' \
                    && ret=0

                  case $state in
                    modes)
                      desc='modes'
                      modes=(
                        'set':'Set value in hot-config'
                        'delete':'Delete value from hot-config'
                      )
                      _describe -t 'mode-group-0' $desc modes

                      ;;
                    args)
                      case $line[1] in
                        'set')
                          _arguments -s \
                            '(* : -)--svnrevision[print svn version]' \
                            '(* : -)'{'-h','--help'}'[print usage]' \
                            '1:ARG:_default' \
                            '2:ARG:_default' \
                            && ret=0
                          ;;
                        'delete')
                          _arguments -s \
                            '(* : -)--svnrevision[print svn version]' \
                            '(* : -)'{'-h','--help'}'[print usage]' \
                            '1:ARG:_default' \
                            && ret=0
                          ;;
                      esac
                      ;;
                  esac
                  ;;
              esac
              ;;
          esac
          ;;
        'prefetch-files')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--remote-branches)--remote-branches[prefetch remote branches and objects for them]' \
            '(--local-branches)--local-branches[prefetch objects for local branches]' \
            '(--commit)--commit[prefetch objects from special commit]: :_default' \
            '(--ignore-not-found)--ignore-not-found[skip commits where PATH is not found]' \
            '(--best-effort)--best-effort[do not stop the process if any error occurs during fetching]' \
            '(--quiet)--quiet[do not print warning and errors]' \
            '(--rpc-timeout)--rpc-timeout[rpc timeout for GetObject requests (ms)]: :_default' \
            '(--no-blobs)--no-blobs[prefetch only directory structure without file contents]' \
            '(--blob-size-limit)--blob-size-limit[prefetch only files with size less than specified]:BYTES:_default' \
            '(-g --filter)'{'-g','--filter'}'[filter (glob) for paths Note\: arc takes into account current cwd or provided paths for such filters]:GLOB:_default' \
            '(--read-filters-from)--read-filters-from[path to file with globs filters Note\: arc consider such filters as root-relative]:PATH:_default' \
            '(--read-paths-from)--read-paths-from[path to file with paths to prefetch targets Note\: passing - as an argument forces arc to read contents from stdin Note\: Filters from cmdline are not applied, use file instead]:PATH:_default' \
            '(--verbose)--verbose[print all fetched object ids and paths to stderr (includes folders)]' \
            '(--disable-priorities)--disable-priorities[disable the priorities for the fetching queue]' \
            '*:ARG:_default' \
            && ret=0
          ;;
        'repair-command')
          _arguments \
            '(- *)'{-h,--help}'[show help information]' \
            '(- *)--svnrevision[show build information]' \
            '(-h --help --svnrevision)*: :_files' \
            && ret=0
          ;;
        'list-commands')
          _arguments \
            '(- *)'{-h,--help}'[show help information]' \
            '(- *)--svnrevision[show build information]' \
            '(-h --help --svnrevision)*: :_files' \
            && ret=0
          ;;
        'user-info')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '(--update)--update[Load user information from server]' \
            '(--json)--json[Print info as json]' \
            && ret=0
          ;;
        'completion')
          _arguments -s \
            '(* : -)--svnrevision[print svn version]' \
            '(* : -)'{'-h','--help'}'[print usage]' \
            '1:shell syntax for completion script:(( 'zsh' 'bash'))' \
            && ret=0
          ;;
        '--update')
          _arguments \
            '(- *)'{-h,--help}'[show help information]' \
            '(- *)--svnrevision[show build information]' \
            '(-h --help --svnrevision)*: :_files' \
            && ret=0
          ;;
        '--has-update')
          _arguments \
            '(- *)'{-h,--help}'[show help information]' \
            '(- *)--svnrevision[show build information]' \
            '(-h --help --svnrevision)*: :_files' \
            && ret=0
          ;;
        '--set-channel')
          _arguments \
            '(- *)'{-h,--help}'[show help information]' \
            '(- *)--svnrevision[show build information]' \
            '(-h --help --svnrevision)*: :_files' \
            && ret=0
          ;;
        '--is-launcher')
          _arguments \
            '(- *)'{-h,--help}'[show help information]' \
            '(- *)--svnrevision[show build information]' \
            '(-h --help --svnrevision)*: :_files' \
            && ret=0
          ;;
        '--remove-unused-versions')
          _arguments \
            '(- *)'{-h,--help}'[show help information]' \
            '(- *)--svnrevision[show build information]' \
            '(-h --help --svnrevision)*: :_files' \
            && ret=0
          ;;
      esac
      ;;
  esac

  return ret
}

(( $+functions[_arc__completer_20] )) ||
_arc__completer_20() {
  compadd ${@} ${expl[@]} -- "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- ConfigKey "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}"
}

(( $+functions[_arc__completer_19] )) ||
_arc__completer_19() {
  compadd ${@} ${expl[@]} -- "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- LocalBranch "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}"
}

(( $+functions[_arc__completer_18] )) ||
_arc__completer_18() {
  local items=( "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- RemoteBranch "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}" )

  local rempat=${items[1]}
  shift items

  local sep=${items[1]}
  shift items

  local files=( ${items:#*"${sep}"} )
  local filenames=( ${files#"${rempat}"} )
  local dirs=( ${(M)items:#*"${sep}"} )
  local dirnames=( ${dirs#"${rempat}"} )

  local need_suf
  compset -S "${sep}*" || need_suf="1"

  compadd ${@} ${expl[@]} -d filenames -- ${(q)files}
  compadd ${@} ${expl[@]} ${need_suf:+-S"${sep}"} -q -d dirnames -- ${(q)dirs%"${sep}"}
}

(( $+functions[_arc__completer_17] )) ||
_arc__completer_17() {
  local expl action

  _description 'alt-1' expl 'local branches'
  _arc__completer_21 "${expl[@]}" 

  _description 'alt-2' expl 'remote branches'
  _arc__completer_22 "${expl[@]}" 
}

(( $+functions[_arc__completer_22] )) ||
_arc__completer_22() {
  local items=( "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- RemoteBranch "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}" )

  local rempat=${items[1]}
  shift items

  local sep=${items[1]}
  shift items

  local files=( ${items:#*"${sep}"} )
  local filenames=( ${files#"${rempat}"} )
  local dirs=( ${(M)items:#*"${sep}"} )
  local dirnames=( ${dirs#"${rempat}"} )

  local need_suf
  compset -S "${sep}*" || need_suf="1"

  compadd ${@} ${expl[@]} -d filenames -- ${(q)files}
  compadd ${@} ${expl[@]} ${need_suf:+-S"${sep}"} -q -d dirnames -- ${(q)dirs%"${sep}"}
}

(( $+functions[_arc__completer_21] )) ||
_arc__completer_21() {
  compadd ${@} ${expl[@]} -- "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- LocalBranch "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}"
}

(( $+functions[_arc__completer_16] )) ||
_arc__completer_16() {
  local expl action

  _description 'alt-1' expl 'local branches'
  _arc__completer_23 "${expl[@]}" 

  _description 'alt-2' expl 'remote branches'
  _arc__completer_24 "${expl[@]}" 
}

(( $+functions[_arc__completer_24] )) ||
_arc__completer_24() {
  local items=( "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- RemoteBranch "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}" )

  local rempat=${items[1]}
  shift items

  local sep=${items[1]}
  shift items

  local files=( ${items:#*"${sep}"} )
  local filenames=( ${files#"${rempat}"} )
  local dirs=( ${(M)items:#*"${sep}"} )
  local dirnames=( ${dirs#"${rempat}"} )

  local need_suf
  compset -S "${sep}*" || need_suf="1"

  compadd ${@} ${expl[@]} -d filenames -- ${(q)files}
  compadd ${@} ${expl[@]} ${need_suf:+-S"${sep}"} -q -d dirnames -- ${(q)dirs%"${sep}"}
}

(( $+functions[_arc__completer_23] )) ||
_arc__completer_23() {
  compadd ${@} ${expl[@]} -- "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- LocalBranch "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}"
}

(( $+functions[_arc__completer_15] )) ||
_arc__completer_15() {
  local expl action

  _description 'alt-1' expl 'local branches'
  _arc__completer_25 "${expl[@]}" 

  _description 'alt-2' expl 'remote branches'
  _arc__completer_26 "${expl[@]}" 
}

(( $+functions[_arc__completer_26] )) ||
_arc__completer_26() {
  local items=( "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- RemoteBranch "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}" )

  local rempat=${items[1]}
  shift items

  local sep=${items[1]}
  shift items

  local files=( ${items:#*"${sep}"} )
  local filenames=( ${files#"${rempat}"} )
  local dirs=( ${(M)items:#*"${sep}"} )
  local dirnames=( ${dirs#"${rempat}"} )

  local need_suf
  compset -S "${sep}*" || need_suf="1"

  compadd ${@} ${expl[@]} -d filenames -- ${(q)files}
  compadd ${@} ${expl[@]} ${need_suf:+-S"${sep}"} -q -d dirnames -- ${(q)dirs%"${sep}"}
}

(( $+functions[_arc__completer_25] )) ||
_arc__completer_25() {
  compadd ${@} ${expl[@]} -- "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- LocalBranch "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}"
}

(( $+functions[_arc__completer_14] )) ||
_arc__completer_14() {
  local expl action

  _description 'alt-1' expl 'local branches'
  _arc__completer_27 "${expl[@]}" 

  _description 'alt-2' expl 'remote branches'
  _arc__completer_28 "${expl[@]}" 
}

(( $+functions[_arc__completer_28] )) ||
_arc__completer_28() {
  local items=( "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- RemoteBranch "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}" )

  local rempat=${items[1]}
  shift items

  local sep=${items[1]}
  shift items

  local files=( ${items:#*"${sep}"} )
  local filenames=( ${files#"${rempat}"} )
  local dirs=( ${(M)items:#*"${sep}"} )
  local dirnames=( ${dirs#"${rempat}"} )

  local need_suf
  compset -S "${sep}*" || need_suf="1"

  compadd ${@} ${expl[@]} -d filenames -- ${(q)files}
  compadd ${@} ${expl[@]} ${need_suf:+-S"${sep}"} -q -d dirnames -- ${(q)dirs%"${sep}"}
}

(( $+functions[_arc__completer_27] )) ||
_arc__completer_27() {
  compadd ${@} ${expl[@]} -- "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- LocalBranch "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}"
}

(( $+functions[_arc__completer_13] )) ||
_arc__completer_13() {
  local expl action

  _description 'alt-1' expl 'local branches'
  _arc__completer_29 "${expl[@]}" 

  _description 'alt-2' expl 'remote branches'
  _arc__completer_30 "${expl[@]}" 
}

(( $+functions[_arc__completer_30] )) ||
_arc__completer_30() {
  local items=( "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- RemoteBranch "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}" )

  local rempat=${items[1]}
  shift items

  local sep=${items[1]}
  shift items

  local files=( ${items:#*"${sep}"} )
  local filenames=( ${files#"${rempat}"} )
  local dirs=( ${(M)items:#*"${sep}"} )
  local dirnames=( ${dirs#"${rempat}"} )

  local need_suf
  compset -S "${sep}*" || need_suf="1"

  compadd ${@} ${expl[@]} -d filenames -- ${(q)files}
  compadd ${@} ${expl[@]} ${need_suf:+-S"${sep}"} -q -d dirnames -- ${(q)dirs%"${sep}"}
}

(( $+functions[_arc__completer_29] )) ||
_arc__completer_29() {
  compadd ${@} ${expl[@]} -- "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- LocalBranch "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}"
}

(( $+functions[_arc__completer_12] )) ||
_arc__completer_12() {
  local expl action

  _description 'alt-1' expl 'local branches_or_file'
  _arc__completer_31 "${expl[@]}" 

  _description 'alt-2' expl 'remote branches_or_file'
  _arc__completer_32 "${expl[@]}" 
}

(( $+functions[_arc__completer_32] )) ||
_arc__completer_32() {
  local items=( "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- RemoteBranchOrFile "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}" )

  local rempat=${items[1]}
  shift items

  local sep=${items[1]}
  shift items

  local files=( ${items:#*"${sep}"} )
  local filenames=( ${files#"${rempat}"} )
  local dirs=( ${(M)items:#*"${sep}"} )
  local dirnames=( ${dirs#"${rempat}"} )

  local need_suf
  compset -S "${sep}*" || need_suf="1"

  compadd ${@} ${expl[@]} -d filenames -- ${(q)files}
  compadd ${@} ${expl[@]} ${need_suf:+-S"${sep}"} -q -d dirnames -- ${(q)dirs%"${sep}"}
}

(( $+functions[_arc__completer_31] )) ||
_arc__completer_31() {
  local items=( "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- LocalBranchOrFile "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}" )

  local rempat=${items[1]}
  shift items

  local sep=${items[1]}
  shift items

  local files=( ${items:#*"${sep}"} )
  local filenames=( ${files#"${rempat}"} )
  local dirs=( ${(M)items:#*"${sep}"} )
  local dirnames=( ${dirs#"${rempat}"} )

  local need_suf
  compset -S "${sep}*" || need_suf="1"

  compadd ${@} ${expl[@]} -d filenames -- ${(q)files}
  compadd ${@} ${expl[@]} ${need_suf:+-S"${sep}"} -q -d dirnames -- ${(q)dirs%"${sep}"}
}

(( $+functions[_arc__completer_11] )) ||
_arc__completer_11() {
  compadd ${@} ${expl[@]} -- "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- LocalBranch "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}"
}

(( $+functions[_arc__completer_10] )) ||
_arc__completer_10() {
  local expl action

  _description 'alt-1' expl 'local branches'
  _arc__completer_33 "${expl[@]}" 

  _description 'alt-2' expl 'remote branches'
  _arc__completer_34 "${expl[@]}" 
}

(( $+functions[_arc__completer_34] )) ||
_arc__completer_34() {
  local items=( "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- RemoteBranch "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}" )

  local rempat=${items[1]}
  shift items

  local sep=${items[1]}
  shift items

  local files=( ${items:#*"${sep}"} )
  local filenames=( ${files#"${rempat}"} )
  local dirs=( ${(M)items:#*"${sep}"} )
  local dirnames=( ${dirs#"${rempat}"} )

  local need_suf
  compset -S "${sep}*" || need_suf="1"

  compadd ${@} ${expl[@]} -d filenames -- ${(q)files}
  compadd ${@} ${expl[@]} ${need_suf:+-S"${sep}"} -q -d dirnames -- ${(q)dirs%"${sep}"}
}

(( $+functions[_arc__completer_33] )) ||
_arc__completer_33() {
  compadd ${@} ${expl[@]} -- "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- LocalBranch "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}"
}

(( $+functions[_arc__completer_9] )) ||
_arc__completer_9() {
  compadd ${@} ${expl[@]} -- "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- LocalBranch "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}"
}

(( $+functions[_arc__completer_8] )) ||
_arc__completer_8() {
  compadd ${@} ${expl[@]} -- "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- LocalBranch "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}"
}

(( $+functions[_arc__completer_7] )) ||
_arc__completer_7() {
  local items=( "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- RemoteBranch "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}" )

  local rempat=${items[1]}
  shift items

  local sep=${items[1]}
  shift items

  local files=( ${items:#*"${sep}"} )
  local filenames=( ${files#"${rempat}"} )
  local dirs=( ${(M)items:#*"${sep}"} )
  local dirnames=( ${dirs#"${rempat}"} )

  local need_suf
  compset -S "${sep}*" || need_suf="1"

  compadd ${@} ${expl[@]} -d filenames -- ${(q)files}
  compadd ${@} ${expl[@]} ${need_suf:+-S"${sep}"} -q -d dirnames -- ${(q)dirs%"${sep}"}
}

(( $+functions[_arc__completer_6] )) ||
_arc__completer_6() {
  local expl action

  _description 'alt-1' expl 'local branches_or_file'
  _arc__completer_35 "${expl[@]}" 

  _description 'alt-2' expl 'remote branches_or_file'
  _arc__completer_36 "${expl[@]}" 
}

(( $+functions[_arc__completer_36] )) ||
_arc__completer_36() {
  local items=( "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- RemoteBranchOrFile "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}" )

  local rempat=${items[1]}
  shift items

  local sep=${items[1]}
  shift items

  local files=( ${items:#*"${sep}"} )
  local filenames=( ${files#"${rempat}"} )
  local dirs=( ${(M)items:#*"${sep}"} )
  local dirnames=( ${dirs#"${rempat}"} )

  local need_suf
  compset -S "${sep}*" || need_suf="1"

  compadd ${@} ${expl[@]} -d filenames -- ${(q)files}
  compadd ${@} ${expl[@]} ${need_suf:+-S"${sep}"} -q -d dirnames -- ${(q)dirs%"${sep}"}
}

(( $+functions[_arc__completer_35] )) ||
_arc__completer_35() {
  local items=( "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- LocalBranchOrFile "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}" )

  local rempat=${items[1]}
  shift items

  local sep=${items[1]}
  shift items

  local files=( ${items:#*"${sep}"} )
  local filenames=( ${files#"${rempat}"} )
  local dirs=( ${(M)items:#*"${sep}"} )
  local dirnames=( ${dirs#"${rempat}"} )

  local need_suf
  compset -S "${sep}*" || need_suf="1"

  compadd ${@} ${expl[@]} -d filenames -- ${(q)files}
  compadd ${@} ${expl[@]} ${need_suf:+-S"${sep}"} -q -d dirnames -- ${(q)dirs%"${sep}"}
}

(( $+functions[_arc__completer_5] )) ||
_arc__completer_5() {
  local expl action

  _description 'alt-1' expl 'local branches_or_file'
  _arc__completer_37 "${expl[@]}" 

  _description 'alt-2' expl 'remote branches_or_file'
  _arc__completer_38 "${expl[@]}" 
}

(( $+functions[_arc__completer_38] )) ||
_arc__completer_38() {
  local items=( "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- RemoteBranchOrFile "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}" )

  local rempat=${items[1]}
  shift items

  local sep=${items[1]}
  shift items

  local files=( ${items:#*"${sep}"} )
  local filenames=( ${files#"${rempat}"} )
  local dirs=( ${(M)items:#*"${sep}"} )
  local dirnames=( ${dirs#"${rempat}"} )

  local need_suf
  compset -S "${sep}*" || need_suf="1"

  compadd ${@} ${expl[@]} -d filenames -- ${(q)files}
  compadd ${@} ${expl[@]} ${need_suf:+-S"${sep}"} -q -d dirnames -- ${(q)dirs%"${sep}"}
}

(( $+functions[_arc__completer_37] )) ||
_arc__completer_37() {
  local items=( "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- LocalBranchOrFile "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}" )

  local rempat=${items[1]}
  shift items

  local sep=${items[1]}
  shift items

  local files=( ${items:#*"${sep}"} )
  local filenames=( ${files#"${rempat}"} )
  local dirs=( ${(M)items:#*"${sep}"} )
  local dirnames=( ${dirs#"${rempat}"} )

  local need_suf
  compset -S "${sep}*" || need_suf="1"

  compadd ${@} ${expl[@]} -d filenames -- ${(q)files}
  compadd ${@} ${expl[@]} ${need_suf:+-S"${sep}"} -q -d dirnames -- ${(q)dirs%"${sep}"}
}

(( $+functions[_arc__completer_4] )) ||
_arc__completer_4() {
  local expl action

  _description 'alt-1' expl 'local branches'
  _arc__completer_39 "${expl[@]}" 

  _description 'alt-2' expl 'remote branches'
  _arc__completer_40 "${expl[@]}" 
}

(( $+functions[_arc__completer_40] )) ||
_arc__completer_40() {
  local items=( "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- RemoteBranch "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}" )

  local rempat=${items[1]}
  shift items

  local sep=${items[1]}
  shift items

  local files=( ${items:#*"${sep}"} )
  local filenames=( ${files#"${rempat}"} )
  local dirs=( ${(M)items:#*"${sep}"} )
  local dirnames=( ${dirs#"${rempat}"} )

  local need_suf
  compset -S "${sep}*" || need_suf="1"

  compadd ${@} ${expl[@]} -d filenames -- ${(q)files}
  compadd ${@} ${expl[@]} ${need_suf:+-S"${sep}"} -q -d dirnames -- ${(q)dirs%"${sep}"}
}

(( $+functions[_arc__completer_39] )) ||
_arc__completer_39() {
  compadd ${@} ${expl[@]} -- "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- LocalBranch "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}"
}

(( $+functions[_arc__completer_3] )) ||
_arc__completer_3() {
  local expl action

  _description 'alt-1' expl 'local branches'
  _arc__completer_41 "${expl[@]}" 

  _description 'alt-2' expl 'remote branches'
  _arc__completer_42 "${expl[@]}" 
}

(( $+functions[_arc__completer_42] )) ||
_arc__completer_42() {
  local items=( "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- RemoteBranch "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}" )

  local rempat=${items[1]}
  shift items

  local sep=${items[1]}
  shift items

  local files=( ${items:#*"${sep}"} )
  local filenames=( ${files#"${rempat}"} )
  local dirs=( ${(M)items:#*"${sep}"} )
  local dirnames=( ${dirs#"${rempat}"} )

  local need_suf
  compset -S "${sep}*" || need_suf="1"

  compadd ${@} ${expl[@]} -d filenames -- ${(q)files}
  compadd ${@} ${expl[@]} ${need_suf:+-S"${sep}"} -q -d dirnames -- ${(q)dirs%"${sep}"}
}

(( $+functions[_arc__completer_41] )) ||
_arc__completer_41() {
  compadd ${@} ${expl[@]} -- "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- LocalBranch "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}"
}

(( $+functions[_arc__completer_2] )) ||
_arc__completer_2() {
  local expl action

  _description 'alt-1' expl 'local branches'
  _arc__completer_43 "${expl[@]}" 

  _description 'alt-2' expl 'remote branches'
  _arc__completer_44 "${expl[@]}" 
}

(( $+functions[_arc__completer_44] )) ||
_arc__completer_44() {
  local items=( "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- RemoteBranch "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}" )

  local rempat=${items[1]}
  shift items

  local sep=${items[1]}
  shift items

  local files=( ${items:#*"${sep}"} )
  local filenames=( ${files#"${rempat}"} )
  local dirs=( ${(M)items:#*"${sep}"} )
  local dirnames=( ${dirs#"${rempat}"} )

  local need_suf
  compset -S "${sep}*" || need_suf="1"

  compadd ${@} ${expl[@]} -d filenames -- ${(q)files}
  compadd ${@} ${expl[@]} ${need_suf:+-S"${sep}"} -q -d dirnames -- ${(q)dirs%"${sep}"}
}

(( $+functions[_arc__completer_43] )) ||
_arc__completer_43() {
  compadd ${@} ${expl[@]} -- "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- LocalBranch "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}"
}

(( $+functions[_arc__completer_1] )) ||
_arc__completer_1() {
  local expl action

  _description 'alt-1' expl 'local branches'
  _arc__completer_45 "${expl[@]}" 

  _description 'alt-2' expl 'remote branches'
  _arc__completer_46 "${expl[@]}" 
}

(( $+functions[_arc__completer_46] )) ||
_arc__completer_46() {
  local items=( "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- RemoteBranch "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}" )

  local rempat=${items[1]}
  shift items

  local sep=${items[1]}
  shift items

  local files=( ${items:#*"${sep}"} )
  local filenames=( ${files#"${rempat}"} )
  local dirs=( ${(M)items:#*"${sep}"} )
  local dirnames=( ${dirs#"${rempat}"} )

  local need_suf
  compset -S "${sep}*" || need_suf="1"

  compadd ${@} ${expl[@]} -d filenames -- ${(q)files}
  compadd ${@} ${expl[@]} ${need_suf:+-S"${sep}"} -q -d dirnames -- ${(q)dirs%"${sep}"}
}

(( $+functions[_arc__completer_45] )) ||
_arc__completer_45() {
  compadd ${@} ${expl[@]} -- "${(@f)$(${words_orig[@]} ---CUSTOM-COMPLETION--- LocalBranch "${current_orig}" "${prefix_orig}" "${suffix_orig}" 2> /dev/null)}"
}

_arc "$@"
