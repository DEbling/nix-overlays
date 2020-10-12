{ pkgs ? import <nixpkgs> { } }:

with pkgs;

let
  zimply-lib = python3Packages.buildPythonPackage {
    pname = "zimpy-lib";
    version = "1.1.2";

    src = fetchFromGitHub {
      owner = "kimbauters";
      repo = "ZIMply";
      rev = "4a5180721f97a2aab324b76a53dcc4191d0b8526";
      sha256 = "0h4drf0m6z4hk71sp8v00lvklq4d4z97ksz7h8wiprw5myxlc9sb";
    };

    propagatedBuildInputs = with python3Packages; [
      setuptools
      gevent
      falcon
      Mako
    ];
  };
in stdenv.mkDerivation {
  name = "zimply";
  version = "1.1.2";

  src = pkgs.writers.writePython3Bin "zimply" { libraries = [ zimply-lib ]; } ''
    from zimply import ZIMServer
    import argparse

    parser = argparse.ArgumentParser(description='Run zimply service')

    parser.add_argument('wiki', type=str,
                        help='filepath to the wiki.zim file')
    parser.add_argument('-i', '--index-file', type=str,
                        help='Path to index file', default="")
    parser.add_argument('-l', '--listen-address', type=str,
                        help='Address to listen on', default="127.0.0.1")
    parser.add_argument('-p', '--port', type=int,
                        help='port to serve', default='8080')

    args = parser.parse_args()

    ZIMServer(args.wiki, index_file=args.index_file,
              ip_address=args.listen_address, port=args.port)
  '';

  buildInpus = [ zimply-lib ];

  installPhase = "install -m755 -Dt $out/bin bin/zimply";

  meta = with stdenv.lib; {
    description = "An easy to use offline reader for ZIM files right in your browser";
    homepage = "https://github.com/kimbauters/ZIMply";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
