# DMASDK
集合以太坊的区块链方法和 ela 的区块链方法


1 -- 先使用Carthage
在文件中添加如下
github "tang3680564/DMASDK" "master"
执行命令
Carthage update --platform ios

2 -- 再使用 pod
在文件中添加如下
    pod 'web3swift', '~> 1.1.10'
    pod 'Alamofire', '~> 4.7'
    pod 'HandyJSON', '~> 5.0.0'
    pod 'ElastosCarrierSDK', '~> 5.3.1'
    
执行命令
pod install

最后将 carthage 的 build 里面的 framework 和 当前项目的SDK目录中的ElastosSdkWallet.framework ,ElastosSdkKeypair.framework添加到项目当中

在使用的地方使用

import DMASDKV1
