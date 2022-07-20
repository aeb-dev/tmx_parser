enum Encoding {
  csv,
  base64,
  ;
}

extension StringExtensions on String {
  Encoding toEncoding() {
    switch (this) {
      case "csv":
        return Encoding.csv;
      case "base64":
        return Encoding.base64;
    }

    throw "Unknown 'Encoding' value: '$this'";
  }
}
