import 'package:meta/meta.dart';
import 'package:xml/xml.dart';
import 'package:xml/xml_events.dart';

import '../extensions/xml_element.dart';
import '../extensions/xml_start_element_event.dart';

@internal
class XmlAccessor {
  final Object element;

  String get localName {
    if (element is XmlStartElementEvent) {
      return (element as XmlStartElementEvent).localName;
    } else {
      return (element as XmlElement).name.local;
    }
  }

  String get text {
    if (element is XmlTextEvent) {
      return (element as XmlTextEvent).text;
    } else {
      return (element as XmlNode).text;
    }
  }

  const XmlAccessor(this.element)
      : assert(
          element is XmlStartElementEvent ||
              element is XmlTextEvent ||
              element is XmlEndElementEvent ||
              element is XmlElement ||
              element is XmlText,
          "element has to be either 'XmlStartElementEvent' or 'XmlTextEvent' or 'XmlEndElementEvent' or 'XmlElement' or 'XmlText'",
        );

  String getAttributeStrOr(String attrName, String defaultValue) {
    if (element is XmlStartElementEvent) {
      return (element as XmlStartElementEvent)
          .getAttributeStrOr(attrName, defaultValue);
    } else {
      return (element as XmlElement).getAttributeStrOr(attrName, defaultValue);
    }
  }

  int getAttributeIntOr(String attrName, int defaultValue, {int radix = 10}) {
    if (element is XmlStartElementEvent) {
      return (element as XmlStartElementEvent)
          .getAttributeIntOr(attrName, defaultValue);
    } else {
      return (element as XmlElement).getAttributeIntOr(attrName, defaultValue);
    }
  }

  double getAttributeDoubleOr(String attrName, double defaultValue) {
    if (element is XmlStartElementEvent) {
      return (element as XmlStartElementEvent)
          .getAttributeDoubleOr(attrName, defaultValue);
    } else {
      return (element as XmlElement)
          .getAttributeDoubleOr(attrName, defaultValue);
    }
  }

  bool getAttributeBoolOr(String attrName, bool defaultValue) {
    if (element is XmlStartElementEvent) {
      return (element as XmlStartElementEvent)
          .getAttributeBoolOr(attrName, defaultValue);
    } else {
      return (element as XmlElement).getAttributeBoolOr(attrName, defaultValue);
    }
  }

  int getAttributeColorOr(String attrName, int defaultValue) {
    if (element is XmlStartElementEvent) {
      return (element as XmlStartElementEvent)
          .getAttributeColorOr(attrName, defaultValue);
    } else {
      return (element as XmlElement)
          .getAttributeColorOr(attrName, defaultValue);
    }
  }

  String? getAttributeStr(String attrName) {
    if (element is XmlStartElementEvent) {
      return (element as XmlStartElementEvent).getAttributeStr(attrName);
    } else {
      return (element as XmlElement).getAttributeStr(attrName);
    }
  }

  int? getAttributeInt(String attrName, {int radix = 10}) {
    if (element is XmlStartElementEvent) {
      return (element as XmlStartElementEvent).getAttributeInt(attrName);
    } else {
      return (element as XmlElement).getAttributeInt(attrName);
    }
  }

  double? getAttributeDouble(String attrName) {
    if (element is XmlStartElementEvent) {
      return (element as XmlStartElementEvent).getAttributeDouble(attrName);
    } else {
      return (element as XmlElement).getAttributeDouble(attrName);
    }
  }

  bool? getAttributeBool(String attrName) {
    if (element is XmlStartElementEvent) {
      return (element as XmlStartElementEvent).getAttributeBool(attrName);
    } else {
      return (element as XmlElement).getAttributeBool(attrName);
    }
  }

  int? getAttributeColor(String attrName) {
    if (element is XmlStartElementEvent) {
      return (element as XmlStartElementEvent).getAttributeColor(attrName);
    } else {
      return (element as XmlElement).getAttributeColor(attrName);
    }
  }
}
