{ pkgs ? import <nixpkgs> { } }:

with pkgs;

let
  x11-nim = fetchFromGitHub {
    owner = "nim-lang";
    repo = "x11";
    rev = "b7bae7dffa4e3f12370d5a18209359422ae8bedd";
    sha256 = "1j3kyp0vf2jl20c67gcm759jnfskdf0wc4ajrdbvfxias285c5sb";
  };
  opengl-nim = fetchFromGitHub {
    owner = "nim-lang";
    repo = "opengl";
    rev = "a6fb649e5bd94d8420d4a11287092a4dc3e922b4";
    sha256 = "0w62lfrdms2vb24kd4jnypwmqvdk5x9my1dinnqdq82yl4nz6d0s";
  };
in stdenv.mkDerivation {
  name = "boomer";
  version = "git";

  src = fetchFromGitHub {
    owner = "tsoding";
    repo = "boomer";
    rev = "d16c65ce3eae31f4c77de1585b340d8d624c1252";
    sha256 = "1kqfg2i5p1zrvl9jx0ig7f0ckxnaxi9svr0bs52aavwydldnnl8d";
  };

  buildInputs = [ nim x11-nim opengl-nim ];

  buildPhase = ''
    HOME=$TMPDIR
    nim -p:${x11-nim}/ -p:${opengl-nim}/src c -d:danger src/boomer.nim
  '';

  installPhase = "install -m755 -Dt $out/bin src/boomer";

  fixupPhase = let
    libPath =
      lib.makeLibraryPath [ stdenv.cc.cc.lib xorg.libX11 xorg.libXrandr libGL ];
  in "patchelf --set-rpath ${libPath} $out/bin/boomer";

  meta = with stdenv.lib; {
    description = "Zoomer application for Linux.";
    homepage = "https://github.com/tsoding/boomer";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
