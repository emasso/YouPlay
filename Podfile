platform :ios, '10.3'

target 'YouPlayer' do

  use_frameworks!

  pod 'PlayerTracker', :git => 'https://github.com/emasso/PlayerTracker.git', :tag => '1.0.0'

end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end