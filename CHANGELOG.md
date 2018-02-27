Change Log
==========

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
