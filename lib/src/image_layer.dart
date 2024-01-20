import "dart:async";

import "package:xml/xml_events.dart";

import "extensions/json_map.dart";
import "extensions/xml_event.dart";
import "extensions/xml_start_element_event.dart";
import "layer.dart";
import "tmx_image.dart";

class ImageLayer extends Layer {
  TmxImage? image;
  late bool repeatX = false;
  late bool repeatY = false;

  @override
  void readAttributesXml(XmlStartElementEvent element) {
    assert(
      element.localName == "imagelayer",
      "can not parse, element is not an 'imagelayer'",
    );

    super.readAttributesXml(element);
    repeatX = element.getAttribute<bool>(
      "repeatx",
      defaultValue: false,
    );
    repeatY = element.getAttribute<bool>(
      "repeaty",
      defaultValue: false,
    );
  }

  @override
  Future<void> traverseXml() async {
    await super.traverseXml();
    switch (six.current.asStartElement.localName) {
      case "image":
        image = TmxImage();
        await image!.loadXml(six);
    }
  }

  @override
  Future<void> readJson(String key) async {
    await super.readJson(key);
    switch (key) {
      case "repeatx":
        repeatX = await this.readPropertyJsonContinue<bool>(
          defaultValue: false,
        );
      case "repeaty":
        repeatY = await this.readPropertyJsonContinue<bool>(
          defaultValue: false,
        );
      case "image":
        image ??= TmxImage();
        image!.source = await this.readPropertyJsonContinue<String>();
    }
  }

  @override
  void loadFromJsonMap(Map<String, dynamic> json) {
    super.loadFromJsonMap(json);
    repeatX = json.getField(
      "repeatx",
      defaultValue: false,
    );
    repeatY = json.getField(
      "repeaty",
      defaultValue: false,
    );
    if (json["image"] != null) {
      image = TmxImage();
      image!.source = json.getField<String>("image");
    }
  }
}
