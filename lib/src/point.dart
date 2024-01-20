import "package:json_events/json_events.dart";

class Point with JsonObjectTraverser {
  late double x = 0.0;
  late double y = 0.0;

  Point.from(
    this.x,
    this.y,
  );

  Point.zero();

  @override
  Future<void> readJson(String key) async {
    switch (key) {
      case "x":
        x = await this.readPropertyJsonContinue<double>(defaultValue: 0.0);
      case "y":
        y = await this.readPropertyJsonContinue<double>(defaultValue: 0.0);
    }
  }
}
