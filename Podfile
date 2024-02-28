# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

 pod 'Alamofire'
 pod 'SVProgressHUD'
 pod 'SDWebImage'
 pod 'SwiftyJSON'
 pod 'Localize-Swift'
 pod 'YouTubePlayer'
 pod 'SnapKit'
 pod 'Localize-Swift'

target 'OzinsheSnapKit' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for OzinsheSnapKit

end

# Setup target iOS version for all pods after install
post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
      end
  end
end
