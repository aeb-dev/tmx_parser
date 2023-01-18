import "dart:async";

import "package:xml/xml_events.dart";

import "data.dart";
import "enums/compression.dart";
import "enums/encoding.dart";
import "extensions/json_map.dart";
import "extensions/json_traverser.dart";
import "extensions/xml_event.dart";
import "extensions/xml_start_element_event.dart";
import "layer.dart";

class TileLayer extends Layer {
  late int width;
  late int height;
  late double parallaxX = 0.0;
  late double parallaxY = 0.0;
  late Encoding encoding;
  late Compression compression = Compression.uncompressed;

  final List<Data> chunks = [];

  // Data? data;

  @override
  void readAttributesXml(XmlStartElementEvent element) {
    assert(
      element.localName == "layer",
      "can not parse, element is not a 'layer'",
    );

    super.readAttributesXml(element);
    width = element.getAttribute<int>("width");
    height = element.getAttribute<int>("height");
    parallaxX = element.getAttribute<double>("parallaxx", defaultValue: 0.0);
    parallaxY = element.getAttribute<double>("parallaxy", defaultValue: 0.0);
  }

  @override
  Future<void> traverseXml() async {
    await super.traverseXml();
    XmlStartElementEvent element = six.current.asStartElement;
    switch (element.localName) {
      case "data":
        encoding = element.getAttribute<String>("encoding").toEncoding();
        compression = element
            .getAttribute<String>(
              "compression",
              defaultValue: "uncompressed",
            )
            .toCompression();
        break;
      case "chunk":
        Data chunk = Data.chunked();
        await chunk.loadXml(six);
        chunks.add(chunk);
        break;
    }
  }

  @override
  void readTextXml(XmlTextEvent element) {
    Data data = Data(
      width,
      height,
    );
    data.originalData = element.text.trim();
    chunks.add(data);
  }

  @override
  void postProcessXml() {
    _postProcess();
  }

  @override
  Future<void> readJson(String key) async {
    await super.readJson(key);
    switch (key) {
      case "width":
        width = await this.readPropertyJsonContinue<int>();
        break;
      case "height":
        height = await this.readPropertyJsonContinue<int>();
        break;
      case "parallaxx":
        parallaxX =
            await this.readPropertyJsonContinue<double>(defaultValue: 0.0);
        break;
      case "parallaxy":
        parallaxY =
            await this.readPropertyJsonContinue<double>(defaultValue: 0.0);
        break;
      case "data":
        Data data = Data(
          width,
          height,
        );
        data.originalData = await this.readPropertyJsonContinue<String>();
        chunks.add(data);
        break;
      case "compression":
        compression = (await this.readPropertyJsonContinue<String>(
          defaultValue: "uncompressed",
        ))
            .toCompression();
        break;
      case "encoding":
        encoding = (await this.readPropertyJsonContinue<String>(
          defaultValue: "",
        ))
            .toEncoding();
        break;
      case "chunks":
        await this.loadListJson(
          l: chunks,
          creator: Data.chunked,
        );
        break;
    }
  }

  @override
  void postProcessJson() {
    _postProcess();
  }

  void _postProcess() {
    for (Data data in chunks) {
      data.postProcess(
        encoding,
        compression,
      );
    }
  }

  @override
  void loadFromJsonMap(Map<String, dynamic> json) {
    super.loadFromJsonMap(json);
    width = json.getField<int>("width");
    height = json.getField<int>("height");
    parallaxX = json.getField<double>(
      "parallaxx",
      defaultValue: 0.0,
    );
    parallaxY = json.getField<double>(
      "parallaxy",
      defaultValue: 0.0,
    );
    compression = json.getField<Compression>(
      "compression",
      defaultValue: Compression.uncompressed,
    );
    encoding = json.getField<Encoding>("encoding");

    String? originalData = json.getField<String?>("data");
    if (originalData != null) {
      Data data = Data(
        width,
        height,
      );
      data.originalData = originalData;
      chunks.add(data);
    }

    List<Data>? _chunks = json.getField<List<Data>?>("chunks");
    if (_chunks != null) {
      chunks.addAll(_chunks);
    }
  }
}
