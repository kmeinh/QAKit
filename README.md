# QAKit

**QAKit** is a handy Library providing functionality to get better QA Results. With Fingertips, it is easy to follow the Testers steps when you just got a recorded video of the Screen.

### Example
<image src="Github/example.gif" width="300"/>

# Installation

### Cocoapods

QAKit is available through [CocoaPods](https://cocoapods.org/about). To install it, simply add the following line to your Podfile:

```
use_frameworks!
pod "QAKit", '~> 0.0.5'
```

# Usage

Start Fingertips with in AppDelegate's `applicationDidFinishLaunching(_ application:)`:

```
QAKit.Fingertips.start()
```

You can stop (or hide) Fingertips whenever you like in your App Life Time with:

```
QAKit.Fingertips.hide()
```

# Upcoming

TBD
