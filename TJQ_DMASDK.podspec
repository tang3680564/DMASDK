Pod::Spec.new do |s|
  s.name                      = 'TJQ_DMASDK'
  s.version                   = '1.0.0'
  s.summary                   = 'DMA Framework'
  s.homepage                  = 'https://github.com/tang3680564/DMASDK'
  s.license                   = { :type => 'MIT', :file => 'LICENSE' }
  s.author                    = { 'tang3680564' => '494326253@qq.com' }
  s.source                    = { :git => 'https://github.com/tang3680564/DMASDK.git', :tag => s.version }
  s.platform                  = :ios
  s.ios.deployment_target     = '12.0'
  s.swift_version             = '5.0'
  s.ios.vendored_frameworks   = 'Carthage/Build/iOS/*.framework'

  # 依赖库
  s.dependency 'Alamofire', '~> 4.7'
  s.dependency 'web3swift', '~> 1.1.10'
  s.dependency 'HandyJSON', '~> 5.0.0'
  s.dependency 'ElastosCarrierSDK', '~> 5.3.1'
end 