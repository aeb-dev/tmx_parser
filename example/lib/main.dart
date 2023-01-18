import "dart:io";

import "package:tmx_parser/tmx_parser.dart";

Future<void> main(List<String> arguments) async {
  File file = File(
    "map.tmx",
  );

  await TmxParser.fromFile(file);
}
