//
//  PledgeActivityService.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/7/15.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation
import BigInt
import web3swift
import DMASDKV1

public class PledgeActivityService : NSObject{
    
    var urlStr = EthService().url
   
   
    
    /// 初始化
    ///
    /// - Parameter url: eth 节点地址
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
    /// - Returns: return value description
    public func deploy(privateKey:String,gasPrice:String,gasLimit:String,name:String,symbol:String,metadata:String,endtime : String,token20 : String) -> ContractResult {
        let eth = EthService()
        eth.url = urlStr
        let address = eth.exportAddressFromPrivateKey(privateKey: privateKey)
        let balance = eth.balance(address: address)
        switch balance {
        case .success(let resp):
            let b = resp["balance"] as!String
            if Double(b)! > 0{
                let asset = AssetManagement(url: urlStr)
                
                let assetResult = asset.setupDeploy(privateKey: privateKey, name: name, symbol: symbol, metadata: metadata, isburn: true, gasLimit: gasLimit, gasPrice: gasPrice)
                switch assetResult{
                    
                case .success(let value):
                    let assetAddress = value["address"] as!String
                    let platform = PledgeActivityContract(url: urlStr)
                    let platformResult =  platform.setupDeploy(privateKey: privateKey, token721: assetAddress, token20: token20, endtime: endtime, gasLimit: gasLimit, gasPrice: gasPrice)
                    switch platformResult{
                    case .success(let value):
                        let platformAddress = value["address"] as!String
                        return ContractResult.success(value: ["platformAddress":platformAddress,"assetAddress":assetAddress])
                    case .failure(let error):
                        return ContractResult.failure(error: error)
                    }
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
    ///   - to: 资产归属地址
    ///   - array: 资产id 数组
    ///   - metaData: 资产描述
    ///   - isTransfer: 是否可以转送
    ///   - isBurn: 是否可以销毁
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: 交易 hash
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
    ///   - contractAddress: 票券地址
    ///   - platformAddress: 平台合约地址
    ///   - privateKey: ETH私钥
    ///   - gasLimit: defaultGasLimit
    ///   - gasPrice: defaultGasPrice
    ///   - owner: ETH地址
    ///   - tokenIds: 资产 ID
    ///   - price:  上架价格
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    ///   - canNext : true : 足够支付 gas 费的时候 ,进行此次操作, false: 足够支付 gas 费的时候,不进行此次操作
    /// - Returns:
    public func onSales(contractAddress:String,platformAddress:String,privateKey:String,gasLimit:String = "",gasPrice:String = "",owner:String,tokenIds:Array<Any>,price:String,getGasFee : Bool = false,canNext : Bool = false) -> ContractResult {
        var canNext = canNext
        var gasLimit = gasLimit
        var gasPrice = gasPrice
        if getGasFee{
            if gasLimit.isEmpty{
                canNext = true
                limAndPriceIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice)
            }
            return onSales(contractAddress: contractAddress, platformAddress: platformAddress, privateKey: privateKey, gasLimit: gasLimit, gasPrice: gasPrice, owner: owner, tokenIds: tokenIds, price: price, getGasFees: true,canNext: canNext)
        }
        limAndPriceIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice)
        let asset = AssetManagement(url: urlStr)
        //
        let assetresult = asset.approveWithArray(privateKey: privateKey, contractAddress: contractAddress, approved: platformAddress, tokenArr: tokenIds, gasLimit: gasLimit, gasPrice: gasPrice)
        switch assetresult {
            
        case .success(let value):
            let assetHash = value["hash"] as!String
            let platfrom = PledgeActivityContract(url: urlStr)
            let platformResult = platfrom.saveApproveWithArray(privateKey: privateKey, contractAddress: platformAddress, owner: owner, tokenArr: tokenIds, value:price, gasLimit: gasLimit, gasPrice: gasPrice)
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
    
    
    private func onSales(contractAddress:String,platformAddress:String,privateKey:String,gasLimit:String,gasPrice:String,owner:String,tokenIds:Array<Any>,price:String,getGasFees : Bool,canNext : Bool = false) -> ContractResult {
        print(contractAddress)
        print(platformAddress)
        print(owner)
        print(tokenIds)
        print(price)
        let asset = AssetManagement(url: urlStr)
        //
        let assetresult = asset.approveWithArray(privateKey: privateKey, contractAddress: contractAddress, approved: platformAddress, tokenArr: tokenIds, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee: getGasFees)
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
                    return onSales(contractAddress: contractAddress, platformAddress: platformAddress, privateKey: privateKey, gasLimit: userLimt.stringValue, gasPrice: gasPrice, owner: owner, tokenIds: tokenIds, price: price)
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
    ///   - platAddress: 托管合约地址
    ///   - tokenArr: 资产 id 数组
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: 交易 hash
    public func offSales(privateKey:String,platAddress:String,tokenArr:Array<Any>,gasLimit:String = "",gasPrice:String = "",getGasFee : Bool = false) -> ContractResult {
        let result = PledgeActivityContract(url : urlStr)
        
        var gasLimit = gasLimit
        var gasPrice = gasPrice
        var getGasFee = getGasFee
        if !getGasFee{
            let result = result.revokeApprovesWithArray(privateKey: privateKey, contractAddress: platAddress, tokenArr: tokenArr, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : true)
            let isError = limIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice, getGasFee: &getGasFee, result: result)
            if let result = isError{
                return result
            }
        }else{
            limAndPriceIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice)
        }
        
        return result.revokeApprovesWithArray(privateKey: privateKey, contractAddress: platAddress, tokenArr: tokenArr, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
    }
    
    
    
    /// 购买
    ///
    /// - Parameters:
    ///   - platAddress: 托管合约地址
    ///   - privateKey: 购买者的私钥
    ///   - gasPrice: gasPrice description
    ///   - gasLimit: gasLimit description
    ///   - tokenId: 购买的资产 id
    ///   - sumPrice: 总金额
    ///   - owner: 资产拥有者的地址
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: return value description
    public  func createOrder(platAddress:String,token20Address : String,privateKey:String,gasPrice:String = "",gasLimit:String = "",tokenId:String,sumPrice:String,owner:String,getGasFee : Bool = false) -> ContractResult {
        let platform = PledgeActivityContract(url: urlStr)
        
        var gasLimit = gasLimit
        var gasPrice = gasPrice
        var getGasFee = getGasFee
        if !getGasFee{
            let result = platform.transfer(privateKey: privateKey, contractAddress: platAddress, tokenId: tokenId, value: sumPrice, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : true)
            let isError = limIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice, getGasFee: &getGasFee, result: result)
            if let result = isError{
                return result
            }
        }else{
            limAndPriceIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice)
        }
        
        
        let tokencontact = TokenContract(url: urlStr)
        let tokencontactResult = tokencontact.approve(privateKey: privateKey, contractAddress: token20Address, spender: platAddress, value: sumPrice, gasLimit: gasLimit, gasPrice: gasPrice)
        switch tokencontactResult {
        case .success(let value):
            let tokenHash = value["hash"] as!String
            let platform = PledgeActivityContract(url: urlStr)
            let platformResult = platform.transfer(privateKey: privateKey, contractAddress: platAddress, tokenId: tokenId, value: sumPrice, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
            switch platformResult{
                
            case .success(let value):
                if getGasFee {
                    let platformHash = "\(value["gas"]!)"
                    return ContractResult.success(value: ["platformGasFee":platformHash])
                }
                let platformHash = value["hash"] as!String
                return ContractResult.success(value: ["tokenHash":tokenHash,"platformHash":platformHash])
                
            case .failure(let error):
                return ContractResult.failure(error: error)
            }
            
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
    }
    
    
    
    /// 结束活动
    ///
    /// - Parameters:
    ///   - privateKey: 合约拥有者的私钥
    ///   - contractAddress: 合约地址
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: 交易 hash
    public func endActivity(privateKey : String,contractAddress : String,gasLimit : String = "",gasPrice : String = "",getGasFee : Bool = false) -> ContractResult{
        let platform = PledgeActivityContract(url: urlStr)
        
        var gasLimit = gasLimit
        var gasPrice = gasPrice
        var getGasFee = getGasFee
        if !getGasFee{
            let result = platform.endActivity(privateKey: privateKey, contractAddress: contractAddress, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : true)
            let isError = limIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice, getGasFee: &getGasFee, result: result)
            if let result = isError{
                return result
            }
        }else{
            limAndPriceIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice)
        }
        
        
        let reulst = platform.endActivity(privateKey: privateKey, contractAddress: contractAddress, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        switch reulst {
        case .success(let dic):
            return ContractResult.success(value: dic)
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
    }
    
    
    /// 获取资产授权信息
    ///
    /// - Parameters:
    ///   - contractAddress: 合约地址
    ///   - tokenId: 资产 id
    /// - Returns: return value description
    public func getApproveInfo(contractAddress : String,tokenId : String) -> ContractResult{
        let platform = PledgeActivityContract(url: urlStr)
        return platform.getApproveinfo(contractAddress: contractAddress, tokenId: tokenId)
    }
    
    
    
    /// 退款
    ///
    /// - Parameters:
    ///   - privateKey: 合约创建者的私钥
    ///   - contractAddress: 合约地址
    ///   - tokenId: 资产 ID
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: hash
    public func refund(privateKey : String,contractAddress : String,tokenId : String,gasLimit : String = "",gasPrice : String = "",getGasFee : Bool = false) -> ContractResult{
        let platform = PledgeActivityContract(url: urlStr)
        var gasLimit = gasLimit
        var gasPrice = gasPrice
        var getGasFee = getGasFee
        if !getGasFee{
            let result = platform.refund(privateKey: privateKey, contractAddress: contractAddress, tokenId: tokenId, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : true)
            let isError = limIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice, getGasFee: &getGasFee, result: result)
            if let result = isError{
                return result
            }
        }else{
            limAndPriceIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice)
        }
        
        return platform.refund(privateKey: privateKey, contractAddress: contractAddress, tokenId: tokenId, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
    }
    
    
    public func verify(privateKey : String,contractAddress : String,tokenId : String,owner : String,gasLimit : String = "", gasPrice : String = "",getGasFee : Bool = false ) -> ContractResult{
        let platform = PledgeActivityContract(url: urlStr)
        var gasLimit = gasLimit
        var gasPrice = gasPrice
        var getGasFee = getGasFee
        if !getGasFee{
            let result = platform.verify(privateKey: privateKey, contractAddress: contractAddress, tokenId: tokenId, owner: owner, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : true)
            let isError = limIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice, getGasFee: &getGasFee, result: result)
            if let result = isError{
                return result
            }
        }else{
            limAndPriceIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice)
        }
        return platform.verify(privateKey: privateKey, contractAddress: contractAddress, tokenId: tokenId, owner: owner, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
    }
    
}
