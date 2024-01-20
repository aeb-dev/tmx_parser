import "dart:async";

import "package:xml/xml_events.dart";

import "enums/draw_order.dart";
import "extensions/json_map.dart";
import "extensions/json_traverser.dart";
import "extensions/string.dart";
import "extensions/xml_event.dart";
import "extensions/xml_start_element_event.dart";
import "layer.dart";
import "tmx_object.dart";

class ObjectGroup extends Layer {
  int? color;
  late DrawOrder drawOrder = DrawOrder.topDown;

  final Map<int, TmxObject> objects = <int, TmxObject>{};

  late final List<TmxObject> _objects = <TmxObject>[];

  @override
  void readAttributesXml(XmlStartElementEvent element) {
    assert(
      element.localName == "objectgroup",
      "can not parse, element is not a 'objectgroup'",
    );
    super.readAttributesXml(element);

    color = element.getAttribute<String?>("color")?.toColor();
    drawOrder = element
        .getAttribute<String>(
          "draworder",
          defaultValue: "topdown",
        )
        .toDrawOrder();
  }

  @override
  Future<void> traverseXml() async {
    await super.traverseXml();
    switch (six.current.asStartElement.localName) {
      case "object":
        TmxObject object = TmxObject();
        await object.loadXml(six);
        _objects.add(object);
    }
  }

  @override
  void postProcessXml() {
    _postProcess();
  }

  @override
  Future<void> readJson(String key) async {
    await super.readJson(key);
    switch (key) {
      case "color":
        color = (await this.readPropertyJsonContinue<String?>())?.toColor();
      case "draworder":
        drawOrder = (await this.readPropertyJsonContinue<String>(
          defaultValue: "topdown",
        ))
            .toDrawOrder();
      case "objects":
        await loadListJson(
          l: _objects,
          creator: TmxObject.new,
        );
    }
  }

  @override
  void loadFromJsonMap(Map<String, dynamic> json) {
    super.loadFromJsonMap(json);
    color = json.getField<String?>("color")?.toColor();
    drawOrder = json.getField<DrawOrder>(
      "draworder",
      defaultValue: DrawOrder.topDown,
    );

    _objects.addAll(json.getField<List<TmxObject>>("objects"));
  }

  @override
  Future<void> postProcessJson() async {
    _postProcess();
  }

  void _postProcess() {
    if (drawOrder == DrawOrder.topDown) {
      _objects.sort(
          (TmxObject first, TmxObject second) => first.y.compareTo(second.y),);
    }

    for (TmxObject object in _objects) {
      objects[object.id] = object;
    }

    _objects.clear();
  }
}
