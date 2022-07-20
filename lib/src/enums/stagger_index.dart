enum StaggerIndex {
  even,
  odd,
  ;
}

extension StringExtensions on String {
  StaggerIndex toStaggerIndex() {
    switch (this) {
      case "even":
        return StaggerIndex.even;
      case "odd":
        return StaggerIndex.odd;
    }

    throw "Unknown 'StaggerIndex' value: '$this'";
  }
}
