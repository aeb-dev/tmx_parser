import "dart:async";

import "package:json_events/json_events.dart";
import "package:meta/meta.dart";
import "package:xml/xml_events.dart";

import "data.dart";
import "enums/compression.dart";
import "enums/draw_order.dart";
import "enums/encoding.dart";
import "extensions/json_map.dart";
import "extensions/string.dart";
import "extensions/xml_event.dart";
import "extensions/xml_start_element_event.dart";
import "group.dart";
import "image_layer.dart";
import "mixins/xml_traverser.dart";
import "object_group.dart";
import "property.dart";
import "tile_layer.dart";
import "tmx_object.dart";

abstract class Layer with XmlTraverser, JsonObjectTraverser {
  late int id;
  late String name = "";
  late bool visible = true;
  late double offsetX = 0.0;
  late double offsetY = 0.0;
  late double opacity = 1.0;
  int? tintColor;

  final Map<String, Property> properties = {};

  static FutureOr<Layer> fromJsonMap(StreamIterator<JsonEvent> si) async {
    late Map<String, dynamic> json;

    Future<void> readJson(String key) async {
      switch (key) {
        case "layers":
          List<Layer> layers = json[key] as List<Layer>;
          await for (Layer layer in readArrayJsonContinue(
            si: si,
            creator: () => Layer.fromJsonMap(si),
            callLoader: false,
          )) {
            layers.add(layer);
          }
          break;
        case "objects":
          List<TmxObject> objects = json[key] as List<TmxObject>;
          await for (TmxObject object in readArrayJsonContinue(
            si: si,
            creator: TmxObject.new,
          )) {
            objects.add(object);
          }
          break;
        case "chunks":
          List<Data> datas = json[key] as List<Data>;
          await for (Data data in readArrayJsonContinue(
            si: si,
            creator: Data.chunked,
          )) {
            datas.add(data);
          }
          break;
        case "properties":
          Map<String, Property> properties = json[key] as Map<String, Property>;

          await for (Property property in readArrayJsonContinue(
            si: si,
            creator: Property.new,
          )) {
            properties[property.name] = property;
          }
          break;
        case "type":
          json[key] = await readPropertyJsonContinue<String>(si: si);
          break;
        case "id":
          json[key] = await readPropertyJsonContinue<int>(si: si);
          break;
        case "name":
          json[key] = await readPropertyJsonContinue<String>(
            si: si,
            defaultValue: "",
          );
          break;
        case "visible":
          json[key] = await readPropertyJsonContinue<bool>(
            si: si,
            defaultValue: true,
          );
          break;
        case "offsetx":
          json[key] = await readPropertyJsonContinue<double>(
            si: si,
            defaultValue: 0.0,
          );
          break;
        case "offsety":
          json[key] = await readPropertyJsonContinue<double>(
            si: si,
            defaultValue: 0.0,
          );
          break;
        case "opacity":
          json[key] = await readPropertyJsonContinue<double>(
            si: si,
            defaultValue: 1.0,
          );
          break;
        case "tintcolor":
          json[key] = (await readPropertyJsonContinue<String?>(
            si: si,
          ))
              ?.toColor();
          break;
        case "color":
          json[key] = (await readPropertyJsonContinue<String?>(
            si: si,
          ))
              ?.toColor();
          break;
        case "draworder":
          json[key] = (await readPropertyJsonContinue<String>(
            si: si,
            defaultValue: "topdown",
          ))
              .toDrawOrder();
          break;
        case "repeatx":
          json[key] = await readPropertyJsonContinue<bool>(
            si: si,
            defaultValue: false,
          );
          break;
        case "repeaty":
          json[key] = await readPropertyJsonContinue<bool>(
            si: si,
            defaultValue: false,
          );
          break;
        case "image":
          json[key] = await readPropertyJsonContinue<String>(
            si: si,
          );
          break;
        case "width":
          json[key] = await readPropertyJsonContinue<int>(
            si: si,
          );
          break;
        case "height":
          json[key] = await readPropertyJsonContinue<int>(
            si: si,
          );
          break;
        case "parallaxx":
          json[key] = await readPropertyJsonContinue<double>(
            si: si,
            defaultValue: 0.0,
          );
          break;
        case "parallaxy":
          json[key] = await readPropertyJsonContinue<double>(
            si: si,
            defaultValue: 0.0,
          );
          break;
        case "data":
          json[key] = await readPropertyJsonContinue<String>(
            si: si,
          );
          break;
        case "compression":
          json[key] = (await readPropertyJsonContinue<String>(
            si: si,
            defaultValue: "uncompressed",
          ))
              .toCompression();
          break;
        case "encoding":
          json[key] = (await readPropertyJsonContinue<String>(
            si: si,
            defaultValue: "",
          ))
              .toEncoding();
          break;
      }
    }

    json = <String, dynamic>{
      "layers": <Layer>[],
      "objects": <TmxObject>[],
      "chunks": <Data>[],
      "properties": <String, Property>{},
    };

    await readCustomObjectJsonContinue(si: si, readJson: readJson);

    late Layer layer;
    switch (json["type"] as String) {
      case "tilelayer":
        layer = TileLayer();
        break;
      case "group":
        layer = Group();
        break;
      case "objectgroup":
        layer = ObjectGroup();
        break;
      case "imagelayer":
        layer = ImageLayer();
        break;
    }

    layer.loadFromJsonMap(json);
    await layer.postProcessJson();

    return layer;
  }

  @override
  @mustCallSuper
  void readAttributesXml(XmlStartElementEvent element) {
    id = element.getAttribute<int>("id");
    name = element.getAttribute<String>(
      "name",
      defaultValue: "",
    );
    visible = element.getAttribute<bool>(
      "visible",
      defaultValue: true,
    );
    offsetX = element.getAttribute<double>(
      "offsetx",
      defaultValue: 0.0,
    );
    offsetY = element.getAttribute<double>(
      "offsety",
      defaultValue: 0.0,
    );
    opacity = element.getAttribute<double>(
      "opacity",
      defaultValue: 1.0,
    );
    tintColor = element.getAttribute<String?>("tintcolor")?.toColor();
  }

  @override
  @mustCallSuper
  Future<void> traverseXml() async {
    switch (six.current.asStartElement.localName) {
      case "property":
        Property property = Property();
        await property.loadXml(six);
        properties[property.name] = property;
        break;
    }
  }

  @override
  Future<void> readJson(String key) async {
    switch (key) {
      case "id":
        id = await this.readPropertyJsonContinue<int>();
        break;
      case "name":
        name = await this.readPropertyJsonContinue<String>(
          defaultValue: "",
        );
        break;
      case "visible":
        visible = await this.readPropertyJsonContinue<bool>(
          defaultValue: true,
        );
        break;
      case "offsetx":
        offsetX = await this.readPropertyJsonContinue<double>(
          defaultValue: 0.0,
        );
        break;
      case "offsety":
        offsetY = await this.readPropertyJsonContinue<double>(
          defaultValue: 0.0,
        );
        break;
      case "opacity":
        opacity = await this.readPropertyJsonContinue<double>(
          defaultValue: 1.0,
        );
        break;
      case "tintcolor":
        tintColor = (await this.readPropertyJsonContinue<String?>())?.toColor();
        break;
    }
  }

  @protected
  @mustCallSuper
  void loadFromJsonMap(Map<String, dynamic> json) {
    id = json.getField<int>("id");
    name = json.getField<String>(
      "name",
      defaultValue: "",
    );
    visible = json.getField<bool>(
      "visible",
      defaultValue: true,
    );
    offsetX = json.getField<double>(
      "offsetx",
      defaultValue: 0.0,
    );
    offsetY = json.getField<double>(
      "offsety",
      defaultValue: 0.0,
    );
    opacity = json.getField(
      "opacity",
      defaultValue: 1.0,
    );
    tintColor = json.getField<String?>("tintcolor")?.toColor();
    properties.addAll(json.getField<Map<String, Property>>("properties"));
  }
}
