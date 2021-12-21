import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:xml/xml.dart';

class Data {
  String? encoding;
  String? compression;
  Uint8List? rawData;

  // final Map<int, Tile> tiles = {};

  Data.fromXML(XmlElement element) {
    if (element.name.local != "data") {
      throw "can not parse, element is not a 'data'";
    }

    encoding = element.getAttribute("encoding");
    compression = element.getAttribute("compression");

    if (encoding == null) {
      throw "unsupported 'data' node";
      // element.children.whereType<XmlElement>().forEach((childElement) {
      //   switch (childElement.name.local) {
      //     case "tile":
      //       final Tile tile = Tile.fromXML(childElement);
      //       tiles[tile.id] = tile;
      //       break;
      //     // case "chunk":
      //     //   break;
      //   }
      // });
    } else {
      late List<int> data;
      switch (encoding) {
        case "csv":
          data = element.innerText.split(",").map((e) => int.parse(e)).toList();
          break;
        case "base64":
          data = base64Decode(element.innerText.trim());
          break;
        default:
          throw "unsupported encoding $encoding";
      }

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

      rawData = Uint8List.fromList(data);
    }
  }
}
