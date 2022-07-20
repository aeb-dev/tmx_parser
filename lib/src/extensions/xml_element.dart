import 'package:xml/xml.dart';

import 'string.dart';

extension XmlElementExtensions on XmlElement {
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

  String? getAttributeStr(String attrName) => this.getAttribute(attrName);

  int? getAttributeInt(String attrName, {int radix = 10}) =>
      this.getAttribute(attrName)?.toInt(radix: radix);

  double? getAttributeDouble(String attrName) =>
      this.getAttribute(attrName)?.toDouble();

  bool? getAttributeBool(String attrName) =>
      this.getAttribute(attrName)?.toBool();

  int? getAttributeColor(String attrName) {
    String? attribute = this.getAttribute(attrName);
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
