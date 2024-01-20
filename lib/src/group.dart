import "dart:async";

import "package:xml/xml_events.dart";

import "extensions/xml_event.dart";
import "image_layer.dart";
import "layer.dart";
import "object_group.dart";
import "tile_layer.dart";

class Group extends Layer {
  final List<TileLayer> tileLayers = <TileLayer>[];
  final List<ObjectGroup> objectGroups = <ObjectGroup>[];
  final List<ImageLayer> imageLayers = <ImageLayer>[];
  final List<Group> groups = <Group>[];

  final List<Layer> renderOrderedLayers = <Layer>[];

  @override
  void readAttributesXml(XmlStartElementEvent element) {
    assert(
      element.localName == "group",
      "can not parse, element is not a 'group'",
    );

    super.readAttributesXml(element);
  }

  @override
  Future<void> traverseXml() async {
    await super.traverseXml();
    switch (six.current.asStartElement.localName) {
      case "layer":
        TileLayer tileLayer = TileLayer();
        await tileLayer.loadXml(six);
        tileLayers.add(tileLayer);
        renderOrderedLayers.add(tileLayer);
      case "objectgroup":
        ObjectGroup objectGroup = ObjectGroup();
        await objectGroup.loadXml(six);
        objectGroups.add(objectGroup);
        renderOrderedLayers.add(objectGroup);
      case "imagelayer":
        ImageLayer imageLayer = ImageLayer();
        await imageLayer.loadXml(six);
        imageLayers.add(imageLayer);
        renderOrderedLayers.add(imageLayer);
      case "group":
        Group group = Group();
        await group.loadXml(six);
        groups.add(group);
        renderOrderedLayers.add(group);
    }
  }

  @override
  Future<void> readJson(String key) async {
    await super.readJson(key);
    switch (key) {
      case "layers":
        await for (Layer l in this.readArrayJsonContinue()) {
          if (l is TileLayer) {
            tileLayers.add(l);
          } else if (l is Group) {
            groups.add(l);
          } else if (l is ObjectGroup) {
            objectGroups.add(l);
          } else if (l is ImageLayer) {
            imageLayers.add(l);
          }

          renderOrderedLayers.add(l);
        }
    }
  }

  @override
  void loadFromJsonMap(Map<String, dynamic> json) {
    super.loadFromJsonMap(json);

    for (Layer layer in json["layers"] as Iterable<Layer>) {
      if (layer is TileLayer) {
        tileLayers.add(layer);
      } else if (layer is Group) {
        groups.add(layer);
      } else if (layer is ObjectGroup) {
        objectGroups.add(layer);
      } else if (layer is ImageLayer) {
        imageLayers.add(layer);
      }

      renderOrderedLayers.add(layer);
    }
  }
}
