# CHANGELOG ROCKDOT_GENERATOR

## 0.9.7

- Fixed tool/grind.dart so dartanalyzer uses the `.packages` file instead of dir
- Travis build should work now
- Removed drone.io hook (drone.io went out of service)
- Updated README to reflect those changes

## 0.9.6

- Refactored file generation to use `Resource` package, getting rid of >60MiB of byte arrays!
- Refactored master template for better separation of example content from actual project

## 0.9.5

- Strong mode fixes
- Added removeSelf option to dispose method

## 0.9.4

- New Extension and Example: StageXL Isometric Runtime
- New Extension and Example: StageXL Particle Engine
- Fixed a bug in add_screen helper script
- Refactored add_element helper script to extend RockdotBoxSprite instead of RockdotLifecycleSprite

## 0.9.3

- New Extension: BabylonJS Wrapper
- BabylonJS Extension Example

## 0.9.2

- add_screen helper now accepts custom root path
- fixed bugs in transformer
- GAF Extension Examples: Fireman, Gun swap, Named Parts, Sequences, Skeleton, SlotMachine, Sound
- DragonBones Extension Examples: Demon, Dragon, Swordsman, Ubbie
- StageXL Example: Bezier Tweening 
- StageXL Example: Drag and Drop 
- StageXL Example: Dart Logo 
- StageXL Example: Map Filtering 
- StageXL Example: Memory Game 
- Spine Extension Examples: SpineBoy, Goblins, Hero, Powerup, Raptor, Tank, Texture Atlas, Vine
- Particle Extension Example
- Isometric Extension Example
- Flump Extension Example

## 0.9.1

- StageXL Example: HiDPI BitmapData 
- StageXL Example: Sprite 3D 
- StageXL BitmapFont Extension Example: Simple 
- StageXL BitmapFont Extension Example: Texture Atlas 
- StageXL BitmapFont Extension Example: Distance Field 
- Changed root for collect_assets to web/public/assets/autoload  

## 0.9.0

- Breaking change: new CLI parameters 
- Refactored codebase to support StageXL extensions 

## 0.8.1

- Added support for project generation via Rockdot IntelliJ IDEA Plugin

## 0.8.0

- Fully tested
- Fully running

## 0.7.0

- Removed analytics leftovers
- Reorganized generators: Only BasicGenerator left, takes options for plugin and demo addons.
- Reorganized templates: Duplicate data eliminated.
- Reorganized plugins and demos: Can get installed independently of demos
- Demos are now Rockdot Plugins
- templates/template can be opened/edited as project, with full features. Makes it easier to develop rockdot_generator demos.

## 0.6.0

- templates now work as projects inside rockdot_generator (makes development of rockdot_generator templates easier and less error prone)
- Added rockdot-zend template (called 'server') UNFINISHED BUSINESS

## 0.5.0

- Updated minimal and maximal template
- version bump to match all blockforest libraries

## 0.3.0

- Bugfixes
- Added maximal template

## 0.2.0

- Enhancements to generate Rockdot/StageXL projects
- Fixed all CI services: drone, appveyor, travis
- Added minimal template
- Included additional variable substitutions

# CHANGELOG STAGEHAND

## 0.1.5+5

- Updated the dependency on `usage`

## 0.1.5+3

- Updated the dependency on `usage`

## 0.1.5+2

- Changed to using the `usage` library for Google Analytics

## 0.1.5+1

- Update README to mention ubersimplewebapp

## 0.1.5

- Added a new `ubersimplewebapp` template.

## 0.1.4

- Added a new `appengineapp` template (thanks @wibling!)
- updates to the webapp, shelfapp, and polymerapp samples

## 0.1.3

- Added a `label` attribute to the templates and to the `--machine` output
- Renamed the `shelfapp` template to `shelfserver`
- Added a `--version` command-line option
- Clarified and simplified some template descriptions
- Made useage of Sass in the `webapp` template optional; added instructions in
  the template about how to enable it
- Added instructions after project generation to tell the user how best to run
  the project
- Stagehand is now integrated into the Editor, the Eclipe plugins, Chrome Dev
  Editor, and the Sublime plugin

## 0.1.2

- Removed the `-o` option; we now generate the selected template into the
  current directory
- Added pre-generated css to the `webapp` template
- some changes to better support rockdot_generator being driven by existing tooling
  (IDEs)
- The `polymer` template was renamed to `polymerapp`

## 0.1.1

- Changed to allow rockdot_generator to generate a project into an existing directory

## 0.1.0

- Removed Web Starter Kit, waiting for at least WSK 0.6.0
- Renamed `helloworld` to `consoleapp`
- Added `polymer` template
- Added `shelfapp` template
- Added default BSD license to projects
- Analytics are opt-in. Version update ping is still automatic.

## 0.0.5

- Added [Web Starter Kit](https://developers.google.com/web/starter-kit/)!
- Added anonymous user metrics via Google Analytics

## 0.0.4

- Fix bug in publib generator

## 0.0.3

- Add first version of a publib generator
