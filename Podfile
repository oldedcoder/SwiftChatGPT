# Uncomment the next line to define a global platform for your project
platform :osx, '13.0'
inhibit_all_warnings! # 消除第三方库警告
source 'https://github.com/CocoaPods/Specs.git'

target 'Chatgpt' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Chatgpt
  pod 'Alamofire'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'WCDB.swift'

  target 'ChatgptTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ChatgptUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '13.0'
      config.build_settings['SWIFT_SUPPRESS_WARNINGS'] = 'YES' # 消除警告
    end
  end
end
