import 'dart:async';

import 'package:meta/meta.dart';
import 'package:tmx_parser/src/helpers/xml_accessor.dart';
import 'package:xml/xml.dart';
import 'package:xml/xml_events.dart';

mixin XmlTraverser {
  Future<void> loadXml(StreamIterator<XmlAccessor> si) async {
    readAttributes(si);

    if ((si.current.element is XmlStartElementEvent &&
            (si.current.element as XmlStartElementEvent).isSelfClosing) ||
        (si.current.element is XmlElement &&
            (si.current.element as XmlElement).children.isEmpty)) {
      return;
      // print("i");
    }

    while (await si.moveNext()) {
      if (si.current.element is XmlEndElementEvent) {
        break;
      }

      if (si.current.element is XmlTextEvent) {
        readText(si);
        continue;
      }

      if (si.current.element is XmlText) {
        if ((si.current.element as XmlText).nextElementSibling == null) {
          readText(si);
          break;
        } else {
          readText(si);
          continue;
        }
      }

      if (si.current.element is XmlElement) {
        if ((si.current.element as XmlElement).nextElementSibling == null) {
          await traverse(si);
          break;
        } else {
          await traverse(si);
          continue;
        }
      }

      if (si.current.element is XmlStartElementEvent) {
        await traverse(si);
        continue;
      }
    }

    postProcess(si);
  }

  @protected
  void readAttributes(StreamIterator<XmlAccessor> si) {}

  @protected
  void readText(StreamIterator<XmlAccessor> si) {}

  @protected
  Future<void> traverse(StreamIterator<XmlAccessor> si) async {}

  @protected
  void postProcess(StreamIterator<XmlAccessor> si) {}
}
