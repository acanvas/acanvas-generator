# Acanvas Generator

[![Coverage Status](https://coveralls.io/repos/acanvas/acanvas-generator/badge.svg?branch=master)](https://coveralls.io/github/block-forest/acanvas-generator)
[![Travis Build Status](https://travis-ci.org/acanvas/acanvas-generator.svg?branch=master)](https://travis-ci.org/block-forest/acanvas-generator)
[![Appveyor Build Status](https://ci.appveyor.com/api/projects/status/vgk8ojml63nd68be?svg=true)](https://ci.appveyor.com/project/nilsdoehring/acanvas-generator)

*Acanvas Generator* lets you generate *[Acanvas](http://acanvas.sounddesignz.com/acanvas-framework/)* projects for Dart 2.0 and StageXL.
With Acanvas, you quickly write web apps, minigames, or anything in-between, in pure Dart. 
No HTML, no CSS, no JS. 

![Acanvas Banner](http://acanvas.sounddesignz.com/acanvas-framework/assets/autoload/acanvas-logo-wide-bnw@2x.png)

*Acanvas* is a layered architecture originally conceived for Actionscript,
and has been used in dozens of highly interactive microsites and facebook apps for brands such as Mercedes-Benz, Nike, Nikon, serving millions of pageviews.
*[Learn more](http://acanvas.sounddesignz.com/acanvas-framework/)*.

## Acanvas Examples

* The [Acanvas Framework Demo](http://acanvas.sounddesignz.com/acanvas-framework/) – Examples including Animation, Material Design, BitmapFonts, Toolchains (DragonBones, GAF, Spine), Physics, 3D, Bitmapdrawing.
* The best way to learn how to use *Acanvas Spring* and *Acanvas Framework* by generating a project with [Acanvas Generator](https://github.com/acanvas/acanvas-generator).
* [Acanvas Dartbook](http://acanvas.sounddesignz.com/acanvas-dartbook/) - [Source](https://github.com/acanvas/acanvas-dartbook)
* [Acanvas Physics](http://acanvas.sounddesignz.com/acanvas-physics/) - [Source](https://github.com/blockforest/acanvas-physics/tree/master/lib/src/Examples)
* [BabylonJS StageXL Wrapper](http://acanvas.sounddesignz.com/stagexl/babylonjs-interop/) - [Source](https://github.com/acanvas/babylonjs-dart-facade/tree/master/example)
* [THREE.js StageXL Wrapper](http://acanvas.sounddesignz.com/stagexl/threejs-interop/) - [Source](https://github.com/acanvas/threejs-dart-facade/tree/master/example)

## Installation

Make sure you have an up-to-date [Dart 2.0 SDK](https://webdev.dartlang.org/tools/sdk#install) installed.

    $> pub global activate --source git https://github.com/acanvas/acanvas-generator

This puts the executable `acgen` on your path.

## Usage

### Basic Project

This is how you create the most basic Acanvas skeleton in your current directory:

    # directory name serves as project name
    $> mkdir fancy-name
    $> cd fancy-name
    $> acgen project

The basic project skeleton will give you:
 
 * Directory structure according to Dart specs.
 * Best practice index.html.
 * Best practice StageXL bootstrap.
 * Best practice Acanvas framework bootstrap.
 * Acanvas framework's state and screen extensions.
 * Dart2JS size: 120 KiB gzipped.
 * Deployment-ready.
 
### Advanced Project
 
For a list of optional plugins and examples to install, type:
    
    $> acgen project --help

Following plugins are available:
 * *material*: Material Design reference library
 * *google*: Full access to Google APIs
 * *facebook Plugin*: Full access to Facebook APIs
 * *physics*: Physics engine based on Box2D
 * *ugc*: Persist User Generated Content and create leaderboards (work in progress)
 * *bitmapFont*: Add BitmapFont Extension to StageXL
 * *dragonBones*: Add Dragonbones Extension to StageXL
 * *flump*: Add Flump Extension to StageXL
 * *gaf*: Add GAF Extension to StageXL
 * *spine*: Add Spine Extension to StageXL

### Advanced Project Examples

Additionally, you can choose to install example pages:

 * *materialExamples*: Material Design reference library
 * *googleExamples*: Full access to Google APIs
 * *facebookExamples Plugin*: Full access to Facebook APIs
 * *physicsExamples*: Physics engine based on Box2D
 * *ugcExamples*: Persist User Generated Content and create leaderboards
 * *bitmapFontExamples*: Install BitmapFont Examples
 * *dragonBonesExamples*: Install Dragonbones Examples
 * *flumpExamples*: Install Flump Examples
 * *gafExamples*: Install GAF Examples
 * *spineExamples*: Install Spine Examples
 
 
    # one plugin and examples
    $> acgen project--material --materialExamples
    
    # all plugins and examples
    $> acgen project --material --materialExamples --google --googleExamples --facebook --facebookExamples --physics --physicsExamples --ugc --ugcExamples --bitmapFont --bitmapFontExamples --dragonBones --dragonBonesExamples --flump --flumpExamples --gaf --gafExamples --spine --spineExamples 

### Final Step

Finally, run pub:

    $> pub get
    $> pub global activate webdev
    $> webdev serve

See, your project is up and running!

## Project Helpers

A fast way to create classes and link them into your project.

    # Create a Command
    $> acgen command --name MyCommand
    
    # Create a Screen
    $> acgen screen --name MyScreen
    
    # Create a view Element
    $> acgen element --name MyElement
    
    # Collect Assets into Autoloader
    $> acgen collect

## Notes for generator developers 
(that's me)

Generator was built in a way that the 'master' template under `templates/master/` can be directly opened as an IDEA project, with all plugins and examples activated, in order to allow for easy develop/debug of the master template. This decision stems from experience, and is less error prone than having to generate a project and merge back the changes (especially since package names will differ as well as content that has been auto-injected).

Inner workings:
- Before pushing a new version, you need to run `dart tool/grind.dart` to generate Lists of String with the file uri's of the assets that need to end up in the target directory.
- Upon project generation, this array will get iterated over, and the files will be loaded via the `Resource` package, which is the only way to access files when running scripts via `pub`.
- Additionally, some file manipulation will be done according to command line options. Basically, the master template, where all options are switched ON, will get stripped from every plugin and example that is not explicitly activated via command line options.
- The generated project sports a `builder`, which collects all properties string from lib/config/ directory and merge them into web/config whenever 'webdev serve' or 'webdev build' is run.

To summarize, these steps are advised before pushing an update to github:

    # Remember to run the conversion before submitting:
    $> dart tool/grind.dart

    # You can test locally with
    $> dart tool/grind.dart test

