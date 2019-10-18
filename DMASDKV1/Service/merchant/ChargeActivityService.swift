//
//  ChargeActivityService.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/7/15.
//  Copyright © 2019 starrymedia. All rights reserved.
//  收费活动合约

import Foundation
import Alamofire
import BigInt
import web3swift


public class ChargeActivityService : NSObject{
    var urlStr = defultURL
    

    
    /// 初始化
    ///
    /// - Parameter url: eth 的节点地址
    public required init(url : String) {
        super.init()
        urlStr = url
    }
    
    public required override init() {
        super.init()
    }
    
    
    /// 发布合约
    ///
    /// - Parameters:
    ///   - privateKey: 私钥
    ///   - gasPrice: gasPrice description
    ///   - gasLimit: gasLimit description
    ///   - name: 合约名称
    ///   - symbol: 合约简介
    ///   - metadata: 合约描述
    ///   - endtime: 活动结束时间
    /// - Returns: assetAddress : 资产合约地址,platformAddress : 托管合约地址
    public func deploy(privateKey:String,gasPrice:String = "",gasLimit:String = "",getGasFee: Bool = false) -> ContractResult {
        let platform = ChargeActivityContract(url: urlStr)
        var gasLimit = gasLimit
        var gasPrice = gasPrice
        var getGasFee = getGasFee
        if !getGasFee{
            let result = platform.setupDeploy(privateKey: privateKey,gasLimit: gasLimit, gasPrice: gasPrice)
            let isError = limIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice, getGasFee: &getGasFee, result: result)
            if let result = isError{
                return result
            }
        }else{
            limAndPriceIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice)
        }
        
        let eth = EthService(url: urlStr)
        eth.url = urlStr
        let address = eth.exportAddressFromPrivateKey(privateKey: privateKey)
        let balance = eth.balance(address: address)
        switch balance {
        case .success(let resp):
            let b = resp["balance"] as!String
            if Double(b)! > 0{
                let platformResult = platform.setupDeploy(privateKey: privateKey,gasLimit: gasLimit, gasPrice: gasPrice)
                switch platformResult{
                case .success(let value):
                    if getGasFee{
                        if let gas = value["gas"] as? String{
                            return ContractResult.success(value: ["gas":gas])
                        }
                    }
                    let platformAddress = value["address"] as!String
                    return ContractResult.success(value: ["platformAddress":platformAddress])
                case .failure(let error):
                    return ContractResult.failure(error: error)
                }
            }else
            {
                return ContractResult.failure(error: DMASDKError.BALANCE_UNDERFINANCED.getCodeAndMsg())
            }
        case.failure(let error):
            return ContractResult.failure(error: error)
        }
    }
    
    
    /// 批量创建资产
    ///
    /// - Parameters:
    ///   - privateKey: 资产合约拥有者地址
    ///   - assetAddress: 资产合约地址
    ///   - to: 创建资产给哪个地址
    ///   - array: 资产 ID 数组
    ///   - metaData: 资产描述
    ///   - isTransfer: 是否可以转送
    ///   - isBurn: 是否可以销毁
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: 交易hash
    public func mintWithArray(privateKey:String,assetAddress:String,to:String,array:Array<Any>,metaData:String,isTransfer:Bool,isBurn:Bool,gasLimit:String = "",gasPrice:String = "",getGasFee : Bool = false) -> ContractResult {
        let asset = AssetManagement(url: urlStr)
        var gasLimit = gasLimit
        var gasPrice = gasPrice
        var getGasFee = getGasFee
        if !getGasFee{
            let result = asset.mintWithArray(privateKey: privateKey, contractAddress: assetAddress, to: to, array: array, uri: metaData, isTransfer: isTransfer, isBurn: isBurn, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : true)
            let isError = limIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice, getGasFee: &getGasFee, result: result)
            if let result = isError{
                return result
            }
        }else{
            limAndPriceIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice)
        }
        let result = asset.mintWithArray(privateKey: privateKey, contractAddress: assetAddress, to: to, array: array, uri: metaData, isTransfer: isTransfer, isBurn: isBurn, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }
    
    /// 上架
    ///
    /// - Parameters:
    ///   - contractAddress: 资产地址
    ///   - platformAddress: 平台合约地址
    ///   - privateKey: 资产拥有者的私钥
    ///   - gasLimit: defaultGasLimit
    ///   - gasPrice: defaultGasPrice
    ///   - owner: 资产拥有者的地址
    ///   - tokenIds: 资产 ID
    ///   - price:  上架价格
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    ///   - canNext : true : 足够支付 gas 费的时候 ,进行此次操作, false: 足够支付 gas 费的时候,不进行此次操作
    /// - Returns:
    public func onSales(contractAddress:String,platformAddress:String,privateKey:String,gasLimit:String = "" ,gasPrice:String = "" ,owner:String,tokenIds:Array<Any>,price:String,endTime:String,getGasFee : Bool = false,canNext : Bool = false) -> ContractResult {
        var canNext = canNext
        var gasLimit = gasLimit
        var gasPrice = gasPrice
        if getGasFee{
            if gasLimit.isEmpty{
                canNext = true
                limAndPriceIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice)
            }
            return onSalesInFor(contractAddress: contractAddress, platformAddress: platformAddress, privateKey: privateKey, gasLimit: gasLimit, gasPrice: gasPrice, owner: owner, tokenIds: tokenIds, price: price, endTime: endTime, getGasFees: getGasFee,canNext: canNext)
        }
        limAndPriceIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice)
        let asset = AssetManagement(url: urlStr)
        //
        let assetresult = asset.approveWithArray(privateKey: privateKey, contractAddress: contractAddress, approved: platformAddress, tokenArr: tokenIds, gasLimit: gasLimit, gasPrice: gasPrice)
        switch assetresult {
            
        case .success(let value):
            let assetHash = value["hash"] as!String
            let platfrom = ChargeActivityContract(url: urlStr)
            let platformResult = platfrom.saveApproveWithArray(privateKey: privateKey, assetAddress: contractAddress, contractAddress: platformAddress, owner: owner, tokenArr: tokenIds, value:price, endTime: endTime, gasLimit: gasLimit, gasPrice: gasPrice)
            switch platformResult
            {
            case .success(let value):
                let platfromHash = value["hash"] as!String
                return ContractResult.success(value: ["assetHash":assetHash,"platfromHash":platfromHash,"priceStr":price])
            case .failure(let error):
                print("secend error")
                return ContractResult.failure(error: error)
            }
        case .failure(let error):
            print("fist error")
            return ContractResult.failure(error: error)
            
        }
        
    }
    
    private func onSalesInFor(contractAddress:String,platformAddress:String,privateKey:String,gasLimit:String,gasPrice:String,owner:String,tokenIds:Array<Any>,price:String,endTime:String,getGasFees : Bool,canNext : Bool = false) -> ContractResult {
        let asset = AssetManagement(url: urlStr)
        //
        let assetresult = asset.approveWithArray(privateKey: privateKey, contractAddress: contractAddress, approved: platformAddress, tokenArr: tokenIds, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee:  getGasFees)
        switch assetresult {
            
        case .success(let value):
            let assetHash = "\(value["gas"]!)"
            let ethServers = EthService(url: urlStr)
            let address = ethServers.exportAddressFromPrivateKey(privateKey: privateKey)
            let banlance = ethServers.balances(address: address)
            let gasValue = NSDecimalNumber(string : assetHash.getWeb3ValueInWei()).adding(NSDecimalNumber(string: assetHash.getWeb3ValueInWei()))
            print("assetHash  \(assetHash)")
            var userLimt = NSDecimalNumber(string: assetHash).multiplying(by: 3)
            if userLimt.doubleValue > NSDecimalNumber(string: "7000000").doubleValue{
                userLimt = NSDecimalNumber(string: "7000000")
            }
            if canNext{
                if gasValue.doubleValue < NSDecimalNumber(string: banlance).doubleValue{
                    return onSales(contractAddress: contractAddress, platformAddress: platformAddress, privateKey: privateKey, gasLimit: userLimt.stringValue, gasPrice: gasPrice, owner: owner, tokenIds: tokenIds, price: price,endTime:endTime)
                }else{
                    return ContractResult.failure(error: DMASDKError.BALANCE_UNDERFINANCED.getCodeAndMsg())
                }
            }
            return ContractResult.success(value: ["assetGasFee":assetHash,"priceStr":price])
        case .failure(let error):
            print("fist error")
            return ContractResult.failure(error: error)
            
        }
    }
    
    
    /// 下架
    ///
    /// - Parameters:
    ///   - privateKey: 资产拥有者的私钥
    ///   - assetAddress: 资产地址
    ///   - platAddress: 托管合约地址
    ///   - tokenArr: 资产id 数组
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: 交易 hash
    public func offSales(privateKey:String,assetAddress:String,platAddress:String,tokenArr:Array<Any>,gasLimit:String = "",gasPrice:String = "",getGasFee : Bool = false) -> ContractResult {
        let result = ChargeActivityContract(url : urlStr)
        var gasLimit = gasLimit
        var gasPrice = gasPrice
        var getGasFee = getGasFee
        if !getGasFee{
            let result = result.revokeApprovesWithArray(privateKey: privateKey, assetAddress: assetAddress, contractAddress: platAddress, tokenArr: tokenArr, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : true)
            let isError = limIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice, getGasFee: &getGasFee, result: result)
            if let result = isError{
                return result
            }
        }else{
            limAndPriceIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice)
        }
        
        
        return result.revokeApprovesWithArray(privateKey: privateKey, assetAddress: assetAddress, contractAddress: platAddress, tokenArr: tokenArr, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
    }
    
    
    
    /// 购买多个资产
    ///
    /// - Parameters:
    ///   - platAddress: 托管合约地址
    ///   - privateKey: 购买者的私钥
    ///   - gasPrice: gasPrice description
    ///   - gasLimit: gasLimit description
    ///   - tokenIds: 资产 id 数组
    ///   - sumPrice: 总金额
    ///   - owner: 资产拥有者的地址
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: 交易hash
    public  func createOrder(platAddress:String,assetAddress : String,privateKey:String,gasPrice:String = "",gasLimit:String = "",tokenIds : Array<Any>,sumPrice:String,owner:String,getGasFee : Bool = false) -> ContractResult {
        let platform = ChargeActivityContract(url: urlStr)
        
        var gasLimit = gasLimit
        var gasPrice = gasPrice
        var getGasFee = getGasFee
        
        if !getGasFee{
            let result = platform.transferWithArray(privateKey: privateKey, assetAddress: assetAddress, contractAddress: platAddress, owner: owner, tokenArr: tokenIds, weiValue: sumPrice, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : true)
            let isError = limIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice, getGasFee: &getGasFee, result: result)
            if let result = isError{
                return result
            }
        }else{
            limAndPriceIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice)
        }
        
        let paltformResult = platform.transferWithArray(privateKey: privateKey, assetAddress: assetAddress, contractAddress: platAddress, owner: owner, tokenArr: tokenIds, weiValue: sumPrice, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        switch paltformResult{
        case .success(let value):
            if getGasFee {
                let platformHash = "\(value["gas"]!)"
                return ContractResult.success(value: ["platformGasFee":platformHash])
            }
            let platformHash = value["hash"] as!String
            return ContractResult.success(value: ["platformHash":platformHash])
            
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
    }
    
    
    
    /// 结束活动
    ///
    /// - Parameters:
    ///   - privateKey: 资产合约拥有者私钥
    ///   - assetAddress: 资产地址
    ///   - contractAddress: 托管合约地址
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: 交易 hash
    public func endActivity(privateKey : String,assetAddress:String,contractAddress : String,gasLimit : String = "",gasPrice : String = "",getGasFee : Bool = false) -> ContractResult{
        let platform = ChargeActivityContract(url: urlStr)
        var gasLimit = gasLimit
        var gasPrice = gasPrice
        var getGasFee = getGasFee
       
        if !getGasFee{
            let result = platform.endActivity(privateKey: privateKey, assetAddress: assetAddress, contractAddress: contractAddress, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : true)
            let isError = limIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice, getGasFee: &getGasFee, result: result)
            if let result = isError{
                return result
            }
        }else{
            limAndPriceIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice)
        }
        let reulst = platform.endActivity(privateKey: privateKey, assetAddress: assetAddress, contractAddress: contractAddress, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        switch reulst {
        case .success(let dic):
            return ContractResult.success(value: dic)
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
    }
    
    
   
    
    /// 获取资产信息
    ///
    /// - Parameters:
    /// - assetAddress: 资产地址
    ///   - contractAddress: 合约地址
    ///   - tokenId: 资产 ID
    /// - Returns: return value description
    public func getApproveInfo(assetAddress : String,contractAddress : String,tokenId : String) -> ContractResult{
        let platform = ChargeActivityContract(url: urlStr)
        return platform.getApproveinfo(contractAddress: contractAddress, assetAddress: assetAddress, tokenId: tokenId)
    }
    
    /// 获取托管地址下的已上架的资产地址数量
    ///
    /// - Parameter contractAddress: 合约地址
    /// - Returns: return value description
    func getAssetNum(platAddress : String) -> ContractResult{
        let platform =  ChargeActivityContract(url: urlStr)
        return platform.getAssetNum(contractAddress: platAddress)
    }
    
    
    /// 获取托管合约下的已上架的所有资产地址以及资产下的 token 数量
    ///
    /// - Parameter pageSize: 页码
    func getAssetList(pageSize : String,platAddress : String) -> ContractResult{
        let platform =  ChargeActivityContract(url: urlStr)
        return platform.getAssetList(pageSize: pageSize, contractAddress: platAddress)
    }
    
    
    /// 获取托管合约下已上架的资产数量
    ///
    /// - Parameters:
    ///   - assetAddress: 资产地址
    ///   - contractAddress: 托管地址
    /// - Returns: return value description
    func getTokenNum(assetAddress : String,platAddress : String) -> ContractResult{
        let platform =  ChargeActivityContract(url: urlStr)
        return platform.getTokenNum(assetAddress: assetAddress, contractAddress: platAddress)
    }
    
    
    /// 获取托管合约下已上架的资产token
    ///
    /// - Parameters:
    ///   - assetAddress: 资产地址
    ///   - pageSize: 页码
    ///   - contractAddress: 托管合约地址
    func getTokenList(assetAddress : String,pageSize : String,platAddress : String) -> ContractResult{
        let platform = ChargeActivityContract(url: urlStr)
        return platform.getTokenList(assetAddress: assetAddress,pageSize: pageSize, contractAddress: platAddress)
    }
    
    
}
