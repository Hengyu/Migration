# Migration

![](https://img.shields.io/badge/iOS-12.0%2B-green)
![](https://img.shields.io/badge/tvOS-12.0%2B-green)
![](https://img.shields.io/badge/macOS-11.0%2B-green)
![](https://img.shields.io/badge/visionOS-1.0%2B-green)
![](https://img.shields.io/badge/Swift-5-orange?logo=Swift&logoColor=white)
![](https://img.shields.io/github/last-commit/hengyu/Migration)

Manages blocks of code that need to run once on version updates in iOS apps. This could be anything from data normalization routines, "What's New In This Version" screens, or bug fixes.

This is the Swift version of [MTMigration][1].

## Table of contents

* [Requirements](#requirements)
* [Installation](#installation)
* [Usage](#usage)
* [Notes](#notes)
* [License](#license)

## Requirements

- Swift 5.9
- iOS 12.0+, tvOS 12.0+, macOS 11.0+, visionOS 1.0+

## Installation

`Migration` could be installed via [Swift Package Manager](https://www.swift.org/package-manager/). Open Xcode and go to **File** -> **Add Packages...**, search `https://github.com/hengyu/Migration.git`, and add the package as one of your project's dependency.

## Usage

```swift
Migration.applicationUpdate {
    // do your migration code here
    self.cache.clear()
    self.preferenceStore.reset()
}
```

## Notes

Migration assumes version numbers are incremented in a logical way, i.e. 1.0.1 -\> 1.0.2, 1.1 -\> 1.2, etc.

## License
**Migration** is released under the [MIT License][3].

[1]:	https://github.com/mysterioustrousers/MTMigration
[2]:	https://github.com/hengyu/Migration.git
[3]:	https://github.com/Hengyu/Migration/blob/main/LICENSE
