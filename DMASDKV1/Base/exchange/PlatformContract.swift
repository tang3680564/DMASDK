//
//  PlatformContract.swift
//  DMASDK
//
//  Created by Zhangxz& on 2019/3/20.
//  Copyright © 2019 Zhangxz&. All rights reserved.
//

import UIKit
import BigInt
import web3swift
class PlatformContract: NSObject {
    let abi = "ETHPlatform"
    
    var url = defultURL
    
    required public init(url : String) {
        super.init()
        self.url = url
    }
    
    public required override init() {
        super.init()
    }
    
    func setupDeploy(privateKey:String,token721:String,platformAddress:String,firstExpense : String,secondExpense:String,gasLimit:String,gasPrice:String) -> ContractResult {
        
        let deployHelper = DeployHelper(url: url)
        let param = [token721 ,platformAddress ,firstExpense,secondExpense] as [Any]
        return deployHelper.setupDeploy(privateKey: privateKey, abi: abi, bytecode: "ETHPlatformData", parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
        
    }
    
    func saveApprove(privateKey:String,contractAddress:String,owner:String,tokenId:String,value:String,gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [owner,tokenId,Web3.Utils.parseToBigUInt(value, units: .eth) as Any] as [Any]
        let contract = ContractMethodHelper(url: url)
        
        
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "saveApprove", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
        return result
    }
    func saveApproveWithArray(privateKey:String,contractAddress:String,owner:String,tokenArr:Array<Any>,value:String,gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [owner,tokenArr,Web3.Utils.parseToBigUInt(value, units: .eth)! as Any] as Any
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "saveApproveWithArray", privateKey: privateKey, parameters: param as! [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
       
        return result
    }
    
    
    func transfer(privateKey:String,contractAddress:String,owner:String,tokenId:String,value:String,gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [owner,tokenId,Web3.Utils.parseToBigUInt(value, units: .eth)as Any] as Any
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "transfer", privateKey: privateKey, parameters: param as! [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,weiValue: value)
        return result
    }
    
    func transferWithArray(privateKey:String,contractAddress:String,owner:String,tokenArr:Array<Any>,totalValue:String,gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [owner,tokenArr,Web3.Utils.parseToBigUInt(totalValue, units: .eth) as Any] as Any
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "transferWithArray", privateKey: privateKey, parameters: param as! [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,weiValue: totalValue)
        return result
    }
    
    
    func getGasFee(privateKey:String,contractAddress:String,owner:String,tokenArr:Array<Any>,totalValue:String,gasLimit:String,gasPrice:String) -> ContractResult{
        let param = [owner,tokenArr,Web3.Utils.parseToBigUInt(totalValue, units: .eth) as Any] as Any
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContractGas(abi: abi,contractAddress:contractAddress,method: "transferWithArray", privateKey: privateKey, parameters: param as! [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,weiValue: totalValue)
        return result
    }
    
    func revokeApprove(privateKey:String,contractAddress:String,tokenId:String,gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [tokenId] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "revokeApprove", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
        return result
    }
    func revokeApprovesWithArray(privateKey:String,contractAddress:String,tokenArr:Array<Any>,gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [tokenArr] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "revokeApprovesWithArray", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
        return result
    }
    //  无私钥
    func getAssetCnt(contractAddress:String,owner:String) -> ContractResult {
        let param = [owner] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "getAssetCnt", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
        switch result {
        case .success(let res):
            let management = ModelType1.deserialize(from: res)
            let regexStr = "\""
            let array = management?._owner?.components(separatedBy: regexStr)
            for item in array!{
                if item.contains("0x")
                {
                    management?._owner = item
                }
            }
            let s = Web3.Utils.formatToPrecision(BigUInt(management!._value!)!)
            management?._value = s
            return ContractResult.success(value:["result":management!.toJSONString()! as Any])
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
        
    }
    func getApproveinfo(contractAddress:String,tokenId:String) -> ContractResult {
        let param = [tokenId] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "getApproveInfo", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
        switch result {
        case .success(let res):
            let management = ModelType1.deserialize(from: res)
            let regexStr = "\""
            let array = management?._owner?.components(separatedBy: regexStr)
            for item in array!{
                if item.contains("0x")
                {
                    management?._owner = item
                }
            }
            let s = Web3.Utils.formatToPrecision(BigUInt(management!._value!)!)
            management?._value = s
        
            return ContractResult.success(value:["result":management!.toJSONString()! as Any])
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
        
    }
}
