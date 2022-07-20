import 'package:collection/collection.dart';
import 'package:xml/xml_events.dart';

import 'string.dart';

extension XmlElementExtensions on XmlStartElementEvent {
  String getAttributeStrOr(String attrName, String defaultValue) =>
      this.getAttributeStr(attrName) ?? defaultValue;

  int getAttributeIntOr(String attrName, int defaultValue, {int radix = 10}) =>
      getAttributeInt(attrName, radix: radix) ?? defaultValue;

  double getAttributeDoubleOr(String attrName, double defaultValue) =>
      this.getAttributeDouble(attrName) ?? defaultValue;

  bool getAttributeBoolOr(String attrName, bool defaultValue) =>
      this.getAttributeBool(attrName) ?? defaultValue;

  int getAttributeColorOr(String attrName, int defaultValue) =>
      this.getAttributeColor(attrName) ?? defaultValue;

  String? getAttributeStr(String attrName) =>
      this.attributes.firstWhereOrNull((attr) => attr.name == attrName)?.value;

  int? getAttributeInt(String attrName, {int radix = 10}) =>
      this.getAttributeStr(attrName)?.toInt(radix: radix);

  double? getAttributeDouble(String attrName) =>
      this.getAttributeStr(attrName)?.toDouble();

  bool? getAttributeBool(String attrName) =>
      this.getAttributeStr(attrName)?.toBool();

  int? getAttributeColor(String attrName) {
    String? attribute = this.getAttributeStr(attrName);
    if (attribute == null) {
      return null;
    }

    String replace = "";
    if (attribute.length == 6) {
      replace = "ff";
    }

    return attribute.replaceFirst("#", replace).toInt(radix: 16);
  }
}
