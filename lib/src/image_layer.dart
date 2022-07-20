import 'dart:async';


import 'helpers/xml_accessor.dart';
import 'layer.dart';
import 'properties.dart';
import 'tmx_image.dart';

class ImageLayer extends Layer {
  TmxImage? image;

  @override
  void readAttributes(StreamIterator<XmlAccessor> si) {
    XmlAccessor element = si.current;
    assert(
      element.localName == "imagelayer",
      "can not parse, element is not an 'imagelayer'",
    );

    super.readAttributes(si);
  }

  @override
  Future<void> traverse(StreamIterator<XmlAccessor> si) async {
    XmlAccessor child = si.current;
    switch (child.localName) {
      case "properties":
        properties = await Properties();
        await (properties as Properties).loadXml(si);
        break;
      case "image":
        image = TmxImage();
        await image!.loadXml(si);
        break;
    }
  }
}
