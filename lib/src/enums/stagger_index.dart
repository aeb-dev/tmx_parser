enum StaggerIndex {
  even("even"),
  odd("odd"),
  ;

  final String tiledName;

  const StaggerIndex(this.tiledName);
}

extension StaggerIndexExtensions on String {
  StaggerIndex toStaggerIndex() {
    switch (this) {
      case "even":
        return StaggerIndex.even;
      case "odd":
        return StaggerIndex.odd;
    }

    throw Exception("Unknown 'StaggerIndex' value: '$this'");
  }
}
