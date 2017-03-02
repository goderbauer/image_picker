Pod::Spec.new do |s|
  s.name             = 'FlutterImagePicker'
  s.version          = '0.0.1'
  s.summary          = 'Convenience wrapper for picking images in Flutter apps.'

  s.description      = <<-DESC
FlutterImagePicker helps Flutter iOS apps show an image picker.
                       DESC

  s.homepage         = 'https://github.com/flutter/image_picker'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'BSD', :file => 'LICENSE' }
  s.author           = { 'Collin Jackson' => 'jackson@google.com' }
  s.source           = { :git => 'https://github.com/flutter/image_picker.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/flutterio'

  s.ios.deployment_target = '7.0'

  s.source_files = 'ios/ImagePicker/Classes/**/*'
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit'
end
