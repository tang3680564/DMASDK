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
    public func deploy(privateKey:String,gasPrice:String,gasLimit:String,name:String,symbol:String,metadata:String,endtime : String) -> ContractResult {
        let eth = EthService(url: urlStr)
        eth.url = urlStr
        let address = eth.exportAddressFromPrivateKey(privateKey: privateKey)
        let balance = eth.balance(address: address)
        switch balance {
        case .success(let resp):
            let b = resp["balance"] as!String
            if Double(b)! > 0{
                let asset = AssetManagement(url: urlStr)
                print(b)
                let assetResult = asset.setupDeploy(privateKey: privateKey, name: name, symbol: symbol, metadata: metadata, isburn: true, gasLimit: gasLimit, gasPrice: gasPrice)
                switch assetResult{
                    
                case .success(let value):
                    let assetAddress = value["address"] as!String
                    let platform = ChargeActivityContract(url: urlStr)
                    let platformResult = platform.setupDeploy(privateKey: privateKey, token721: assetAddress, endtime: endtime,gasLimit: gasLimit, gasPrice: gasPrice)
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
    public func mintWithArray(privateKey:String,assetAddress:String,to:String,array:Array<Any>,metaData:String,isTransfer:Bool,isBurn:Bool,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let asset = AssetManagement(url: urlStr)
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
    /// - Returns:
    public func onSales(contractAddress:String,platformAddress:String,privateKey:String,gasLimit:String,gasPrice:String,owner:String,tokenIds:Array<Any>,price:String,getGasFee : Bool = false) -> ContractResult {
        if getGasFee{
            return onSales(contractAddress: contractAddress, platformAddress: platformAddress, privateKey: privateKey, gasLimit: gasLimit, gasPrice: gasPrice, owner: owner, tokenIds: tokenIds, price: price, getGasFees: true)
        }
        let asset = AssetManagement(url: urlStr)
        //
        let assetresult = asset.approveWithArray(privateKey: privateKey, contractAddress: contractAddress, approved: platformAddress, tokenArr: tokenIds, gasLimit: gasLimit, gasPrice: gasPrice)
        switch assetresult {
            
        case .success(let value):
            let assetHash = value["hash"] as!String
            let platfrom = ChargeActivityContract(url: urlStr)
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
    
    func onSales(contractAddress:String,platformAddress:String,privateKey:String,gasLimit:String,gasPrice:String,owner:String,tokenIds:Array<Any>,price:String,getGasFees : Bool) -> ContractResult {
        let asset = AssetManagement(url: urlStr)
        //
        let assetresult = asset.approveWithArray(privateKey: privateKey, contractAddress: contractAddress, approved: platformAddress, tokenArr: tokenIds, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee:  getGasFees)
        switch assetresult {
            
        case .success(let value):
            let assetHash = value["gas"] as? String
            let platfrom = ChargeActivityContract(url: urlStr)
            let platformResult = platfrom.saveApproveWithArray(privateKey: privateKey, contractAddress: platformAddress, owner: owner, tokenArr: tokenIds, value:price, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee: getGasFees)
            switch platformResult
            {
            case .success(let value):
                let platfromHash = value["gas"] as? String
                return ContractResult.success(value: ["assetGasFee":assetHash,"platfromGasFee":platfromHash,"priceStr":price])
            case .failure(let error):
                print("secend error")
                return ContractResult.failure(error: error)
            }
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
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: 交易 hash
    public func offSales(privateKey:String,platAddress:String,tokenArr:Array<Any>,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let result = ChargeActivityContract(url : urlStr)
        return result.revokeApprovesWithArray(privateKey: privateKey, contractAddress: platAddress, tokenArr: tokenArr, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
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
    public  func createOrder(platAddress:String,privateKey:String,gasPrice:String,gasLimit:String,tokenIds : Array<Any>,sumPrice:String,owner:String,getGasFee : Bool = false) -> ContractResult {
        let platform = ChargeActivityContract(url: urlStr)
        let paltformResult = platform.transferWithArray(privateKey: privateKey, contractAddress: platAddress, owner: owner, tokenArr: tokenIds, weiValue: sumPrice, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        switch paltformResult{
        case .success(let value):
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
    ///   - contractAddress: 资产合约地址
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: 交易 hash
    public func endActivity(privateKey : String,contractAddress : String,gasLimit : String,gasPrice : String,getGasFee : Bool = false) -> ContractResult{
        let platform = ChargeActivityContract(url: urlStr)
        let reulst = platform.endActivity(privateKey: privateKey, contractAddress: contractAddress, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
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
    ///   - contractAddress: 合约地址
    ///   - tokenId: 资产 ID
    /// - Returns: return value description
    public func getApproveInfo(contractAddress : String,tokenId : String) -> ContractResult{
        let platform = ChargeActivityContract(url: urlStr)
        return platform.getApproveinfo(contractAddress: contractAddress, tokenId: tokenId)
    }
    
}
