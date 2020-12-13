import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:xml/xml.dart';

class Data {
  static Uint8List fromXML(XmlElement element) {
    if (element.name.local != "data") {
      throw "can not parse, element is not a 'data'";
    }

    Uint8List data;
    final String encoding = element.getAttribute("encoding");
    switch (encoding) {
      case "csv":
        data = Uint8List.fromList(
            element.innerText.split(",").map((e) => int.parse(e)).toList());
        break;
      case "base64":
        data = base64Decode(element.innerText.trim());
        break;
      default:
        throw "unsupported encoding $encoding";
    }

    final String compression = element.getAttribute("compression");
    if (compression != null) {
      switch (compression) {
        case "gzip":
          data = gzip.decode(data);
          break;
        case "zlib":
          data = zlib.decode(data);
          break;
        case "zstd":
        default:
          throw "unsupported compression $compression";
      }
    }

    return data;
  }
}
