{ stdenv
, lib
, unzip
, fetchurl
, autoPatchelfHook
, zlib
, gcc-unwrapped
, krb5
, openssl
}:

let
  version = "1.6.6";
in
stdenv.mkDerivation {
  name = "trash-updater-${version}";

  src = fetchurl {
    url = "https://github.com/rcdailey/trash-updater/releases/download/v${version}/trash-linux-x64.zip";
    sha256 = "11njvbch7mh72balxnj96xbxxvf51l1qx3m23yhvwyn0vz4z3drf";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    unzip
  ];

  buildInputs = [
    zlib
    gcc-unwrapped
    krb5
    openssl
  ];

  unpackCmd = ''
    mkdir src
    unzip $src -d src
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    chmod +rx trash
    mv trash $out/bin/
  '';

  meta = {
    description = "Automatically sync TRaSH guides to your Sonarr and Radarr instances.";
    homepage = "https://github.com/rcdailey/trash-updater";
  };
}
