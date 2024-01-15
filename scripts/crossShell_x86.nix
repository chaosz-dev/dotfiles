with import <nixpkgs> {
  crossSystem = {
    config = "i686-unknown-linux-gnu";
  };
};

mkShell {
  packages = [
    gcc
    glib
    glibc
    glibc_multi
  ];

  shellHook = ''
    echo 'Running x86 shell (32bit mode).'
  '';

}