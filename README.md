# DMASDK
集合以太坊的区块链方法和 ela 的区块链方法

Swift: 5.0 以上

1 -- 先使用Carthage

在文件中添加如下

github "tang3680564/DMASDK" "master"

执行命令

Carthage update --platform ios

2 -- 再使用 pod

在文件中添加如下
   
   pod 'ElastosCarrierSDK', '~> 5.3.2'
    
执行命令

pod install

最后将 carthage 的 build 里面的 framework 和 当前项目的SDK目录中的ElastosSdkWallet.framework ,ElastosSdkKeypair.framework添加到项目当中

buildsetting: bitcode -> false

在使用的地方使用

import DMASDKV1
