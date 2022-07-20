enum TileRenderSize {
  tile,
  grid,
}

extension StringExtensions on String {
  TileRenderSize toTileRenderSize() {
    switch (this) {
      case "tile":
        return TileRenderSize.tile;
      case "grid":
        return TileRenderSize.grid;
    }

    throw "Unknown 'TileRenderSize' value: '$this'";
  }
}
