# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

target 'Beers' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Beers
  
  # Code Quality
  pod 'R.swift' # https://github.com/mac-cain13/R.swift

   # UI
  pod 'Kingfisher'

  target 'BeersTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'BeersUITests' do
    # Pods for testing
  end

end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
  end
 end
end
