import "dart:async";
import "dart:convert";
import "dart:io";

import "package:json_events/json_events.dart";
import "package:xml/xml.dart";
import "package:xml/xml_events.dart";

import "../tmx_parser.dart";

class TmxParser {
  TmxParser._();

  static Future<TmxMap> fromFile(File file) {
    int dotIndex = file.path.lastIndexOf(".");
    String extension = file.path.substring(dotIndex);
    if (extension == ".tmx") {
      Stream<String> stream = file.openRead().transform(const Utf8Decoder());

      return TmxParser._fromXmlStringStream(stream);
    } else if (extension == ".tmj") {
      Stream<String> stream = file.openRead().transform(const Utf8Decoder());

      return TmxParser.fromJsonStringStream(stream);
    }

    throw "Unknown file extension: '$extension'";
  }

  static Future<TmxMap> fromXmlStream(Stream<XmlEvent> stream) async {
    StreamIterator<XmlEvent> si = StreamIterator(stream);
    TmxMap map = TmxMap();
    await map.loadXml(si);
    return map;
  }

  static Future<TmxMap> fromXmlString(String xml) =>
      TmxParser._fromXmlStringStream(Stream.value(xml));

  static Future<TmxMap> _fromXmlStringStream(Stream<String> stream) {
    Stream<XmlEvent> eventStream =
        stream.toXmlEvents().normalizeEvents().flatten().where(
              (event) =>
                  event is XmlStartElementEvent ||
                  event is XmlEndElementEvent ||
                  (event is XmlTextEvent && event.text.trim().isNotEmpty),
            );

    return TmxParser.fromXmlStream(eventStream);
  }

  static Future<TmxMap> fromXmlElement(XmlElement element) =>
      TmxParser.fromXmlString(element.outerXml);

  static Future<TmxMap> fromXmlDoc(XmlDocument doc) =>
      TmxParser.fromXmlString(doc.rootElement.outerXml);

  static Future<TmxMap> fromJsonStream(Stream<JsonEvent> stream) async {
    TmxMap map = TmxMap();
    await map.loadJsonFromStream(stream);
    return map;
  }

  static Future<TmxMap> fromJsonStringStream(Stream<String> stream) async {
    TmxMap map = TmxMap();
    await map.loadJsonFromStringStream(stream);
    return map;
  }

  static Future<TmxMap> fromJsonString(String json) async {
    TmxMap map = TmxMap();
    await map.loadJsonFromString(json);
    return map;
  }

  // static Future<TmxMap> fromJsonMap(Map<String, dynamic> jsonMap) async {
  //   TmxMap map = TmxMap();
  //   await map.loadJsonFromMap(jsonMap);
  //   return map;
  // }
}
