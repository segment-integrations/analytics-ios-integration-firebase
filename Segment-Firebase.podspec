Pod::Spec.new do |s|
  s.name             = "Segment-Firebase"
  s.version          = "2.1.0"
  s.summary          = "Firebase Integration for Segment's analytics-ios library."

  s.description      = <<-DESC
                       Analytics for iOS provides a single API that lets you
                       integrate with over 100s of tools.

                       This is the Firebase integration for the iOS library.
                       DESC

  s.homepage         = "http://segment.com/"
  s.license          =  { :type => 'MIT' }
  s.author           = { "Segment" => "friends@segment.com" }
  s.source           = { :git => "https://github.com/segment-integrations/analytics-ios-integration-firebase.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/segment'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Segment-Firebase/Classes/**/*'
  s.default_subspec = 'Core'

  s.dependency 'Analytics', '~> 3.2'
  s.dependency 'Firebase/Core', '~> 4.0'

  s.subspec 'Core' do |core|
    #For users who only want the core Firebase package
  end

  s.subspec 'DynamicLinks' do |dynamiclinks|
    # This will bundle in Firebase Dynamic Link support
    dynamiclinks.dependency 'Firebase/DynamicLinks', '~> 4.0'
  end


  s.subspec 'StaticLibWorkaround' do |workaround|
    # For users who are unable to bundle static libraries as dependencies
    # you can choose this subspec, but be sure to include the folling in your podfile
    # pod 'Firebase'
    # Please manually add the following file preserved by Cocoapods to your xcodeproj file
    workaround.preserve_paths = 'Pod/Classes/**/*'
  end

end
