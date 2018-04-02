Change Log
==========

Version 2.2.0 *(2nd April, 2018)*
-------------------------------------------
*(Supports analytics-ios 3.2.+ and Firebase 4.0+)*

 * [New](https://github.com/segment-integrations/analytics-ios-integration-firebase/pull/23): Adds Static Library Workaround subspec to assist with the [Cocoapods static library/framework issue](https://github.com/CocoaPods/CocoaPods/issues/2926). The limitation occurs when an application is built in Swift, you are including use_frameworks! in your podfile, and are using a transitive dependency that is provided as a static library or framework. More [here](https://segment.com/docs/sources/mobile/ios/#target-has-transitive-dependencies-that-include-static-binaries).

Version 2.1.0 *(27th February, 2018)*
-------------------------------------------
*(Supports analytics-ios 3.2.+ and Firebase 4.0+)*

 * [Fix](https://github.com/segment-integrations/analytics-ios-integration-firebase/pull/19): Bug was replacing spaces with underscores for each value. Firebase shows that trait/property names should have underscores, but not the values. This will break current users implementations if they are expecting the values to have underscores. 

Version 2.0.0 *(11th September, 2017)*
-------------------------------------------
*(Supports analytics-ios 3.2.+ and Firebase 4.0+)*

 * [Update](https://github.com/segment-integrations/analytics-ios-integration-firebase/pull/7/files):Bumps to 4.0. Removes deprecated pod appIndexing in subspec.
 * [Fix](https://github.com/segment-integrations/analytics-ios-integration-firebase/pull/9/files): Crash when passing a non NSString value through `traits` on `identify`.
 * [Fix](https://github.com/segment-integrations/analytics-ios-integration-firebase/pull/10/files): Mapping to Firebase logEvent and reserved Params and Constants.
 
Version 1.0.0 *(2nd August, 2016)*
-------------------------------------------
*(Supports analytics-ios 3.2.+ and Firebase 3.3.+)*

Initial stable release.

Version 1.0.0-alpha *(2nd August, 2016)*
-------------------------------------------
*(Supports analytics-ios 3.2.+ and Firebase 3.3.+)*

Initial alpha release.
