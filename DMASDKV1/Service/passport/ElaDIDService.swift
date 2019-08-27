//
//  ElaDIDService.swift
//  DMASDK
//
//  Created by Zhangxz& on 2019/3/29.
//  Copyright © 2019 Zhangxz&. All rights reserved.
//

import Foundation

open class ElaDIDService: NSObject {
    public var url = "http://did-mainnet-node-lb-1452309420.ap-northeast-1.elb.amazonaws.com:20604"
    public var didInfoUrl = "https://api-wallet-did.elastos.org"
    
    public required override init() {
        super.init()
    }
    
    public required init(url : String) {
        super.init()
        self.url = url
    }
    
    public required init(didInfoUrl : String) {
        super.init()
        self.didInfoUrl = didInfoUrl
    }
    
    public required init(didInfoUrl : String,url : String) {
        super.init()
        self.didInfoUrl = didInfoUrl
        self.url = url
    }
    
    
    public func create() -> (mnemonic:String,privateKey:String,address:String,elaDid:String) {
        let ela = ElaDID()
        return ela.create()
    }
    
    /// 通过助记词生成私钥
    ///
    /// - Parameters:
    ///   - mnemonics: 助记词
    ///   - words: words
    ///   - mnemonicPassword: mnemonicPassword
    /// - Returns: 私钥
    public func exportPrivateKeyFromMnemonics(mnemonics:String) -> String {
        let ela = ElaDID()
        return  ela.exportPrivateKeyFromMnemonics(mnemonics: mnemonics)
    }
    /// 通过私钥导出地址Did
    ///
    /// - Parameter privateKey: 私钥
    /// - Returns: 地址
    public func exportAddressDidFromPrivateKey(privateKey:String) -> (address:String,did:String) {
        let ela = ElaDID()
        return ela.exportAddressDidFromPrivateKey(privateKey: privateKey)
    }
    
    /// 通过助记词导出私钥和地址
    ///
    /// - Parameter mnemonics: 助记词
    /// - Returns: 地址
    public func exportAddresPrivateKeyDidFromMnemonics(mnemonics:String) -> (address:String,privateKey:String,did:String) {
        let ela = ElaDID()
        return ela.exportAddresPrivateKeyDidFromMnemonics(mnemonics: mnemonics)
    }
    /// 根据地址获取余额
    ///
    /// - Parameters:
    ///   - address: 地址
    ///   - success: 成功
    ///   - Failed: 失败
    public func balances(address:String,success:@escaping ElaWalletSuccess,Failed:@escaping ElaWalletSuccess) -> Void {
        let ela = ElaDID()
        ela.url = url
        ela.getassetbalances(address: address, success: success, Failed: Failed)
        
    }
    public func transfer(privateKey:String,to:String,value:String,success:@escaping ElaWalletSuccess,Failed:@escaping ElaWalletSuccess) -> Void {
        let ela = ElaDID()
        ela.url = url
        ela.transfer(privateKey: privateKey, to: to, value: value, success: success, Failed: Failed)
        
    }
    
    /// 侧链向主链转账
    ///
    /// - Parameters:
    ///   - privateKey: 私钥
    ///   - to: 转入地址
    ///   - value: 转入金额
    ///   - success: success description
    ///   - Failed: Failed description
    public func crossTranfer(mnemonic:String,to:String,value:String,success:@escaping ElaWalletSuccess,Failed:@escaping ElaWalletSuccess){
        let ela = ElaWallet()
        let privateKey = exportPrivateKeyFromMnemonics(mnemonics: mnemonic)
        ela.url = url
        ela.crossTransfer(privateKey: privateKey, to: to, value: value, transferType: TranferType.DID_MAIN_CROSS_CHAIN, success: success, Failed: Failed)
    }
    
    public func setDIDInfo(mnemonic : String,didProfile : Profile) -> String{
        let ela = ElaDID()
        let remark = NSMutableDictionary(dictionary: didProfile.toJSON()!)
        return ela.setDidInfo(mnemonic: mnemonic,remark : remark,nodeUrl : didInfoUrl)
    }
    
    public func setDIDInfo(mnemonic : String, dic : NSMutableDictionary) -> String{
         let ela = ElaDID()
        return ela.setDidInfo(mnemonic: mnemonic, remark: dic, nodeUrl: didInfoUrl)
    }
    
    public func getDIDInfo(didAddress : String,Success : @escaping ServerResultSuccessResult,Failed : @escaping ServerResultSuccessResult){
        let ela = ElaDID()
        ela.getDidInfo(nodeUrl: didInfoUrl, didAddress: didAddress, Success: Success, Failed: Failed)
    }
    
    public func getDIDInfo(didAddress : String,status : Propertys.Status,Success : @escaping ServerResultSuccessResult,Failed : @escaping ServerResultSuccessResult){
        let ela = ElaDID()
        var baseUrl = didInfoUrl + "/api/1/didexplorer/did/"
        baseUrl += didAddress
        baseUrl += "/status/"
        switch status {
            case .normal :
            baseUrl += "normal"
            case .deprecated :
            baseUrl += "deprecated"
            case .all :
            baseUrl += "all"
        }
        ela.getDidInfo(baseUrl: baseUrl, Success: Success, Failed: Failed)
    }
    
    
    public func getDIDInfoByTxId(txid : String,Success : @escaping ServerResultSuccessResult,Failed : @escaping ServerResultSuccessResult){
        let ela = ElaDID()
        var baseUrl = didInfoUrl + "/transaction/"
        baseUrl += txid
        ela.getDidInfo(baseUrl: baseUrl, Success: Success, Failed: Failed)
    }
    
    
    public func getDIDInfoByKey(did : String,key : String,Success : @escaping ServerResultSuccessResult,Failed : @escaping ServerResultSuccessResult){
        let ela = ElaDID()
        var baseUrl = didInfoUrl + "/api/1/didexplorer/did/"
        baseUrl += did
        baseUrl += "/property?"
        baseUrl += "key="
        baseUrl += key
        ela.getDidInfo(baseUrl: baseUrl, Success: Success, Failed: Failed)
    }
    
}
