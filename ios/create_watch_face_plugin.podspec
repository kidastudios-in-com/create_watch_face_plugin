#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint create_watch_face_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'create_watch_face_plugin'
  s.version          = '1.0.0'
  s.summary          = "A Flutter plugin install Apple's WatchFaces."
  s.description      = <<-DESC
A Flutter plugin to install Apple's WatchFaces from flutter.
This under the hood calls the Apple's `CLKWatchFaceLibrary`
                       DESC
  s.homepage         = 'https://github.com/kidastudios-in-com/create_watch_face_plugin'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'KIDA Studios Pvt Ltd' => 'sharan@kidastudios.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '14.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
