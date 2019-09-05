//
//  DMAEum.swift
//  DMAFrameTest
//
//  Created by StarryMedia 刘晓祥 on 2019/7/22.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation

public enum TranferType : String{
//    case MAIN_CHAIN
//    case DID_SIDECHAIN
    ///主链向 did侧链 转账
    case MAIN_DID_CROSS_CHAIN = "XKUh4GLhFJiqAMTF6HyWQrV9pK9HcGUdfJ"
    ///主链 向 eth侧链 转账
    case MAIN_ETH_CROSS_CHAIN = "XVbCTM7vqM1qHKsABSFH4xKN1qbp7ijpWf"
    ///did 向 主链 转账
    case DID_MAIN_CROSS_CHAIN = "0000000000000000000000000000000000"
}
///eth侧链 向 主链转账
public let ethToElaContractAddress = "0xC445f9487bF570fF508eA9Ac320b59730e81e503"
///主链 向 eth侧链 转账 fee
public var MAIN_ETH_CROSS_CHAIN_FEE = "0.0002"
///eth侧链 向 主链转账 fee
public var ETH_CROSS_MAIN_CHAIN_FEE = "0.0001"
///主链向 did侧链 转账 fee
public var MAIN_DID_CROSS_CHAIN_FEE = "0.0002"

///估算收费的合约初始化资产 gas 费的合约地址
public var defultChargeContractAddress = "0xe986B89c0a3b3e1cF66B64825c5F232EA0e8588b"
///估算质押的合约初始化资产 gas 费的合约地址
public var defultPledgeContractAddress = "0xac2c92D285a7EB5F971A5212EFc4cE70982b355a"
///估算gas 的私钥
public var defultContractAddressPrivateKey = "131beaa6385a35307df62e8bf098ef61a990073dead098009e0de98ee500909c"
