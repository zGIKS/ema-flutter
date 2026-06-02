{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  packages = with pkgs; [
    flutter
    dart
    git
    jdk17
    android-tools

    # Linux desktop deps commonly needed by Flutter apps/plugins
    pkg-config
    clang
    cmake
    ninja
    gtk3
    glib
    nss
    libGL
    cairo
    pango
    atk
    gdk-pixbuf
    xorg.libX11
    xorg.libXi
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
  ];

  shellHook = ''
    echo "Flutter SDK: $(command -v flutter || true)"
    echo "Tip: ejecuta 'flutter doctor' al entrar."
  '';
}
