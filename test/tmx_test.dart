import "dart:io";

import "package:test/test.dart";
import "package:tmx_parser/tmx_parser.dart";

// TODO: add tests for 'text' and 'editor settings'
// TODO: change test structure. Is group inside group good?(No?)
void main() {
  group("xml", () {
    late File file;
    setUpAll(() async {
      file = File("./test/files/tmx_file.tmx");
    });

    testMap(() => file);
  });

  group("json", () {
    late File file;
    setUpAll(() async {
      file = File("./test/files/tmj_file.tmj");
    });

    testMap(() => file);
  });
}

void testMap(File Function() f) {
  group("map", () {
    late TmxMap tmxMap;
    setUpAll(() async {
      tmxMap = await TmxParser.fromFile(f());
    });

    test("", () {
      expect(tmxMap.backgroundColor, equals(null));
      expect(tmxMap.className, "");
      expect(tmxMap.compressionLevel, -1);
      expect(tmxMap.height, equals(32));
      expect(tmxMap.hexSideLength, isNull);
      expect(tmxMap.infinite, equals(false));
      expect(tmxMap.nextLayerId, equals(21));
      expect(tmxMap.nextObjectId, equals(52));
      expect(tmxMap.orientation, equals(Orientation.orthogonal));
      expect(tmxMap.parallaxOriginX, equals(0.0));
      expect(tmxMap.parallaxOriginY, equals(0.0));
      expect(tmxMap.renderOrder, equals(RenderOrder.rightDown));
      expect(tmxMap.staggerAxis, isNull);
      expect(tmxMap.staggerIndex, isNull);
      expect(tmxMap.tileHeight, equals(32));
      expect(tmxMap.tileWidth, equals(32));
      expect(tmxMap.tiledVersion, equals("1.9.0"));
      expect(tmxMap.version, equals("1.9"));
      expect(tmxMap.width, equals(128));
    });

    // group("editorSettings", () {
    //   late EditorSettings editorSettings;
    //   setUpAll(() {
    //     editorSettings = tmxMap.editorSettings;
    //   });

    //   test("", () {
    //     expect(editorSettings.chunkSize, isNotNull);
    //     expect(editorSettings.export, isNotNull);
    //   });

    //   test("chunkSize", () {
    //     ChunkSize chunkSize = editorSettings.chunkSize;

    //     expect(chunkSize.height, equals(16));
    //     expect(chunkSize.width, equals(16));
    //   });

    //   test("export", () {
    //     Export export = editorSettings.export!;

    //     expect(export.format, equals("json"));
    //     expect(export.target, equals("tmj_file.tmj"));
    //   });
    // });

    group("groups", () {
      late List<Group> groups;
      setUpAll(() {
        groups = tmxMap.groups;
      });

      test("", () {
        expect(groups.length, equals(1));
      });

      group("index 0", () {
        late Group group_;
        setUpAll(() {
          group_ = groups[0];
        });

        test("", () {
          expect(group_.id, equals(5));
          expect(group_.name, equals("objects"));
          expect(group_.offsetX, equals(0.0));
          expect(group_.offsetY, equals(0.0));
          expect(group_.opacity, equals(1.0));
          expect(group_.tintColor, isNull);
          expect(group_.visible, equals(true));

          expect(group_.groups, isEmpty);
          expect(group_.imageLayers, isEmpty);
          expect(group_.properties, isEmpty);
        });

        group("objectGroups", () {
          late List<ObjectGroup> objectGroups;
          setUpAll(() {
            objectGroups = group_.objectGroups;
          });

          test("", () {
            expect(objectGroups.length, equals(2));
          });

          group("index 0", () {
            late ObjectGroup objectGroup;
            setUpAll(() {
              objectGroup = objectGroups[0];
            });

            test("", () {
              expect(objectGroup.color, isNull);
              expect(objectGroup.drawOrder, equals(DrawOrder.topDown));
              expect(objectGroup.id, equals(2));
              expect(objectGroup.name, equals("box-mountain"));
              expect(objectGroup.offsetX, equals(0.0));
              expect(objectGroup.offsetY, equals(0.0));
              expect(objectGroup.opacity, equals(1.0));
              expect(objectGroup.properties, isEmpty);
              expect(objectGroup.tintColor, isNull);
              expect(objectGroup.visible, equals(true));
            });

            group("objects", () {
              late Map<int, TmxObject> objects;
              setUpAll(() {
                objects = objectGroup.objects;
              });

              test("", () {
                expect(objects.length, equals(2));
              });

              group("key 1", () {
                late TmxObject object;
                setUpAll(() {
                  object = objects[1]!;
                });

                test("", () {
                  expect(object.className, equals(""));
                  expect(object.gid, equals(22));
                  expect(object.height, equals(35));
                  expect(object.id, equals(1));
                  expect(object.name, equals(""));
                  expect(object.objectType, isNull);
                  expect(object.points, isEmpty);
                  expect(object.properties, isEmpty);
                  expect(object.rotation, equals(0.0));
                  expect(object.text, isNull);
                  expect(object.visible, equals(true));
                  expect(object.width, equals(35));
                  expect(object.x, equals(256));
                  expect(object.y, equals(480));
                });
              });

              group("key 2", () {
                late TmxObject object;
                setUpAll(() {
                  object = objects[2]!;
                });

                test("", () {
                  expect(object.className, equals(""));
                  expect(object.gid, equals(22));
                  expect(object.height, equals(35));
                  expect(object.id, equals(2));
                  expect(object.name, equals(""));
                  expect(object.objectType, isNull);
                  expect(object.points, isEmpty);
                  expect(object.properties, isEmpty);
                  expect(object.rotation, equals(0.0));
                  expect(object.text, isNull);
                  expect(object.visible, equals(true));
                  expect(object.width, equals(35));
                  expect(object.x, equals(288));
                  expect(object.y, equals(480));
                });
              });
            });
          });

          group("index 1", () {
            late ObjectGroup objectGroup;
            setUpAll(() {
              objectGroup = objectGroups[1];
            });

            test("", () {
              expect(objectGroup.color, isNull);
              expect(objectGroup.drawOrder, equals(DrawOrder.topDown));
              expect(objectGroup.id, equals(4));
              expect(objectGroup.name, equals("table"));
              expect(objectGroup.offsetX, equals(0.0));
              expect(objectGroup.offsetY, equals(0.0));
              expect(objectGroup.opacity, equals(1.0));
              expect(objectGroup.properties, isEmpty);
              expect(objectGroup.tintColor, isNull);
              expect(objectGroup.visible, equals(true));
            });

            group("objects", () {
              late Map<int, TmxObject> objects;
              setUpAll(() {
                objects = objectGroup.objects;
              });

              test("", () {
                expect(objects.length, equals(1));
              });

              group("key 21", () {
                late TmxObject object;
                setUpAll(() {
                  object = objects[21]!;
                });

                test("", () {
                  expect(object.className, equals(""));
                  expect(object.gid, equals(27));
                  expect(object.height, equals(28));
                  expect(object.id, equals(21));
                  expect(object.name, equals(""));
                  expect(object.objectType, isNull);
                  expect(object.points, isEmpty);
                  expect(object.properties, isEmpty);
                  expect(object.rotation, equals(0.0));
                  expect(object.text, isNull);
                  expect(object.visible, equals(true));
                  expect(object.width, equals(73));
                  expect(object.x, equals(1632));
                  expect(object.y, equals(320));
                });
              });
            });
          });
        });
      });
    });

    group("imageLayers", () {
      late List<ImageLayer> imageLayers;
      setUpAll(() {
        imageLayers = tmxMap.imageLayers;
      });

      test("", () {
        expect(imageLayers.length, equals(1));
      });

      group("index 0", () {
        late ImageLayer imageLayer;
        setUpAll(() {
          imageLayer = imageLayers[0];
        });

        test("", () {
          expect(imageLayer.repeatX, equals(false));
          expect(imageLayer.repeatY, equals(false));
          expect(imageLayer.id, equals(16));
          expect(imageLayer.name, equals("Image Layer 1"));
          expect(imageLayer.offsetX, equals(0));
          expect(imageLayer.offsetY, equals(0));
          expect(imageLayer.opacity, equals(1.0));
          expect(imageLayer.properties, isEmpty);
          expect(imageLayer.tintColor, isNull);
          expect(imageLayer.visible, equals(true));
        });

        group("image", () {
          late TmxImage image;
          setUpAll(() {
            image = imageLayer.image!;
          });

          test("", () {
            expect(image.width, isNull);
            expect(image.height, isNull);
            expect(image.source, equals("../images/background.jpg"));
            expect(image.transparentColor, isNull);
          });
        });
      });
    });

    group("objectGroups", () {
      late List<ObjectGroup> objectGroups;
      setUpAll(() {
        objectGroups = tmxMap.objectGroups;
      });

      test("", () {
        expect(objectGroups.length, equals(1));
      });

      group("index 0", () {
        late ObjectGroup objectGroup;
        setUpAll(() {
          objectGroup = objectGroups[0];
        });

        test("", () {
          expect(objectGroup.objects.length, equals(2));
          expect(objectGroup.objects[47], isNotNull);
          expect(objectGroup.objects[51], isNotNull);
        });

        group("objects", () {
          late Map<int, TmxObject> objects;
          setUpAll(() {
            objects = objectGroups[0].objects;
          });

          group("key 47", () {
            late TmxObject object;
            setUpAll(() {
              object = objects[47]!;
            });

            test("", () {
              expect(object.id, equals(47));
              expect(object.x, equals(2050));
              expect(object.y, equals(190));
              expect(object.width, equals(98));
              expect(object.height, equals(82));
            });
          });

          group("key 51", () {
            late TmxObject object;
            setUpAll(() {
              object = objects[51]!;
            });

            test("", () {
              expect(object.id, equals(51));
              expect(object.gid, equals(2));
              expect(object.x, equals(2054));
              expect(object.y, equals(398));
            });
          });
        });
      });
    });

    group("properties", () {
      late Map<String, Property> properties;
      setUpAll(() {
        properties = tmxMap.properties;
      });

      test("", () {
        expect(properties["hasName"]!.value, equals(true));
        expect(properties["name"]!.value, equals("Woaw"));
      });
    });

    group("renderOrderedLayers", () {
      late List<Layer> renderOrderedLayers;
      setUpAll(() {
        renderOrderedLayers = tmxMap.renderOrderedLayers;
      });

      test("", () {
        // the order will be reversed of the tiled map editor
        expect(renderOrderedLayers[0], isA<ImageLayer>());
        expect(renderOrderedLayers[1], isA<ObjectGroup>());
        expect(renderOrderedLayers[2], isA<TileLayer>());
        expect(renderOrderedLayers[3], isA<Group>());
        expect(renderOrderedLayers[4], isA<TileLayer>());
      });
    });

    group("tileLayers", () {
      late List<TileLayer> tileLayers;
      setUpAll(() {
        tileLayers = tmxMap.tileLayers;
      });

      test("", () {
        expect(tileLayers.length, equals(2));
      });

      group("index 0", () {
        late TileLayer tileLayer;
        setUpAll(() {
          tileLayer = tileLayers[0];
        });

        test("", () {
          expect(tileLayer.compression, equals(Compression.uncompressed));
          expect(tileLayer.encoding, equals(Encoding.base64));
          expect(tileLayer.height, equals(32));
          expect(tileLayer.parallaxX, equals(0.0));
          expect(tileLayer.parallaxY, equals(0.0));
          expect(tileLayer.width, equals(128));
          expect(tileLayer.id, equals(6));
          expect(tileLayer.name, equals("wall"));
          expect(tileLayer.offsetX, equals(0.0));
          expect(tileLayer.offsetY, equals(0.0));
          expect(tileLayer.opacity, equals(1.0));
          expect(tileLayer.tintColor, isNull);
          expect(tileLayer.visible, equals(true));

          expect(tileLayer.properties, isEmpty);
        });

        group("chunks", () {
          late List<Data> data;
          setUpAll(() {
            data = tileLayer.chunks;
          });

          test("", () {
            expect(data.length, equals(1));
          });

          group("index 0", () {
            late Data datum;
            setUpAll(() {
              datum = data[0];
            });

            test("", () {
              expect(datum.height, equals(32));
              expect(datum.width, equals(128));
              expect(datum.x, equals(0));
              expect(datum.y, equals(0));
            });
          });
        });
      });

      group("index 1", () {
        late TileLayer tileLayer;
        setUpAll(() {
          tileLayer = tileLayers[1];
        });

        test("", () {
          expect(tileLayer.compression, equals(Compression.uncompressed));
          expect(tileLayer.encoding, equals(Encoding.base64));
          expect(tileLayer.height, equals(30));
          expect(tileLayer.parallaxX, equals(0.0));
          expect(tileLayer.parallaxY, equals(0.0));
          expect(tileLayer.width, equals(30));
          expect(tileLayer.id, equals(19));
          expect(tileLayer.name, equals("chunk"));
          expect(tileLayer.offsetX, equals(0.0));
          expect(tileLayer.offsetY, equals(0.0));
          expect(tileLayer.opacity, equals(1.0));
          expect(tileLayer.tintColor, isNull);
          expect(tileLayer.visible, equals(true));

          expect(tileLayer.properties, isEmpty);
        });

        group("chunks", () {
          late List<Data> chunks;
          setUpAll(() {
            chunks = tileLayer.chunks;
          });

          test(
            "",
            () {
              expect(chunks.length, equals(1));
            },
          );

          group("index 0", () {
            late Data chunk;
            setUpAll(() {
              chunk = chunks[0];
            });

            test("", () {
              expect(chunk.x, equals(0));
              expect(chunk.y, equals(0));
              expect(chunk.width, equals(30.0));
              expect(chunk.height, equals(30.0));
              expect(
                chunk.originalData,
                equals(
                  "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                ),
              );
            });
          });
        });
      });
    });

    group("tileSets", () {
      late Map<String, TileSet> tileSets;
      setUpAll(() {
        tileSets = tmxMap.tileSets;
      });

      test("", () {
        expect(tileSets.length, equals(2));
        expect(tileSets["platform"], isNotNull);
        expect(tileSets["props"], isNotNull);
      });

      group("key platform", () {
        late TileSet tileSet;
        setUpAll(() {
          tileSet = tmxMap.tileSets["platform"]!;
        });

        test("", () {
          expect(tileSet.name, equals("platform"));
          expect(tileSet.firstGid, equals(1));
          expect(tileSet.tileWidth, equals(32));
          expect(tileSet.tileHeight, equals(32));
          expect(tileSet.tileCount, equals(1));
          expect(tileSet.columns, equals(2));
          expect(tileSet.objectAlignment, equals(ObjectAlignment.center));

          expect(tileSet.image, isNotNull);
          expect(tileSet.tiles, isNotNull);
        });

        group("image", () {
          late TmxImage image;
          setUpAll(() {
            image = tileSet.image!;
          });

          test("", () {
            expect(image.source, equals("../images/platform_dark.png"));
            expect(image.transparentColor, equals(0x1fb51f));
            expect(image.width, equals(256));
            expect(image.height, equals(256));
          });
        });

        group("tiles", () {
          late Map<int, Tile> tiles;
          setUpAll(() {
            tiles = tileSet.tiles;
          });

          test("", () {
            expect(tiles.length, equals(1));
            expect(tiles[0], isNotNull);
          });

          group("key 0", () {
            late Tile tile;
            setUpAll(() {
              tile = tiles[0]!;
            });

            test("", () {
              expect(tile.id, equals(0));

              expect(tile.objectGroup, isNotNull);
            });

            group("objectGroup", () {
              late ObjectGroup objectGroup;
              setUpAll(() {
                objectGroup = tiles[0]!.objectGroup!;
              });

              test("", () {
                expect(objectGroup.id, equals(2));
                expect(objectGroup.drawOrder, equals(DrawOrder.indexOrder));
              });

              group("objects", () {
                late Map<int, TmxObject> objects;
                setUpAll(() {
                  objects = objectGroup.objects;
                });

                test("", () {
                  expect(objects.length, equals(2));

                  expect(objects[5], isNotNull);
                  expect(objects[6], isNotNull);
                });

                group("key 5", () {
                  late TmxObject object;
                  setUpAll(() {
                    object = objects[5]!;
                  });

                  test("", () {
                    expect(object.id, equals(5));
                    expect(object.x, equals(0));
                    expect(object.y, equals(32));
                    expect(object.objectType, equals(ObjectType.polyline));
                    expect(object.points, isNotNull);
                    expect(object.points.length, equals(2));
                    expect(object.points[0].x, equals(0));
                    expect(object.points[0].y, equals(0));
                    expect(object.points[1].x, equals(0));
                    expect(object.points[1].y, equals(-32));
                  });
                });

                group("key 6", () {
                  late TmxObject object;
                  setUpAll(() {
                    object = objects[6]!;
                  });

                  test("", () {
                    expect(object.id, equals(6));
                    expect(object.x, equals(0));
                    expect(object.y, equals(0));
                    expect(object.objectType, equals(ObjectType.polyline));
                    expect(object.points, isNotNull);
                    expect(object.points.length, equals(2));
                    expect(object.points[0].x, equals(0));
                    expect(object.points[0].y, equals(0));
                    expect(object.points[1].x, equals(32));
                    expect(object.points[1].y, equals(0));
                  });
                });
              });
            });
          });
        });
      });

      group("key props", () {
        late TileSet tileSet;
        setUpAll(() {
          tileSet = tmxMap.tileSets["props"]!;
        });

        test("", () {
          expect(tileSet.name, equals("props"));
          expect(tileSet.firstGid, equals(21));
          expect(tileSet.tileWidth, equals(1920));
          expect(tileSet.tileHeight, equals(661));
          expect(tileSet.tileCount, equals(2));
          expect(tileSet.columns, equals(0));
          expect(tileSet.objectAlignment, equals(ObjectAlignment.topRight));

          expect(tileSet.grid, isNotNull);
          expect(tileSet.tiles, isNotNull);
          expect(tileSet.wangSets, isNotNull);
        });

        group("grid", () {
          late Grid grid;
          setUpAll(() {
            grid = tileSet.grid!;
          });

          test("", () {
            expect(grid.orientation, equals(Orientation.orthogonal));
            expect(grid.width, equals(1));
            expect(grid.height, equals(1));
          });
        });

        group("tiles", () {
          late Map<int, Tile> tiles;
          setUpAll(() {
            tiles = tileSet.tiles;
          });

          test("", () {
            expect(tiles.length, equals(2));
            expect(tiles[0], isNotNull);
            expect(tiles[1], isNotNull);
          });

          group("key 0", () {
            late Tile tile;
            setUpAll(() {
              tile = tiles[0]!;
            });

            test("", () {
              expect(tile.id, equals(0));

              expect(tile.image, isNotNull);
              expect(tile.animation, isNotNull);
            });

            group("image", () {
              late TmxImage image;
              setUpAll(() {
                image = tile.image!;
              });

              test("", () {
                expect(image.source, equals("../images/box_big.png"));
              });
            });

            group("animation", () {
              late List<Frame> animation;
              setUpAll(() {
                animation = tile.animation;
              });

              test("", () {
                expect(animation.length, equals(2));
              });

              group("index 0", () {
                late Frame frame;
                setUpAll(() {
                  frame = animation[0];
                });

                test("", () {
                  expect(frame.tileId, equals(0));
                  expect(frame.duration, equals(100));
                });
              });

              group("index 1", () {
                late Frame frame;
                setUpAll(() {
                  frame = animation[1];
                });

                test("", () {
                  expect(frame.tileId, equals(1));
                  expect(frame.duration, equals(100));
                });
              });
            });
          });

          group("key 1", () {
            late Tile tile;
            setUpAll(() {
              tile = tiles[1]!;
            });

            test("", () {
              expect(tile.id, equals(1));

              expect(tile.objectGroup, isNotNull);
            });

            group("image", () {
              late TmxImage image;
              setUpAll(() {
                image = tile.image!;
              });

              test("", () {
                expect(image.source, equals("../images/box_small.png"));
              });
            });

            group("objectGroup", () {
              late ObjectGroup objectGroup;
              setUpAll(() {
                objectGroup = tiles[1]!.objectGroup!;
              });

              test("", () {
                expect(objectGroup.id, equals(2));
                expect(objectGroup.drawOrder, equals(DrawOrder.indexOrder));
              });

              group("objects", () {
                late Map<int, TmxObject> objects;
                setUpAll(() {
                  objects = objectGroup.objects;
                });

                test("", () {
                  expect(objects.length, equals(1));

                  expect(objects[1], isNotNull);
                });

                group("key 1", () {
                  late TmxObject object;
                  setUpAll(() {
                    object = objects[1]!;
                  });

                  test("", () {
                    expect(object.id, equals(1));
                    expect(object.x, equals(0));
                    expect(object.y, equals(0));
                    expect(object.width, equals(35));
                    expect(object.height, equals(35));
                    expect(object.objectType, equals(ObjectType.rectangle));
                  });
                });
              });
            });
          });
        });

        group("wangsets", () {
          late Map<String, WangSet> wangSets;
          setUpAll(() {
            wangSets = tileSet.wangSets;
          });

          test("", () {
            expect(wangSets.length, equals(2));
          });

          group("key Unnamed Set", () {
            late WangSet wangSet;
            setUpAll(() {
              wangSet = wangSets["Unnamed Set"]!;
            });

            test("", () {
              expect(wangSet.name, equals("Unnamed Set"));
              expect(wangSet.tile, equals(1));
            });

            group("wangColors", () {
              late List<WangColor> wangColors;
              setUpAll(() {
                wangColors = wangSet.wangColors;
              });

              test("", () {
                expect(wangColors.length, equals(1));
              });

              group(
                "index 0",
                () {
                  late WangColor wangColor;

                  setUpAll(() {
                    wangColor = wangColors[0];
                  });

                  test("", () {
                    expect(wangColor.name, equals(""));
                    expect(wangColor.color, equals(0xff0000));
                    expect(wangColor.tile, equals(0));
                    expect(wangColor.probability, equals(1));
                  });
                },
              );
            });

            group("wangTiles", () {
              late Map<int, WangTile> wangTiles;
              setUpAll(() {
                wangTiles = wangSet.wangTiles;
              });

              test("", () {
                expect(wangTiles.length, equals(2));
              });

              group(
                "key 1",
                () {
                  late WangTile wangTile;

                  setUpAll(() {
                    wangTile = wangTiles[1]!;
                  });

                  test("", () {
                    expect(wangTile.tileId, equals(1));
                    expect(
                      wangTile.wangId,
                      equals(<int>[0, 0, 0, 1, 1, 0, 0, 0]),
                    );
                  });
                },
              );

              group(
                "key 2",
                () {
                  late WangTile wangTile;

                  setUpAll(() {
                    wangTile = wangTiles[2]!;
                  });

                  test("", () {
                    expect(wangTile.tileId, equals(2));
                    expect(
                      wangTile.wangId,
                      equals(<int>[0, 0, 0, 0, 1, 0, 0, 0]),
                    );
                  });
                },
              );
            });
          });

          group("key Unnamed Set 2", () {
            late WangSet wangSet;
            setUpAll(() {
              wangSet = wangSets["Unnamed Set 2"]!;
            });

            test("", () {
              expect(wangSet.name, equals("Unnamed Set 2"));
              expect(wangSet.tile, equals(1));
            });

            group("wangColors", () {
              late List<WangColor> wangColors;
              setUpAll(() {
                wangColors = wangSet.wangColors;
              });

              test("", () {
                expect(wangColors.length, equals(2));
              });

              group(
                "index 0",
                () {
                  late WangColor wangColor;

                  setUpAll(() {
                    wangColor = wangColors[0];
                  });

                  test("", () {
                    expect(wangColor.name, equals(""));
                    expect(wangColor.color, equals(0xff0000));
                    expect(wangColor.tile, equals(-1));
                    expect(wangColor.probability, equals(1));
                  });
                },
              );

              group(
                "index 1",
                () {
                  late WangColor wangColor;

                  setUpAll(() {
                    wangColor = wangColors[1];
                  });

                  test("", () {
                    expect(wangColor.name, equals(""));
                    expect(wangColor.color, equals(0x00ff00));
                    expect(wangColor.tile, equals(-1));
                    expect(wangColor.probability, equals(1));
                  });
                },
              );
            });
          });
        });
      });
    });
  });
}
