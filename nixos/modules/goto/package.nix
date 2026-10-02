{
  goto,
  runCommand,
  bash,
  zsh,
  coreutils,
  gawk,
  gnused,
  gnugrep,
}:

let
  package = goto.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./dynamic.patch ];
    passthru = (old.passthru or { }) // {
      tests = (old.passthru.tests or { }) // {
        dynamic = runCommand "goto-dynamic-tests" {
          nativeBuildInputs = [ bash zsh coreutils gawk gnused gnugrep ];
        } ''
          bash --noprofile --norc ${./tests.sh} ${package}/share/goto.sh
          zsh -f ${./tests.sh} ${package}/share/goto.sh
          touch "$out"
        '';
      };
    };
  });
in
package
