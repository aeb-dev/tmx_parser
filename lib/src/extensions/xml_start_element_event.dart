import "package:collection/collection.dart";
import "package:xml/xml_events.dart";

import "string.dart";

extension XmlElementExtensions on XmlStartElementEvent {
  T getAttribute<T>(
    String attrName, {
    T? defaultValue,
  }) {
    T toTypedValue(String value) {
      if ("" is T) {
        return value as T;
      }

      if (1.1 is T) {
        return value.toDouble() as T;
      }

      if (1 is T) {
        return value.toInt() as T;
      }

      if (true is T) {
        return value.toBool() as T;
      }

      throw "Unreachable";
    }

    String? value = this
        .attributes
        .firstWhereOrNull((attr) => attr.name == attrName)
        ?.value;

    if (value == null && defaultValue == null) {
      return null as T;
    }

    T t = value == null ? defaultValue! : toTypedValue(value);
    return t;
  }
}
