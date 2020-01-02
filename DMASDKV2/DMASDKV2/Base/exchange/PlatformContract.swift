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
import DMASDKV1

class PlatformContract: NSObject {
    let abi = "DMAPlatform"
    
    var url = defultURL
    
    
    /// 初始化
    ///
    /// - Parameter url: eth 节点地址
    required public init(url : String) {
        super.init()
        self.url = url
    }
    
    public required override init() {
        super.init()
    }
    
    
    /// 发布合约
    ///
    /// - Parameters:
    ///   - privateKey: 私钥
    ///   - token721: token721
    ///   - platformAddress: 托管合约地址
    ///   - firstExpense: firstExpense description
    ///   - secondExpense: secondExpense description
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    /// - Returns: return value description
    func setupDeploy(privateKey:String,token721:String,token20:String,platformAddress:String,firstExpense : String,secondExpense:String,gasLimit:String,gasPrice:String) -> ContractResult {
        
        let deployHelper = DeployHelper(url: url)
        let param = [token721 ,token20,platformAddress ,firstExpense,secondExpense] as [Any]
        return deployHelper.setupDeploy(privateKey: privateKey, abi: abi, bytecode: "DMAPlatformData", parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
        
    }
    
    
    /// 资产授权
    ///
    /// - Parameters:
    ///   - privateKey: 资产拥有者的私钥
    ///   - contractAddress: 合约地址
    ///   - owner: 授权给哪个地址
    ///   - tokenId: 资产 id 数组
    ///   - value:  金额
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    /// - Returns: 交易hash
    func saveApprove(privateKey:String,contractAddress:String,owner:String,tokenId:String,value:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [owner,tokenId,Web3.Utils.parseToBigUInt(value, units: .eth) as Any] as [Any]
        let contract = ContractMethodHelper(url: url)
        
        
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "saveApprove", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }
    
    
    /// 批量资产授权
    ///
    /// - Parameters:
    ///   - privateKey: 资产拥有着的私钥
    ///   - contractAddress: 合约地址
    ///   - owner: 授权给哪个地址
    ///   - tokenArr: 资产 id 数组
    ///   - value: 金额
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    /// - Returns: 交易hash
    func saveApproveWithArray(privateKey:String,contractAddress:String,owner:String,tokenArr:Array<Any>,value:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [owner,tokenArr,Web3.Utils.parseToBigUInt(value, units: .eth)! as Any] as Any
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "saveApproveWithArray", privateKey: privateKey, parameters: param as! [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
       
        return result
    }
    
    
    
    /// 资产转送
    ///
    /// - Parameters:
    ///   - privateKey: 资产拥有者的私钥
    ///   - contractAddress: 合约地址
    ///   - owner: 转送给哪个地址
    ///   - tokenId: 资产 id
    ///   - value: 金额
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    /// - Returns: 交易hash
    func transfer(privateKey:String,contractAddress:String,owner:String,tokenId:String,value:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [owner,tokenId,Web3.Utils.parseToBigUInt(value, units: .eth)as Any] as Any
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "transfer", privateKey: privateKey, parameters: param as! [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,weiValue: value,getGasFee : getGasFee)
        return result
    }
    
    
    
    /// 资产批量转送
    ///
    /// - Parameters:
    ///   - privateKey: 资产拥有者的地址
    ///   - contractAddress: 合约地址
    ///   - owner: 转送给哪个地址
    ///   - tokenArr: 资产 id 数组
    ///   - totalValue: 总金额
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    /// - Returns: 交易hash
    
    func transferWithArray(privateKey:String,contractAddress:String,owner:String,tokenArr:Array<Any>,totalValue:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [owner,tokenArr,Web3.Utils.parseToBigUInt(totalValue, units: .eth) as Any] as Any
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "transferWithArray", privateKey: privateKey, parameters: param as! [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,weiValue: totalValue,getGasFee : getGasFee)
        return result
    }
    
    
//    func getGasFee(privateKey:String,contractAddress:String,owner:String,tokenArr:Array<Any>,totalValue:String,gasLimit:String,gasPrice:String) -> ContractResult{
//        let param = [owner,tokenArr,Web3.Utils.parseToBigUInt(totalValue, units: .eth) as Any] as Any
//        let contract = ContractMethodHelper(url: url)
//        let result = contract.getContractGas(abi: abi,contractAddress:contractAddress,method: "transferWithArray", privateKey: privateKey, parameters: param as! [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,weiValue: totalValue)
//        return result
//    }
    
    
    /// 取消授权
    ///
    /// - Parameters:
    ///   - privateKey: 资产拥有者的地址
    ///   - contractAddress: 合约地址
    ///   - tokenId: 资产 id
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    /// - Returns: return value description
    func revokeApprove(privateKey:String,contractAddress:String,tokenId:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [tokenId] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "revokeApprove", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }
    
    
    /// 批量取消授权
    ///
    /// - Parameters:
    ///   - privateKey: 资产拥有者的地址
    ///   - contractAddress: 合约地址
    ///   - tokenArr: 资产 id 数组
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    /// - Returns: 交易 hash
    func revokeApprovesWithArray(privateKey:String,contractAddress:String,tokenArr:Array<Any>,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [tokenArr] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "revokeApprovesWithArray", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }
    
    
    
    /// 获取地址的资产数量
    ///
    /// - Parameters:
    ///   - contractAddress: 合约地址
    ///   - owner: 要查询的地址
    /// - Returns: json
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
    
    
    /// 获取资产授权的信息
    ///
    /// - Parameters:
    ///   - contractAddress: 合约地址
    ///   - tokenId: 资产id
    /// - Returns:
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
