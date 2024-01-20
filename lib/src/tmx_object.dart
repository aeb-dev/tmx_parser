import "dart:async";

import "package:json_events/json_events.dart";
import "package:xml/xml_events.dart";

import "enums/object_type.dart";
import "extensions/json_traverser.dart";
import "extensions/xml_event.dart";
import "extensions/xml_start_element_event.dart";
import "mixins/xml_traverser.dart";
import "point.dart";
import "property.dart";
import "text.dart";

class TmxObject with XmlTraverser, JsonObjectTraverser {
  late int id;
  late String name = "";
  late String className = "";
  late double x = 0.0;
  late double y = 0.0;
  late double width = 0.0;
  late double height = 0.0;
  late double rotation; // in degrees, clockwise
  late bool visible = true;
  // String template;

  int? gid;
  ObjectType? objectType;
  Text? text;

  final List<Point> points = <Point>[];
  final Map<String, Property> properties = <String, Property>{};

  @override
  void readAttributesXml(XmlStartElementEvent element) {
    assert(
      element.localName == "object",
      "can not parse, element is not an 'object'",
    );

    id = element.getAttribute<int>("id");
    name = element.getAttribute<String>("name", defaultValue: "");
    className = element.getAttribute<String>("class", defaultValue: "");
    x = element.getAttribute<double>("x", defaultValue: 0.0);
    y = element.getAttribute<double>("y", defaultValue: 0.0);
    width = element.getAttribute<double>("width", defaultValue: 0.0);
    height = element.getAttribute<double>("height", defaultValue: 0.0);
    rotation = element.getAttribute<double>("rotation", defaultValue: 0.0);
    gid = element.getAttribute<int?>("gid");
    visible = element.getAttribute<bool>("visible", defaultValue: true);
  }

  @override
  Future<void> traverseXml() async {
    switch (six.current.asStartElement.localName) {
      case "ellipse":
        objectType = ObjectType.ellipse;
      case "point":
        objectType = ObjectType.point;
      case "polygon":
      case "polyline":
        objectType = six.current.asStartElement.localName.toObjectType();
        six.current.asStartElement
            .getAttribute<String>("points")
            .split(" ")
            .forEach((String pointS) {
          List<String> pointPairs = pointS.split(",");
          Point p = Point.from(
            double.parse(pointPairs.first),
            double.parse(pointPairs.last),
          );

          points.add(p);
        });
      case "text":
        objectType = ObjectType.text;
        text = Text();
        await text!.loadXml(six);
      case "property":
        Property property = Property();
        await property.loadXml(six);
        properties[property.name] = property;
    }
  }

  @override
  void postProcessXml() {
    _postProcess();
  }

  @override
  Future<void> readJson(String key) async {
    switch (key) {
      case "id":
        id = await this.readPropertyJsonContinue<int>();
      case "name":
        name = await this.readPropertyJsonContinue<String>(defaultValue: "");
      case "class":
        className =
            await this.readPropertyJsonContinue<String>(defaultValue: "");
      case "x":
        x = await this.readPropertyJsonContinue<double>(defaultValue: 0.0);
      case "y":
        y = await this.readPropertyJsonContinue<double>(defaultValue: 0.0);
      case "width":
        width = await this.readPropertyJsonContinue<double>(defaultValue: 0.0);
      case "height":
        height = await this.readPropertyJsonContinue<double>(defaultValue: 0.0);
      case "rotation":
        rotation =
            await this.readPropertyJsonContinue<double>(defaultValue: 0.0);
      case "gid":
        gid = await this.readPropertyJsonContinue<int?>();
      case "visible":
        visible = await this.readPropertyJsonContinue<bool>(defaultValue: true);
      case "ellipse":
        objectType = ObjectType.ellipse;
      case "point":
        objectType = ObjectType.point;
      case "polygon":
      case "polyline":
        objectType = key.toObjectType();
        await loadListJson(
          l: points,
          creator: Point.zero,
        );
      case "text":
        objectType = ObjectType.text;
        text = await this.readObjectJsonContinue(creator: Text.new);
      case "properties":
        await loadMapJson<String, Property>(
          m: properties,
          keySelector: (Property property) => property.name,
          creator: Property.new,
        );
    }
  }

  @override
  Future<void> postProcessJson() async {
    _postProcess();
  }

  void _postProcess() {
    if (gid == null && objectType == null) {
      objectType = ObjectType.rectangle;
    }
  }
}
