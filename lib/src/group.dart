import 'dart:async';


import 'helpers/xml_accessor.dart';
import 'image_layer.dart';
import 'layer.dart';
import 'tile_layer.dart';
import 'object_group.dart';
import 'properties.dart';

class Group extends Layer {
  final List<TileLayer> tileLayers = [];
  final Map<String, ObjectGroup> objectGroups = {};
  final List<ImageLayer> imageLayers = [];
  final List<Group> groups = [];

  final List<Layer> renderOrderedLayers = [];

  @override
  void readAttributes(StreamIterator<XmlAccessor> si) {
    XmlAccessor element = si.current;
    assert(
      element.localName == "group",
      "can not parse, element is not a 'group'",
    );

    super.readAttributes(si);
  }

  @override
  Future<void> traverse(StreamIterator<XmlAccessor> si) async {
    XmlAccessor child = si.current;
    switch (child.localName) {
      case "properties":
        properties = Properties();
        await (properties as Properties).loadXml(si);
        break;
      case "layer":
        TileLayer tileLayer = TileLayer();
        await tileLayer.loadXml(si);
        tileLayers.add(tileLayer);
        renderOrderedLayers.add(tileLayer);
        break;
      case "objectgroup":
        ObjectGroup objectGroup = await ObjectGroup();
        await objectGroup.loadXml(si);
        objectGroups[objectGroup.name] = objectGroup;
        renderOrderedLayers.add(objectGroup);
        break;
      case "imagelayer":
        ImageLayer imageLayer = await ImageLayer();
        await imageLayer.loadXml(si);
        imageLayers.add(imageLayer);
        renderOrderedLayers.add(imageLayer);
        break;
      case "group":
        Group group = await Group();
        await group.loadXml(si);
        groups.add(group);
        renderOrderedLayers.add(group);
        break;
    }
  }
}
