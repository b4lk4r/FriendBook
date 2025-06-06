platform :ios, '15.0'

target 'PresentsUsingGPT' do
  use_frameworks!

  pod 'Alamofire', '~> 5.8'
  pod 'Swinject', '~> 2.8'
  pod 'KeychainSwift', '~> 20.0'

  target 'PresentsUsingGPTTests' do
    inherit! :search_paths
  end

  target 'PresentsUsingGPTUITests' do
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
    end
  end
end
