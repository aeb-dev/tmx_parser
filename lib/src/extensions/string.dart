import '../enums/object_alignment.dart';

extension StringExtensions on String {
  int toInt() => int.parse(this);

  double toDouble() => double.parse(this);

  bool toBool() => this == "1";

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