import 'package:xml/xml.dart';

import 'extensions/xml_element.dart';

class Text {
  String fontFamily = "sans-serif";
  double pixelSize = 16.0; // font size in pixels
  bool wrap = false;
  String color;
  bool bold = false;
  bool italic = false;
  bool underline = false;
  bool kerning = false;
  String hAlign = "left";
  String vAlign = "top";

  Text.fromXML(XmlElement element) {
    if (element.name.local != "text") {
      throw "can not parse, element is not a 'text'";
    }

    fontFamily = element.getAttributeStrOr("fontfamily", fontFamily);
    pixelSize = element.getAttributeDoubleOr("pixelsize", pixelSize);
    wrap = element.getAttributeBoolOr("wrap", wrap);
    color = element.getAttributeStrOr("color", color);
    bold = element.getAttributeBoolOr("bold", bold);
    italic = element.getAttributeBoolOr("italic", italic);
    underline = element.getAttributeBoolOr("underline", underline);
    kerning = element.getAttributeBoolOr("kerning", kerning);
    hAlign = element.getAttributeStrOr("halign", hAlign);
    vAlign = element.getAttributeStrOr("valign", vAlign);
  }
}
