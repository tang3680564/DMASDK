//
//  ContractMethodHelper.swift
//  DMASDK
//
//  Created by Zhangxz& on 2019/3/20.
//  Copyright © 2019 Zhangxz&. All rights reserved.
//

import UIKit
import web3swift
import BigInt
import HandyJSON


class ContractMethodHelper: NSObject {
    
    var nodeURL = assetManagementUrl!
    
    private static var randomInt : BigUInt = 0
    
    private static var address = ""
  
    
    required init(url : String) {
        super.init()
        nodeURL = URL(string: url)!
    }
    
    required override init() {
        super.init()
    }
    
    func getContract(abi:String,contractAddress:String,method:String,privateKey:String,parameters: [AnyObject] = [AnyObject](),gasLimit:String,gasPrice:String,weiValue : String? = "",getGasFee : Bool = false) -> ContractResult {
        
        if getGasFee{
            return getContractGas(abi: abi, contractAddress: contractAddress, method: method, privateKey: privateKey,parameters : parameters, gasLimit: gasLimit, gasPrice: gasPrice,weiValue : weiValue)
        }
        let abi = getAbi(abi: abi)
        let ethWallet = EthWallet()
        let web3 = Web3.new(nodeURL)
        web3?.provider.network = nil
        var options = Web3Options()
        if !privateKey.isEmpty {
            let keystoreJson = ethWallet.exportKeystoreFromPrivateKeyAndPassword(privateKey: privateKey, passWord: "A")
            let address = ethWallet.exportAddressFromPrivateKey(privateKey: privateKey) ?? ""
            if ContractMethodHelper.address != address{
                ContractMethodHelper.address = address
                ContractMethodHelper.randomInt = 0
            }
            if keystoreJson != nil {
                let keystore = EthereumKeystoreV3.init(keystoreJson!)
                let keystoreManager = KeystoreManager([keystore!])
                let account = keystoreManager.addresses![0]
                options.from = account
                options.gasLimit = BigUInt(gasLimit)
                options.gasPrice = BigUInt(gasPrice)
                if weiValue != "" {
                    options.value = Web3.Utils.parseToBigUInt(weiValue!, units: .eth)
                }
                web3?.addKeystoreManager(keystoreManager)
                let contraction = web3?.contract(abi, at: EthereumAddress(contractAddress), abiVersion: 2)
//                let result = contraction?.method(method, parameters: parameters, extraData: Data(), options: options)?.send(password: "A", options: options,onBlock: "latest")
//                switch result{
//                case .success(let res)?:
//                    return ContractResult.success(value:["hash":res.hash])
//                case .failure(let error)?:
//                    return ContractResult.failure(error: error)
//                case .none:
//                    return ContractResult.failure(error: "转账失败")
//                }
                var transfer = contraction?.method(method, parameters: parameters, extraData: Data(), options: options)?.transaction
                let random = web3?.eth.getTransactionCount(address: account)
                switch random{
                case .success(let res)?:
                    
                    if ContractMethodHelper.randomInt == res{
                        transfer?.nonce = res + 1
                    }else if ContractMethodHelper.randomInt > res{
                        transfer?.nonce = ContractMethodHelper.randomInt + 1
                    }else{
                        transfer?.nonce = res
                    }
                    ContractMethodHelper.randomInt = transfer!.nonce
                    do {
                        try Web3Signer.signTX(transaction: &transfer!, keystore: keystore!, account: account, password: "A")
                    } catch {
                        print("签名失败")
                    }
                    let encoded:Data? = transfer?.encode()
                    let sendTransation = web3?.eth.sendRawTransaction(encoded!)
                    switch sendTransation{
                    case .success(let res)?:
                        return ContractResult.success(value:["hash":res.hash])
                    case .failure(let error)?:
                        return ContractResult.failure(error: error)
                    case .none:
                        return ContractResult.failure(error: DMASDKError.RPC_REQUEST_FAILED.getCodeAndMsg())
                    }
                case .failure(let error)?:
                    print(error)
                    return ContractResult.failure(error: error)
                case .none:
                    return ContractResult.failure(error: DMASDKError.RPC_REQUEST_FAILED.getCodeAndMsg())
                }
            }else { return ContractResult.failure(error: "私钥错误")}
        }else
        {
            let contraction = web3?.contract(abi, at: EthereumAddress(contractAddress), abiVersion: 2)
            let result = contraction?.method(method, parameters: parameters, extraData: Data(), options: options)?.call(options: options)

            switch result {
            case .success(let res)?:
                return ContractResult.success(value: res)
            case .failure(let error)?:
                return ContractResult.failure(error: error.localizedDescription)

            case .none:
                return ContractResult.failure(error: DMASDKError.RPC_REQUEST_FAILED.getCodeAndMsg())
            }
        }

    }
    
    
    func getContractGas(abi:String,contractAddress:String,method:String,privateKey:String,parameters: [AnyObject] = [AnyObject](),gasLimit:String,gasPrice:String,weiValue : String? = "") -> ContractResult {
        let abi = getAbi(abi: abi)
        let ethWallet = EthWallet()
        let web3 = Web3.new(nodeURL)
        web3?.provider.network = nil
        var options = Web3Options()
        if !privateKey.isEmpty {
            let keystoreJson = ethWallet.exportKeystoreFromPrivateKeyAndPassword(privateKey: privateKey, passWord: "A")
            if keystoreJson != nil {
                let keystore = EthereumKeystoreV3.init(keystoreJson!)
                let keystoreManager = KeystoreManager([keystore!])
                let account = keystoreManager.addresses![0]
                options.from = account
                options.gasLimit = BigUInt(gasLimit)
                options.gasPrice = BigUInt(gasPrice)
                if weiValue != "" {
                    options.value = Web3.Utils.parseToBigUInt(weiValue!, units: .eth)
                }
                web3?.addKeystoreManager(keystoreManager)
                
                let contraction = web3?.contract(abi, at: EthereumAddress(contractAddress), abiVersion: 2)
                let result = contraction?.method(method, parameters: parameters, extraData: Data(), options: options)?.estimateGas(options: options)
               
                switch result {
                case .success(let res)?:
                    print("opopoop")
                    print(res)
                    return ContractResult.success(value:["gas":res])
                case .failure(let error)?:
                    print(error)
                    return ContractResult.failure(error: error)
                case .none:
                    return ContractResult.failure(error: DMASDKError.RPC_REQUEST_FAILED.getCodeAndMsg())
                }
            }else { return ContractResult.failure(error: "私钥错误")}
        }else
        {
            let contraction = web3?.contract(abi, at: EthereumAddress(contractAddress), abiVersion: 2)
            let result = contraction?.method(method, parameters: parameters, extraData: Data(), options: options)?.call(options: options)
            
            switch result {
            case .success(let res)?:
                return ContractResult.success(value: res)
            case .failure(let error)?:
                return ContractResult.failure(error: error.localizedDescription)
                
            case .none:
                return ContractResult.failure(error: DMASDKError.RPC_REQUEST_FAILED.getCodeAndMsg())
            }
        }
        
    }
    
    func getAbi(abi:String) -> String {
       let path = Bundle(identifier: "starrymedia.DMASDKV1")?.path(forResource: abi, ofType: "json")
//        let path = Bundle.main.path(forResource: abi, ofType: "json")
        let data = NSData.init(contentsOfFile: path!)
        let abiString = String.init(data: data! as Data, encoding:.utf8)
        return abiString!
    }
}
