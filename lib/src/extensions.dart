part of tmx_parser;

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

extension StringExtensions on String {
  int toInt() => int.parse(this);

  double toDouble() => double.parse(this);

  bool toBool() => this == "1";

  Uint32 toUint() => int.parse(this) as Uint32;

  ObjectAlignment toObjectAlignment() {
    ObjectAlignment objectAligment;
    switch (this) {
      case "unspecified":
      case "bottomleft":
        objectAligment = ObjectAlignment.bottomLeft;
        break;
      case "bottomright":
        objectAligment = ObjectAlignment.bottomRight;
        break;
      case "bottom":
        objectAligment = ObjectAlignment.bottom;
        break;
      case "topleft":
        objectAligment = ObjectAlignment.topLeft;
        break;
      case "topright":
        objectAligment = ObjectAlignment.topRight;
        break;
      case "top":
        objectAligment = ObjectAlignment.top;
        break;
      case "left":
        objectAligment = ObjectAlignment.left;
        break;
      case "center":
        objectAligment = ObjectAlignment.center;
        break;
      case "right":
        objectAligment = ObjectAlignment.right;
        break;
      default:
        throw "unexpected 'objectalignment': $this";
    }

    return objectAligment;
  }
}
