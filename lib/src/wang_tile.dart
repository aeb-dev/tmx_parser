import 'package:xml/xml.dart';

import 'extensions/xml_element.dart';

class WangTile {
  late int tileId;
  late int wangId;

  WangTile.fromXML(XmlElement element) {
    if (element.name.local != "wangtile") {
      throw "can not parse, element is not a 'wangtile'";
    }

    tileId = element.getAttributeInt("tileId")!;
    wangId = element.getAttributeInt("wangId")!;
  }
}
