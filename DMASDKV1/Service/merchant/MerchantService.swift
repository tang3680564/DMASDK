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
    public func deployStorage(privateKey:String,gasPrice:String,gasLimit:String,chainType:String,name:String,symbol:String,metadata:String,token20:String,success:@escaping MerchantServiceFinal,Failed:@escaping MerchantServiceFinal) -> Void {
        let deployResult = self.deploy(privateKey: privateKey, gasPrice: gasPrice, gasLimit: gasLimit, name: name, symbol: symbol, metadata: metadata)
        switch deployResult {
        case .success(let value):
            let assetAddress = value["assetAddress"]
            let platformAddress = value["platformAddress"]
            let eth = EthWallet()
            
            let param = ["gasPrice":BigUInt(gasPrice)!,
                         "gasLimit":BigUInt(gasLimit)!,
                         "owner":eth.exportAddressFromPrivateKey(privateKey: privateKey)!,
                         "name":name,
                         "address":assetAddress!,
                         "platformAddress":platformAddress!,
                         "symbol":symbol,
                         "metaData":metadata,
                         "canBurn":true,
                         "chainType":chainType,
                         "nodeUrl":assetManagementUrl!]
            
            Alamofire.request(URL(string: merchainDeploy)!, method: .post, parameters: param , encoding: URLEncoding.default).responseString { (resp) in
                if resp.result.isSuccess
                {
                    success(resp.result.value!)
                }
            }
        case .failure(let error):
            Failed("失败")
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
    public func mintWithArray(privateKey:String,assetAddress:String,to:String,array:Array<Any>,metaData:String,isTransfer:Bool,isBurn:Bool,gasLimit:String,gasPrice:String) -> ContractResult {
        let asset = AssetManagement(url: url)
        let result = asset.mintWithArray(privateKey: privateKey, contractAddress: assetAddress, to: to, array: array, uri: metaData, isTransfer: isTransfer, isBurn: isBurn, gasLimit: gasLimit, gasPrice: gasPrice)
        return result
    }
    public func mintWithArrayStorage(privateKey:String,assetAddress:String,platformAddress:String,chainType:String,to:String,tokenIds:Array<String>,metaData:String,isTransfer:Bool,isBurn:Bool,notifyUrl:String,gasLimit:String,gasPrice:String,success:@escaping MerchantServiceFinal,Failed:@escaping MerchantServiceFinal) -> Void {
        let mintResult = self.mintWithArray(privateKey: privateKey, assetAddress: assetAddress, to: to, array: tokenIds, metaData: metaData, isTransfer: isTransfer, isBurn: isBurn, gasLimit: gasLimit, gasPrice: gasPrice)
        var targetString:String? = ""
        for i in tokenIds{
            targetString?.append(String(i)+",")
        }
        
        switch mintResult {
        case .success(let value):
            let param = ["owner":to,
                         "contractAddress":assetAddress,
                         "platformAddress":platformAddress,
                         "assetLevel":1,
                         "metaData":metaData,
                         "canTrans":isTransfer,
                         "canBurn":isBurn,
                         "mintTxId":value["hash"]!,
                         "nodeUrl":assetManagementUrl!,
                         "chainType":chainType,
                         "notifyUrl":notifyUrl,
                         "tokenIds":targetString!
            ]
            
            Alamofire.request(URL(string: merchainMint)!, method: .post, parameters: param , encoding: URLEncoding.default).responseString { (resp) in
                if resp.result.isSuccess
                {
                    success(resp.result.value!)
                }
            }
            break
        case .failure( _):
            Failed("失败")
            break
        }
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
    
    
    
    /// 上架
    ///
    /// - Parameters:
    ///   - privateKey: 资产拥有者的私钥
    ///   - platformAddress: 托管合约地址
    ///   - owner: 授权给哪个地址
    ///   - tokenIds: 资产 id
    ///   - price: 上架的金额
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    /// - Returns: return value description
    func saveApproveWithArray(privateKey : String,platformAddress : String,owner : String,tokenIds:Array<Any>,price : String,gasLimit : String,gasPrice : String) -> ContractResult{
        let platfrom = PlatformContract(url: url)
        let platformResult = platfrom.saveApproveWithArray(privateKey: privateKey, contractAddress: platformAddress, owner: owner, tokenArr: tokenIds, value:price, gasLimit: gasLimit, gasPrice: gasPrice)
        switch platformResult
        {
        case .success(let value):
            let platfromHash = value["hash"] as!String
            return ContractResult.success(value: ["platfromHash":platfromHash,"priceStr" : price])
        case .failure(let error):
            print("secend error")
            return ContractResult.failure(error: error)
        }
    }
    
    /// 转卖
    ///
    /// - Parameters:
    ///   - contractAddress: 合约地址
    ///   - platformAddress: 平台合约地址
    ///   - privateKey:  eth 私钥
    ///   - gasLimit: gasLimit description
    ///   - chainType: chainType description
    ///   - notifyUrl: <#notifyUrl description#>
    ///   - gasPrice: gasPrice description
    ///   - owner: 自己的 ETH 地址
    ///   - tokenIds: 票档 ID
    ///   - price:  价格
    ///   - success: success description
    ///   - Failed: Failed description
    public  func onSalesStorage(contractAddress:String,platformAddress:String,privateKey:String,gasLimit:String,chainType:String,notifyUrl:String,gasPrice:String,owner:String,tokenIds:Array<String>,price:String,success:@escaping MerchantServiceFinal,Failed:@escaping MerchantServiceFinal) -> Void {
        let onSaleResult = self.onSales(contractAddress: contractAddress, platformAddress: platformAddress, privateKey: privateKey, gasLimit: gasLimit, gasPrice: gasPrice, owner: owner, tokenIds: tokenIds, price: price)
        switch onSaleResult {
        case .success(let value):
            let assetHash = value["assetHash"]
            let platfromHash = value["platfromHash"]
            var targetString:String? = ""
            for i in tokenIds{
                targetString?.append(i+",")
            }
            let param = ["owner":owner,
                         "contractAddress":contractAddress,
                         "platformAddress":platformAddress,
                         "type":1,
                         "status":0,
                         "price":price,
                         "serialNo":isBurn,
                         "approveTxId":assetHash!,
                         "saveApproveTxId":platfromHash!,
                         "nodeUrl":assetManagementUrl!,
                         "chainType":chainType,
                         "notifyUrl":notifyUrl,
                         "tokenIds":targetString!
            ]
            
            Alamofire.request(URL(string: merchainSale)!, method: .post, parameters: param, encoding: URLEncoding.default).responseString { (resp) in
                if resp.result.isSuccess
                {
                    success(resp.result.value!)
                }
            }
            break
        case .failure(let error):
            Failed("失败")
            break
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
    public func offSales(privateKey:String,platAddress:String,tokenArr:Array<Any>,gasLimit:String,gasPrice:String) -> ContractResult {
        let result =  PlatformContract(url: url)
        return result.revokeApprovesWithArray(privateKey: privateKey, contractAddress: platAddress, tokenArr: tokenArr, gasLimit: gasLimit, gasPrice: gasPrice)
    }
    public  func offSalesStorage(contractAddress:String,privateKey:String,platAddress:String,tokenArr:Array<String>,notifyUrl:String,chainType:String,gasLimit:String,gasPrice:String,success:@escaping MerchantServiceFinal,Failed:@escaping MerchantServiceFinal) -> Void {
        let offsaleResult = self.offSales(privateKey: privateKey, platAddress: platAddress, tokenArr: tokenArr, gasLimit: gasLimit, gasPrice: gasPrice)
        let eth = EthWallet()
        
        switch offsaleResult {
        case .success(let value):
            var targetString:String? = ""
            for i in tokenArr{
                targetString?.append(i+",")
            }
            let param = [
                "contractAddress":contractAddress,
                "platformAddress":platAddress,
                "type":2,
                "status":0,
                "owner":eth.exportAddressFromPrivateKey(privateKey: privateKey)!,
                "revokeTxId":value["hash"]!,
                "nodeUrl":assetManagementUrl!,
                "notifyUrl":notifyUrl,
                "tokenIds":targetString!,
                "chainType":chainType
            ]
            Alamofire.request(URL(string: merchainSale)!, method: .post, parameters: param , encoding: URLEncoding.default).responseString { (resp) in
                if resp.result.isSuccess
                {
                    success(resp.result.value!)
                }            }
            break
        case .failure(let error):
            Failed("失败")
            break
        }
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
    public  func createOrder(platAddress:String,privateKey:String,gasPrice:String,gasLimit:String,tokenIds:Array<Any>,sumPrice:String,owner:String) -> ContractResult {
        let platform = PlatformContract(url: url)
        let platformResult = platform.transferWithArray(privateKey: privateKey, contractAddress: platAddress, owner: owner, tokenArr: tokenIds, totalValue: sumPrice,gasLimit: gasLimit, gasPrice: gasPrice)
        switch platformResult{
        case .success(let value):
            let platformHash = value["hash"] as!String
            return ContractResult.success(value: ["platformHash":platformHash])
            
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
        
    }
    public  func createOrderStorage(contractAddress:String,platAddress:String,privateKey:String,gasPrice:String,gasLimit:String,tokenIds:Array<String>,sumPrice:String,owner:String,chainType:String,notifyUrl:String,remark:String,name:String,orderNo:String,success:@escaping MerchantServiceFinal,Failed:@escaping MerchantServiceFinal) -> Void {
        let createOrderResult = self.createOrder(platAddress: platAddress, privateKey: privateKey, gasPrice: gasPrice, gasLimit: gasLimit, tokenIds: tokenIds, sumPrice: sumPrice, owner: owner)
        switch createOrderResult {
        case .success(let value):
            var targetString:String? = ""
            for i in tokenIds{
                targetString?.append(i+",")
            }
            let eth = EthWallet()
            
            let param = [
                "quantity":tokenIds.count,
                "remark":remark,
                "name":name,
                "orderNo":name,
                "price":sumPrice,
                "contractAddress":contractAddress,
                "platformAddress":platAddress,
                "owner":owner,
                "toOwner":eth.exportAddressFromPrivateKey(privateKey: privateKey)!,
                "transTxId":value["platformHash"]!,
                "approveTxId":value["tokenHash"]!,
                "tokenIds":targetString!,
                "notifyUrl":notifyUrl,
                "nodeUrl":assetManagementUrl!,
                "chainType":chainType
            ]
            
            Alamofire.request(URL(string: merchaincreateorderInfo)!, method: .post, parameters: param, encoding: URLEncoding.default).responseString { (resp) in
                if resp.result.isSuccess
                {
                    success(resp.result.value!)
                }
                
            }
            break
        case .failure(let error):
            Failed("失败")
            break
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
    
    public func orderInfo(orderNo:String,success:@escaping MerchantServiceFinal) -> Void {
        let param = [
            "orderNo":orderNo,
            ]
        
        Alamofire.request(URL(string: merchaingetorderInfo)!, method: .post, parameters: param as Dictionary<String,String>, encoding: URLEncoding.default).responseString { (resp) in
            if resp.result.isSuccess
            {
                success(resp.result.value!)
            }        }
    }
    public func orderInfoDetails(orderNo:String,success:@escaping MerchantServiceFinal) -> Void {
        let param = [
            "orderNo":orderNo,
            ]
        Alamofire.request(URL(string: merchaingetorderInfoDetails)!, method: .post, parameters: param as Dictionary<String,String>, encoding: URLEncoding.default).responseString { (resp) in
            if resp.result.isSuccess
            {
                success(resp.result.value!)
            }        }
    }
    public func orderInfoList(owner:String,toOwner:String,success:@escaping MerchantServiceFinal) -> Void {
        var var_empty_dic:Dictionary<String, String> = [:]
        
        //        var param:Dictionary<String, String>?
        if !owner.isEmpty{
            var_empty_dic = ["owner":owner]
        }
        if !toOwner.isEmpty {
            var_empty_dic = ["toOwner":toOwner]
            
        }
        Alamofire.request(URL(string: merchaingetorderInfoList)!, method: .post, parameters: var_empty_dic , encoding: URLEncoding.default).responseString { (resp) in
            if resp.result.isSuccess
            {
                success(resp.result.value!)
            }        }
    }
    public func myContract(owner:String,success:@escaping MerchantServiceFinal) -> Void {
        let param = [
            "owner":owner,
            ]
        Alamofire.request(URL(string: merchaingetmyContract)!, method: .post, parameters: param as Dictionary<String,String>, encoding: URLEncoding.default).responseString { (resp) in
            if resp.result.isSuccess
            {
                success(resp.result.value!)
            }        }
    }
    public  func shelfRecords(contractAddress:String,owner:String,shelfType:Int,success:@escaping MerchantServiceFinal) -> Void {
        let param = [
            "owner":owner,
            "contractAddress":contractAddress,
            "shelfType":String(shelfType),
            ]
        Alamofire.request(URL(string: merchaingetshelfRecords)!, method: .post, parameters: param , encoding: URLEncoding.default).responseString { (resp) in
            if resp.result.isSuccess
            {
                success(resp.result.value!)
            }        }
    }
    public func shelfRecordsDetails(contractAddress:String,owner:String,shelfType:Int,serialNo:String,success:@escaping MerchantServiceFinal) -> Void {
        let param = [
            "owner":owner,
            "contractAddress":contractAddress,
            "shelfType":shelfType,
            "serialNo":serialNo
            ] as [String : Any]
        Alamofire.request(URL(string: merchaingetshelfRecordsDetails)!, method: .post, parameters: param as! Dictionary<String,String>, encoding: URLEncoding.default).responseString { (resp) in
            if resp.result.isSuccess
            {
                success(resp.result.value!)
            }        }
    }
    public func shelfRecordsPendingDetails(contractAddress:String,owner:String,shelfType:Int,serialNo:String,success:@escaping MerchantServiceFinal) -> Void {
        let param = [
            "owner":owner,
            "contractAddress":contractAddress,
            "shelfType":shelfType,
            "serialNo":serialNo
            ] as [String : Any]
        Alamofire.request(URL(string: merchaingetshelfRecordsPendingDetails)!, method: .post, parameters: param as! Dictionary<String,String>, encoding: URLEncoding.default).responseString { (resp) in
            if resp.result.isSuccess
            {
                success(resp.result.value!)
            }
            
        }
    }
    
}
