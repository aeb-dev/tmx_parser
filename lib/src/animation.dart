import 'package:xml/xml.dart';

import 'frame.dart';

class Animation {
  final List<Frame> frameList = [];

  Animation.fromXML(XmlElement element) {
    if (element.name.local != "animation") {
      throw "can not parse, element is not an 'animation'";
    }

    element.children.whereType<XmlElement>().forEach(
      (childElement) {
        switch (childElement.name.local) {
          case "frame":
            frameList.add(Frame.fromXML(childElement));
            break;
        }
      },
    );
  }
}
