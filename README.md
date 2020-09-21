# Chatalyze

[![N|Solid](https://chatalyze.com/images/v7/chatalyze-orange-min.png)](https://chatalyze.com)
[![Languages](https://img.shields.io/badge/language-Swift4.2-orange.svg)](https://github.com/mansa-dev/chatalyze_ios)

This is Chatalyze iOS Repository. It is compatible with most updated versions of XCode, iOS and Swift. Here is the checklist:
  - XCode 10.0
  - Swift 4.2
  - iOS 12


## Dependencies Carthage
Chatalyze uses a number of open source projects to work properly:
* [socketio](https://github.com/socketio/socket.io-client-swift) - WebSocket Connection Wrapper 
* [HCSStarRatingView](https://github.com/hsousa/HCSStarRatingView) - Swipe feature and Custom UI for rating the call.
* [Alamofire](https://github.com/Alamofire/Alamofire) - Elegant HTTP Networking in Swift
* [ImageLoaderSwift](https://github.com/hirohisa/ImageLoaderSwift) - A lightweight and fast image loader for iOS written in Swift.
* [SDWebImage](https://github.com/SDWebImage/SDWebImage) - Asynchronous image downloader with cache support
* [ninjaprox/NVActivityIndicatorView](https://github.com/ninjaprox/NVActivityIndicatorView) - A collection of awesome loading animations
* [input-mask-ios](https://github.com/RedMadRobot/input-mask-ios) - User input masking library repo.
* [facebook/facebook-sdk-swift](https://github.com/facebook/facebook-sdk-swift) - Integrate your iOS apps in Swift with Facebook Platform.

## Dependencies CocoaPods
 - pod 'JTAppleCalendar', '~> 7.1.5'
 - pod 'GoogleWebRTC' 
 - pod 'GoogleSignIn'
 - pod 'TwitterKit', '3.4.0'
 - pod 'TwitterCore', '3.1.0'
 - pod 'CropViewController', :git => 'https://github.com/TimOliver/TOCropViewController.git'

## SetUp
- Download Developer's Certification from Apple Developer Account and add it to developer's system Keychain Access. 
- Open Xcode and Go to XCode -> Account Preferences -> Add Apple Developer Account of Chatalyze -> Download Provisional Profiles.

## Installation

Chatalyze requires [Carthage](https://github.com/Carthage/Carthage) & [CocoaPods](https://github.com/CocoaPods/CocoaPods) to install the dependencies.

We prefer Carthage over CocoaPods because of its framework builds that keep libraries isolated from overall project structure. But some libraries that don't support carthage like [GoogleWebRTC](https://cocoapods.org/pods/GoogleWebRTC) need CocoaPods support.

Install the Carthage dependencies
```sh
$ cd chatalyze
$ carthage update --platform iOS
```

Install the CocoaPods dependencies

```sh
$ cd chatalyze
$ pods install
```


License
----
© Copyright 2020 Chatalyze - All Rights Reserved.


