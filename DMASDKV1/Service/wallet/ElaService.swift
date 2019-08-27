//
//  ElaService.swift
//  DMASDK
//
//  Created by Zhangxz& on 2019/3/25.
//  Copyright © 2019 Zhangxz&. All rights reserved.
//

import Foundation

public class ElaService: NSObject {
    
   
    public var url = "https://node-mainnet-restful.elastos.org"
    
    public init(url : String) {
        super.init()
        self.url = url
    }
    
    public override init() {
        
    }
    
    deinit {
        
    }
    
    /// 创建钱包
    ///
    /// - Returns: 助记词、私钥、地址
    public func create() -> (mnemonic:String,privateKey:String,address:String) {
        let ela = ElaWallet()
        let wallet = ela.create()
        return (wallet.0,wallet.1,wallet.2)
    }
    /// 通过助记词生成私钥
    ///
    /// - Parameters:
    ///   - mnemonics: 助记词
    ///   - words: words
    ///   - mnemonicPassword: mnemonicPassword
    /// - Returns: 私钥
    public func exportPrivateKeyFromMnemonics(mnemonics:String) -> String {
        let ela = ElaWallet()
        let privateKey = ela.exportPrivateKeyFromMnemonics(mnemonics: mnemonics)
        return privateKey
    }
    /// 通过私钥导出地址
    ///
    /// - Parameter privateKey: 私钥
    /// - Returns: 地址
    public func exportAddressFromPrivateKey(privateKey:String) -> String {
        let ela = ElaWallet()
        let address = ela.exportAddressFromPrivateKey(privateKey: privateKey)
        return address
    }
    /// 通过助记词导出私钥和地址
    ///
    /// - Parameter mnemonics: 助记词
    /// - Returns: 地址
    public  func exportAddressAndPrivateKeyFromMnemonics(mnemonics:String) -> (address:String,privateKey:String) {
        let ela = ElaWallet()
        let wallet = ela.exportAddressAndPrivateKeyFromMnemonics(mnemonics: mnemonics)
        return (wallet.0,wallet.1)
    }
    /// 根据块号获取交易信息
    ///
    /// - Parameters:
    ///   - height: 高度
    ///   - success: 成功
    ///   - Failed: 失败
    public  func getTransactionsbyHeight(height:String,success:@escaping ElaWalletSuccess,Failed:@escaping ElaWalletSuccess) -> Void {
        let ela = ElaWallet()
        ela.url = url
        _ = ela.getTransactionsbyHeight(height: height, success: success, Failed: Failed)
    }
    /// 根据块号获取块详情
    ///
    /// - Parameters:
    ///   - height: 高度
    ///   - success: 成功
    ///   - Failed: 失败
    public  func getdetailsbyHeight(height:String,success:@escaping ElaWalletSuccess,Failed:@escaping ElaWalletSuccess) -> Void {
        let ela = ElaWallet()
        ela.url = url
        _ = ela.getdetailsbyHeight(height: height, success: success, Failed: Failed)
    }
    /// 根据交易哈希获取交易信息
    ///
    /// - Parameters:
    ///   - height: 高度
    ///   - success: 成功
    ///   - Failed: 失败
    public   func getdetailsbyHash(txid:String,success:@escaping ElaWalletSuccess,Failed:@escaping ElaWalletSuccess) -> Void {
        let ela = ElaWallet()
        ela.url = url
        _ = ela.getdetailsbyHash(txid: txid, success: success, Failed: Failed)
    }
    /// 获取当前块高度
    ///
    /// - Parameters:
    ///   - height: 高度
    ///   - success: 成功
    ///   - Failed: 失败
    public  func getHeight(success:@escaping ElaWalletSuccess,Failed:@escaping ElaWalletSuccess) -> Void {
        let ela = ElaWallet()
        ela.url = url
        _ = ela.getHeight(success: success, Failed: Failed)
    }
    //    交易相关
    public func getTransaction(txid:String,success:@escaping ElaWalletSuccess,Failed:@escaping ElaWalletSuccess) -> Void {
        let ela = ElaWallet()
        ela.url = url
        _ = ela.getTransaction(txid: txid, success: success, Failed: Failed)
    }
    
    /// 根据地址获取余额
    ///
    /// - Parameters:
    ///   - address: 地址
    ///   - success: 成功
    ///   - Failed: 失败
    public func getassetbalances(address:String,success:@escaping ElaWalletSuccess,Failed:@escaping ElaWalletSuccess) -> Void {
        let ela = ElaWallet()
        ela.url = url
        _ = ela.getassetbalances(address: address, success: success, Failed: Failed)
    }
    
    /// 根据地址获取utxo
    ///
    /// - Parameters:
    ///   - address: 地址
    ///   - success: 成功
    ///   - Failed: 失败
    public func getassetutxos(address:String,success:@escaping ElaWalletSuccess,Failed:@escaping ElaWalletSuccess) -> Void {
        let ela = ElaWallet()
        _ = ela.getassetutxos(address: address, success: success, Failed: Failed)
    }
    
    
    /// 主链向侧链转账
    ///
    /// - Parameters:
    ///   - privateKey: 私钥
    ///   - to: 转入地址
    ///   - value: 转入金额
    ///   - success: success description
    ///   - Failed: Failed description
    public func crossTranferByDID(mnemonic:String,to:String,value:String,success:@escaping ElaWalletSuccess,Failed:@escaping ElaWalletSuccess){
        let ela = ElaWallet()
        ela.url = url
        ela.crossTranferToDID(mnemonic: mnemonic, to: to, value: value, Success: success, Failed: Failed)
    }
    
    
    /// 主链向侧链转账 
    ///
    /// - Parameters:
    ///   - privateKey: 私钥
    ///   - to: 转入地址
    ///   - value: 转入金额
    ///   - success: success description
    ///   - Failed: Failed description
    public func crossTranferByETH(mnemonic:String,to:String,value:String,success:@escaping ElaWalletSuccess,Failed:@escaping ElaWalletSuccess){
        let ela = ElaWallet()
        let privateKey = exportPrivateKeyFromMnemonics(mnemonics: mnemonic)
        ela.url = url
        ela.crossTransfer(privateKey: privateKey, to: to, value: value, transferType: TranferType.MAIN_ETH_CROSS_CHAIN, success: success, Failed: Failed)
    }
    
    public func transferSignEncode(privateKey:String,to:String,value:String,Success : @escaping ((String) -> Void),Failed : @escaping ((String) -> Void)){
        let ela = ElaWallet()
        ela.url = url
        ela.transferSignEncode(privateKey: privateKey, to: to, value: value, Success: Success, Failed: Failed)
    }
    
    
    public func transfer(privateKey:String,to:String,value:String,success:@escaping ElaWalletSuccess,Failed:@escaping ElaWalletSuccess) -> Void {
        let ela = ElaWallet()
        ela.url = url
        _ = ela.transfer(privateKey: privateKey, to: to, value: value, success: success, Failed: Failed)
    }
}
