import 'dart:async';

import 'package:tmx_parser/src/helpers/xml_traverser.dart';

import 'enums/h_align.dart';
import 'enums/v_align.dart';
import 'helpers/xml_accessor.dart';

class Text with XmlTraverser {
  late String fontFamily;
  late double pixelSize; // font size in pixels
  late bool wrap;
  late int color;
  late bool bold;
  late bool italic;
  late bool underline;
  late bool kerning;
  late HAlign hAlign;
  late VAlign vAlign;

  @override
  void readAttributes(StreamIterator<XmlAccessor> si) {
    XmlAccessor element = si.current;
    assert(
      element.localName == "text",
      "can not parse, element is not a 'text'",
    );
    fontFamily = element.getAttributeStrOr("fontfamily", "sans-serif");
    pixelSize = element.getAttributeDoubleOr("pixelsize", 16.0);
    wrap = element.getAttributeBoolOr("wrap", false);
    color = element.getAttributeColorOr("color", 0xff000000);
    bold = element.getAttributeBoolOr("bold", false);
    italic = element.getAttributeBoolOr("italic", false);
    underline = element.getAttributeBoolOr("underline", false);
    kerning = element.getAttributeBoolOr("kerning", false);
    hAlign = element.getAttributeStrOr("halign", "left").toHAlign();
    vAlign = element.getAttributeStrOr("valign", "top").toVAlign();
  }
}
