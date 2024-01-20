import "dart:async";

import "package:json_events/json_events.dart";
import "package:meta/meta.dart";
import "package:xml/xml_events.dart";

import "extensions/json_traverser.dart";
import "extensions/xml_start_element_event.dart";
import "mixins/xml_traverser.dart";

class WangTile with XmlTraverser, JsonObjectTraverser {
  late int tileId;

  final List<int> wangId = <int>[];

  @override
  @internal
  void readAttributesXml(XmlStartElementEvent element) {
    assert(
      element.localName == "wangtile",
      "can not parse, element is not a 'wangtile'",
    );

    tileId = element.getAttribute<int>("tileid");
    element
        .getAttribute<String>("wangid")
        .split(",")
        .forEach((String i) => wangId.add(int.parse(i)));
  }

  @override
  Future<void> readJson(String key) async {
    switch (key) {
      case "tileid":
        tileId = await this.readPropertyJsonContinue<int>();
      case "wangid":
        await this.loadListJson(l: wangId);
    }
  }
}
