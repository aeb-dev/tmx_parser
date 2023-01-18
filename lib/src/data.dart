import "dart:convert";
import "dart:io";
import "dart:typed_data";

import "package:json_events/json_events.dart";
import "package:meta/meta.dart";
import "package:xml/xml_events.dart";

import "enums/compression.dart";
import "enums/encoding.dart";
import "extensions/xml_start_element_event.dart";
import "flips.dart";
import "mixins/xml_traverser.dart";

// TODO: understand how chunks work
class Data with XmlTraverser, JsonObjectTraverser {
  static const int kFlippedHorizontallyFlag = 0x80000000;
  static const int kFlippedVerticallyFlag = 0x40000000;
  static const int kFlippedDiagonallyFlag = 0x20000000;

  late int x = 0;
  late int y = 0;
  late int width;
  late int height;
  late String originalData;

  late List<List<int>> tileMatrix;
  late List<List<Flips?>> tileFlips;

  Data(
    this.width,
    this.height,
  );

  Data.chunked();

  @override
  void readAttributesXml(XmlStartElementEvent element) {
    assert(
      element.localName == "chunk",
      "can not parse, element is not a 'chunk'",
    );

    x = element.getAttribute<int>(
      "x",
    );
    y = element.getAttribute<int>(
      "y",
    );
    width = element.getAttribute<int>(
      "width",
    );
    height = element.getAttribute<int>(
      "height",
    );
  }

  @override
  void readTextXml(XmlTextEvent element) {
    originalData = element.text.trim();
  }

  @override
  Future<void> readJson(String key) async {
    switch (key) {
      case "x":
        x = await this.readPropertyJsonContinue<int>();
        break;
      case "y":
        y = await this.readPropertyJsonContinue<int>();
        break;
      case "width":
        width = await this.readPropertyJsonContinue<int>();
        break;
      case "height":
        height = await this.readPropertyJsonContinue<int>();
        break;
      case "data":
        originalData = await this.readPropertyJsonContinue<String>();
        break;
    }
  }

  @internal
  void postProcess(
    Encoding encoding,
    Compression compression,
  ) {
    List<int> data;
    switch (encoding) {
      case Encoding.csv:
        data = originalData.split(",").map((e) => int.parse(e)).toList();
        break;
      case Encoding.base64:
        data = base64Decode(originalData);
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

    Uint8List rawData = Uint8List.fromList(data);
    if (rawData.length != width * height * 4) {
      throw "data length should match tile size";
    }

    tileMatrix = List.generate(
      height,
      (index) => List.generate(
        width,
        (_) => 0,
        growable: false,
      ),
      growable: false,
    );

    tileFlips = List.generate(
      height,
      (index) => List.generate(
        width,
        (_) => null,
        growable: false,
      ),
      growable: false,
    );

    int tileIndex = 0;
    for (int y = 0; y < height; ++y) {
      for (int x = 0; x < width; ++x) {
        int globalTileId = rawData[tileIndex] |
            rawData[tileIndex + 1] << 8 |
            rawData[tileIndex + 2] << 16 |
            rawData[tileIndex + 3] << 24;

        tileIndex += 4;

        bool flippedHorizontally = (globalTileId & kFlippedHorizontallyFlag) ==
            kFlippedHorizontallyFlag;
        bool flippedVertically =
            (globalTileId & kFlippedVerticallyFlag) == kFlippedVerticallyFlag;
        bool flippedDiagonally =
            (globalTileId & kFlippedDiagonallyFlag) == kFlippedDiagonallyFlag;

        globalTileId &= ~(kFlippedHorizontallyFlag |
            kFlippedVerticallyFlag |
            kFlippedDiagonallyFlag);

        tileMatrix[y][x] = globalTileId;

        tileFlips[y][x] = Flips(
          flippedHorizontally,
          flippedVertically,
          flippedDiagonally,
        );
      }
    }
  }
}
