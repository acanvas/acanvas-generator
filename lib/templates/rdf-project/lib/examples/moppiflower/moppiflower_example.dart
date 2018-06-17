library moppiflower_example;

import 'dart:async';
import 'dart:math' as math;
import 'dart:web_audio';
import 'dart:typed_data';

import 'package:stagexl/stagexl.dart';
import 'package:acanvas_commons/acanvas_commons.dart'
    show Ac, BoxSprite, MdButton;

import 'package:acanvas_framework/src/core.all.dart' show AbstractAcPlugin;
import 'package:acanvas_template/acanvas_template.dart'
    show AbstractScreen, EffectIDs;

part 'src/moppiflower_example_plugin.dart';
part 'src/model/moppiflower_model.dart';
part 'src/model/moppiflower_example_screen_ids.dart';
part 'src/view/screen/moppi_flower.dart';

// ## SCREEN INSERTION PLACEHOLDER - DO NOT REMOVE ## //

part 'src/view/element/sound_analyzer.dart';
part 'src/view/element/flower_manager.dart';
part 'src/view/element/flower.dart';
part 'src/view/element/branch.dart';
part 'src/view/element/stem.dart';
part 'src/view/element/spawn_item.dart';
part 'src/view/element/base.dart';
// ## ELEMENT INSERTION PLACEHOLDER - DO NOT REMOVE ## //
