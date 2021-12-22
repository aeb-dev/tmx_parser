# Tmx Parser
**Tmx Parser** is a library for parsing Tiled files.

Supported file types are: **.tmx**

Supported file formats are: **Xml**
# Usage
Usage is very simple. Supply your .tmx file content like the following
```dart
// String xml = // read your .tmx file in anyway
TmxMap tmxMap = TmxParser.parse(xml);
```

After that you can acess any item in your map. Check tiled documentation [documentation](https://doc.mapeditor.org/en/stable/reference/tmx-map-format/#)
