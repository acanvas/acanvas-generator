library google_example;

import 'dart:math';

import 'package:stagexl/stagexl.dart';
import 'package:acanvas_commons/acanvas_commons.dart'
    show
        IAsyncCommand,
        BehaveSprite,
        Button,
        ImageSprite,
        AcGraphics,
        Ac,
        MdWrap,
        MdButton,
        AcSignal;

import 'package:acanvas_framework/src/core.all.dart'
    show AbstractAcPlugin, StateEvents;
import 'package:acanvas_framework/src/plugin.io.dart'
    show DataProxy, DataRetrieveVO, IIOModelAware, IOModel, IOEvents;
import 'package:googleapis/plus/v1.dart' show Person;
import 'package:acanvas_framework/src/plugin.google.dart';
import 'package:acanvas_template/acanvas_template.dart'
    show
        AbstractReflowScreen,
        AbstractPhotoPager,
        AbstractScreen,
        Colors,
        EffectIDs,
        Theme;

part 'src/google_example_plugin.dart';
part 'src/model/google_example_screen_ids.dart';

part 'src/view/screen/google_example.dart';
part 'src/view/screen/google_friends.dart';

part 'src/view/element/pager/google_plus_friend_photo_pager.dart';
part 'src/view/element/pager/image_item_button.dart';
