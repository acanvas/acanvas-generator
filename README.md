# Rockdot Generator - a CLI to start your Rockdot project with ease!

![Rockdot Generator banner](https://raw.githubusercontent.com/blockforest/rockdot-generator/master/lib/templates/basic/web/public/assets/autoload/rockdot.png)

[![Coverage Status](https://coveralls.io/repos/blockforest/rockdot-generator/badge.svg?branch=master)](https://coveralls.io/github/blockforest/rockdot-generator)
[![Travis Build Status](https://travis-ci.org/blockforest/rockdot-generator.svg?branch=master)](https://travis-ci.org/blockforest/rockdot-generator)
[![Appveyor Build Status](https://ci.appveyor.com/api/projects/status/vgk8ojml63nd68be?svg=true)](https://ci.appveyor.com/project/nilsdoehring/rockdot-generator)


Welcome Aboard!
======================

(install notes further down)

With Rockdot, you write apps as well as games (or a mix of the two) in Pure Dart. No HTML, no CSS. 
If you happen(ed) to be a Pure Actionscript developer, you will feel at home, immediately. 
In fact, Rockdot was started as an ActionScript framework in 2009, and has been used in dozens of 
apps served millions of pageviews in individual web apps, microsites and specials for brands such 
as Mercedes-Benz, Nike, Bosch, Nikon.  

Rockdot for Dart gives you 

* pixel-precise control over the html CanvasElement (2D and WebGL) through StageXL, the Flash DisplayList API for HTML5, written in Dart
* a blazing fast, industry proven IoC/DI/MVC+Command framework based on Spring ActionScript (no shit)
* smart UI lifecycle management with runtimes for GAF (Flash Pro), Spine, DragonBones, Flump, babylonjs, and THREE.js (coming soon)
* plugins for integration with facebook, google APIs (examples included!)
* a codebase that has its roots in Pure ActionScript, and has been in continuous development for about six years (2008 - 2014),
* a codebase that has served millions of pageviews in individual web apps, microsites and specials for brands such as Mercedes-Benz, Nike, Bosch, Nikon.
* soon a generic frontend and backend solution for management of user generated content, for example to be used in sweepstakes, competitions.

Got an old iPhone4, a brand new Pixel, or any web browser on any OS? Then be sure to fire up the 
[Demo](http://rockdot.sounddesignz.com/template/).

## Building Blocks
* [Rockdot Framework](https://github.com/blockforest/rockdot-framework) Plugin System, UI Lifecycle and Asset Manager, i18n, Google and Facebook Integration, Generic User Generated Content backend communication
* [Rockdot Spring](https://github.com/blockforest/rockdot-spring) IoC/DI container (ObjectFactory, ObjectFactory and Object Postprocessing, Interface Injection)
* [Rockdot Commons](https://github.com/blockforest/rockdot-commons) Async library (FrontController and Commands/Operations, also sequences)
* [Rockdot Commons](https://github.com/blockforest/rockdot-commons) Material Design Implementation
* [Rockdot Commons](https://github.com/blockforest/rockdot-commons) EventBus (with some tweaks to Operations to make them as effective as Signals)
* [Rockdot Commons](https://github.com/blockforest/rockdot-commons) Logging
* [StageXL](https://github.com/bp74/StageXL) - Flash API for Dart

# Installation

### Requirements

* Dart SDK 1.22 or greater on your path


### Install

    $> pub global activate --source git https://github.com/blockforest/rockdot-generator

This puts the executable `rockdot_generator` on your path.

# Usage

The purpose of Rockdot Generator is to take care of ALL THE THINGS required, 
so you can jump into development right away.

This is how you create the most basic Rockdot skeleton in your current directory:

    # directory name also serves as project name
    $> mkdir fancy_project
    $> cd fancy_project
    $> rockdot_generator basic

The basic project skeleton will give you:
 
 * directory structure according to Dart specs
 * best practice index.html
 * best practice StageXL bootstrap
 * best practice Rockdot framework bootstrap
 * röckdöt framework's state and screen extensions
 * dart2js size: 120 KiB gzipped
 * deployment-ready
 
It is possible to add extensions:
    
    # replace <extension> with an identifier from the list below
    $> rockdot_generator basic --<extension>


 * material: Material Design reference library
 * google: Full access to Google APIs
 * facebook Plugin: Full access to Facebook APIs
 * physics: Physics engine based on Box2D
 * ugc: Persist User Generated Content and create leaderboards (work in progress)
 * bitmapFont: Add BitmapFont Extension to StageXL
 * dragonBones: Add Dragonbones Extension to StageXL
 * flump: Add Flump Extension to StageXL
 * gaf: Add GAF Extension to StageXL
 * spine: Add Spine Extension to StageXL

Of course, you can combine these extensions

    $> rockdot_generator basic --material --google --facebook --physics --ugc

Additionally, you can choose to install example pages:

 * materialExamples: Material Design reference library
 * googleExamples: Full access to Google APIs
 * facebookExamples Plugin: Full access to Facebook APIs
 * physicsExamples: Physics engine based on Box2D
 * ugcExamples: Persist User Generated Content and create leaderboards
 * bitmapFontExamples: Install BitmapFont Examples
 * dragonBonesExamples: Install Dragonbones Examples
 * flumpExamples: Install Flump Examples
 * gafExamples: Install GAF Examples
 * spineExamples: Install Spine Examples
 
 
    # one extension and examples
    $> rockdot_generator basic --material --materialExamples
    
    # all extensions and examples
    $> rockdot_generator basic --material --materialExamples --google --googleExamples --facebook --facebookExamples --physics --physicsExamples --ugc --ugcExamples --bitmapFont --bitmapFontExamples --dragonBones --dragonBonesExamples --flump --flumpExamples --gaf --gafExamples --spine --spineExamples 

Finally, run pub:

    $> pub get
    $> pub serve

That's it, your project is up and running!

Note: Point your browser to the public subdirectory like this: http://localhost:8080/public/


# Notes for generator developers (that's me)

Generator was built in a way that the 'master' template under `lib/templates/master/` can be directly opened as an IDEA project, with all plugins and examples activated, in order to allow for easy develop/debug of the master template. This decision stems from experience, and is less error prone than having to generate a project and merge back the changes (especially since package names will differ as well as content that has been auto-injected).

Inner workings:
- Before pushing a new version, you need to run `dart tool/grind.dart` to generate Lists of String with the file uri's of the assets that need to end up in the target directory.
- Upon project generation, this array will get iterated over, and the files will be loaded via the `Resource` package, which is the only way to access files when running scripts via `pub`. The logic happens in `lib/generators/basic.dart`.
- Also within `lib/generators/basic.dart`, some file manipulation will incur based on the command line options given. Basically, the master template, where all options are switched ON, will get stripped from every plugin and example that is not explicitly activated via command line options.
- The generated project sports a `transformer`, which does two things:
     - collect all properties string from config/ directory and example subdirectories, and merge them into web/public/config
     - inspect all files and inject properties, if applicable (@some.property@ will be replaced by the matching string)
     - when debugging, this should ideally be repeated with every Chromium refresh, and most  
     unfortunately, in IDEA/WebStorm, transformers are not even guaranteed to get re-run upon starting a debug session.
     - workaround: run pub serve from terminal, and once transformers completed, kill the process 

To summarize, these steps are advised before pushing an update to github:

    # Remember to run the conversion before submitting:
    $> dart tool/grind.dart

    # You can test locally with
    $> dart tool/grind.dart test





## Mission Statements

#### Best of breed. Built for speed.
Rockdot loads extra fast. The minified/gzipped JS comes at a mere 120 KByte, including Material Design UI components.
Rockdot's UI components were built by some of the best ActionScript programmers in the field, resulting in snappy performance - even on an iPhone 4. 
Rockdot generally animates at 60 fps, but has an idle mode to save on cpu load whenever possible.

#### Innovation
Rockdot takes technology out of the way, so that teams can focus on UX and jaw dropping designs.

#### Total Control
With Rockdot, you define what happens when - control every pixel and every millisecond, and make art direction
happy. Because _everything_ is built in Dart, you get full cycle introspection from logic to layout and back again.
No media breach. No magic functions. No WTFs.

#### Extreme Flexibility
Rockdot has been used for microsites, facebook apps, and mobile apps (Adobe AIR). Thanks to Spring's IoC container and smart conventions, 
you can plug everything together with everything else. No matter what, things won't get messy. You write Rockdot code once, and it runs anywhere.

#### Rapid Scalability
A Rockdot project team usually only requires a single 'system architect', responsible for its bootstrap and creation of commands and services. 
All other developers can focus on the frontend and will feel at home, instantly.
There have been cases where teams were scaled from one to six frontend developers without framework experience within a single day.

#### Inherent Reusability
How often did you hear yourself saying: "some time after the project is done, i will clean up and reuse this and that killer feature"?
Exactly, too often. Rockdot's architecture enables you to code in a sustainable fashion without losing speed.

#### 10x faster to market than traditional html/js/css
No kidding. Not only will you have more certainty about what's feasible, but also way, way, way less QA.


## The Story behind Rockdot

So Rockdot was originally created in ActionScript and started somewhere around 2007. It has served millions of pageviews for dozens of clients in the form of
high fidelity, highly interactive, specialized browser apps. Life was good. 
As Flash Player's demise became evident, the quest for a succeeding technology was started. 

And in summer of 2014, it was found in StageXL, an implementation of Flash's diplay list for the Canvas element, written in Dart. 

With Dart's syntax and StageXL's APIs being quite similar to ActionScript, the project was started by finding a way to 
port code over to Dart in the laziest way possible, with as much automation as possible.
Abstract Syntax Tree conversion was quickly dropped in favor of good old search and replace via Regular Expressions, 
making it possible to manually compare the converted file with the original in case of errors (which occur). 
The resulting converter automates most of what's possible, more than enough to rely on the Dart Analyzer to identify any remaining conversion errors or incompatible APIs.
Since then, everything has been refactored and optimized for Dart.

Here's that tool: [Actionscript to StageXL Conversion Helper](https://github.com/blockforest/stagexl-converter-pubglobal)

Thanks to it, about 500 classes of AS3 Commons, Spring Actionscript, and Rockdot found their way to Dart without pain.
The rest was just optimization. Almost two years of night coding, actually :-)


## TL;DR What was Rockdot's USP again?
* Focus on highly interactive rich media applications
* Mature UI lifecycle management
* Asset load management
* i18n
* Plugin system
* LOTS of examples
* Generic User Generated Content backend (soon!)


## Issues and bugs

Please file reports on the
[GitHub Issue Tracker](https://github.com/blockforest/rockdot_generator/issues).

## Disclaimer

We're in beta!

## Next Steps

* Add full persistency backend (Zend/MySQL)
* Provide StageXL-only skeletons
* Optimize Rockdot even more
