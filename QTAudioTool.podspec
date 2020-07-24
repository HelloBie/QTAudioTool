

Pod::Spec.new do |s|


s.name         = "QTAudioTool"
s.version      = "0.2"
s.summary      = "QTAudioTool"


s.description  = "QTAudioTool"

s.homepage     = "https://github.com/HelloBie/QTAudioTool.git"

s.license      = "MIT"

s.author             = { "不不不紧张" => "1005903848@qq.com" }

s.source       = { :git => "https://github.com/HelloBie/QTAudioTool.git", :tag => "#{s.version}" }


s.ios.frameworks = 'Foundation'

s.platform     = :ios, "8.0"
s.vendored_libraries = 'QTAudioTool/QTAudioTool/QTAudioTool/libmp3lame.a'
s.source_files  = 'QTAudioTool/QTAudioTool/QTAudioTool/*'

end
