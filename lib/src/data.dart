import 'dart:async';
import 'dart:convert' hide Encoding;
import 'dart:io';
import 'dart:typed_data';

import 'package:tmx_parser/src/helpers/xml_traverser.dart';

import 'enums/compression.dart';
import 'enums/encoding.dart';
import 'helpers/xml_accessor.dart';

class Data with XmlTraverser {
  late Encoding encoding;
  late Compression compression;
  late Uint8List rawData;

  @override
  void readAttributes(StreamIterator<XmlAccessor> si) {
    XmlAccessor element = si.current;
    assert(
      element.localName == "data",
      "can not parse, element is not a 'data'",
    );
    encoding = element.getAttributeStrOr("encoding", "").toEncoding();
    compression = element
        .getAttributeStrOr("compression", "uncompressed")
        .toCompression();
  }

  @override
  void readText(StreamIterator<XmlAccessor> si) {
    XmlAccessor element = si.current;

    List<int> data;
    switch (encoding) {
      case Encoding.csv:
        data = element.text.trim().split(",").map((e) => int.parse(e)).toList();
        break;
      case Encoding.base64:
        data = base64Decode(element.text.trim());
        break;
    }

    switch (compression) {
      case Compression.uncompressed:
        break;
      case Compression.gzip:
        data = gzip.decode(data);
        break;
      case Compression.zlib:
        data = zlib.decode(data);
        break;
      case Compression.zstd:
        throw "unsupported compression $compression";
    }

    rawData = Uint8List.fromList(data);
  }
}
