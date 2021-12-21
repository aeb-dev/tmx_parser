import 'package:xml/xml.dart';

import 'string.dart';

extension XmlElementExtensions on XmlElement {
  String getAttributeStrOr(String attrName, String defaultValue) =>
      this.getAttributeStr(attrName) ?? defaultValue;

  int getAttributeIntOr(String attrName, int defaultValue) =>
      getAttributeInt(attrName) ?? defaultValue;

  double getAttributeDoubleOr(String attrName, double defaultValue) =>
      this.getAttributeDouble(attrName) ?? defaultValue;

  bool getAttributeBoolOr(String attrName, bool defaultValue) =>
      this.getAttributeBool(attrName) ?? defaultValue;

  String? getAttributeStr(String attrName) => this.getAttribute(attrName);

  int? getAttributeInt(String attrName) => this.getAttribute(attrName)?.toInt();

  double? getAttributeDouble(String attrName) =>
      this.getAttribute(attrName)?.toDouble();

  bool? getAttributeBool(String attrName) =>
      this.getAttribute(attrName)?.toBool();
}
