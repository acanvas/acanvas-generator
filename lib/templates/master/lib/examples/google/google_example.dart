library google_example;

import 'dart:math';

import 'package:googleapis/plus/v1.dart' show Person;
import 'package:stagexl/stagexl.dart';
import 'package:rockdot_commons/rockdot_commons.dart';

// ##### PLUGINS #####
import 'package:rockdot_framework/src/core.dart';
import 'package:rockdot_framework/src/io.dart';
import 'package:rockdot_framework/src/google.dart';
import 'package:rockdot_template/rockdot_template.dart'
    show AbstractReflowScreen, AbstractPhotoPager, AbstractScreen, Colors, Dimensions, EffectIDs, Theme;

part 'src/google_example_plugin.dart';
part 'src/model/google_example_screen_ids.dart';

part 'src/view/screen/google_example.dart';
part 'src/view/screen/google_friends.dart';

part 'src/view/element/pager/google_plus_friend_photo_pager.dart';
part 'src/view/element/pager/image_item_button.dart';
part 'src/view/element/pager/pager_prev_next_button.dart';
