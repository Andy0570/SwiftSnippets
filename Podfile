# Uncomment the next line to define a global platform for your project
platform :ios, '15.6'

target 'SwiftSnippets' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SwiftSnippets
  pod 'Alamofire', '~> 5.10.1'
  pod 'Kingfisher', '~> 8.1.1'
  pod 'SwiftyJSON', '~> 5.0.2'
  # pod 'Hero', '~> 1.6.3'
  # pod 'anim', '~> 1.2.10' # 页面内动画
  # pod 'ViewAnimator', '~> 3.1.0' # 页面转场动画
  pod 'SwiftMessages', '~> 10.0.1'
  pod 'Hue', '~> 5.0.0' # 颜色
  pod 'SwifterSwift', '~> 7.0.0' # Swift 扩展

  target 'SwiftSnippetsTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SwiftSnippetsUITests' do
    # Pods for testing
  end

end

# 更改所有第三方框架 Target 版本
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.6'
        end
    end
end
