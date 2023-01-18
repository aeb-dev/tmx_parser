// ignore_for_file: invalid_use_of_protected_member

import "dart:async";

import "package:json_events/json_events.dart";

extension JsonTraversExtensions on JsonObjectTraverser {
  Future<void> loadListJson<T>({
    required List<T> l,
    FutureOr<T> Function()? creator,
  }) async {
    await for (T t in this.readArrayJsonContinue(
      creator: creator,
    )) {
      l.add(t);
    }
  }

  Future<void> loadMapJson<K, V>({
    required Map<K, V> m,
    required K Function(V) keySelector,
    FutureOr<V> Function()? creator,
  }) async {
    await for (V v in this.readArrayJsonContinue(
      creator: creator,
    )) {
      K k = keySelector(v);
      m[k] = v;
    }
  }
}
