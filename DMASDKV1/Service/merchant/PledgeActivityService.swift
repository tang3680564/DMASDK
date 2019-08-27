//
//  PledgeActivityService.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/7/15.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation
import Alamofire
import BigInt
import web3swift

public class PledgeActivityService : NSObject{
    
    var urlStr = EthService().url
   
   
    
    public required init(url : String) {
        super.init()
        urlStr = url
    }
    
    public required override init() {
        super.init()
    }
    
    ///发布合约
    public func deploy(privateKey:String,gasPrice:String,gasLimit:String,name:String,symbol:String,metadata:String,endtime : String) -> ContractResult {
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
                    let platformResult =  platform.setupDeploy(privateKey: privateKey, token721: assetAddress, endtime: endtime, gasLimit: gasLimit, gasPrice: gasPrice)
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
    
    ///
    public func mintWithArray(privateKey:String,assetAddress:String,to:String,array:Array<Any>,metaData:String,isTransfer:Bool,isBurn:Bool,gasLimit:String,gasPrice:String) -> ContractResult {
        let asset = AssetManagement(url: urlStr)
        let result = asset.mintWithArray(privateKey: privateKey, contractAddress: assetAddress, to: to, array: array, uri: metaData, isTransfer: isTransfer, isBurn: isBurn, gasLimit: gasLimit, gasPrice: gasPrice)
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
    public func onSales(contractAddress:String,platformAddress:String,privateKey:String,gasLimit:String,gasPrice:String,owner:String,tokenIds:Array<Any>,price:String) -> ContractResult {
        print(contractAddress)
        print(platformAddress)
        print(owner)
        print(tokenIds)
        print(price)
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
    
    
    
    
    ///下架
    public func offSales(privateKey:String,platAddress:String,tokenArr:Array<Any>,gasLimit:String,gasPrice:String) -> ContractResult {
        let result = PledgeActivityContract(url : urlStr)
        return result.revokeApprovesWithArray(privateKey: privateKey, contractAddress: platAddress, tokenArr: tokenArr, gasLimit: gasLimit, gasPrice: gasPrice)
    }
    
    
    ///创建订单
    public  func createOrder(platAddress:String,privateKey:String,gasPrice:String,gasLimit:String,tokenId:String,sumPrice:String,owner:String) -> ContractResult {
        let platform = PledgeActivityContract(url: urlStr)
        let platformResult = platform.transfer(privateKey: privateKey, contractAddress: platAddress, tokenId: tokenId, weiValue: sumPrice, gasLimit: gasLimit, gasPrice: gasPrice)
        switch platformResult{
            
        case .success(let value):
            let platformHash = value["hash"] as!String
            return ContractResult.success(value: ["platformHash":platformHash])
            
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
    }
    
    
    ///结束活动
    public func endActivity(privateKey : String,contractAddress : String,gasLimit : String,gasPrice : String) -> ContractResult{
        let platform = PledgeActivityContract(url: urlStr)
        let reulst = platform.endActivity(privateKey: privateKey, contractAddress: contractAddress, gasLimit: gasLimit, gasPrice: gasPrice)
        switch reulst {
        case .success(let dic):
            return ContractResult.success(value: dic)
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
    }
    
    ///获取资产信息
    public func getApproveInfo(contractAddress : String,tokenId : String) -> ContractResult{
        let platform = PledgeActivityContract(url: urlStr)
        return platform.getApproveinfo(contractAddress: contractAddress, tokenId: tokenId)
    }
    
    
    /// 退款
    public func refund(privateKey : String,contractAddress : String,tokenId : String,gasLimit : String,gasPrice : String) -> ContractResult{
        let platform = PledgeActivityContract(url: urlStr)
        return platform.refund(privateKey: privateKey, contractAddress: contractAddress, tokenId: tokenId, gasLimit: gasLimit, gasPrice: gasPrice)
    }
    
    /// 验证资产
    public func verify(privateKey : String,contractAddress : String,tokenId : String,owner : String,gasLimit : String, gasPrice : String ) -> ContractResult{
        let platform = PledgeActivityContract(url: urlStr)
        return platform.verify(privateKey: privateKey, contractAddress: contractAddress, tokenId: tokenId, owner: owner, gasLimit: gasLimit, gasPrice: gasPrice)
    }
    
}
