import "package:xml/xml_events.dart";

extension XmlEventExtensions on XmlEvent {
  XmlStartElementEvent get asStartElement => this as XmlStartElementEvent;
  XmlEndElementEvent get asEndElement => this as XmlEndElementEvent;
  XmlTextEvent get asText => this as XmlTextEvent;
}
