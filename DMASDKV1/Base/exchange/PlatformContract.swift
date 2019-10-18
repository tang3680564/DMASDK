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
    ///   - assetAddress: assetAddress
    ///   - platformAddress: 平台收款地址
    ///   - firstExpense: firstExpense description
    ///   - secondExpense: secondExpense description
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    /// - Returns: return value description
    func setupDeploy(privateKey:String,platformAddress:String,firstExpense : String,secondExpense:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        
        let deployHelper = DeployHelper(url: url)
        let param = [platformAddress ,firstExpense,secondExpense] as [Any]
        return deployHelper.setupDeploy(privateKey: privateKey, abi: abi, bytecode: "ETHPlatformData", parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        
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
    func saveApprove(privateKey:String,contractAddress:String,assetAddress:String,owner:String,tokenId:String,value:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [assetAddress,owner,tokenId,Web3.Utils.parseToBigUInt(value, units: .eth) as Any] as [Any]
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
    func saveApproveWithArray(privateKey:String,contractAddress:String,assetAddress:String,owner:String,tokenArr:Array<Any>,value:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [assetAddress,owner,tokenArr,Web3.Utils.parseToBigUInt(value, units: .eth)! as Any] as Any
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
    func transfer(privateKey:String,contractAddress:String,owner:String,assetAddress:String,tokenId:String,value:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [assetAddress,owner,tokenId,Web3.Utils.parseToBigUInt(value, units: .eth)as Any] as Any
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "transfer", privateKey: privateKey, parameters: param as! [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,weiValue: value,getGasFee : getGasFee)
        return result
    }
    
    
    
    /// 资产批量转送
    ///
    /// - Parameters:
    ///   - privateKey: 购买人的私钥
    ///   - contractAddress: 合约地址
    ///   - owner: 资产拥有者的地址
    ///   - tokenArr: 资产 id 数组
    ///   - totalValue: 总金额
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    /// - Returns: 交易hash
    
    func transferWithArray(privateKey:String,contractAddress:String,assetAddress:String,owner:String,tokenArr:Array<Any>,totalValue:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [assetAddress,owner,tokenArr,Web3.Utils.parseToBigUInt(totalValue, units: .eth) as Any] as Any
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
    func revokeApprove(privateKey:String,contractAddress:String,assetAddress:String,tokenId:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [assetAddress,tokenId] as [Any]
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
    func revokeApprovesWithArray(privateKey:String,contractAddress:String,assetAddress:String,tokenArr:Array<Any>,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [assetAddress,tokenArr] as [Any]
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
    func getAssetCnt(contractAddress:String,assetAddress:String,owner:String) -> ContractResult {
        let param = [assetAddress,owner] as [Any]
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
    
    
    
    /// 获取托管地址下的已上架的资产地址数量
    ///
    /// - Parameter contractAddress: 合约地址
    /// - Returns: return value description
    func getAssetNum(contractAddress : String) -> ContractResult{
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi, contractAddress: contractAddress, method: "assetNum", privateKey: "", gasLimit: "", gasPrice: "")
        switch result {
        case .success(let dic):
            let number = dic["0"] as? String
            return ContractResult.success(value:["result":number ?? "0"])
        case .failure(error: let error):
            return ContractResult.failure(error: error)
        }
    }
    
    
    /// 获取托管合约下的已上架的所有资产地址以及资产下的 token 数量
    ///
    /// - Parameter pageSize: 页码
    func getAssetList(pageSize : String,contractAddress : String) -> ContractResult{
        let param = [pageSize] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "assetList", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
        switch result {
        case .success(let dic):
            let addressArray : NSMutableArray = []
            var addressTempArray : NSMutableArray = []
            if let address = dic["_address"] as? NSArray{
                addressTempArray = NSMutableArray(array: address)
                for i in 0..<address.count{
                    let ethAddress = address[i]
                    if let ethAddStr = ethAddress as? EthereumAddress{
                        if ethAddStr.address != "0x0000000000000000000000000000000000000000"{
                            addressArray.add(ethAddStr.address)
                        }
                    }
                }
            }
            let tokenNumberArr : NSMutableArray = []
            if let tokenNumber = dic["_amount"] as? NSArray{
                for i in 0..<tokenNumber.count{
                    let tokenArr = tokenNumber[i]
                    let token = "\(tokenArr)"
                    if token != "0" {
                        tokenNumberArr.add(token)
                    }else{
                        if i < addressTempArray.count{
                            let ethAddress = addressTempArray[i]
                            if let ethAddStr = ethAddress as? EthereumAddress{
                                if ethAddStr.address != "0x0000000000000000000000000000000000000000"{
                                    addressArray.remove(ethAddStr.address)
                                }
                            }
                        }
                    }
                }
            }
            return ContractResult.success(value:["addressArray":addressArray,"tokenArray":tokenNumberArr])
        case .failure(error: let error):
            return ContractResult.failure(error: error)
        }
    }
    
    
    /// 获取托管合约下已上架的资产数量
    ///
    /// - Parameters:
    ///   - assetAddress: 资产地址
    ///   - contractAddress: 托管地址
    /// - Returns: return value description
    func getTokenNum(assetAddress : String,contractAddress : String) -> ContractResult{
        let param = [assetAddress] as [Any]
        let contract = ContractMethodHelper(url: url)
       
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "tokenNum", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
        switch result {
        case .success(let dic):
            print(dic)
            let number = "\(dic["0"] ?? 0)"
            return ContractResult.success(value:["result":number])
        case .failure(error: let error):
            return ContractResult.failure(error: error)
        }
    }
    
    
    /// 获取托管合约下已上架的资产token
    ///
    /// - Parameters:
    ///   - token712: 资产地址
    ///   - pageSize: 页码
    ///   - contractAddress: 托管合约地址
    func getTokenList(assetAddress : String,pageSize : String,contractAddress : String) -> ContractResult{
        let param = [assetAddress,pageSize] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "tokenList", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
        switch result {
        case .success(let dic):
            
            let tokenIDArray : NSMutableArray = []
            if let tokenIdsArr = dic["_tokenIds"] as? NSArray{
                for i in 0..<tokenIdsArr.count{
                    let str = tokenIdsArr[i]
                    if "\(str)" != "0"{
                        tokenIDArray.add("\(str)")
                    }
                }
            }
            
            let priceArray : NSMutableArray = []
            if let priceArr = dic["_prices"] as? NSArray{
                for i in 0..<tokenIDArray.count {
                    let price = priceArr[i]
                    let priceStr = "\(price)".getWeb3WeiInValue()
                    priceArray.add(priceStr ?? "0")
                }
            }
            let ownersArray : NSMutableArray = []
            if let ownersArr = dic["_owners"] as? NSArray{
                for i in 0..<tokenIDArray.count{
                    let owners = ownersArr[i]
                    if let ownersAddress = owners as? EthereumAddress{
                        ownersArray.add(ownersAddress.address)
                    }
                }
            }
            let countArray : NSMutableArray = []
            if let countArr = dic["_count"] as? NSArray{
                for i in 0..<tokenIDArray.count{
                    let count = countArr[i]
                    countArray.add("\(count)")
                }
            }
            
            return ContractResult.success(value:["tokenIds":tokenIDArray,"count":countArray,"owners":ownersArray,"prices":priceArray])
        case .failure(error: let error):
            return ContractResult.failure(error: error)
        }
    }
    
    /// 获取资产授权的信息
    ///
    /// - Parameters:
    ///   - contractAddress: 合约地址
    ///   - tokenId: 资产id
    /// - Returns:
    func getApproveinfo(contractAddress:String,assetAddress:String,tokenId:String) -> ContractResult {
        let param = [assetAddress,tokenId] as [Any]
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
