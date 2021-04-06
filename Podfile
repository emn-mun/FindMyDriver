source 'http://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'

inhibit_all_warnings!
use_frameworks!

workspace 'FindMyDriver.xcworkspace'

def main_pods
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxGesture'
    pod 'RxCoreLocation'
    pod 'SnapKit'
end

def test_pods
    pod 'RxTest'
    pod 'RxBlocking'
end

target :FindMyDriver do
    project 'FindMyDriver.xcodeproj', 'Debug' => :debug, 'Release' => :release
    main_pods
    target :FindMyDriverTests do
        test_pods
    end
end

post_install do |installer|

    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '5.0'
        end
    end

end
