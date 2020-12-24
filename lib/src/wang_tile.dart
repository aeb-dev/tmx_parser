import 'package:xml/xml.dart';

import 'extensions/xml_element.dart';

class WangTile {
  int tileId;
  int wangId;
  bool hflip = false;
  bool vflip = false;
  bool dflip = false;

  WangTile.fromXML(XmlElement element) {
    if (element.name.local != "wangtile") {
      throw "can not parse, element is not a 'wangtile'";
    }

    tileId = element.getAttributeIntOr("tileId", tileId);
    wangId = element.getAttributeIntOr("wangId", wangId);
    hflip = element.getAttributeBoolOr("hflip", hflip);
    vflip = element.getAttributeBoolOr("vflip", vflip);
    dflip = element.getAttributeBoolOr("dflip", dflip);
  }
}
