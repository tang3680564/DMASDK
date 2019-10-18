//
//  TicketTrustService.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/10/16.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation

public class TicketTrustService : NSObject{
    
    var url = ""
    
    public required init(url : String) {
        super.init()
        self.url = url
    }
    
    /**
     * 创建托管合约
     *
     * @param privateKey
     * @return
     */
    public func createTicketTrustContract(privateKey :String) -> ContractResult{
        let merchantService = MerchantService(url: url)
        return merchantService.deploy(privateKey: privateKey)
    }
    
    /**
     * 将token托管给托管合约（上架）
     *
     * @param privateKey
     * @param tokenids
     * @param price
     * @return
     */
    public func TrustTicketToken(privateKey : String , tokenIds : NSMutableArray , price : String,ticketTrustContractAddress:String,ticketContractAddress : String ){
        let saleTick = SaleMyTickService(url: url)
        saleTick.onSaleTick(tokenArr: tokenIds, platAddress: ticketTrustContractAddress, contractAddress: ticketContractAddress, price: price, privateKey: privateKey)
    }
    
    /**
     * 移除托管（下架）
     *
     * @param privateKey
     * @param tokenids
     * @return
     */
    public func removeTrustTicketToken(privateKey : String , tokenIds : NSMutableArray,ticketTrustContractAddress:String,ticketContractAddress : String){
        let saleTick = SaleMyTickService(url: url)
        saleTick.offSaleTick(tokenArr:tokenIds, platAddress: ticketTrustContractAddress, contractAddress: ticketContractAddress, privateKey: privateKey)
    }
    
    /**
     * 创建订单
     *
     * @param privateKey
     * @param tokenids
     * @param price
     * @return
     */
    public func createTicketOrder(privateKey : String , tokenIds : Array<Any> , price : String,ticketTrustContractAddress:String,ticketContractAddress : String,owner : String) -> ContractResult{
        let merchantService = MerchantService(url: url)
        return merchantService.createOrder(platAddress: ticketTrustContractAddress, privateKey: privateKey, assetAddress: ticketContractAddress, tokenIds: tokenIds, sumPrice: price, owner: owner)
    }
    
    /**
     * 根据托管合约地址获取所有托管的票的合约地址
     *
     * @param ticketTrustContractAddress
     * @return
     */
    public func getTicketContractAddressAll(ticketTrustContractAddress : String) -> ContractResult{
        let merchantService = MerchantService(url: url)
        let addressArr : NSMutableArray = []
        let tokenArray : NSMutableArray = []
        let pageSize = 0
        let result = merchantService.getAssetList(pageSize: "\(pageSize)", platAddress: ticketTrustContractAddress)
        guard case .success(let dic) = result else{
            return ContractResult.failure(error: "search error")
        }
        guard let address = dic["addressArray"] as? NSMutableArray else{
            return ContractResult.failure(error: "search error")
        }
        guard let token = dic["tokenArray"] as? NSMutableArray else {
            return ContractResult.failure(error: "search error")
        }
        addressArr.addObjects(from: address as! [Any])
        tokenArray.addObjects(from: token as! [Any])
        if address.count < 10{
            return ContractResult.success(value: ["addressArray":addressArr,"tokenArray":tokenArray])
        }else{
            return getTicketContractAddressAll(ticketTrustContractAddress : ticketTrustContractAddress,pageSize: pageSize + 1,addressArr: addressArr,tokenArray : tokenArray)
        }
        
    }
    
    private func getTicketContractAddressAll(ticketTrustContractAddress : String,pageSize : Int = 0,addressArr : NSMutableArray,tokenArray : NSMutableArray) -> ContractResult{
        let merchantService = MerchantService(url: url)
        let result = merchantService.getAssetList(pageSize: "\(pageSize)", platAddress: ticketTrustContractAddress)
        guard case .success(let dic) = result else{
            return ContractResult.failure(error: "search error")
        }
        guard let address = dic["addressArray"] as? NSMutableArray else{
            return ContractResult.failure(error: "search error")
        }
        guard let token = dic["tokenArray"] as? NSMutableArray else {
            return ContractResult.failure(error: "search error")
        }
        addressArr.addObjects(from: address as! [Any])
        tokenArray.addObjects(from: token as! [Any])
        if address.count < 10{
            return ContractResult.success(value: ["addressArray":addressArr,"tokenArray":tokenArray])
        }else{
            return getTicketContractAddressAll(ticketTrustContractAddress : ticketTrustContractAddress,pageSize: pageSize + 1,addressArr : addressArr,tokenArray : tokenArray)
        }
    }
    
    /**
     * 获取托管合约里面我上架的 tokenID
     *
     * @param ticketTrustContractAddress
     * @param owner
     * @return
     */
    public func getTrustTicketContractByAddress(ticketTrustContractAddress : String ,owner : String,dmaNodelUrl : String,Success : @escaping ServerResultSuccessResult,Failed : @escaping ServerResultSuccessResult){
        DMAHttpUtil.getServerData(url: dmaNodelUrl + onSale_URL, param: ["trustAddress":ticketTrustContractAddress,"owner":owner], Success: Success, Failed: Failed)
    }
    
    /**
     * 查询已上架的门票合约地址下的 token
     *
     * @param ticketTrustContractAddress
     * @param ticketContractAddress
     * @return
     */
    public func getTokenByTicketContractInOnSale(ticketTrustContractAddress : String , ticketContractAddress : String ) -> ContractResult{
        let merchantService = MerchantService(url: url)
        let pageSize = 0
        let result = merchantService.getTokenList(assetAddress: ticketContractAddress, pageSize: "\(pageSize)", platAddress: ticketTrustContractAddress)
        let tokenIDArray : NSMutableArray = []
        let countArray : NSMutableArray = []
        let ownersArray : NSMutableArray = []
        let priceArray : NSMutableArray = []
        guard case .success(let dic) = result else {
            return ContractResult.failure(error: "search error")
        }
        guard let tokenIds = dic["tokenIds"] as? NSMutableArray else{
            return ContractResult.failure(error: "search error")
        }
        guard let count = dic["count"] as? NSMutableArray else{
            return ContractResult.failure(error: "search error")
        }
        guard let owners = dic["owners"] as? NSMutableArray else{
            return ContractResult.failure(error: "search error")
        }
        guard let prices = dic["prices"] as? NSMutableArray else{
            return ContractResult.failure(error: "search error")
        }
        print("getTokenByTicketContractInOnSale is this pageSize \(pageSize)")
        tokenIDArray.addObjects(from: tokenIds as! [Any])
        countArray.addObjects(from: count as! [Any])
        ownersArray.addObjects(from: owners as! [Any])
        priceArray.addObjects(from: prices as! [Any])
        if tokenIds.count < 10{
            return ContractResult.success(value: ["tokenIds":tokenIDArray,"count":countArray,"owners":ownersArray,"prices":priceArray])
        }else{
            return getTokenByTicketContractInOnSale(ticketTrustContractAddress: ticketTrustContractAddress, ticketContractAddress: ticketContractAddress, pageSize: pageSize + 1, tokenIDArray: tokenIDArray, countArray: countArray, ownersArray: ownersArray, priceArray: priceArray)
        }
    }
    
    private func getTokenByTicketContractInOnSale(ticketTrustContractAddress : String , ticketContractAddress : String,pageSize : Int,tokenIDArray : NSMutableArray,countArray : NSMutableArray,ownersArray : NSMutableArray,priceArray : NSMutableArray) -> ContractResult{
        print("getTokenByTicketContractInOnSale is this pageSize \(pageSize)")
        let merchantService = MerchantService(url: url)
        let result = merchantService.getTokenList(assetAddress: ticketContractAddress, pageSize: "\(pageSize)", platAddress: ticketTrustContractAddress)
        guard case .success(let dic) = result else {
            return ContractResult.failure(error: "search error")
        }
        guard let tokenIds = dic["tokenIds"] as? NSMutableArray else{
            return ContractResult.failure(error: "search error")
        }
        guard let count = dic["count"] as? NSMutableArray else{
            return ContractResult.failure(error: "search error")
        }
        guard let owners = dic["owners"] as? NSMutableArray else{
            return ContractResult.failure(error: "search error")
        }
        guard let prices = dic["prices"] as? NSMutableArray else{
            return ContractResult.failure(error: "search error")
        }
        tokenIDArray.addObjects(from: tokenIds as! [Any])
        countArray.addObjects(from: count as! [Any])
        ownersArray.addObjects(from: owners as! [Any])
        priceArray.addObjects(from: prices as! [Any])
        if tokenIds.count < 10{
            return ContractResult.success(value: ["tokenIds":tokenIDArray,"count":countArray,"owners":ownersArray,"prices":priceArray])
        }else{
            return getTokenByTicketContractInOnSale(ticketTrustContractAddress: ticketTrustContractAddress, ticketContractAddress: ticketContractAddress, pageSize: pageSize + 1, tokenIDArray: tokenIDArray, countArray: countArray, ownersArray: ownersArray, priceArray: priceArray)
        }
    }
    
    /**
     * 根据票合约地址查询 owner 托管的tokenid
     *
     * @param ticketTrustContractAddress
     * @param ticketContractAddress
     * @param owner
     * @return
     */
    public func  getTrustTicketTokensByTicketContractAndAddress(ticketTrustContractAddress : String , ticketContractAddress : String , owner : String) -> ContractResult{
        let result = getTokenByTicketContractInOnSale(ticketTrustContractAddress: ticketTrustContractAddress, ticketContractAddress: ticketContractAddress)
        let tokenIDArray : NSMutableArray = []
        let countArray : NSMutableArray = []
        let ownersArray : NSMutableArray = []
        let priceArray : NSMutableArray = []
        guard case .success(let dic) = result else{
            return ContractResult.failure(error: "search error")
        }
        guard let tokenIds = dic["tokenIds"] as? NSMutableArray else{
            return ContractResult.failure(error: "search error")
        }
        guard let count = dic["count"] as? NSMutableArray else{
            return ContractResult.failure(error: "search error")
        }
        guard let owners = dic["owners"] as? NSMutableArray else{
            return ContractResult.failure(error: "search error")
        }
        guard let prices = dic["prices"] as? NSMutableArray else{
            return ContractResult.failure(error: "search error")
        }
        for i in 0..<tokenIds.count{
            if let ownerStr = owners[i] as? String{
                if ownerStr == owner {
                    tokenIDArray.add(tokenIds[i])
                    countArray.add(count[i])
                    ownersArray.add(owners[i])
                    priceArray.add(prices[i])
                }
            }
        }
        return ContractResult.success(value: ["tokenIds":tokenIDArray,"count":countArray,"owners":ownersArray,"prices":priceArray])
    }
    
    /**
     * 获取未进行托管的tokenid
     *
     * @param ticketTrustContractAddress
     * @param ticketContractAddress
     * @return
     */
    public func getNotTrustTicketTokensByTicketContract(ticketTrustContractAddress : String , ticketContractAddress : String,owner : String,dmaNodelUrl : String,Success : @escaping ((NSMutableArray) -> ()),Failed : @escaping ((NSMutableDictionary) -> ())){
        DMAHttpUtil.getServerData(url: dmaNodelUrl + aseet_URL, param: ["contractAddress":ticketContractAddress,"owner":owner,"pageSize":9999999,"pageNumber":1], Success: { (dic) in
            DispatchQueue.global().async {
                let tokenArr : NSMutableArray = []
                guard let data = dic["data"] as? [NSMutableDictionary] else{
                    return
                }
                for tokenDic in data{
                    guard let tokenIDs = tokenDic["tokenId"] else{
                        return
                    }
                    guard let saleStatus = tokenDic["saleStatus"] else{
                        return
                    }
                    if "\(saleStatus)" == "0"{
                        tokenArr.add("\(tokenIDs)")
                    }
                }
                Success(tokenArr)
            }
        }) { (error) in
            Failed(error)
        }
    }
    
    
    /// 获取门票合约地址下门票已售数量
    ///
    /// - Parameters:
    ///   - ticketTrustContractAddress: 门票托管地址
    ///   - ticketContractAddress: 门票合约地址
    ///   - owner: 门票合约地址拥有者
    ///   - dmaNodelUrl: dma 节点地址
    ///   - Success: 已售数量
    ///   - Failed: 失败 json
    public func getTickSlod(ticketTrustContractAddress : String , ticketContractAddress : String,owner : String,dmaNodelUrl : String,Success : @escaping ((Int) -> ()),Failed : @escaping ((NSMutableDictionary) -> ())){
        let urlStr = url
        let trusService = TicketTrustService(url: ServerUrl.dmaIP)
        var result = trusService.getTokenByTicketContractInOnSale(ticketTrustContractAddress: ticketTrustContractAddress, ticketContractAddress: ticketContractAddress)
        ///计算商城库存
        let tokenIndexArr : NSMutableArray = []
        guard case .success(let dic) = result else{
            print("seach token error")
            return
        }
        guard let tokenIdsArr = dic["tokenIds"] as? NSMutableArray else{
            print("seach tokenIds error")
            return
        }
        guard let countArr = dic["count"] as? NSMutableArray else{
            print("seach count error")
            return
        }
        guard let ownersArr = dic["owners"] as? NSMutableArray else{
            print("seach owners error")
            return
        }
        guard let pricesArr = dic["prices"] as? NSMutableArray else{
            print("seach prices error")
            return
        }
        print("seach success")
        ///设置售卖价格
        var inventory = 0
        for i in 0..<tokenIdsArr.count{
            if "\(countArr[i])" == "0"{
                inventory += 1
                tokenIndexArr.add("\(tokenIdsArr[i])")
            }
        }
        getNotTrustTicketTokensByTicketContract(ticketTrustContractAddress: ticketTrustContractAddress, ticketContractAddress: ticketContractAddress, owner: owner, dmaNodelUrl: dmaNodelUrl, Success: { (tokenArr) in
            DispatchQueue.global().async {
                let aseert = AssetManagementService(url: urlStr)
                result = aseert.totalSupply(contractAddress: ticketContractAddress)
                guard case .success(let dic) = result else{
                    print("seach token error")
                    return
                }
                guard let tokenNumebr = dic["result"] as? String else{
                    print("seach token error")
                    return
                }
                print("inventory is \(inventory)")
                print("noOnsale is \(tokenArr.count)")
                print("total token is \(tokenNumebr)")
                let slod = NSDecimalNumber(string: tokenNumebr).subtracting(NSDecimalNumber(value: inventory)).subtracting(NSDecimalNumber(value: tokenArr.count))
                Success(slod.intValue)
            }
        }) { (error) in
            Failed(error)
            print(error)
        }
    }
    
    /**
     * 获取所有订单记录
     *
     * @param ticketTrustContractAddress
     * @return
     */
    public func getOrderRecordAll(ticketTrustContractAddress : String ,dmaNodelUrl : String,Success : @escaping (([TicketOrderInfo?]?) ->()),Failed : @escaping ServerResultSuccessResult){
        DMAHttpUtil.getServerData(url: dmaNodelUrl + order_URL, param: ["trustAddress":ticketTrustContractAddress], Success: { (dic) in
            guard let data = dic["data"] as? NSArray else{
                return
            }
            Success([TicketOrderInfo].deserialize(from: data))
        }, Failed: Failed)
    }
    
    /**
     * 获取与address有关的订单记录
     *
     * @return
     */
    public func getOrderRecordByAddress(ticketTrustContractAddress : String = "" , userAddress : String ,dmaNodelUrl : String,Success : @escaping (([TicketOrderInfo?]?) ->()),Failed : @escaping ServerResultSuccessResult){
        DMAHttpUtil.getServerData(url: dmaNodelUrl + order_URL, param: ["trustAddress":ticketTrustContractAddress,"form":userAddress,"to":userAddress], Success: { (dic) in
            guard let data = dic["data"] as? NSArray else{
                return
            }
            Success([TicketOrderInfo].deserialize(from: data))
        }, Failed: Failed)
        
    }
    
    /**
     * 获取接受着是address有关的订单记录
     *
     * @return
     */
    public func getOrderRecordToAddress(ticketTrustContractAddress : String = "" , userAddress : String ,dmaNodelUrl : String,Success : @escaping (([TicketOrderInfo?]?) ->()),Failed : @escaping ServerResultSuccessResult){
        DMAHttpUtil.getServerData(url: dmaNodelUrl + order_URL, param: ["to":userAddress], Success: { (dic) in
            guard let data = dic["data"] as? NSArray else{
                return
            }
            Success([TicketOrderInfo].deserialize(from: data))
        }, Failed: Failed)
    }
    
    /**
     * 获取订单详情
     *
     * @param hash
     * @return
     */
    public func getOrderInfoByHash(hash : String ,dmaNodelUrl : String,Success : @escaping ServerResultSuccessResult,Failed : @escaping ServerResultSuccessResult){
        DMAHttpUtil.getServerData(url: dmaNodelUrl + orderItems, param: ["transactionHash":hash], Success: Success, Failed: Failed)
    }
}
