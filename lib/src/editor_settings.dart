import 'dart:async';

import 'chunk_size.dart';
import 'export.dart';
import 'mixins/xml_traverser.dart';
import 'helpers/xml_accessor.dart';

class EditorSettings with XmlTraverser {
  ChunkSize? chunkSize;
  Export? export;

  @override
  void readAttributesXml(StreamIterator<XmlAccessor> si) {
    XmlAccessor element = si.current;
    assert(
      element.localName == "editorsettings",
      "can not parse, element is not a 'editorsettings'",
    );
  }

  @override
  Future<void> traverseXml(StreamIterator<XmlAccessor> si) async {
    XmlAccessor child = si.current;
    switch (child.localName) {
      case "chunkSize":
        chunkSize = ChunkSize();
        await chunkSize!.loadXml(si);
        break;
      case "export":
        export = Export();
        await export!.loadXml(si);
        break;
    }
  }
}
