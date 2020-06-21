inhibit_all_warnings!

workspace 'Cinema'
target 'backyardTests' do
  platform :osx, '10.15'
  project 'backyard/backyard.xcodeproj'

  pod 'Quick'
  pod 'Nimble'
end


def core()
  pod 'AlamofireImage'
  pod 'AttributedLib'
  pod 'AnimatedField', :git => 'https://github.com/nikburnt/AnimatedField.git', :branch => 'master'
  pod 'DateScrollPicker'
  pod 'EmptyDataSet-Swift'
  pod 'GeometricLoaders', :git => 'https://github.com/nikburnt/GeometricLoaders', :branch => 'develop'
  pod 'GradientAnimator'
  pod 'KeychainAccess'
  pod 'SwiftEntryKit'
  pod 'LGButton'
  pod 'PromiseKit'
  pod 'PromiseKit/Alamofire'
  pod 'Require'
end

target 'Cinemagic' do
  platform :ios, '13.0'
  use_frameworks!
  project 'Cinemagic/Cinemagic.xcodeproj'

  core()
end


target 'CinemagicTests' do
  platform :ios, '13.0'
  use_frameworks!
  project 'Cinemagic/Cinemagic.xcodeproj'

  pod 'Quick'
  pod 'Nimble'

  core()
end
