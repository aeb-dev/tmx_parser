part of tmx_parser;

class Frame {
  int tileId;
  int duration; // in ms

  Frame.fromXML(XmlElement element) {
    if (element.name.local != "frame") {
      throw "can not parse, element is not a 'frame'";
    }

    tileId = element.getAttributeIntOr("tileid", tileId);
    duration = element.getAttributeIntOr("duration", duration);
  }
}