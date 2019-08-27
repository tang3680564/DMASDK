//
//  ElaDID.swift
//  DMASDK
//
//  Created by Zhangxz& on 2019/3/25.
//  Copyright © 2019 Zhangxz&. All rights reserved.
//

import UIKit
import ElastosSdkKeypair
import ElastosSdkWallet

class ElaDID: NSObject {
    var url = ""

    func create() -> (mnemonic:String,privateKey:String,address:String,elaDid:String) {
        let mnemonic = ElastosKeypair.GenerateMnemonic(language: "english", words: "")
        var seed = Data()
        let seedLen = ElastosKeypair.GetSeedFromMnemonic(seed: &seed, mnemonic: mnemonic!, language: "english", words: "", mnemonicPassword: "")
        
        let privKey = ElastosKeypair.GetSinglePrivateKey(seed: seed, seedLen: seedLen)
        let pubKey = ElastosKeypair.GetSinglePublicKey(seed: seed, seedLen: seedLen)
        let address = ElastosKeypair.GetAddress(publicKey: pubKey!)
        let did = ElastosKeypairDID.GetDid(publicKey: pubKey!)
        
        return (mnemonic!,privKey!,address!,did!)
    }
    
    /// 通过助记词生成私钥
    ///
    /// - Parameters:
    ///   - mnemonics: 助记词
    ///   - words: words
    ///   - mnemonicPassword: mnemonicPassword
    /// - Returns: 私钥
    func exportPrivateKeyFromMnemonics(mnemonics:String) -> String {
        var seed = Data()
        
        let seedLen = ElastosKeypair.GetSeedFromMnemonic(seed: &seed, mnemonic: mnemonics, language: "english", words: "", mnemonicPassword: "")
        let privateKey = ElastosKeypair.GetSinglePrivateKey(seed: seed, seedLen: seedLen)
        return privateKey!
    }
    /// 通过私钥导出地址Did
    ///
    /// - Parameter privateKey: 私钥
    /// - Returns: 地址
    func exportAddressDidFromPrivateKey(privateKey:String) -> (address:String,did:String) {
        let pubkey = ElastosKeypair.GetPublicKeyFromPrivateKey(privateKey: privateKey)
        let address = ElastosKeypair.GetAddress(publicKey: pubkey!)
        let did = ElastosKeypairDID.GetDid(publicKey: pubkey!)
        
        return (address!,did!)
    }
    
    /// 通过助记词导出私钥和地址
    ///
    /// - Parameter mnemonics: 助记词
    /// - Returns: 地址
    func exportAddresPrivateKeyDidFromMnemonics(mnemonics:String) -> (address:String,privateKey:String,did:String) {
        let privateKey = self.exportPrivateKeyFromMnemonics(mnemonics: mnemonics)
        let address = self.exportAddressDidFromPrivateKey(privateKey: privateKey)
        return (address.0,privateKey,address.1)
    }
    
    
    private func exportGenerateRawTransaction(sign:String) -> String {
        let signEncode = ElastosKeypairSign.GenerateRawTransaction(transaction: sign)
        return signEncode!
    }
    /// 根据地址获取余额
    ///
    /// - Parameters:
    ///   - address: 地址
    ///   - success: 成功
    ///   - Failed: 失败
    func getassetbalances(address:String,success:@escaping ElaWalletSuccess,Failed:@escaping ElaWalletSuccess) -> Void {
        let ela = ElaWallet()
        ela.url = url
        ela.getassetbalances(address: address, success: success, Failed: Failed)
        
    }
    func transfer(privateKey:String,to:String,value:String,success:@escaping ElaWalletSuccess,Failed:@escaping ElaWalletSuccess) -> Void {
        let ela = ElaWallet()
        ela.url = url
        ela.transfer(privateKey: privateKey, to: to, value: value, success: success, Failed: Failed)
        
    }
    
    
    func setDidInfo(mnemonic : String,remark : NSMutableDictionary,nodeUrl : String) -> String{
        print(mnemonic)
        let seed = elastos.IdentityManager.GetSeed(mnemonic: mnemonic, language: "english", words: "", mnemonicPassword: "")
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let cachesDir = paths[0]
        let identity = elastos.IdentityManager.CreateIdentity(localPath: cachesDir);
        let node = elastos.BlockChainNode(url: nodeUrl)
        let singleWallet = identity.createSingleAddressWallet(seed: seed!, node: node)
        singleWallet.syncHistory()
        let address = singleWallet.getAddress(chain: 0, index: 0)
        print("address: \(address)")
        //        let balance = singleWallet.getBalance(address: "ESXuzYC5VjdEYHETXY2SUYh2ZNPNhQNd8U")
        //        print("balance: \(balance)")
        
        let didManager = identity.createDidManager(seed: seed!)
        let did = didManager.createDid(index: 0)
        let id = did.getId()
        print("id: \(id)")
        var arr : NSMutableArray = []
        for key in remark.allKeys{
            let dic : NSMutableDictionary = [:]
            dic["Key"] = "\(key)"
            dic["Value"] = "\(remark[key]!)"
            arr.add(dic)
        }
        let jsonData = try! JSONSerialization.data(withJSONObject: arr, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonStr = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        print(jsonStr)
       
        var txid = did.setInfo(seed: seed!, json: jsonStr as! String, wallet: singleWallet);
        print("set did info: \(txid)")
        did.syncInfo();
        guard let textStr = txid else{
            return ""
        }
        return textStr
    }
    
    func getDidInfo(nodeUrl : String ,didAddress : String,Success : @escaping ServerResultSuccessResult,Failed : @escaping ServerResultSuccessResult){
        var baseUrl = nodeUrl + "/api/1/didexplorer/did/"
        baseUrl += didAddress
        baseUrl += "/status/all"
        DMAHttpUtil.getServerDataByGet(url: baseUrl, param: [:], Success: { (dic) in
            let resultDic : NSMutableDictionary = [:]
            if let resultStr = dic["result"] as? String{
                let data = resultStr.data(using: String.Encoding.utf8)
                if let arr = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSMutableArray{
                    for dataDic in arr{
                        if let dataDiction = dataDic as? NSMutableDictionary{
                            let key = "\(dataDiction["key"] ?? "")"
                            let value = "\(dataDiction["value"] ?? "")"
                            resultDic[key] = value
                        }
                    }
                }
            }
            Success(resultDic)
        }) { (error) in
            print("error")
            print(error)
            Failed(error)
        }
    }
    
    
    func getDidInfo(baseUrl : String ,Success : @escaping ServerResultSuccessResult,Failed : @escaping ServerResultSuccessResult){
        DMAHttpUtil.getServerDataByGet(url: baseUrl, param: [:], Success: { (dic) in
            let resultDic : NSMutableDictionary = [:]
            if let resultStr = dic["result"] as? String{
                let data = resultStr.data(using: String.Encoding.utf8)
                if let arr = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSMutableArray{
                    for dataDic in arr{
                        if let dataDiction = dataDic as? NSMutableDictionary{
                            let key = "\(dataDiction["key"] ?? "")"
                            let value = "\(dataDiction["value"] ?? "")"
                            resultDic[key] = value
                        }
                    }
                }
            }
            Success(resultDic)
        }) { (error) in
            print("error")
            print(error)
            Failed(error)
        }
    }
}
