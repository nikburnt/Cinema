inhibit_all_warnings!

workspace 'Cinema'
target 'backyardTests' do
  platform :osx, '10.15'
  project 'backyard/backyard.xcodeproj'

  pod 'Quick'
  pod 'Nimble'
end

target 'Cinemagic' do
  platform :ios, '13.0'
  use_frameworks!
  project 'Cinemagic/Cinemagic.xcodeproj'

  pod 'AnimatedField'
  pod 'GeometricLoaders', :git => 'https://github.com/nikburnt/GeometricLoaders', :branch => 'develop'
  pod 'GradientAnimator'
  pod 'KeychainAccess'
  pod 'SwiftEntryKit'
  pod 'LGButton'
  pod 'PromiseKit'
  pod 'PromiseKit/Alamofire'
  pod 'Require'
end
