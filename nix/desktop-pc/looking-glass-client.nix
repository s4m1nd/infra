{ stdenv
, lib
, fetchFromGitHub
, makeDesktopItem
, pkg-config
, cmake
, freefont_ttf
, spice-protocol
, nettle
, libbfd
, fontconfig
, libffi
, expat
, libGL
, libX11
, libxkbcommon
, libXext
, libXrandr
, libXi
, libXScrnSaver
, libXinerama
, libXcursor
, libXpresent
, wayland
, wayland-protocols
, pipewire
, pulseaudio
, libsamplerate
, xorgSupport ? true
, waylandSupport ? true
, pipewireSupport ? true
, pulseSupport ? true
}:

let
  desktopItem = makeDesktopItem {
    name = "looking-glass-client";
    desktopName = "Looking Glass Client B6";
    type = "Application";
    exec = "looking-glass-client-b6";
    icon = "lg-logo";
    terminal = true;
  };
in
stdenv.mkDerivation rec {
  pname = "looking-glass-client-b6";
  version = "B6";

  src = fetchFromGitHub {
    owner = "gnif";
    repo = "LookingGlass";
    rev = version;
    sha256 = "sha256-6vYbNmNJBCoU23nVculac24tHqH7F4AZVftIjL93WJU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libGL libX11 freefont_ttf spice-protocol expat libbfd nettle fontconfig libffi ]
    ++ lib.optionals xorgSupport [ libxkbcommon libXi libXScrnSaver libXinerama libXcursor libXpresent libXext libXrandr ]
    ++ lib.optionals waylandSupport [ libxkbcommon wayland wayland-protocols ]
    ++ lib.optionals pipewireSupport [ pipewire libsamplerate ]
    ++ lib.optionals pulseSupport [ pulseaudio libsamplerate ];

  cmakeFlags = [ "-DOPTIMIZE_FOR_NATIVE=OFF" ]
    ++ lib.optional (!xorgSupport) "-DENABLE_X11=no"
    ++ lib.optional (!waylandSupport) "-DENABLE_WAYLAND=no"
    ++ lib.optional (!pulseSupport) "-DENABLE_PULSEAUDIO=no"
    ++ lib.optional (!pipewireSupport) "-DENABLE_PIPEWIRE=no";

  postUnpack = ''
    echo ${src.rev} > source/VERSION
    export sourceRoot="source/client"
  '';

installPhase = ''
  runHook preInstall

  mkdir -p $out/bin
  cp looking-glass-client $out/bin/looking-glass-client-b6

  mkdir -p $out/share/applications
  cp ${desktopItem}/share/applications/* $out/share/applications/
  mv $out/share/applications/looking-glass-client.desktop $out/share/applications/looking-glass-client-b6.desktop
  sed -i 's/Exec=looking-glass-client/Exec=looking-glass-client-b6/' $out/share/applications/looking-glass-client-b6.desktop

  mkdir -p $out/share/pixmaps
  cp $src/resources/lg-logo.png $out/share/pixmaps/lg-logo-b6.png
  sed -i 's/Icon=lg-logo/Icon=lg-logo-b6/' $out/share/applications/looking-glass-client-b6.desktop

  runHook postInstall
'';

  meta = with lib; {
    description = "A KVM Frame Relay (KVMFR) implementation";
    longDescription = ''
      Looking Glass is an open source application that allows the use of a KVM
      (Kernel-based Virtual Machine) configured for VGA PCI Pass-through
      without an attached physical monitor, keyboard or mouse. This is the final
      step required to move away from dual booting with other operating systems
      for legacy programs that require high performance graphics.
    '';
    homepage = "https://looking-glass.io/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ alexbakker babbaj ];
    platforms = [ "x86_64-linux" ];
  };
}
