//
//  EthWallet.swift
//  DMASDK
//
//  Created by Zhangxz& on 2019/3/18.
//  Copyright © 2019 Zhangxz&. All rights reserved.
//

import UIKit
import web3swift
import BigInt


class EthWallet: NSObject {
//    let url:String = "http://192.168.1.104:8545"
    var url:String?
    
    let abi = "ETHTransfer"

    /// 获取助记词
    ///
    /// - Parameter seedLen: 随机长度
    /// - Returns: 返回助记词
    func exportMnemonics() -> (String?) {
        guard let mnemonics = try?BIP39.generateMnemonics(bitsOfEntropy: 128) else {return (nil)}
        return mnemonics
    }
    
    /// 钱包生成   0代表助记词 1代表私钥 2代表地址
    ///
    /// - Returns: 0代表助记词 1代表私钥 2代表地址
    func create() -> (mnemonics:String?,privateKey:String?,address:String?) {
        guard let mnemonics = try?BIP39.generateMnemonics(bitsOfEntropy: 128) else {return (nil,nil,nil)}
        let keystore = try!BIP32Keystore.init(mnemonics:mnemonics)
        let account = keystore?.addresses![0]
        let privateKey = try!keystore?.UNSAFE_getPrivateKeyData(password: "web3swift", account: account!).toHexString()
        let address = account?.address
        return (mnemonics,privateKey,address)
    }
    /// 通过助记词生成钱包地址和私钥 0私钥1钱包地址
    ///
    /// - Parameter mnemonics: 私钥
    /// - Returns: 钱包地址
    func exportAddressAndPrivateKeyFromMnemonics(mnemonics:String) -> (privateKey:String?,address:String?) {
        let keystore = try!BIP32Keystore.init(mnemonics:mnemonics)
        let account = keystore?.addresses![0]
        let privateKey = try!keystore?.UNSAFE_getPrivateKeyData(password: "web3swift", account: account!).toHexString()
        let address = account?.address
        return (privateKey,address)
    }
    /// 通过私钥生成钱包地址
    ///
    /// - Parameter privateKey: 私钥
    /// - Returns: 钱包地址
    func exportAddressFromPrivateKey(privateKey:String) -> String? {
        guard let keystoreV3 = try!EthereumKeystoreV3.init(privateKey: Data.fromHex(privateKey)!) else{ return(nil)}
        let keystoreManager = KeystoreManager.init([keystoreV3])
        guard let address = keystoreManager.addresses?.first?.address else {return (nil)}
        return address
    }
    /// 通过keystore和密码生成钱包地址和私钥 0私钥1钱包地址
    ///
    /// - Parameter keystore: 私钥
    /// - Returns: 钱包地址/私钥
    func exportAddressFromKeystore(keystore:String ,password:String) -> (privateKey:String?,address:String?) {
        guard let keystoreV3 = EthereumKeystoreV3.init(keystore) else {return (nil,nil)}
        let keystoreManager = KeystoreManager.init([keystoreV3])
        guard let account = keystoreManager.addresses?.first else {return (nil,nil)}
        guard let privateKey = try? keystoreManager.UNSAFE_getPrivateKeyData(password:password, account:account) else {return (nil,nil)}
        return (privateKey.toHexString(),account.address)
    }

    /// 通过私钥以及密码生成keystore
    ///
    /// - Parameters:
    ///   - privateKey: 私钥
    ///   - passWord: 密码
    /// - Returns: keyStore
    func exportKeystoreFromPrivateKeyAndPassword(privateKey :String, passWord: String) -> String? {
        
        guard let keystoreV3 = try! EthereumKeystoreV3.init(privateKey: Data.fromHex(privateKey)!, password: passWord, aesMode:"aes-128-ctr") else {return nil}
        guard let jsonData = try? JSONEncoder().encode(keystoreV3.keystoreParams) else {return nil}
        let keystoreJson = String(data: jsonData, encoding: .utf8)
        return keystoreJson!
    }
    
    /// 通过地址查询钱包余额
    ///
    /// - Parameter address: 地址
    /// - Returns: 余额
    func balance(address:String) -> ContractResult {
        let web3 = Web3.new(URL(string: url!)!)
        web3?.provider.network = nil
        let account = EthereumAddress(address)

        let balanceResult = web3?.eth.getBalance(address: account!)
        switch balanceResult {
        case .success(let balance)?:
            
            return ContractResult.success(value:["balance":Web3.Utils.formatToPrecision(balance,formattingDecimals : 8) as Any])
        case .failure(let error)?:
            return ContractResult.failure(error: error.localizedDescription)
        case .none:
            return ContractResult.failure(error: DMASDKError.RPC_REQUEST_FAILED.getCodeAndMsg())
        }
    }
    
    func balances(address:String) -> String {
        let web3 = Web3.new(URL(string: url!)!)
        web3?.provider.network = nil
        let account = EthereumAddress(address)
        let balanceResult = web3?.eth.getBalance(address: account!)
        switch balanceResult {
        case .success(let balance)?:
            print("balance is \(balance)")
            return Web3.Utils.formatToPrecision(balance,formattingDecimals : 8)!
        case .failure(let error)?:
            return "查询失败\(error)"
        case .none:
            return "查询失败erro"
        }
    }
    
    
    
    /// eth侧链 向 主链转账
    ///
    /// - Parameters:
    ///   - privateKey: 私钥
    ///   - to: 转账地址
    ///   - value: 转账金额
    ///   - contractAddress: 合约地址
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    /// - Returns: return value description
    public func crossTransfer(privateKey : String,to : String,value : String,contractAddress : String,gasLimit : String,gasPrice : String,getGasFee : Bool = false) -> ContractResult{
        let fee = "0.0001"
        let valuesC = NSDecimalNumber(string: value).adding(0.0001)
        let param = [to,Web3.Utils.parseToBigUInt(valuesC.stringValue, units: .eth)! as Any,Web3.Utils.parseToBigUInt(fee, units: .eth)! as Any] as [Any]
        let contract = ContractMethodHelper(url: url!)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "receivePayload", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: "30744", gasPrice: gasPrice,weiValue: valuesC.stringValue,getGasFee: getGasFee)
        
        return result
    }
    
    static public func parseToBigUInt(value : String) -> String?{
        return Web3.Utils.formatToEthereumUnits(BigUInt(value)!)
    }
    
    
    func getStatusByHash(hash : String ) -> ContractResult{
        let web3 = Web3.new(URL(string: url!)!)
        let result = web3?.eth.getTransactionReceipt(hash)
        switch result {
        case .success(let dic)?:
            let status = dic.status
            if status == web3swift.TransactionReceipt.TXStatus.ok{
                return ContractResult.success(value: ["status" : true])
            }
            return ContractResult.success(value: ["status" : false])
        case .failure(let error)?:
            return ContractResult.failure(error: [error_Str : error.localizedDescription])
        case .none:
            return ContractResult.failure(error: DMASDKError.RPC_REQUEST_FAILED.getCodeAndMsg())
        }
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
    func transfer(privatekey:String,to:String,value:String,gasPrice:String,gasLimit:String) -> ContractResult {
        let keyJsonString = self.exportKeystoreFromPrivateKeyAndPassword(privateKey: privatekey, passWord: "")
        let keystore = EthereumKeystoreV3.init(keyJsonString!)
        let keystoreManager = KeystoreManager.init([keystore!])
        let account = keystoreManager.addresses![0]

        let web3 = Web3.new(URL(string: url!)!)
        web3?.provider.network = nil
        web3?.addKeystoreManager(keystoreManager)

        
        
        let toAddress = EthereumAddress(to)
        
        let random = web3?.eth.getTransactionCount(address: account)
       
        switch random {
        case .success(let res)?:
            
            var transaction = EthereumTransaction(gasPrice: BigUInt(gasPrice)!,
                                                  gasLimit: BigUInt(gasLimit)!,
                                                  to: toAddress!,
                                                  value: Web3.Utils.parseToBigUInt(value, units: .eth)!,
                                                  data: Data())
            
            transaction.nonce = res
            do {
                try Web3Signer.signTX(transaction: &transaction, keystore: keystore!, account: account, password: "")
            } catch {
                print("签名失败")
            }
            let encoded:Data? = transaction.encode()
 
            let sendTransation = web3?.eth.sendRawTransaction(encoded!)
            
            switch sendTransation {
            case .success(let res)?:
                return ContractResult.success(value:["hash":res.hash])
            case .failure(let error)?:
                return ContractResult.failure(error: error)
            case .none:
                return ContractResult.failure(error: DMASDKError.RPC_REQUEST_FAILED.getCodeAndMsg())
            }
            
        case .failure(let error)?:
            return ContractResult.failure(error: error)
        case .none:
            return ContractResult.failure(error: DMASDKError.RPC_REQUEST_FAILED.getCodeAndMsg())
        }
    }
    
}
