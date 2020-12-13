import 'dart:ffi';

import 'package:xml/xml.dart';

import 'string.dart';

extension XmlElementExtensions on XmlElement {
  String getAttributeStrOr(String attrName, String defaultValue) =>
      this.getAttribute(attrName) ?? defaultValue;

  int getAttributeIntOr(String attrName, int defaultValue) =>
      this.getAttribute(attrName)?.toInt() ?? defaultValue;

  double getAttributeDoubleOr(String attrName, double defaultValue) =>
      this.getAttribute(attrName)?.toDouble() ?? defaultValue;

  Uint32 getAttributeUintOr(String attrName, Uint32 defaultValue) =>
      this.getAttribute(attrName)?.toUint() ?? defaultValue;

  bool getAttributeBoolOr(String attrName, bool defaultValue) =>
      this.getAttribute(attrName)?.toBool() ?? defaultValue;
}