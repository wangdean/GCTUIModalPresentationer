
Pod::Spec.new do |s|
  s.name         = "GCTUIModalPresentationer"
  s.version      = "0.0.1"
  s.summary      = "自定义 modal presentation vc"
  s.description  = <<-DESC
  自定义 modal presentation vc 控件：
  支持 xib 自定义控件布局约束；
  支持 present 动画、dismiss 动画；
  支持 TextField、TextView 跟随键盘一起 present 显示
                   DESC

  s.homepage     = "https://github.com/wangdean/GCTUIModalPresentationer"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "Later" => "lshxin89@126.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/wangdean/GCTUIModalPresentationer.git", :tag => s.version }
  s.frameworks = 'UIKit', 'Foundation'
  s.requires_arc = true

  s.public_header_files = 'GCTUIModalPresentationViewController/Classes/*.h'
  s.source_files = 'GCTUIModalPresentationViewController/Classes/*.{h,m}'
end
