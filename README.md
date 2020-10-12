# Migration

Manages blocks of code that need to run once on version updates in iOS apps. This could be anything from data normalization routines, "What's New In This Version" screens, or bug fixes.

This is the Swift version of [MTMigration][1].

## Installation

#### Manual

Download the .zip from this repo and drag the `/Migration` folder into your project.

#### Swift Package Manager

In Xcode 11 or newer versions you can add packages by going to *File \> Swift Packages \> Add Package Dependency*. Copy in this repos [URL][2] and go from there.

## Usage

Still working...
You can see the comments in code first.

## Notes

Migration assumes version numbers are incremented in a logical way, i.e. 1.0.1 -\> 1.0.2, 1.1 -\> 1.2, etc.

## License
Migration is released under the [MIT License][3].

[1]:	https://github.com/mysterioustrousers/MTMigration
[2]:	https://github.com/hengyu/Migration.git
[3]:	https://github.com/Hengyu/Migration/blob/master/LICENSE