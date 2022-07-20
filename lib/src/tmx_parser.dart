import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:tmx_parser/src/helpers/xml_accessor.dart';
import 'package:tmx_parser/src/tmx_map.dart';
import 'package:xml/xml.dart';
import 'package:xml/xml_events.dart';

import "helpers/xml_accessor.dart";

class TmxParser {
  static Future<TmxMap> fromFile(File file) {
    Stream stream = file.openRead().transform(Utf8Decoder());

    String extension = path.extension(file.path);
    if (extension == ".tmx") {
      stream = stream.transform(XmlEventDecoder()).flatten().where((event) =>
          event is XmlStartElementEvent ||
          event is XmlEndElementEvent ||
          (event is XmlTextEvent && event.text.trim().isNotEmpty));
      return TmxParser.fromXmlStream(stream as Stream<XmlEvent>);
    } else if (extension == ".tmj") {
      stream = stream.transform(JsonDecoder());
      // return TmxParser.fromJsonStream(stream);
    }

    throw "Unknown file extensions: '$extension'";
  }

  static Future<TmxMap> fromXmlStream(Stream<XmlEvent> stream) =>
      TmxParser._fromXml(stream.map((event) => XmlAccessor(event)));

  static Future<TmxMap> fromXmlString(String xml) =>
      TmxParser.fromXmlDoc(XmlDocument.parse(xml));

  static Future<TmxMap> fromXmlElement(XmlElement element) {
    if (element.document == null) {
      XmlDocument doc = XmlDocument();
      doc.children.add(element);
    }

    return TmxParser.fromXmlDoc(element.document!);
  }

  static Future<TmxMap> fromXmlDoc(XmlDocument doc) {
    Iterable<XmlAccessor> traverseXml(XmlNode node) sync* {
      if (!(node is XmlText || node is XmlElement)) {
        return;
      }

      if (node is XmlText && node.text.trim().isEmpty) {
        return;
      }

      yield XmlAccessor(node);

      for (XmlNode child in node.children) {
        yield* traverseXml(child);
      }
    }

    Stream<XmlAccessor> childStream =
        Stream.fromIterable(doc.children.expand((c) => traverseXml(c)));

    return TmxParser._fromXml(childStream);
  }

  static Future<TmxMap> _fromXml(Stream<XmlAccessor> stream) async {
    StreamIterator<XmlAccessor> si = StreamIterator(stream);
    await si.moveNext();
    TmxMap map = TmxMap();
    await map.loadXml(si);

    return map;
  }

  // TmxParser.fromJsonFile(File file)
  //     : this.fromJsonStream(
  //           file.openRead().transform(Utf8Decoder()).transform(JsonDecoder()));

  // static Future<TmxMap> fromJsonStream(Stream<Object?> stream) {}

  // static TmxMap fromJsonString(String json) =>
  //     TmxParser.fromJson(jsonDecode(json));

  // static TmxMap fromJson(Map<String, dynamic> v) {}
}
