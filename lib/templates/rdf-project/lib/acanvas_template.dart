library acanvas_template;

import 'dart:html' as html;
import 'dart:math' hide Rectangle, Point;
import 'dart:async' show Future, Timer;

import 'package:stagexl/stagexl.dart';
import 'package:acanvas_commons/acanvas_commons.dart';
import 'package:acanvas_spring/acanvas_spring.dart'
    show
        IObjectFactory,
        LoaderInfo,
        IObjectFactoryPostProcessor,
        IObjectPostProcessor;

// ##### ACANVAS CORE #####
import 'package:acanvas_framework/src/core.all.dart';
import 'package:acanvas_framework/src/plugin.io.dart' show IOEvents, IOPlugin;

import 'package:acanvas_template/acanvas_template_plugins.dart';
// ## PLUGIN INSERTION PLACEHOLDER - DO NOT REMOVE ## //

// ------------##### PROJECT #####------------

// ### BASIC SCREEN CONFIG
/*
part 'src/project/view/screen/home.dart';
part 'src/project/view/screen/two.dart';
part 'src/project/view/layer/abstract_layer.dart';
part 'src/project/view/layer/layer.dart';
*/
// ### END BASIC SCREEN CONFIG

// ### ADVANCED SCREEN CONFIG
part 'src/project/view/screen/home.dart';
part 'src/project/view/element/navigation_sidebar.dart';
part 'src/project/view/element/cell/list_menu_cell.dart';
part 'src/project/view/element/pager/abstract_photo_pager.dart';
part 'src/project/view/element/pager/pager_prev_next_button.dart';
// ### END ADVANCED SCREEN CONFIG

part 'src/project/project.dart';

// BOOTSTRAP
part 'src/bootstrap/ac_render_loop.dart';
part 'src/bootstrap/ac_bootstrap.dart';
part 'src/bootstrap/entrypoint.dart';
part 'src/bootstrap/plugins.dart';
part 'src/bootstrap/load_screen.dart';
part 'src/project/model/assets.dart';

// VIEW:SCREEN
part 'src/project/view/screen/abstract_screen.dart';
part 'src/project/view/screen/abstract_reflow_screen.dart';
// ## SCREEN INSERTION PLACEHOLDER - DO NOT REMOVE ## //

// VIEW:BACKGROUND
part 'src/project/view/element/background.dart';
part 'src/project/view/element/navigation.dart';
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
