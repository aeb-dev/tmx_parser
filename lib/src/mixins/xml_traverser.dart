import "dart:async";

import "package:meta/meta.dart";
import "package:xml/xml_events.dart";

import "../extensions/xml_event.dart";

mixin XmlTraverser {
  @internal
  late StreamIterator<XmlEvent> six;

  @mustCallSuper
  FutureOr<void> loadXml(StreamIterator<XmlEvent> si) async {
    six = si;

    assert(si.current is XmlStartElementEvent);

    String localName = si.current.asStartElement.localName;

    await readAttributesXml(si.current.asStartElement);

    if (!si.current.asStartElement.isSelfClosing) {
      while (await si.moveNext()) {
        if (si.current is XmlStartElementEvent) {
          await traverseXml();
          continue;
        }

        if (si.current is XmlTextEvent) {
          await readTextXml(si.current.asText);
          continue;
        }

        if (si.current is XmlEndElementEvent &&
            si.current.asEndElement.localName == localName) {
          break;
        }
      }
    }

    await postProcessXml();
  }

  @protected
  FutureOr<void> readAttributesXml(XmlStartElementEvent element) {}

  @protected
  FutureOr<void> readTextXml(XmlTextEvent element) {}

  @protected
  FutureOr<void> traverseXml() async {}

  @protected
  FutureOr<void> postProcessXml() async {}
}
