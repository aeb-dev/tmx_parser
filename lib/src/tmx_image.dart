import 'package:xml/xml.dart';

import 'data.dart';
import 'extensions/xml_element.dart';

class TmxImage {
  String? format;
  String? source;
  String? trans;
  double? width;
  double? height;
  Data? data;

  TmxImage.fromXML(XmlElement element) {
    if (element.name.local != "image") {
      throw "can not parse, element is not an 'image'";
    }

    format = element.getAttributeStr("format");
    source = element.getAttributeStr("source");
    trans = element.getAttributeStr("trans");
    width = element.getAttributeDouble("width");
    height = element.getAttributeDouble("height");

    if (source == null && format != null) {
      final XmlElement dataElement = element.children
          .whereType<XmlElement>()
          .firstWhere((element) => element.name.local == "data");

      data = Data.fromXML(dataElement);
    }
  }
}
