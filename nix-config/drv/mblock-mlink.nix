
{ stdenv, lib, fetchurl, rpmextract, makeWrapper, autoPatchelfHook, cpio }:

stdenv.mkDerivation rec {
  pname = "mblock-mlink";
  version = "1.2.0";

  src = /home/caches/Downloads/mLink-1.2.0-1.el7.x86_64.rpm;

  unpackPhase = ''
    ${rpmextract}/bin/rpm2cpio $src | ${cpio}/bin/cpio -idmv
  '';

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  installPhase = ''
    mv $out/usr/local/makeblock $out/usr/makeblock
    rmdir $out/usr/local
    mkdir -p $out/bin
    echo $out/usr/makeblock/mLink/mnode $out/usr/makeblock/mLink/app.js > $out/bin/mlink
    chmod +x $out/bin/mlink
  '';

  meta = with lib; {
    description = "Driver for mBlock web version";
    homepage = "https://mblock.makeblock.com/en-us/download/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.mausch ];
  };
}
