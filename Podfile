platform :ios, '11.0'
inhibit_all_warnings!
use_frameworks!

def examplePods

	pod 'QAKit', :path => '.'
end

target 'QAKit-Example' do
	
	examplePods
end


post_install do |installer|

	installer.pods_project.targets.each do |target|

		target.build_configurations.each do |config|
			config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
			config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
			config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
		end
	end
end