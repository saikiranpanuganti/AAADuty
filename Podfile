# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'AAADuty' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for AAADuty


	pod 'SDWebImage', '~> 5.0'
  pod 'IQKeyboardManagerSwift', '6.5.0'
  pod 'GoogleMaps', '7.4.0'
  pod 'GooglePlaces', '7.4.0'
  pod 'razorpay-pod', '1.3.0'
  pod 'AWSS3'
  pod 'AWSCognito'
  pod 'AWSCore'
  
  
  post_install do |installer|
      installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
              end
          end
      end
  end

end
