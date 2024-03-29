import "dart:async";

import "package:json_events/json_events.dart";
import "package:xml/xml_events.dart";

import "extensions/json_traverser.dart";
import "extensions/string.dart";
import "extensions/xml_event.dart";
import "extensions/xml_start_element_event.dart";
import "frame.dart";
import "mixins/xml_traverser.dart";
import "object_group.dart";
import "property.dart";
import "tmx_image.dart";

class Tile with XmlTraverser, JsonObjectTraverser {
  late int id;
  late String className = "";
  late double probability = 0.0;
  // late int x = 0;
  // late int y = 0;
  // late double width;
  // late double height;

  TmxImage? image;
  ObjectGroup? objectGroup;

  final Map<String, Property> properties = <String, Property>{};
  final List<Frame> animation = <Frame>[];

  @override
  void readAttributesXml(XmlStartElementEvent element) {
    assert(
      element.localName == "tile",
      "can not parse, element is not a 'tile'",
    );

    id = element.getAttribute<int>("id");
    className = element.getAttribute<String>("class", defaultValue: "");
    probability =
        element.getAttribute<double>("probability", defaultValue: 0.0);
    // x = element.getAttribute<int>("x", defaultValue: 0);
    // y = element.getAttribute<int>("y", defaultValue: 0);
    // width =  element.getAttribute<int>("width", defaultValue: 0);
    // height = element.getAttribute<int>("height", defaultValue: 0);
  }

  @override
  Future<void> traverseXml() async {
    switch (six.current.asStartElement.localName) {
      case "property":
        Property property = Property();
        await property.loadXml(six);
        properties[property.name] = property;
      case "image":
        image = TmxImage();
        await image!.loadXml(six);
      case "objectgroup":
        objectGroup = ObjectGroup();
        await objectGroup!.loadXml(six);
      case "frame":
        Frame frame = Frame();
        await frame.loadXml(six);
        animation.add(frame);
    }
  }

  @override
  Future<void> readJson(String key) async {
    switch (key) {
      case "id":
        id = await this.readPropertyJsonContinue<int>();
      case "class":
        className =
            await this.readPropertyJsonContinue<String>(defaultValue: "");
      case "probability":
        probability =
            await this.readPropertyJsonContinue<double>(defaultValue: 0.0);
      // case "x":
      //   x = await this.readPropertyJsonContinue<int>(defaultValue: 0);
      //   break;
      // case "y":
      //   y = await this.readPropertyJsonContinue<int>(defaultValue: 0);
      //   break;
      case "properties":
        await loadMapJson<String, Property>(
          m: properties,
          keySelector: (Property property) => property.name,
          creator: Property.new,
        );
      // case "format":
      //   image ??= TmxImage();
      //   image!.format = await this.readPropertyJsonContinue<String?>();
      //   break;
      case "image":
        image ??= TmxImage();
        image!.source = await this.readPropertyJsonContinue<String>();
      case "transparentcolor":
        image ??= TmxImage();
        image!.transparentColor =
            (await this.readPropertyJsonContinue<String?>())?.toColor();
      case "imagewidth":
        image ??= TmxImage();
        image!.width = await this.readPropertyJsonContinue<int?>();
      case "imageheight":
        image ??= TmxImage();
        image!.height = await this.readPropertyJsonContinue<int?>();
      case "objectgroup":
        objectGroup =
            await this.readObjectJsonContinue(creator: ObjectGroup.new);
      case "animation":
        await loadListJson(
          l: animation,
          creator: Frame.new,
        );
    }
  }
}
