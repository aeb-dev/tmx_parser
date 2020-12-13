import 'package:xml/xml.dart';

import 'terrain.dart';

class TerrainTypes {
  TerrainTypes._();

  static Map<String, Terrain> fromXML(XmlElement element) {
    if (element.name.local != "terraintypes") {
      throw "can not parse, element is not a 'terraintypes'";
    }

    final Map<String, Terrain> terrains = {};

    element.children.whereType<XmlElement>().forEach((childElement) {
      switch (element.name.local) {
        case "terrain":
          final Terrain terrain = Terrain.fromXML(childElement);
          terrains[terrain.name] = terrain;
          break;
      }
    });

    return terrains;
  }
}
