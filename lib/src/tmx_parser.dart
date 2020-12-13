import 'package:xml/xml.dart';

import 'tmx_map.dart';

class TmxParser {
  TmxParser._();

  static TmxMap parse(String xml) {
    final xmlElement = XmlDocument.parse(xml).rootElement;

    final map = TmxMap.fromXml(xmlElement);

    return map;
  }
}
