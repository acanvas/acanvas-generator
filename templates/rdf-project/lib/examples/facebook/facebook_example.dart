library facebook_example;

import 'package:rockdot_commons/rockdot_commons.dart';

import 'package:rockdot_framework/src/core.all.dart'
    show AbstractRdPlugin, StateEvents, IStateModelAware, StateModel;
import 'package:rockdot_framework/src/plugin.io.dart'
    show DataProxy, DataRetrieveVO;
import 'package:rockdot_framework/src/plugin.facebook.dart';
import 'package:rockdot_template/rockdot_template.dart'
    show
        AbstractReflowScreen,
        AbstractScreen,
        Assets,
        Colors,
        Dimensions,
        EffectIDs,
        Theme;

part 'src/facebook_example_plugin.dart';
part 'src/model/facebook_example_screen_ids.dart';

part 'src/view/screen/facebook_example.dart';
part 'src/view/screen/facebook_albums.dart';
part 'src/view/screen/facebook_photos.dart';
part 'src/view/element/cell/list_fb_album_cell.dart';

part 'src/view/element/pager/facebook_photo_polaroid_pager.dart';
