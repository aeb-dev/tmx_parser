import "dart:async";

import "package:json_events/json_events.dart";
import "package:xml/xml_events.dart";

import "chunk_size.dart";
import "export.dart";
import "extensions/xml_event.dart";
import "mixins/xml_traverser.dart";

class EditorSettings with XmlTraverser, JsonObjectTraverser {
  ChunkSize chunkSize = ChunkSize();
  Export? export;

  @override
  void readAttributesXml(XmlStartElementEvent element) {
    assert(
      element.localName == "editorsettings",
      "can not parse, element is not a 'editorsettings'",
    );
  }

  @override
  Future<void> traverseXml() async {
    switch (six.current.asStartElement.localName) {
      case "chunksize":
        chunkSize = ChunkSize();
        await chunkSize.loadXml(six);
      case "export":
        export = Export();
        await export!.loadXml(six);
    }
  }

  @override
  Future<void> readJson(String key) async {
    switch (key) {
      case "chunksize":
        chunkSize = await this.readObjectJsonContinue(creator: ChunkSize.new);
      case "export":
        export = await this.readObjectJsonContinue(creator: Export.new);
    }
  }
}
