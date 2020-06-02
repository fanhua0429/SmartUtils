
Pod::Spec.new do |s|
  s.name             = 'SmartUtils'
  s.version          = '0.2.0'
  s.summary          = 'Vmeet中的基本工具库SmartUtils.'
  s.description      = <<-DESC
  
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/fanhua0429/SmartUtils'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fanhua0429' => '854279162@qq.com' }
  s.source           = { :git => 'https://github.com/fanhua0429/SmartUtils.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SmartUtils/Classes/**/*.{h,m}'
  
  # s.resource_bundles = {
  #   'SmartUtils' => ['SmartUtils/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  #尝试引入第三方依赖库
  s.dependency 'Masonry', '~> 1.1.0' ##自动布局
  s.dependency 'AFNetworking', '~> 3.2.1'  ##网络请求
end
