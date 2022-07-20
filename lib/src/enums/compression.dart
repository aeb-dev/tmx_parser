enum Compression {
  uncompressed,
  gzip,
  zlib,
  zstd,
  ;
}

extension StringExtensions on String {
  Compression toCompression() {
    switch (this) {
      case "uncompressed":
        return Compression.uncompressed;
      case "gzip":
        return Compression.gzip;
      case "zlib":
        return Compression.zlib;
      case "zstd":
        return Compression.zstd;
    }

    throw "Unknown 'Compression' value: '$this'";
  }
}
