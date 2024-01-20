enum Encoding {
  csv("csv"),
  base64("base64"),
  ;

  final String tiledName;

  const Encoding(this.tiledName);
}

extension EncodingExtensions on String {
  Encoding toEncoding() {
    switch (this) {
      case "csv":
        return Encoding.csv;
      case "base64":
        return Encoding.base64;
    }

    throw Exception("Unknown 'Encoding' value: '$this'");
  }
}
