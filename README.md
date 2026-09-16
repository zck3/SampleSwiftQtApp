
# SampleSwiftQtApp

by Zack T Smith, 3 at zs3 dot me

This is a sample app that demonstrates a few ways to lay out
widgets in a Qt 6 window, using SwiftQt. It also demonstrates
various Qt widgets that are available with SwiftQt.

## Dependencies

This app depends on:

* The Qt 6 libraries and utilities.
* The Swift 6 compiler with Swift Package Manager.
* A C++ compiler such as `clang++` or `g++`.

Run the `configure` script to verify these are installed.

## Build and run

* To build the app, type `swift build`.
* To run the compiled app, type `swift run`.
* To clean, type `swift package clean`.

## Changes

This code originally accompanied the SwiftQt library code
but is now separate, so I am renumbering the releases:

* 0.1 Original demo code with manual layout.
* 0.2 Added various automatic layouts.
* 0.3 Separated demo app from SwiftQt library.
* 0.4 Updated for SwiftQt 0.28.
* 0.5 Updated for SwiftQt 0.29, added use of QPdfView.
* 0.6 Updated for SwiftQt 0.30.
* 0.7 Updated for SwiftQt 0.31.

## Media

* The included PDF is Apuleius' comedic novel Metamorphoses, also known as The Golden Ass.

* The included TIFF image for the demo is from here:
  https://www.jpl.nasa.gov/images/pia25970-perseverance-rover-watches-ingenuity-mars-helicopters-54th-flight/
  "PIA25970 is a NASA image identifier for media showing 
the Perseverance Rover watching the Ingenuity Mars Helicopter 
perform its 54th flight on August 3, 2023."

