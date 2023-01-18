import "dart:async";

import "package:json_events/json_events.dart";
import "package:xml/xml_events.dart";

import "enums/h_align.dart";
import "enums/v_align.dart";
import "extensions/string.dart";
import "extensions/xml_start_element_event.dart";
import "mixins/xml_traverser.dart";

class Text with XmlTraverser, JsonObjectTraverser {
  late String fontFamily = "sans-serif";
  late double pixelSize = 16.0; // font size in pixels
  late bool wrap = false;
  late int color = 0xff000000;
  late bool bold = false;
  late bool italic = false;
  late bool underline = false;
  late bool kerning = false;
  late HAlign hAlign = HAlign.left;
  late VAlign vAlign = VAlign.top;

  late String content = "";

  @override
  void readAttributesXml(XmlStartElementEvent element) {
    assert(
      element.localName == "text",
      "can not parse, element is not a 'text'",
    );
    fontFamily =
        element.getAttribute<String>("fontfamily", defaultValue: "sans-serif");
    pixelSize = element.getAttribute<double>("pixelsize", defaultValue: 16.0);
    wrap = element.getAttribute<bool>("wrap", defaultValue: false);
    color = element
        .getAttribute<String>("color", defaultValue: "0xff000000")
        .toColor();
    bold = element.getAttribute<bool>("bold", defaultValue: false);
    italic = element.getAttribute<bool>("italic", defaultValue: false);
    underline = element.getAttribute<bool>("underline", defaultValue: false);
    kerning = element.getAttribute<bool>("kerning", defaultValue: false);
    hAlign =
        element.getAttribute<String>("halign", defaultValue: "left").toHAlign();
    vAlign =
        element.getAttribute<String>("valign", defaultValue: "top").toVAlign();
  }

  @override
  void readTextXml(XmlTextEvent element) {
    content = element.text;
  }

  @override
  Future<void> readJson(String key) async {
    switch (key) {
      case "fontFamily":
        fontFamily = await this
            .readPropertyJsonContinue<String>(defaultValue: "sans-serif");
        break;
      case "pixelSize":
        pixelSize =
            await this.readPropertyJsonContinue<double>(defaultValue: 16.0);
        break;
      case "wrap":
        wrap = await this.readPropertyJsonContinue<bool>(defaultValue: false);
        break;
      case "color":
        color = (await this
                .readPropertyJsonContinue<String>(defaultValue: "0xff000000"))
            .toColor();
        break;
      case "bold":
        bold = await this.readPropertyJsonContinue<bool>(defaultValue: false);
        break;
      case "italic":
        italic = await this.readPropertyJsonContinue<bool>(defaultValue: false);
        break;
      case "underline":
        underline =
            await this.readPropertyJsonContinue<bool>(defaultValue: false);
        break;
      case "kerning":
        kerning =
            await this.readPropertyJsonContinue<bool>(defaultValue: false);
        break;
      case "hAlign":
        (await this.readPropertyJsonContinue<String>(defaultValue: "left"))
            .toHAlign();
        break;
      case "vAlign":
        (await this.readPropertyJsonContinue<String>(defaultValue: "top"))
            .toVAlign();
        break;
    }
  }
}
