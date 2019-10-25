//
//  SaleMyTickService.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/10/14.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation

public class SaleMyTickService : NSObject{
    
    var url = ""
    
    public required init(url : String) {
        super.init()
        self.url = url
    }
    
    
    
    /// 上架我发起的票券
    ///
    /// - Parameters:
    ///   - tokenArr: 资产 id 数组
    ///   - platAddress: 托管合约
    ///   - contractAddress: 资产合约地址
    ///   - price: 上架的价格
    ///   - privateKey: 创建资产的人的私钥
    public func onSaleTick(tokenArr : NSMutableArray,platAddress:String,contractAddress : String,price : String,privateKey : String){
        let owner = EthService().exportAddressFromPrivateKey(privateKey: privateKey)
        let tokenNumber : NSMutableArray = []
        let ques = DispatchQueue(label: "uptoken")
        for i in 0..<tokenArr.count{
            tokenNumber.add(tokenArr[i])
            if tokenNumber.count == 10{
                let arr : NSMutableArray = []
                arr.addObjects(from: tokenNumber as! [Any])
                ques.sync {
                    self.upTokenData(platAddress: platAddress, contractAddress : contractAddress,tokenIDArr : arr,price : price,privateKey : privateKey,owner : owner)
                }
                tokenNumber.removeAllObjects()
            }
        }
        upTokenData(platAddress: platAddress, contractAddress : contractAddress,tokenIDArr : tokenNumber,price : price,privateKey : privateKey,owner : owner)
    }
    
    
    /// 上架资产ID
    ///
    /// - Parameters:
    ///   - platAddress: 托管合约地址
    ///   - contractAddress: 资产合约地址
    ///   - tokenIDArr: 资产 ID
    ///   - price: 上架的价格
    ///   - privateKey: 资产拥有者的私钥
    ///   - owner: 上架给哪个地址
    private func upTokenData(platAddress : String,contractAddress : String,tokenIDArr : NSMutableArray,price : String,privateKey : String,owner : String){
        let urlStr = url
        let chargeServer = MerchantService(url: urlStr)
        let result = chargeServer.onSales(contractAddress: contractAddress, platformAddress: platAddress, privateKey: privateKey, owner: owner, tokenIds: tokenIDArr as! Array<Any>, price: price)
        guard case .success(let dic) = result else{
            print("upshop error")
            if case .failure(let error) = result {
                print("erorro is ")
                print(error)
            }
            return
        }
        
        guard let hash = dic["platfromHash"] as? String else{
            return
        }
        print("hash is \(hash)")
        

       
        
    }
    
    
    /// 我发起的资产下架
    ///
    /// - Parameters:
    ///   - tokenArr: 资产 ID 数组
    ///   - platAddress: 托管合约地址
    ///   - contractAddress: 资产合约地址
    ///   - privateKey: 资产拥有者的私钥
    public func offSaleTick(tokenArr : NSMutableArray,platAddress:String,contractAddress : String,privateKey : String){
        let tokenNumber : NSMutableArray = []
        var hashArr : NSMutableArray = []
        let ques = DispatchQueue(label: "offSaleToken")
        for i in 0..<tokenArr.count{
            tokenNumber.add(tokenArr[i])
            if tokenNumber.count == 10{
                let arr : NSMutableArray = []
                arr.addObjects(from: tokenNumber as! [Any])
                ques.sync {
                    self.downTokenData(platAddress: platAddress, contractAddress : contractAddress,tokenIDArr : arr,privateKey : privateKey)
                }
                tokenNumber.removeAllObjects()
            }
        }
        downTokenData(platAddress: platAddress, contractAddress : contractAddress,tokenIDArr : tokenNumber,privateKey : privateKey)
        
    }
    
    
    /// 资产 ID 下架
    ///
    /// - Parameters:
    ///   - platAddress: 托管地址
    ///   - contractAddress: 资产合约地址
    ///   - tokenIDArr: 资产 ID 数组
    ///   - privateKey: 资产拥有者的私钥
    private func downTokenData(platAddress : String,contractAddress : String,tokenIDArr : NSMutableArray,privateKey : String){
        let urlStr = url
        let merchantService = MerchantService(url : urlStr)
        let result = merchantService.offSales(privateKey: privateKey, platAddress: platAddress, assetAddress : contractAddress, tokenArr: tokenIDArr as! Array<Any>)
        guard case .success(let dic) = result else{
            print("upshop error")
            if case .failure(let error) = result {
                print("erorro is ")
                print(error)
            }
            return
        }
        
        guard let hash = dic["hash"] as? String else{
            return
        }
        print("hash is \(hash)")
        
        }
}
