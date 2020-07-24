

Pod::Spec.new do |s|


s.name         = "QTAudioTool"
s.version      = "0.1"
s.summary      = "QTAudioTool"


s.description  = "QTAudioTool"

s.homepage     = "https://github.com/HelloBie/QTAudioTool.git"

s.license      = "MIT"
# s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

s.author             = { "不不不紧张" => "1005903848@qq.com" }

s.source       = { :git => "https://github.com/HelloBie/QTAudioTool.git", :tag => "#{s.version}" }


s.ios.frameworks = 'Foundation'

s.ios.deployment_target = '6.0' # minimum SDK with autolayout

s.source_files  = 'QTAudioTool/QTAudioTool/QTAudioTool/*.{h,m,a}'
# s.source_files  = 'QTCoreMain/QTCore/**/*.{h,m}'
#s.exclude_files = "Classes/Exclude"

# s.public_header_files = "Classes/**/*.h"



#s.dependency 'AFNetworking', '~> 2.6.1'

# s.resource  = "icon.png"
# s.resources = "Resources/*.png"

# s.preserve_paths = "FilesToSave", "MoreFilesToSave"



s.frameworks = "Foundation", "UIKit"
# s.framework  = "SomeFramework"
# s.frameworks = "SomeFramework", "AnotherFramework"

# s.library   = "iconv"
# s.libraries = "iconv", "xml2"




# s.requires_arc = true

# s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
# s.dependency "JSONKit", "~> 1.4"

end
