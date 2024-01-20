import "dart:async";

import "package:json_events/json_events.dart";
import "package:xml/xml_events.dart";

import "extensions/string.dart";
import "extensions/xml_start_element_event.dart";
import "mixins/xml_traverser.dart";

class TmxImage with XmlTraverser, JsonObjectTraverser {
  // String? format;
  late String source;
  int? transparentColor;
  int? width;
  int? height;
  // Data? data;

  @override
  void readAttributesXml(XmlStartElementEvent element) {
    assert(
      element.localName == "image",
      "can not parse, element is not an 'image'",
    );

    // format = element.getAttributeStr("format");
    source = element.getAttribute<String>("source");
    transparentColor = element.getAttribute<String?>("trans")?.toColor();
    width = element.getAttribute<int?>("width");
    height = element.getAttribute<int?>("height");
  }

  // @override
  // Future<void> traverseXml() async {
  //   switch (si.current.asStartElement.localName) {
  //     case "data":
  //       data = Data();
  //       await data!.loadXml(si);
  //       break;
  //   }
  // }

  @override
  @override
  Future<void> readJson(String key) async {
    switch (key) {
      // case "format":
      //   format = this.readPropertyJsonContinue()
      //   break;
      case "source":
        source = await this.readPropertyJsonContinue<String>();
      case "transparentcolor":
        transparentColor =
            (await this.readPropertyJsonContinue<String?>())?.toColor();
      case "width":
        width = await this.readPropertyJsonContinue<int?>();
      case "height":
        height = await this.readPropertyJsonContinue<int?>();
      // case "data":
      //   break;
    }
  }
}
