part of tmx_parser;

class TmxImage {
  String format;
  String source;
  String trans;
  double width;
  double height;
  Uint8List data;

  TmxImage.fromXML(XmlElement element) {
    if (element.name.local != "image") {
      throw "can not parse, element is not an 'image'";
    }

    format = element.getAttributeStrOr("format", format);
    source = element.getAttributeStrOr("source", source);
    trans = element.getAttributeStrOr("trans", trans);
    width = element.getAttributeDoubleOr("width", width);
    height = element.getAttributeDoubleOr("height", height);

    if (source == null && format != null) {
      final XmlElement dataElement = element.children
          .whereType<XmlElement>()
          .firstWhere((element) => element.name.local == "data");

      data = Data.fromXML(dataElement);
    }
  }
}
