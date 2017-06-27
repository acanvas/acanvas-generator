library rockdot_template;

import 'dart:html' as html;
import 'dart:math' hide Rectangle, Point;
import 'dart:async' show Future, Timer;

import 'package:stagexl/stagexl.dart';
import 'package:rockdot_commons/rockdot_commons.dart';
import 'package:rockdot_spring/rockdot_spring.dart' show IObjectFactory, LoaderInfo, IObjectFactoryPostProcessor, IObjectPostProcessor;

// ##### ROCKDOT CORE #####
import 'package:rockdot_framework/src/core.all.dart';
import 'package:rockdot_framework/src/plugin.io.dart' show IOPlugin;

import 'package:rockdot_template/rockdot_template_plugins.dart';

// ## PLUGIN INSERTION PLACEHOLDER - DO NOT REMOVE ## //

// ##### PROJECT #####

part 'src/project/project.dart';

// BOOTSTRAP
part 'src/bootstrap/rd_render_loop.dart';
part 'src/bootstrap/rd_bootstrap.dart';
part 'src/bootstrap/entrypoint.dart';
part 'src/bootstrap/plugins.dart';
part 'src/bootstrap/load_screen.dart';
part 'src/project/model/assets.dart';

// VIEW:SCREEN
part 'src/project/view/screen/abstract_screen.dart';
part 'src/project/view/screen/abstract_reflow_screen.dart';
part 'src/project/view/screen/home.dart';
//part 'src/project/view/screen/two.dart';

    // ## SCREEN INSERTION PLACEHOLDER - DO NOT REMOVE ## //
  

// VIEW:LAYER
//part 'src/project/view/layer/abstract_layer.dart';
//part 'src/project/view/layer/layer.dart';

// VIEW:BACKGROUND
part 'src/project/view/element/background.dart';
part 'src/project/view/element/navigation.dart';
part 'src/project/view/element/navigation_sidebar.dart';
part 'src/project/view/element/cell/list_menu_cell.dart';
part 'src/project/view/element/pager/abstract_photo_pager.dart';

    // ## ELEMENT INSERTION PLACEHOLDER - DO NOT REMOVE ## //
  
  
  
  
  

// COMMANDS
part 'src/project/command/event/project_events.dart';
part 'src/project/command/abstract_command.dart';
part 'src/project/command/init_command.dart';
part 'src/project/command/message_show_command.dart';
part 'src/project/command/message_hide_command.dart';

// ## COMMAND INSERTION PLACEHOLDER - DO NOT REMOVE ## //

// MODEL
part 'src/project/inject/i_model_aware.dart';
part 'src/project/inject/model_injector.dart';
part 'src/project/model/colors.dart';
part 'src/project/model/dimensions.dart';
part 'src/project/model/model.dart';
part 'src/project/model/screen_ids.dart';
part 'src/project/model/effect_ids.dart';
part 'src/project/model/fonts.dart';
part 'src/project/model/theme.dart';
