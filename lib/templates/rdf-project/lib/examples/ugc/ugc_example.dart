library ugc_example;

import 'dart:html' hide Event;
import 'dart:math' as math;
import 'package:rockdot_commons/rockdot_commons.dart'
    show
        AbstractPolaroidPager,
        BoxSprite,
        IAsyncCommand,
        ImageSprite,
        InteractEvent,
        MdButton,
        MdInput,
        MdText,
        MdWrap,
        PolaroidItemButton,
        Rd,
        RdSignal,
        ScrollOrientation,
        Wrap;

import 'package:rockdot_framework/src/core.all.dart'
    show AbstractRdPlugin, RdConstants, RockdotLifecycleSprite, StateEvents;
import 'package:rockdot_framework/src/plugin.facebook.dart';
import 'package:rockdot_framework/src/plugin.google.dart';
import 'package:rockdot_framework/src/plugin.io.dart';
import 'package:rockdot_framework/src/plugin.ugc.dart';
import 'package:rockdot_template/rockdot_template.dart'
    show
        AbstractReflowScreen,
        AbstractScreen,
        Colors,
        Dimensions,
        EffectIDs,
        IModelAware,
        Model,
        Theme;
import 'package:stagexl/stagexl.dart';

part 'src/ugc_example_plugin.dart';
part 'src/model/ugc_example_screen_ids.dart';

part 'src/view/element/ugc_gallery.dart';

part 'src/view/screen/ugchome.dart';
part 'src/view/layer/ugc_abstract_layer.dart';
part 'src/view/layer/ugc_upload.dart';
part 'src/view/layer/ugc_view.dart';
part 'src/view/layer/ugc_register.dart';
// ## SCREEN INSERTION PLACEHOLDER - DO NOT REMOVE ## //
