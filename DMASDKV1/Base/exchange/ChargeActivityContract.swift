//
//  ChargeActivityContract.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/7/15.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import UIKit
import BigInt
import web3swift

class ChargeActivityContract : NSObject{
    
    let abi = "ETHChargeActivity"
    
    var urlStr = defultURL
    
    required init(url : String) {
        super.init()
        urlStr = url
    }
    
    required override init() {
    }
    
    func setupDeploy(privateKey:String,token721:String,endtime : String,gasLimit:String,gasPrice:String) -> ContractResult {
        let deployHelper = DeployHelper(url: urlStr)
        let param = [token721 , endtime] as [Any]
        return deployHelper.setupDeploy(privateKey: privateKey, abi: abi, bytecode: "ETHChargeActivityData", parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
        
    }
    
   
    
    /// 资产上架
    ///
    /// - Parameters:
    ///   - privateKey: 私钥
    ///   - contractAddress: 合约地址
    ///   - spender: 被授权者地址
    ///   - value: 上架金额
    /// - Returns: hash
    func saveApprove(privateKey:String,contractAddress:String,owner:String,tokenId:String, value: String ,gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [owner,tokenId,Web3.Utils.parseToBigUInt(value, units: .eth) as Any] as [Any]
        let contract = ContractMethodHelper(url: urlStr)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "saveApprove", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
        return result
    }
    
    
    /// 购买
    ///
    /// - Parameters:
    ///   - privateKey: 购买者的私钥
    ///   - contractAddress: 合约地址
    ///   - owner: 资产拥有者
    ///   - tokenId: tokenID
    ///   - value: 金额
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    /// - Returns: hash
    func transfer(privateKey:String,contractAddress:String,owner:String,tokenId:String, weiValue: String ,gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [owner,tokenId] as [Any]
        let contract = ContractMethodHelper(url: urlStr)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "transfer", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,weiValue: weiValue)
        return result
    }
    
    
    /// 资产批量上架
    ///
    /// - Parameters:
    ///   - privateKey: 私钥
    ///   - contractAddress: 合约地址
    ///   - owner: 资产拥有者地址
    ///   - tokenArr: 资产数组
    ///   - value: 上架金额
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    /// - Returns: hash
    func saveApproveWithArray(privateKey:String,contractAddress:String,owner:String,tokenArr:Array<Any>, value: String ,gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [owner,tokenArr,Web3.Utils.parseToBigUInt(value, units: .eth) as Any] as [Any]
        let contract = ContractMethodHelper(url: urlStr)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "saveApproveWithArray", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
        return result
    }
    
    
    /// 资产下架
    ///
    /// - Parameters:
    ///   - privateKey: 私钥
    ///   - contractAddress: 合约地址
    ///   - tokenId: 资产 ID
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    /// - Returns: hash
    func revokeApprove(privateKey:String,contractAddress:String,tokenId:String,gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [tokenId] as [Any]
        let contract = ContractMethodHelper(url: urlStr)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "revokeApprove", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
        return result
    }
    
    
    /// 购买多个资产
    ///
    /// - Parameters:
    ///   - privateKey: 购买者的私钥
    ///   - contractAddress: 合约地址
    ///   - owner: 资产拥有者地址
    ///   - tokenArr: tokenArr description
    ///   - value: 购买的金额
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    /// - Returns: hash
    func transferWithArray(privateKey:String,contractAddress:String,owner:String,tokenArr:Array<Any>, weiValue: String ,gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [owner,tokenArr] as [Any]
        let contract = ContractMethodHelper(url: urlStr)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "transferWithArray", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,weiValue: weiValue)
        return result
    }
    
    
    ///  批量资产下架
    ///
    /// - Parameters:
    ///   - privateKey: 私钥
    ///   - contractAddress: 合约地址
    ///   - tokenArr: 资产数组
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    /// - Returns: hash
    func revokeApprovesWithArray(privateKey:String,contractAddress:String,tokenArr:Array<Any>, gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [tokenArr] as [Any]
        let contract = ContractMethodHelper(url: urlStr)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "revokeApprovesWithArray", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
        return result
    }
    
    
    ///  结束活动
    ///
    /// - Parameters:
    ///   - privateKey: 私钥
    ///   - contractAddress: 合约地址
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    /// - Returns: hash
    func endActivity(privateKey:String,contractAddress:String,gasLimit:String,gasPrice:String) -> ContractResult {
        let param : Array<Any> = []
        let contract = ContractMethodHelper(url: urlStr)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "endActivity", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
        return result
    }
    
    
    //  无私钥
    func getAssetCnt(contractAddress:String,owner:String) -> ContractResult {
        let param = [owner] as [Any]
        let contract = ContractMethodHelper(url: urlStr)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "getAssetCnt", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
        switch result {
        case .success(let res):
            print(res)
            var count = "0"
            if let management = res["_cnt"]{
                count = "\(management)"
            }
            return ContractResult.success(value:["result":count])
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
        
    }
    
    func getApproveinfo(contractAddress:String,tokenId:String) -> ContractResult {
        let param = [tokenId] as [Any]
        let contract = ContractMethodHelper(url: urlStr)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "getApproveInfo", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
        switch result {
        case .success(let res):
            print(res)
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
