
//
//  ElaWallet.swift
//  DMASDK
//
//  Created by Zhangxz& on 2019/3/18.
//  Copyright © 2019 Zhangxz&. All rights reserved.
//

import UIKit
import BigInt
import web3swift
import ElastosSdkKeypair
import Alamofire
import HandyJSON
import ElastosSdkWallet

public typealias ElaWalletSuccess = (String) -> ()
class ElaWalletRsp: HandyJSON {
    var Desc: String?
    var Error: Int?
    var Result: String?

    required init() {}
}
class ElaWalletFinished: HandyJSON {
    var Desc: String?
    var Error: Int?
    var Result: [ElaWalletTransfer]?
    
    required init() {}

}
struct ElaWalletTransfer: HandyJSON {
    var AssetId: String?
    var AssetName: String?
    var Utxos: [Utxo]?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &Utxos, name: "Utxo")
    }
}
struct Utxo: HandyJSON {
    var Index: Double?
    var Txid: String?
    var Value: Double?
}
struct Outputs: HandyJSON {
    var amount: Double?
    var address: String?
}
struct UTXOInputs: HandyJSON {
    var index: Double?
    var txid: String?
    var privateKey: String?
    var address: String?
    
}
struct Transaction: HandyJSON {
    var Fee: Double?
    var Outputs: [Outputs] = []
    var UTXOInputs: [UTXOInputs] = []
}

struct coressTransaction: HandyJSON {
    var Fee: Double?
    var Outputs: [Outputs] = []
    var UTXOInputs: [UTXOInputs] = []
    var CrossChainAsset : [CrossChainAsset] = []
}

class Transactions: HandyJSON {
    var Transactions: [Transaction] = []
    required init() {}
}

class coressTransactions: HandyJSON {
    var Transactions: [coressTransaction] = []
    required init() {}
}

class CrossChainAsset : HandyJSON{
    var amount: Double?
    var address: String?
    required init() {}
}

class ElaWallet: NSObject {

    var url = ""
    /// 创建钱包
    ///
    /// - Returns: 助记词、私钥、地址
    func create() -> (mnemonic:String,privateKey:String,address:String) {
        let mnemonic = ElastosKeypair.GenerateMnemonic(language: "english", words: "")
        var seed = Data()
        let seedLen = ElastosKeypair.GetSeedFromMnemonic(seed: &seed, mnemonic: mnemonic!, language: "english", words: "", mnemonicPassword: "")

        let privKey = ElastosKeypair.GetSinglePrivateKey(seed: seed, seedLen: seedLen)
        let pubKey = ElastosKeypair.GetSinglePublicKey(seed: seed, seedLen: seedLen)
        let address = ElastosKeypair.GetAddress(publicKey: pubKey!)
        return (mnemonic!,privKey!,address!)
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
        guard let privateKey = ElastosKeypair.GetSinglePrivateKey(seed: seed, seedLen: seedLen) else {
            return "invalid mnemonics"
        }
        return privateKey
    }
    
    /// 通过私钥导出地址
    ///
    /// - Parameter privateKey: 私钥
    /// - Returns: 地址
    func exportAddressFromPrivateKey(privateKey:String) -> String {
        guard let pubkey = ElastosKeypair.GetPublicKeyFromPrivateKey(privateKey: privateKey) else {
            return "invalid mnemonics"
        }
        guard let address = ElastosKeypair.GetAddress(publicKey: pubkey) else {
            return "invalid mnemonics"
        }
        return address
    }
    
    /// 通过助记词导出私钥和地址
    ///
    /// - Parameter mnemonics: 助记词
    /// - Returns: 地址
    func exportAddressAndPrivateKeyFromMnemonics(mnemonics:String) -> (address:String,privateKey:String) {
        let privateKey = self.exportPrivateKeyFromMnemonics(mnemonics: mnemonics)
        if(privateKey == "invalid mnemonics"){
            return ("","")
        }
        let address = self.exportAddressFromPrivateKey(privateKey: privateKey)
        return (address,privateKey)
    }
    

    private func exportGenerateRawTransaction(sign:String) -> String {
        let signEncode = ElastosKeypairSign.GenerateRawTransaction(transaction: sign)
        return signEncode!
    }
    
    /// 根据块号获取交易信息
    ///
    /// - Parameters:
    ///   - height: 高度
    ///   - success: 成功
    ///   - Failed: 失败
    func getTransactionsbyHeight(height:String,success:@escaping ElaWalletSuccess,Failed:@escaping ElaWalletSuccess) -> Void {
        Alamofire.request(url+elablocktransactionsheight+height, method: .get, parameters: nil, encoding: URLEncoding.default).responseString { (resp) in
            if resp.result.isSuccess{
                let r = ElaWalletRsp.deserialize(from: resp.result.value)
                if r?.Error == 0 {
                    success((r?.Result)!)
                }else
                {
                    Failed((r?.Result)!)
                }
            }else
            {
                Failed(DMASDKError.ErrorCode.RPC_REQUEST_FAILED.rawValue)
            }
        }
    }
    
    /// 根据块号获取块详情
    ///
    /// - Parameters:
    ///   - height: 高度
    ///   - success: 成功
    ///   - Failed: 失败
    func getdetailsbyHeight(height:String,success:@escaping ElaWalletSuccess,Failed:@escaping ElaWalletSuccess) -> Void {
        Alamofire.request(url+elablockdetailsheight+height, method: .get, parameters: nil, encoding: URLEncoding.default).responseString { (resp) in
            if resp.result.isSuccess{
                let r = ElaWalletRsp.deserialize(from: resp.result.value)
                
                if r?.Error == 0 {
                    success((r?.Result)! )
                }else
                {
                    Failed((r?.Result)! )
                }
            }else
            {
                Failed(DMASDKError.ErrorCode.RPC_REQUEST_FAILED.rawValue)
            }
        }
    }
    
    /// 根据交易哈希获取交易信息
    ///
    /// - Parameters:
    ///   - height: 高度
    ///   - success: 成功
    ///   - Failed: 失败
    func getdetailsbyHash(txid:String,success:@escaping ElaWalletSuccess,Failed:@escaping ElaWalletSuccess) -> Void {
        Alamofire.request(url+elablockdetailshash+txid, method: .get, parameters: nil, encoding: URLEncoding.default).responseString { (resp) in
            if resp.result.isSuccess{
                let r = ElaWalletRsp.deserialize(from: resp.result.value)
                if r?.Error == 0 {
                    success((r?.Result)! )
                }else
                {
                    Failed((r?.Result)! )
                }
            }else
            {
                Failed(DMASDKError.ErrorCode.RPC_REQUEST_FAILED.rawValue)
            }
        }
    }
    
    /// 获取当前块高度
    ///
    /// - Parameters:
    ///   - height: 高度
    ///   - success: 成功
    ///   - Failed: 失败
    func getHeight(success:@escaping ElaWalletSuccess,Failed:@escaping ElaWalletSuccess) -> Void {
        Alamofire.request(url+elablockheight, method: .get, parameters: nil, encoding: URLEncoding.default).responseString { (resp) in
            if resp.result.isSuccess{
                let r = ElaWalletRsp.deserialize(from: resp.result.value)
                if r?.Error == 0 {
                    success((r?.Result)! )
                }else
                {
                    Failed((r?.Result)! )
                }
            }else
            {
                Failed(DMASDKError.ErrorCode.RPC_REQUEST_FAILED.rawValue)
            }
        }
    }
//    交易相关
    func getTransaction(txid:String,success:@escaping ElaWalletSuccess,Failed:@escaping ElaWalletSuccess) -> Void {
        Alamofire.request(url+elatransaction+txid, method: .get, parameters: nil, encoding: URLEncoding.default).responseString { (resp) in
            if resp.result.isSuccess{
                let r = ElaWalletRsp.deserialize(from: resp.result.value)
                if r?.Error == 0 {
                    success((r?.Result)! )
                }else
                {
                    Failed((r?.Result)! )
                }
            }else
            {
                Failed(DMASDKError.ErrorCode.RPC_REQUEST_FAILED.rawValue)
            }
        }
    }
    
    /// 根据地址获取余额
    ///
    /// - Parameters:
    ///   - address: 地址
    ///   - success: 成功
    ///   - Failed: 失败
     func getassetbalances(address:String,success:@escaping ElaWalletSuccess,Failed:@escaping ElaWalletSuccess) -> Void {
        Alamofire.request(url+elaassetbalances+address, method: .get, parameters: nil, encoding: URLEncoding.default).responseString { (resp) in
            if resp.result.isSuccess{
                let r = ElaWalletRsp.deserialize(from: resp.result.value)
                if r?.Error == 0 {
                    success((r?.Result)!)
                }else
                {
                    Failed((r?.Result)! )
                }
            }else
            {
                Failed(DMASDKError.ErrorCode.RPC_REQUEST_FAILED.rawValue)
            }
        }
    }
    
    /// 根据地址获取utxo
    ///
    /// - Parameters:
    ///   - address: 地址
    ///   - success: 成功
    ///   - Failed: 失败
    func getassetutxos(address:String,success:@escaping ElaWalletSuccess,Failed:@escaping ElaWalletSuccess) -> Void {
        Alamofire.request(url+eleaassetutxos+address, method: .get, parameters: nil, encoding: URLEncoding.default).responseString { (resp) in
            if resp.result.isSuccess{
                let r = ElaWalletFinished.deserialize(from: resp.result.value)
                
                if r?.Error == 0 {
                    success((r?.toJSONString()!)!)
                }else
                {
                    Failed(DMASDKError.ErrorCode.RPC_REQUEST_FAILED.rawValue)
                }
            }else
            {
                Failed(DMASDKError.ErrorCode.RPC_REQUEST_FAILED.rawValue)
            }
        }
    }
    
    
     func transfer(privateKey:String,to:String,value:String,success:@escaping ElaWalletSuccess,Failed:@escaping ElaWalletSuccess) -> Void {
        let fee:Double = 0.0001
        var sum:Double = 0
        var utxoInputsArray:Array<UTXOInputs> = []
        var outputsArray:Array<Outputs> = []
//        var transactionArray:Array<Transaction> = []

        let address = self.exportAddressFromPrivateKey(privateKey: privateKey)
        self.getassetbalances(address: address, success: { (resp) in
            let outValue = (NSDecimalNumber(value: fee).adding(NSDecimalNumber(string: value))).doubleValue
            if (Double(resp)! >= outValue){
                
                self.getassetutxos(address: address, success: { (resp) in
                    let addressResut = ElaWalletFinished.deserialize(from: resp)
                    for item in (addressResut?.Result)!{
                        for utxo in item.Utxos! {
                            var u = UTXOInputs()
                            u.address = address
                            u.privateKey = privateKey
                            u.index = utxo.Index
                            u.txid = utxo.Txid
                            utxoInputsArray.append(u)
                            sum = (NSDecimalNumber(value: sum).adding(NSDecimalNumber(value: utxo.Value!))).doubleValue
                            if sum >= outValue {
                                break
                            }
                        }

                    }
                    var outputs = Outputs()
                    var outputs2 = Outputs()

                    outputs.address = to
                    outputs.amount  = (NSDecimalNumber(string: value).multiplying(by: 100000000)).doubleValue
                    outputsArray.append(outputs)
                    
                    outputs2.address = address
                    outputs2.amount = ((NSDecimalNumber(value: sum).subtracting(NSDecimalNumber(value: outValue))).multiplying(by: 100000000)).doubleValue
                    
                    
                    var transaction = Transaction()
                    transaction.Fee = (NSDecimalNumber(value: fee).multiplying(by: 100000000)).doubleValue
                    transaction.Outputs.append(outputs)
                    transaction.Outputs.append(outputs2)
                    transaction.UTXOInputs = utxoInputsArray
                    
                    let trascations = Transactions()
                    trascations.Transactions.append(transaction)
                    let signEncode = self.exportGenerateRawTransaction(sign: trascations.toJSONString()!)
                    let param = ["data":signEncode,
                                 "method":"sendrawtransaction",
                                 "type":"MAIN_CHAIN"]
                    
                    let data = try! JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
                    var string = ""
                    let Str = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                    string = string + Str!
                    print(string)
                    let Url = URL.init(string: self.url+elarawtransaction)
                    let request = NSMutableURLRequest.init(url: Url!)
                    request.timeoutInterval = 30
                    request.httpMethod = "POST"
                    request.httpBody = string.data(using: String.Encoding.utf8)
                    
                    let session = URLSession.shared
                    let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                        if (error != nil) {
                            return
                        }
                        else {
                            
                            let json:Dictionary<String,Any> = try! JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String, Any>
                            let r = ElaWalletRsp.deserialize(from: json)
                            if r?.Error == 0 {
                                success((r?.Result)!)
                            }else
                            {
                                Failed((r?.Result)!)
                            }
                        }
                    }
                    dataTask.resume()
                    
                    
                }, Failed: { (error) in
                    Failed(error)

                })
    
                
            }else
            {
                Failed(DMASDKError.ErrorCode.BALANCE_UNDERFINANCED.rawValue)
            }
            
        }) { (error) in
            Failed(error)
        }
        
        
    }
    
    func crossTranferToDID(mnemonic : String,to : String,value : String,Success:@escaping ElaWalletSuccess,Failed:@escaping ElaWalletSuccess){
        let url = "https://api-wallet-ela.elastos.org"
//        let fee = 0.0001
        let crossFee  = 0.0001
        let seed = elastos.IdentityManager.GetSeed(mnemonic: mnemonic, language: "english", words: "", mnemonicPassword: "")
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let cachesDir = paths[0]
        let identity = elastos.IdentityManager.CreateIdentity(localPath: cachesDir);
        let node = elastos.BlockChainNode(url: url)
        let singleWallet = identity.createSingleAddressWallet(seed: seed!, node: node)
//        singleWallet.syncHistory()
        let values = (NSDecimalNumber(string: value).adding(NSDecimalNumber(value: crossFee))).multiplying(by: 100000000)
        print("corss")
        print(values.int64Value)
        let transaction = elastos.Transaction(address: to, amount: values.int64Value, coinType: 0)
        let result = singleWallet.sendTransaction(transactions: [transaction], memo: "", seed: seed!, chain: "did")
        if let res = result{
            Success(res)
        }else{
            Failed(DMASDKError.ErrorCode.RPC_REQUEST_FAILED.rawValue)
        }
        
    }
    
    ///跨链转账
    func crossTransfer(privateKey:String,to:String,value:String,transferType : TranferType,success:@escaping ElaWalletSuccess,Failed:@escaping ElaWalletSuccess) -> Void {
        let fee:Double = 0.0001
        let crossFee : Double = 0.0001
        var sum:Double = 0
        var utxoInputsArray:Array<UTXOInputs> = []
        var outputsArray:Array<Outputs> = []
        let address = self.exportAddressFromPrivateKey(privateKey: privateKey)
        self.getassetbalances(address: address, success: { (resp) in
            let outValue = (NSDecimalNumber(value: fee).adding(NSDecimalNumber(string: value)).adding(NSDecimalNumber(value: crossFee))).doubleValue
            if (Double(resp)! >= outValue){
                self.getassetutxos(address: address, success: { (resp) in
                    let addressResut = ElaWalletFinished.deserialize(from: resp)
                    for item in (addressResut?.Result)!{
                        for utxo in item.Utxos! {
                            var u = UTXOInputs()
                            u.address = address
                            u.privateKey = privateKey
                            u.index = utxo.Index
                            u.txid = utxo.Txid
                            utxoInputsArray.append(u)
                            sum = (NSDecimalNumber(value: sum).adding(NSDecimalNumber(value: utxo.Value!))).doubleValue
                            if sum >= outValue {
                                break
                            }
                        }
                        
                    }
                    var outputs = Outputs()
                    var outputs2 = Outputs()
                    let crossChainAssets = CrossChainAsset()
                    
                    
                    switch transferType{
                    case .MAIN_DID_CROSS_CHAIN:
                        outputs.address = TranferType.MAIN_DID_CROSS_CHAIN.rawValue
                    case .MAIN_ETH_CROSS_CHAIN:
                        outputs.address = TranferType.MAIN_ETH_CROSS_CHAIN.rawValue
                    case .DID_MAIN_CROSS_CHAIN:
                        outputs.address = TranferType.DID_MAIN_CROSS_CHAIN.rawValue
                    }
                    
                    crossChainAssets.address = to
                    outputs.amount  = ((NSDecimalNumber(string: value).adding(NSDecimalNumber(value: crossFee))).multiplying(by: 100000000)).doubleValue
                    outputsArray.append(outputs)
                    
                    outputs2.address = address
                    outputs2.amount = ((NSDecimalNumber(value: sum).subtracting(NSDecimalNumber(value: outValue))).multiplying(by: 100000000)).doubleValue
                    
                    
                    crossChainAssets.amount = (NSDecimalNumber(string: value).multiplying(by: 100000000)).doubleValue
                    
                    var transaction = coressTransaction()
                    transaction.Fee = (NSDecimalNumber(value: fee).multiplying(by: 100000000)).doubleValue
                    transaction.Outputs.append(outputs)
                    transaction.Outputs.append(outputs2)
                    transaction.UTXOInputs = utxoInputsArray
                    transaction.CrossChainAsset.append(crossChainAssets)
                    
                    print("cccc")
                    print(transaction.toJSON())
                    
                    let trascations = coressTransactions()
                    trascations.Transactions.append(transaction)
                    let signEncode = self.exportGenerateRawTransaction(sign: trascations.toJSONString()!)
                    let param = ["data":signEncode,
                                 "method":"sendrawtransaction",
                                 "type":"MAIN_CHAIN"]
                    
                    let data = try! JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
                    var string = ""
                    let Str = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                    string = string + Str!
                    print(string)
                    let Url = URL.init(string: self.url+elarawtransaction)
                    let request = NSMutableURLRequest.init(url: Url!)
                    request.timeoutInterval = 30
                    request.httpMethod = "POST"
                    request.httpBody = string.data(using: String.Encoding.utf8)
                    
                    let session = URLSession.shared
                    let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                        if (error != nil) {
                            return
                        }
                        else {
                            
                            let json:Dictionary<String,Any> = try! JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String, Any>
                            let r = ElaWalletRsp.deserialize(from: json)
                            if r?.Error == 0 {
                                print("result")
                                print(r?.Result)
                                success((r?.Result)!)
                            }else
                            {
                                Failed((r?.Result)!)
                            }
                        }
                    }
                    dataTask.resume()
                    
                    
                }, Failed: { (error) in
                    Failed(error)
                    
                })
                
                
            }else
            {
                Failed(DMASDKError.ErrorCode.BALANCE_UNDERFINANCED.rawValue)
            }
            
        }) { (error) in
            Failed(error)
        }
        
        
    }
    
    func transferSignEncode(privateKey:String,to:String,value:String,Success : @escaping ((String) -> Void),Failed : @escaping ((String) -> Void)){
        let fee:Double = 0.000001
        var sum:Double = 0
        var utxoInputsArray:Array<UTXOInputs> = []
        var outputsArray:Array<Outputs> = []
        //        var transactionArray:Array<Transaction> = []
        
        let address = self.exportAddressFromPrivateKey(privateKey: privateKey)
        self.getassetbalances(address: address, success: { (resp) in
            let outValue = (NSDecimalNumber(value: fee).adding(NSDecimalNumber(string: value))).doubleValue
            if (Double(resp)! >= outValue){
                
                self.getassetutxos(address: address, success: { (resp) in
                    let addressResut = ElaWalletFinished.deserialize(from: resp)
                    for item in (addressResut?.Result)!{
                        for utxo in item.Utxos! {
                            var u = UTXOInputs()
                            u.address = address
                            u.privateKey = privateKey
                            u.index = utxo.Index
                            u.txid = utxo.Txid
                            utxoInputsArray.append(u)
                            sum = (NSDecimalNumber(value: sum).adding(NSDecimalNumber(value: utxo.Value!))).doubleValue
                            if sum >= outValue {
                                break
                            }
                        }
                        
                    }
                    var outputs = Outputs()
                    var outputs2 = Outputs()
                    
                    outputs.address = to
                    outputs.amount  = (NSDecimalNumber(string: value).multiplying(by: 100000000)).doubleValue
                    outputsArray.append(outputs)
                    
                    outputs2.address = address
                    outputs2.amount = ((NSDecimalNumber(value: sum).subtracting(NSDecimalNumber(value: outValue))).multiplying(by: 100000000)).doubleValue
                    
                    
                    var transaction = Transaction()
                    transaction.Fee = (NSDecimalNumber(value: fee).multiplying(by: 100000000)).doubleValue
                    transaction.Outputs.append(outputs)
                    transaction.Outputs.append(outputs2)
                    transaction.UTXOInputs = utxoInputsArray
                    
                    let trascations = Transactions()
                    trascations.Transactions.append(transaction)
                    let signEncode = self.exportGenerateRawTransaction(sign: trascations.toJSONString()!)
                    Success(signEncode)
                }, Failed: { (error) in
                    Failed(error)
                    
                })
                
                
            }else
            {
                Failed(DMASDKError.ErrorCode.BALANCE_UNDERFINANCED.rawValue)
            }
            
        }) { (error) in
            Failed(error)
        }
        
        
    }
    
}
extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhX", $0) }.joined()
    }
}
