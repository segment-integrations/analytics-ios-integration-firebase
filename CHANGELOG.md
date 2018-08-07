Change Log
==========

Version 2.3.0 *(4th July, 2018)*
-------------------------------------------
*(Supports analytics-ios 3.2.+ and Firebase 4.0+)*

* [Enhancement](https://github.com/segment-integrations/analytics-ios-integration-firebase/commit/6766b87834c5b81401d966a36792d6f9488fca61): Fix issues related to `use_frameworks!` and transitive static libraries

##### Transitioning from static library workarounds

If you are using `use_frameworks!` and workarounds you may need to follow extra-steps :
1. Make sure you are using CocoaPods 1.4+
   ```bash
   $ pod --version
   1.5.3
   ```
2. The `StaticLibWorkaround` subspec has been removed, use the default subspec instead
3. Remove references to the pod source files from your Xcode target if any
4. Remove any remaining workarounds (e.g. `post_install` hooks)
5. *(optional)*  if you don't directly depend on Firebase you don't need to explicit depend on it anymore

###### Example

- Before
    ```ruby
    use_frameworks!

    pod 'Analytics'

    pod 'Segment-Firebase/StaticLibWorkaround'
    pod 'Firebase/Core'

    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                if config.build_settings['PRODUCT_NAME'] == 'Segment_Firebase'
                    # ...
                end
            end
        end
    end
    ```

- After
    ```ruby
    use_frameworks!

    pod 'Analytics'
    pod 'Segment-Firebase'
    ```


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
