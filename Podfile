# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'
use_frameworks! :linkage => :static

target 'BAQQMusic' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_modular_headers!

  # Pods for BAQQMusic
  pod 'SnapKit'
  
end

post_install do |installer|
  # https://github.com/CocoaPods/CocoaPods/issues/8431
  # system 'sed -i "" "s/\[\[ \$line != \"\${PODS_ROOT}\*\" \]\]/\[\[ \$line != \${PODS_ROOT}\* \]\]/g" "./Pods/Target Support Files/Pods-NissanOneApp/Pods-NissanOneApp-resources.sh"'
  # Xcode 14 报签名错误
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['CODE_SIGN_IDENTITY'] = ''
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
  
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"#arm64,arm64e,x86_64"
  end
end
