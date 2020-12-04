part of tmx_parser;

class TmxParser {
  TmxParser._();

  static TmxMap parse(String xml) {
    final xmlElement = XmlDocument.parse(xml).rootElement;

    final map = TmxMap.fromXml(xmlElement);

    return map;
  }
}
