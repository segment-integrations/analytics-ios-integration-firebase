Pod::Spec.new do |s|
  s.name             = "Segment-Firebase"
  s.version          = "1.0.0-alpha"
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
  s.dependency 'Firebase/Core', '~> 3.3.0'

  s.subspec 'Core' do |core|
    #For users who only want the core Firebase package
  end

  s.subspec 'DynamicLinks' do |dynamiclinks|
    # This will bundle in Firebase Dynamic Link support
    dynamiclinks.dependency 'Firebase/DynamicLinks', '~> 3.3.0'
  end

  s.subspec 'AppIndexing' do |appindexing|
    # This will bundle in Firebase App Indexing support
    appindexing.dependency 'Firebase/AppIndexing', '~> 3.3.0'
  end
end