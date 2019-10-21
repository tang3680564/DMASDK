//
//  EthService.swift
//  DMASDK
//
//  Created by Zhangxz& on 2019/3/25.
//  Copyright © 2019 Zhangxz&. All rights reserved.
//

import Foundation

open class EthService: NSObject {
    
    public var url = defultURL

    
    /// 初始化eth 钱包
    ///
    /// - Parameter url: 节点地址
    public init(url : String) {
        super.init()
        self.url = url
    }
    
    public override init() {

    }
    
    /// 获取助记词
    ///
    /// - Parameter seedLen: 随机长度
    /// - Returns: 返回助记词
    public func exportMnemonics() -> String {
        let eth = EthWallet()
        let e = eth.exportMnemonics()
        return e!
        
    }
    /// 钱包生成   0代表助记词 1代表私钥 2代表地址
    ///
    /// - Returns: 0代表助记词 1代表私钥 2代表地址
    public func create() -> (mnemonic:String,privateKey:String,address:String) {
        let eth = EthWallet()
        let create = eth.create()
        return (create.0!,create.1!,create.2!)
    }
    /// 通过私钥生成钱包地址
    ///
    /// - Parameter privateKey: 私钥
    /// - Returns: 钱包地址
    public func exportAddressFromPrivateKey(privateKey:String) -> String {
        let eth = EthWallet()
        return eth.exportAddressFromPrivateKey(privateKey: privateKey)!
    }
    /// 通过keystore和密码生成钱包地址和私钥 0私钥1钱包地址
    ///
    /// - Parameter keystore: 私钥
    /// - Returns: 私钥/钱包地址
    
    public func exportAddressFromKeystore(keystore:String ,password:String) -> (privateKey:String,address:String) {
        let eth = EthWallet()
        let e = eth.exportAddressFromKeystore(keystore: keystore, password: password)
        return (e.0!,e.1!)
    }
    
    /// 通过助记词生成钱包地址和私钥 0私钥1钱包地址
    ///
    /// - Parameter mnemonics: 私钥
    /// - Returns: 钱包地址
    public func exportAddressAndPrivateKeyFromMnemonics(mnemonics:String) -> (privateKey:String,address:String) {
        let eth = EthWallet()
        let e = eth.exportAddressAndPrivateKeyFromMnemonics(mnemonics: mnemonics)
        return (e.0!,e.1!)
    }
    /// 通过私钥以及密码生成keystore
    ///
    /// - Parameters:
    ///   - privateKey: 私钥
    ///   - passWord: 密码
    /// - Returns: keyStore
    public func exportKeystoreFromPrivateKeyAndPassword(privateKey :String, passWord: String) -> String {
        let eth = EthWallet()
        let e = eth.exportKeystoreFromPrivateKeyAndPassword(privateKey: privateKey, passWord: passWord)
        return e!
    }
    
    /// 通过地址查询钱包余额
    ///
    /// - Parameter address: 地址
    /// - Returns: 余额
    public func balance(address:String) -> ContractResult {
        let eth = EthWallet()
        eth.url = url
        let e = eth.balance(address: address)
        return e
        
    }
    
    
    /// 通过地址查询钱包余额
    ///
    /// - Parameter address: 钱包地址
    /// - Returns: 余额
    public func balances(address:String) -> String {
        let eth = EthWallet()
        eth.url = url
        let e = eth.balances(address: address)
        print("balance serveric is \(e)")
        if let _ = Double(e){
             return e
        }else{
             return "0"
        }
    }
    
    /// DMA 转账
    ///
    /// - Parameters:
    ///   - contractAddress : 合约地址
    ///   - privatekey: 私钥
    ///   - to: 转账对象
    ///   - value: 转账金额 例如eg:0.1代表0.1eth
    ///   - gasPrice: gas价格 例如Demo
    ///   - gasLimit: gas限制 例如Demo
    /// - Returns: 哈希值
//    public func tokenTransfer(contractAddress : String ,privatekey:String,to:String,value:String,gasPrice:String,gasLimit:String) -> ContractResult {
//        let tokenContract = TokenContract()
//        let e = tokenContract.transfer(privateKey: privatekey, contractAddress: contractAddress, to: to, value: value, gasLimit: gasLimit, gasPrice: gasPrice)
//        return e
//    }
    
    
   
    public func tokenBalance(contractAddress:String) -> String{
       return balances(address: contractAddress)
    }
    /// 转账
    ///
    /// - Parameters:
    ///   - privatekey: 私钥
    ///   - to: 转账对象
    ///   - value: 转账金额 例如eg:0.1代表0.1eth
    ///   - gasPrice: gas价格 例如Demo
    ///   - gasLimit: gas限制 例如Demo
    /// - Returns: 哈希值
    public func transfer(privatekey:String,to:String,value:String,gasPrice:String = "",gasLimit:String = "") -> ContractResult {
        let eth = EthWallet()
        eth.url = url
        var gasPrice = gasPrice
        var gasLimit = gasLimit
        if gasPrice.isEmpty{
            gasPrice = defaultGasPrice
        }
        if gasLimit.isEmpty {
            gasLimit = transferGasLimit
        }
        let e = eth.transfer(privatekey: privatekey, to: to, value: value, gasPrice: gasPrice, gasLimit: gasLimit)
        return e
    }
    
    func getStatusByHash(hash : String ) -> ContractResult{
        let eth = EthWallet()
        eth.url = url
        return eth.getStatusByHash(hash: hash)
    }
    
    func getStatusByHashs(hash : String ) -> Bool{
        let eth = EthWallet()
        eth.url = url
        let result = eth.getStatusByHash(hash: hash)
        guard case .success(let dic) = result else{
            return false
        }
        guard let status = dic["status"] as? Bool else{
            return false
        }
        return status
    }
    
    func getTransactionReceipt(hash : String ) -> ContractResult{
        let eth = EthWallet()
        eth.url = url
        return eth.getTransactionReceipt(hash: hash)
    }
//    static public func parseToBigUInt(value : String) -> String{
//        if let str = EthWallet.parseToBigUInt(value: value){
//            return str
//        }
//        return "0"
//    }
    
}
