import 'dart:async';


import 'enums/draw_order.dart';
import 'helpers/xml_accessor.dart';
import 'layer.dart';
import 'properties.dart';
import 'tmx_object.dart';

class ObjectGroup extends Layer {
  late int? color;
  late DrawOrder drawOrder;

  final Map<String, TmxObject> objectMapByName = {};
  final Map<int, TmxObject> objectMapById = {};

  final List<TmxObject> _objectList = [];

  @override
  void readAttributes(StreamIterator<XmlAccessor> si) {
    XmlAccessor element = si.current;
    assert(
      element.localName == "objectgroup",
      "can not parse, element is not a 'objectgroup'",
    );
    super.readAttributes(si);

    color = element.getAttributeColor("color");
    drawOrder = element.getAttributeStrOr("draworder", "topdown").toDrawOrder();
  }

  @override
  Future<void> traverse(StreamIterator<XmlAccessor> si) async {
    XmlAccessor child = si.current;
    switch (child.localName) {
      case "properties":
        properties = Properties();
        await (properties as Properties).loadXml(si);
        break;
      case "object":
        TmxObject object = TmxObject();
        await object.loadXml(si);
        _objectList.add(object);
        break;
    }
  }

  @override
  void postProcess(StreamIterator<XmlAccessor> si) {
    if (drawOrder == DrawOrder.topDown) {
      _objectList.sort((first, second) => first.y.compareTo(second.y));
    }

    for (TmxObject object in _objectList) {
      objectMapByName[object.name] = object;
      objectMapById[object.id] = object;
    }

    _objectList.clear();
  }
}
