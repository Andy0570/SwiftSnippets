# Uncomment the next line to define a global platform for your project
platform :ios, '15.6'

# ignore all warnings from all pods
inhibit_all_warnings!

target 'SwiftSnippets' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SwiftSnippets
  # 网络
  pod 'Alamofire', '~> 5.10.1'

  # 图片
  pod 'Kingfisher', '~> 8.1.1'

  # UI动画
  pod 'Hero', '~> 1.6.3'
  pod 'SwiftMessages', '~> 10.0.1'
  pod 'CHTCollectionViewWaterfallLayout', '~> 0.9.10' # 瀑布流布局
  pod 'FaveButton', '~> 3.2.1' # 点赞按钮
  pod 'anim', '~> 1.2.10' # 页面内动画
  pod 'ViewAnimator', '~> 3.1.0' # 页面转场动画
  # pod 'MJRefresh', '~> 3.7.9'
  # pod 'NVActivityIndicatorView', '~> 5.2.0' # <https://github.com/ninjaprox/NVActivityIndicatorView>
  # pod 'HMSegmentedControl', '~> 1.5.6' # <https://github.com/HeshamMegid/HMSegmentedControl>

  # 用户隐私权限管理
  # <https://github.com/sparrowcode/PermissionsKit>
  # pod 'SPPermissions/Camera' # 相机
  # pod 'SPPermissions/PhotoLibrary' # 相册
  # pod 'SPPermissions/Notification' # 通知
  # pod 'SPPermissions/Microphone' # 麦克风
  # pod 'SPPermissions/LocationWhenInUse' # 定位
  # pod 'SPPermissions/LocationAlways'
  # pod 'SPPermissions/Tracking' # 用户跟踪

  # 模型/文件缓存
  pod 'SwiftyJSON', '~> 5.0.2'

  # Realm 数据库
  # pod 'RealmSwift'
  # pod 'RxRealm'
  # pod 'RxRealmDataSources' # Depends on RxSwift (~> 3.0.0)

  # 工具&服务
  pod 'Hue', '~> 5.0.0' # 颜色
  pod 'SwiftGen', '~> 6.6.3' # 项目资产管理
  pod 'SwifterSwift', '~> 7.0.0' # Swift Extensions
  pod 'Siren' # 版本更新弹窗
  pod 'LicensePlist', '~> 3.24.5' # 第三方依赖 Lincense 列表生成器

  # 调试工具/崩溃统计
  pod 'GDPerformanceView-Swift', '~> 2.1.1'

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
