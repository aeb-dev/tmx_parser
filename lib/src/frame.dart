import 'package:xml/xml.dart';

import 'extensions/xml_element.dart';

class Frame {
  late int tileId;
  late int duration; // in ms

  Frame.fromXML(XmlElement element) {
    if (element.name.local != "frame") {
      throw "can not parse, element is not a 'frame'";
    }

    tileId = element.getAttributeInt("tileid")!;
    duration = element.getAttributeInt("duration")!;
  }
}
