//
//  PledgeActivityContract.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/7/15.
//  Copyright © 2019 starrymedia. All rights reserved.
//  质押活动合约

import UIKit
import BigInt
import web3swift

class PledgeActivityContract : NSObject {
    let abi = "ETHPledgeActivity"
    
    var urlStr = defultURL
    
    
    
    /// 初始化
    ///
    /// - Parameter url: eth 节点地址
    required init(url : String) {
        super.init()
        urlStr = url
    }
    
    required override init() {
        
    }
    
    
    
    /// 发布合约
    ///
    /// - Parameters:
    ///   - privateKey: 私钥
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    /// - Returns: return value description
    func setupDeploy(privateKey:String,gasLimit:String = "",gasPrice:String = "",getGasFee : Bool = false) -> ContractResult {
        let deployHelper = DeployHelper(url: urlStr)
        let param : Array<Any> = []
        return deployHelper.setupDeploy(privateKey: privateKey, abi: abi, bytecode: "ETHPledgeActivityData", parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee: getGasFee)
        
    }
    
    /// 上架
    ///
    /// - Parameters:
    ///   - privateKey: 私钥
    ///   - contractAddress: 合约地址
    ///   - assetAddress : 资产地址
    ///   - owner: 资产拥有者地址
    ///   - tokenId: 资产 ID
    ///   - value:  上架金额
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: hash
    func saveApprove(privateKey:String,assetAddress:String,contractAddress:String,owner:String,tokenId:String, value: String ,endTime : String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [assetAddress,owner,tokenId,Web3.Utils.parseToBigUInt(value, units: .eth) as Any,endTime] as [Any]
        let contract = ContractMethodHelper(url: urlStr)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "saveApprove", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }
    
    
    /// 购买
    ///
    /// - Parameters:
    ///   - privateKey: 购买者的私钥
    ///   - assetAddress : 资产地址
    ///   - contractAddress: 合约地址
    ///   - tokenId: 资产 ID
    ///   - value: 购买的金额
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: hash
    func transfer(privateKey:String,assetAddress:String,contractAddress:String,tokenId:String, weiValue: String ,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [assetAddress,tokenId] as [Any]
        let contract = ContractMethodHelper(url: urlStr)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "transfer", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,weiValue: weiValue,getGasFee : getGasFee)
        return result
    }
    
    
    /// 退款
    ///
    /// - Parameters:
    ///   - privateKey: 合约创建者的私钥
    ///   - assetAddress : 资产地址
    ///   - contractAddress: 合约地址
    ///   - tokenId: 资产 ID
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: hash
    func refund(privateKey:String,assetAddress:String,contractAddress:String,tokenId:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [assetAddress,tokenId] as [Any]
        let contract = ContractMethodHelper(url: urlStr)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "refund", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }
    
    
    /// 批量资产上架
    ///
    /// - Parameters:
    ///   - privateKey: 私钥
    ///   - assetAddress : 资产地址
    ///   - contractAddress: 合约地址
    ///   - owner: 资产拥有者地址
    ///   - tokenArr: 批量资产
    ///   - value: 上架金额
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: hash
    func saveApproveWithArray(privateKey:String,assetAddress:String,contractAddress:String,owner:String,tokenArr:Array<Any>, value: String ,endTime : String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [assetAddress,owner,tokenArr,Web3.Utils.parseToBigUInt(value, units: .eth) as Any,endTime] as [Any]
        let contract = ContractMethodHelper(url: urlStr)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "saveApproveWithArray", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }
    
   
    ///  下架
    ///
    /// - Parameters:
    ///   - privateKey: 私钥
    ///   - assetAddress : 资产地址
    ///   - contractAddress: 合约地址
    ///   - tokenId: 资产 ID
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: hash
    func revokeApprove(privateKey:String,assetAddress:String,contractAddress:String,tokenId:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [assetAddress,tokenId] as [Any]
        let contract = ContractMethodHelper(url: urlStr)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "revokeApprove", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }
    
    
    
    /// 批量资产下架
    ///
    /// - Parameters:
    ///   - privateKey: 私钥
    ///   - assetAddress : 资产地址
    ///   - contractAddress: 合约地址
    ///   - tokenArr: 批量资产
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: hash
    func revokeApprovesWithArray(privateKey:String,assetAddress:String,contractAddress:String,tokenArr:Array<Any>,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [assetAddress,tokenArr] as [Any]
        let contract = ContractMethodHelper(url: urlStr)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "revokeApprovesWithArray", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }
    
    
    /// 结束活动
    ///
    /// - Parameters:
    ///   - privateKey: 私钥
    ///   - assetAddress : 资产地址
    ///   - contractAddress: 合约地址
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: hash
    
    func endActivity(privateKey:String,assetAddress:String,contractAddress:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param : Array<Any> = [assetAddress]
        let contract = ContractMethodHelper(url: urlStr)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "endActivity", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }
    
    
    
    /// 验证资产
    ///
    /// - Parameters:
    ///   - privateKey: 合约创建者的私钥
    ///   - assetAddress : 资产地址
    ///   - contractAddress: 合约地址
    ///   - tokenId: 资产 ID
    ///   - owner: 资产拥有者地址
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: hash
    func verify(privateKey:String,assetAddress:String,contractAddress:String,tokenId:String,owner : String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [assetAddress,tokenId,owner] as [Any]
        let contract = ContractMethodHelper(url: urlStr)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "verify", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }

    
    /// 获取地址的资产数量
    ///
    /// - Parameters:
    ///   - assetAddress : 资产地址
    ///   - contractAddress: 合约地址
    ///   - owner: 要查询的地址
    /// - Returns: json
    func getAssetCnt(assetAddress:String,contractAddress:String,owner:String) -> ContractResult {
        let param = [assetAddress,owner] as [Any]
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
    
    /// 获取资产授权的信息
    ///
    /// - Parameters:
    ///   - assetAddress : 资产地址
    ///   - contractAddress: 合约地址
    ///   - tokenId: 资产id
    /// - Returns:
    func getApproveinfo(assetAddress:String,contractAddress:String,tokenId:String) -> ContractResult {
        let param = [assetAddress,tokenId] as [Any]
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
    
    /// 获取托管地址下的已上架的资产地址数量
    ///
    /// - Parameter contractAddress: 合约地址
    /// - Returns: return value description
    func getAssetNum(contractAddress : String) -> ContractResult{
        let contract = ContractMethodHelper(url: urlStr)
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
        let contract = ContractMethodHelper(url: urlStr)
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
        let contract = ContractMethodHelper(url: urlStr)
        
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
    ///   - assetAddress : 资产地址
    ///   - pageSize: 页码
    ///   - contractAddress: 托管合约地址
    func getTokenList(assetAddress : String,pageSize : String,contractAddress : String) -> ContractResult{
        let param = [assetAddress,pageSize] as [Any]
        let contract = ContractMethodHelper(url: urlStr)
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
    

}
