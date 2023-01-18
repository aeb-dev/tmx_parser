import "dart:async";

import "package:json_events/json_events.dart";
import "package:xml/xml_events.dart";

import "editor_settings.dart";
import "enums/orientation.dart";
import "enums/render_order.dart";
import "enums/stagger_axis.dart";
import "enums/stagger_index.dart";
import "extensions/json_traverser.dart";
import "extensions/string.dart";
import "extensions/xml_event.dart";
import "extensions/xml_start_element_event.dart";
import "group.dart";
import "image_layer.dart";
import "layer.dart";
import "mixins/xml_traverser.dart";
import "object_group.dart";
import "property.dart";
import "tile_layer.dart";
import "tile_set.dart";

class TmxMap with XmlTraverser, JsonObjectTraverser {
  late String version;
  String? tiledVersion;
  late String className = "";

  late Orientation orientation;
  late RenderOrder renderOrder = RenderOrder.rightDown;
  late int compressionLevel = -1;
  late int width;
  late int height;
  late int tileWidth;
  late int tileHeight;
  int? hexSideLength;
  StaggerAxis? staggerAxis;
  StaggerIndex? staggerIndex;
  late double parallaxOriginX = 0.0;
  late double parallaxOriginY = 0.0;
  int? backgroundColor; // null means transparent
  late int nextLayerId;
  late int nextObjectId;
  late bool infinite = false;
  late EditorSettings editorSettings = EditorSettings();

  final Map<String, TileSet> tileSets = {};

  final List<TileLayer> tileLayers = [];

  final List<ObjectGroup> objectGroups = [];
  final List<ImageLayer> imageLayers = [];
  final List<Group> groups = [];

  final List<Layer> renderOrderedLayers = [];

  final Map<String, Property> properties = {};

  @override
  Future<void> loadXml(StreamIterator<XmlEvent> si) async {
    await si.moveNext();
    await super.loadXml(si);
  }

  @override
  void readAttributesXml(XmlStartElementEvent element) {
    assert(
      element.localName == "map",
      "can not parse, element is not a 'map'",
    );

    version = element.getAttribute<String>("version");
    tiledVersion = element.getAttribute<String?>("tiledversion");
    className = element.getAttribute<String>("class", defaultValue: "");
    orientation = element.getAttribute<String>("orientation").toOrientation();
    renderOrder = element
        .getAttribute<String>("renderorder", defaultValue: "right-down")
        .toRenderOrder();
    compressionLevel =
        element.getAttribute<int>("compressionlevel", defaultValue: -1);
    width = element.getAttribute<int>("width");
    height = element.getAttribute<int>("height");
    tileWidth = element.getAttribute<int>("tilewidth");
    tileHeight = element.getAttribute<int>("tileheight");
    hexSideLength = element.getAttribute<int?>("hexsidelength");
    staggerAxis = element.getAttribute<String?>("staggeraxis")?.toStaggerAxis();
    staggerIndex =
        element.getAttribute<String?>("staggerindex")?.toStaggerIndex();
    parallaxOriginX =
        element.getAttribute("parallaxoriginx", defaultValue: 0.0);
    parallaxOriginY =
        element.getAttribute("parallaxoriginy", defaultValue: 0.0);
    nextLayerId = element.getAttribute<int>("nextlayerid");
    nextObjectId = element.getAttribute<int>("nextobjectid");
    backgroundColor =
        element.getAttribute<String?>("backgroundcolor")?.toColor();
    infinite = element.getAttribute<bool>("infinite", defaultValue: false);
  }

  @override
  Future<void> traverseXml() async {
    switch (six.current.asStartElement.localName) {
      case "tileset":
        TileSet tileSet = TileSet();
        await tileSet.loadXml(six);
        tileSets[tileSet.name] = tileSet;
        break;
      case "layer":
        TileLayer tileLayer = TileLayer();
        await tileLayer.loadXml(six);
        tileLayers.add(tileLayer);
        renderOrderedLayers.add(tileLayer);
        break;
      case "objectgroup":
        ObjectGroup objectGroup = ObjectGroup();
        await objectGroup.loadXml(six);
        objectGroups.add(objectGroup);
        renderOrderedLayers.add(objectGroup);
        break;
      case "imagelayer":
        ImageLayer imageLayer = ImageLayer();
        await imageLayer.loadXml(six);
        imageLayers.add(imageLayer);
        renderOrderedLayers.add(imageLayer);
        break;
      case "group":
        Group group = Group();
        await group.loadXml(six);
        groups.add(group);
        renderOrderedLayers.add(group);
        break;
      case "property":
        Property property = Property();
        await property.loadXml(six);
        properties[property.name] = property;
        break;
      case "editorsettings":
        editorSettings = EditorSettings();
        await editorSettings.loadXml(six);
        break;
    }
  }

  @override
  Future<void> readJson(String key) async {
    switch (key) {
      case "version":
        version = await this.readPropertyJsonContinue<String>();
        break;
      case "tiledversion":
        tiledVersion = await this.readPropertyJsonContinue<String?>();
        break;
      case "class":
        className = (await this.readPropertyJsonContinue<String?>()) ?? "";
        break;
      case "orientation":
        orientation =
            (await this.readPropertyJsonContinue<String>()).toOrientation();
        break;
      case "renderorder":
        renderOrder = (await this.readPropertyJsonContinue<String>(
          defaultValue: "right-down",
        ))
            .toRenderOrder();
        break;
      case "compressionlevel":
        compressionLevel =
            await this.readPropertyJsonContinue<int>(defaultValue: -1);
        break;
      case "width":
        width = await this.readPropertyJsonContinue<int>();
        break;
      case "height":
        height = await this.readPropertyJsonContinue<int>();
        break;
      case "tilewidth":
        tileWidth = await this.readPropertyJsonContinue<int>();
        break;
      case "tileheight":
        tileHeight = await this.readPropertyJsonContinue<int>();
        break;
      case "hexsidelength":
        hexSideLength = await this.readPropertyJsonContinue<int?>();
        break;
      case "staggeraxis":
        staggerAxis =
            (await this.readPropertyJsonContinue<String?>())?.toStaggerAxis();
        break;
      case "staggerindex":
        staggerIndex =
            (await this.readPropertyJsonContinue<String?>())?.toStaggerIndex();
        break;
      case "parallaxoriginx":
        parallaxOriginX =
            await this.readPropertyJsonContinue<double>(defaultValue: 0.0);
        break;
      case "parallaxoriginy":
        parallaxOriginY =
            await this.readPropertyJsonContinue<double>(defaultValue: 0.0);
        break;
      case "nextlayerid":
        nextLayerId = await this.readPropertyJsonContinue<int>();
        break;
      case "nextobjectid":
        nextObjectId = await this.readPropertyJsonContinue<int>();
        break;
      case "backgroundcolor":
        backgroundColor =
            (await this.readPropertyJsonContinue<String?>())?.toColor();
        break;
      case "infinite":
        infinite = await this.readPropertyJsonContinue<bool>();
        break;
      case "tilesets":
        await loadMapJson<String, TileSet>(
          m: tileSets,
          keySelector: (tileSet) => tileSet.name,
          creator: TileSet.new,
        );
        break;
      case "layers":
        await for (Layer layer in this.readArrayJsonContinue(
          creator: () => Layer.fromJsonMap(sij),
          callLoader: false,
        )) {
          if (layer is TileLayer) {
            tileLayers.add(layer);
          } else if (layer is Group) {
            groups.add(layer);
          } else if (layer is ObjectGroup) {
            objectGroups.add(layer);
          } else if (layer is ImageLayer) {
            imageLayers.add(layer);
          }

          renderOrderedLayers.add(layer);
        }
        break;
      case "editorsettings":
        editorSettings =
            await this.readObjectJsonContinue(creator: EditorSettings.new);
        break;
      case "properties":
        await loadMapJson<String, Property>(
          m: properties,
          keySelector: (property) => property.name,
          creator: Property.new,
        );
        break;
    }
  }

  TileSet getTileSetByGid(int gid) {
    TileSet tileSet =
        tileSets.values.lastWhere((tileset) => tileset.firstGid <= gid);
    return tileSet;
  }

  TileSet getTileSetByName(String name) => tileSets[name]!;
}
