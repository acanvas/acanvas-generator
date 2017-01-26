library facebook_example;

import 'dart:math' hide Rectangle;

import 'package:stagexl/stagexl.dart';
import 'package:rockdot_commons/rockdot_commons.dart';

// ##### PLUGINS #####
import 'package:rockdot_framework/src/core.dart';
import 'package:rockdot_framework/src/io.dart';
import 'package:rockdot_framework/src/facebook.dart';
import 'package:rockdot_template/rockdot_template.dart'
    show AbstractReflowScreen, AbstractPhotoPager, AbstractScreen, Assets, Colors, Dimensions, EffectIDs, Theme;

part 'src/facebook_example_plugin.dart';
part 'src/model/facebook_example_screen_ids.dart';

part 'src/view/screen/facebook_example.dart';
part 'src/view/screen/facebook_albums.dart';
part 'src/view/screen/facebook_photos.dart';
part 'src/view/element/cell/list_fb_album_cell.dart';

part 'src/view/element/pager/abstract_polaroid_pager.dart';
part 'src/view/element/pager/facebook_photo_polaroid_pager.dart';
part 'src/view/element/pager/polaroid_item_button.dart';
