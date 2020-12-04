part of tmx_parser;

class WangSets {
  WangSets._();

  static Map<String, WangSet> fromXML(XmlElement element) {
    if (element.name.local != "wangsets") {
      throw "can not parse, element is not a 'wangsets'";
    }

    final Map<String, WangSet> wangSets = {};

    element.children.whereType<XmlElement>().forEach((childElement) {
      switch (childElement.name.local) {
        case "wangset":
          final WangSet wangSet = WangSet.fromXML(childElement);
          wangSets[wangSet.name] = wangSet;
          break;
      }
    });

    return wangSets;
  }
}