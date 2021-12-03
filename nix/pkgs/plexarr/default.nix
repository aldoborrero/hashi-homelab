{ stdenv
, fetchurl
}:

let
  version = "1.2.0";
in
stdenv.mkDerivation {
  name = "plexarr-${version}";

  src = fetchurl {
    url = "https://github.com/l3uddz/plexarr/releases/download/v${version}/plexarr_v${version}_linux_amd64";
    sha256 = "1fpwb1rbii8bpz74ls65bg9bgl1l55qgvk59vgczszglizaakyr4";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/plexarr
    chmod +x $out/bin/plexarr
  '';

  meta = {
    description = "Fix mismatched media in Plex mastered by Sonarr/Radarr";
    homepage = "https://github.com/l3uddz/plexarr";
  };
}
