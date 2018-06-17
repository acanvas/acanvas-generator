# Acanvas Generator

*Acanvas Generator – for Dart 2.0 and StageXL.*

*Acanvas Generator* lets you generate *[Acanvas Framework](http://acanvas.sounddesignz.com/acanvas-framework/)* layered architecture projects [(diagram)](http://acanvas.sounddesignz.com/template/assets/home/acanvas_spring_architecture.png).
* Blazing fast IoC/DI/MVC UI framework for WebGL and Canvas2D, written in Dart.
* Write web apps, games, or both, in pure Dart. No HTML, no CSS, no JS, no shit.


[![Coverage Status](https://coveralls.io/repos/block-forest/acanvas-generator/badge.svg?branch=master)](https://coveralls.io/github/block-forest/acanvas-generator)
[![Travis Build Status](https://travis-ci.org/block-forest/acanvas-generator.svg?branch=master)](https://travis-ci.org/block-forest/acanvas-generator)
[![Appveyor Build Status](https://ci.appveyor.com/api/projects/status/vgk8ojml63nd68be?svg=true)](https://ci.appveyor.com/project/nilsdoehring/acanvas-generator)


### Features

The purpose of *Acanvas Generator* is to take care of ALL THE THINGS to jump into *Acanvas* development right away.
With *Acanvas*, you write apps, games, or both, in Dart. No HTML, no CSS, JS. 

* Pixel-precise control over the html *CanvasElement (2D and WebGL)* through StageXL, the Flash DisplayList API for HTML5, written in Dart.
* A blazing fast, industry proven *IoC/DI/MVC+Command framework* based on Spring ActionScript (no shit).
* Smart *UI lifecycle management* with runtimes for GAF (Flash Pro), Spine, DragonBones, Flump, babylonjs, and THREE.js (coming soon).
* Plugins for integration with facebook, google APIs (examples included!).
* A generic frontend and backend solution for management of user generated content, for example to be used in sweepstakes, competitions. *WIP*.

*Acanvas* started as an ActionScript framework in 2009, and has been used in dozens of 
apps serving millions of pageviews in individual web apps, microsites and specials for brands such 
as Mercedes-Benz, Nike, Bosch, Nikon.  

### Examples

Got an old iPhone4, a brand new Pixel, or any web browser on any OS? Then you're all set to fire up the 
[Demo](http://acanvas.sounddesignz.com/acanvas-demo/).

### Installation

    $> pub global activate --source git https://github.com/block-forest/acanvas-generator

This puts the executable `acgen` on your path.

### Usage: Basic Project

This is how you create the most basic Acanvas skeleton in your current directory:

    # directory name serves as project name
    $> mkdir fancy-project
    $> cd fancy-project
    $> acgen project

The basic project skeleton will give you:
 
 * Directory structure according to Dart specs.
 * Best practice index.html.
 * Best practice StageXL bootstrap.
 * Best practice Acanvas framework bootstrap.
 * Acanvas framework's state and screen extensions.
 * Dart2JS size: 120 KiB gzipped.
 * Deployment-ready.
 
### Usage: Advanced Project
 
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

### Usage: Advanced Project Examples

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

### Usage: Final Step

Finally, run pub:

    $> pub get
    $> pub global activate webdev
    $> webdev serve

See, your project is up and running!

### Usage: Project Helpers

A fast way to create classes and link them into your project.

    # Create a Command
    $> acgen command --name MyCommand
    
    # Create a Screen
    $> acgen screen --name MyScreen
    
    # Create a view Element
    $> acgen element --name MyElement
    
    # Collect Assets into Autoloader
    $> acgen collect


# Acanvas Framework – Layered Architecture

*Acanvas Framework* is part of a layered architecture built upon the following components. 

* [Acanvas Framework](https://github.com/acanvas/acanvas-framework) Plugin System, UI Lifecycle and Asset Manager, i18n, Google and Facebook Integration, Generic User Generated Content backend communication.
* [Acanvas Spring](https://github.com/acanvas/acanvas-spring) IoC container (ObjectFactory, Postprocessing, Interface Injection).
* [Acanvas Commons](https://github.com/acanvas/acanvas-commons) Async library (FrontController and Commands/Operations, also sequences).
* [Acanvas Commons](https://github.com/acanvas/acanvas-commons) EventBus (with some tweaks to Operations to make them as effective as Signals).
* [Acanvas Commons](https://github.com/acanvas/acanvas-commons) Logging.
* [StageXL](https://github.com/bp74/StageXL) - Flash display list API for Dart.
* Dart 2.0.

# Notes for generator developers 
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

