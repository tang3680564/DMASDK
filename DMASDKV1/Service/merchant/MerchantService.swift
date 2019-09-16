//
//  MerchantService.swift
//  DMASDK
//
//  Created by Zhangxz& on 2019/3/26.
//  Copyright © 2019 Zhangxz&. All rights reserved.
//

import Foundation
import Alamofire
import BigInt
import web3swift

public enum AsssetLevel:Int{
    case shop = 1
    case market
}
public enum ShelfType:Int{
    case on_sale = 1
    case off_sale
}
public enum ShelfStatus:Int{
    case pending = 0
    case success
    case failed
    
}


public typealias MerchantServiceFinal = (String) -> ()

open class MerchantService: NSObject {
    public var url = EthService().url
   
    
    required public init(url : String) {
        super.init()
        self.url = url
    }
    
    required public override init() {
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
    /// - Returns: return value description
    public func deploy(privateKey:String,gasPrice:String,gasLimit:String,name:String,symbol:String,metadata:String) -> ContractResult {
        let eth = EthService()
        eth.url = url
        let address = eth.exportAddressFromPrivateKey(privateKey: privateKey)
        let balance = eth.balance(address: address)
        switch balance {
        case .success(let resp):
            print("aaaa")
            print(resp)
            let b = resp["balance"] as!String
            if Double(b)! > 0{
                let asset = AssetManagement(url: url)
                
                let assetResult = asset.setupDeploy(privateKey: privateKey, name: name, symbol: symbol, metadata: metadata, isburn: true, gasLimit: gasLimit, gasPrice: gasPrice)
                switch assetResult{
                    
                case .success(let value):
                    print("ccccc")
                    print(value)
                    
                    let assetAddress = value["address"] as!String
                    let platform = PlatformContract(url: url)
                    let platformResult = platform.setupDeploy(privateKey: privateKey, token721: assetAddress, platformAddress: platformWallet,firstExpense: firstExpenses,secondExpense: secondExpenses ,gasLimit: gasLimit, gasPrice: gasPrice)
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
                return ContractResult.failure(error: "余额不足")
            }
        case.failure(let error):
            return ContractResult.failure(error: error)
        }
    }
    
    
    /// 批量创建资产
    ///
    /// - Parameters:
    ///   - privateKey: 私钥
    ///   - assetAddress: 资产合约地址
    ///   - to: 资产归属地址
    ///   - array: 资产 id 数组
    ///   - metaData: 资产描述
    ///   - isTransfer: 是否可以转送
    ///   - isBurn: 是否可以销毁
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    /// - Returns: return value description
    public func mintWithArray(privateKey:String,assetAddress:String,to:String,array:Array<Any>,metaData:String,isTransfer:Bool,isBurn:Bool,gasLimit:String = "" ,gasPrice:String = "",getGasFee : Bool = false) -> ContractResult {
        let asset = AssetManagement(url: url)
        
        var gasLimit = gasLimit
        var gasPrice = gasPrice
        var getGasFee = getGasFee
        if !getGasFee{
            let result = asset.mintWithArray(privateKey: privateKey, contractAddress: assetAddress, to: to, array: array, uri: metaData, isTransfer: isTransfer, isBurn: isBurn, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee: true)
            let isError = limIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice, getGasFee: &getGasFee, result: result)
            if let result = isError{
                return result
            }
        }else{
            limAndPriceIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice)
        }
        
        let result = asset.mintWithArray(privateKey: privateKey, contractAddress: assetAddress, to: to, array: array, uri: metaData, isTransfer: isTransfer, isBurn: isBurn, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee: getGasFee)
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
            return onSales(contractAddress: contractAddress, platformAddress: platformAddress, privateKey: privateKey, gasLimit: gasLimit, gasPrice: gasPrice, owner: owner, tokenIds: tokenIds, price: price, getGasFees: getGasFee, canNext: canNext)
        }
        limAndPriceIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice)
        let asset = AssetManagement(url: url)
        //
        let assetresult = asset.approveWithArray(privateKey: privateKey, contractAddress: contractAddress, approved: platformAddress, tokenArr: tokenIds, gasLimit: gasLimit, gasPrice: gasPrice)
        switch assetresult {
            
        case .success(let value):
            let assetHash = value["hash"] as!String
            let platfrom =  PlatformContract(url: url)
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
        let asset = AssetManagement(url: url)
        //
        let assetresult = asset.approveWithArray(privateKey: privateKey, contractAddress: contractAddress, approved: platformAddress, tokenArr: tokenIds, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee: getGasFees)
        switch assetresult {
            
        case .success(let value):
            let assetHash = "\(value["gas"]!)"
            let ethServers = EthService(url: url)
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
    ///   - tokenArr: 资产id 数组
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    /// - Returns: return value description
    public func offSales(privateKey:String,platAddress:String,tokenArr:Array<Any>,gasLimit:String = "",gasPrice:String = "",getGasFee : Bool = false) -> ContractResult {
        let result =  PlatformContract(url: url)
        
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
    ///   - privateKey: 购买者私钥
    ///   - gasPrice: gasPrice description
    ///   - gasLimit: gasLimit description
    ///   - tokenIds: 资产 id 数组
    ///   - sumPrice: 总金额
    ///   - owner: 资产拥有者地址
    /// - Returns: return value description
    public  func createOrder(platAddress:String,privateKey:String,gasPrice:String = "",gasLimit:String = "",tokenIds:Array<Any>,sumPrice:String,owner:String,getGasFee : Bool = false) -> ContractResult {
        let platform = PlatformContract(url: url)
        
        var gasLimit = gasLimit
        var gasPrice = gasPrice
        var getGasFee = getGasFee
        if !getGasFee{
            let result = platform.transferWithArray(privateKey: privateKey, contractAddress: platAddress, owner: owner, tokenArr: tokenIds, totalValue: sumPrice,gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : true)
            let isError = limIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice, getGasFee: &getGasFee, result: result)
            if let result = isError{
                return result
            }
        }else{
            limAndPriceIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice)
        }
        
        
        let platformResult = platform.transferWithArray(privateKey: privateKey, contractAddress: platAddress, owner: owner, tokenArr: tokenIds, totalValue: sumPrice,gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        switch platformResult{
        case .success(let value):
            if getGasFee {
                let gas = "\(value["gas"]!)"
                return ContractResult.success(value: ["platformGasFee":gas])
            }
            let platformHash = value["hash"] as!String
            return ContractResult.success(value: ["platformHash":platformHash])
            
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
        
    }

    public  func getApproveInfo(contractAddress:String,tokenId:String) -> ContractResult {
        let platform =  PlatformContract(url: url)
        return platform.getApproveinfo(contractAddress: contractAddress, tokenId: tokenId)
    }
    public  func ownerOf(contractAddress:String,tokenId:String) -> ContractResult {
        let asset = AssetManagementService(url : url)
        let result = asset.getTokenOwner(contractAddress: contractAddress, tokenId: tokenId)
        return result
    }
    public  func tokenIds(contractAddress:String,owner:String) -> ContractResult {
        let asset = AssetManagement(url: url)
        let result = asset.tokenIds(contractAddress: contractAddress, owner: owner)
        return result
    }
    
}
