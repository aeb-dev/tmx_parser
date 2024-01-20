enum TileRenderSize {
  tile("tile"),
  grid("grid"),
  ;

  final String tiledName;

  const TileRenderSize(this.tiledName);
}

extension TileRenderSizeExtensions on String {
  TileRenderSize toTileRenderSize() {
    switch (this) {
      case "tile":
        return TileRenderSize.tile;
      case "grid":
        return TileRenderSize.grid;
    }

    throw Exception("Unknown 'TileRenderSize' value: '$this'");
  }
}
