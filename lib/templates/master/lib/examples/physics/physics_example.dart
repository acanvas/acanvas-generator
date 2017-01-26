library physics_example;

import 'dart:math' hide Point, Rectangle;
import 'dart:async' show Timer;

import 'package:stagexl/stagexl.dart';
import 'package:rockdot_commons/rockdot_commons.dart';
import 'package:rockdot_physics/rockdot_physics.dart';

// ##### PLUGINS #####
import 'package:rockdot_framework/src/core.dart';
import 'package:rockdot_template/rockdot_template.dart' show Colors, Theme, AbstractScreen, Dimensions, EffectIDs;

part 'src/physics_example_plugin.dart';
part 'src/model/physics_example_screen_ids.dart';

part 'src/view/screen/abstract_box2d_screen.dart';
part 'src/view/screen/paper_physics.dart';
part 'src/view/element/physics/i_box2d_element.dart';
part 'src/view/element/physics/abstract_box2d_element.dart';
part 'src/view/element/physics/m_box2d_helper.dart';
part 'src/view/element/physics/impl/buoyancy.dart';
part 'src/view/element/physics/impl/bridge.dart';
part 'src/view/element/physics/impl/ragdolls.dart';
part 'src/view/element/physics/impl/stacks.dart';
