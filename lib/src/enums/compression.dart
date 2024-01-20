enum Compression {
  uncompressed("uncompressed"),
  gzip("gzip"),
  zlib("zlib"),
  zstd("zstd"),
  ;

  final String tiledName;

  const Compression(this.tiledName);
}

extension CompressionExtensions on String {
  Compression toCompression() {
    switch (this) {
      case "":
      case "uncompressed":
        return Compression.uncompressed;
      case "gzip":
        return Compression.gzip;
      case "zlib":
        return Compression.zlib;
      case "zstd":
        return Compression.zstd;
    }

    throw Exception("Unknown 'Compression' value: '$this'");
  }
}
