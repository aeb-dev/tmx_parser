extension JsonMapExtension on Map<String, dynamic> {
  T getField<T>(
    String fieldName, {
    T? defaultValue,
  }) {
    num toNum(num value) {
      if (1.1 is T) {
        return value.toDouble();
      } else {
        return value.toInt();
      }
    }

    dynamic value = this[fieldName];

    if (value == null) {
      if (defaultValue != null) {
        return defaultValue;
      }

      return value as T;
    }

    if (value is num) {
      value = toNum(value);
    }

    return value as T;
  }
}
