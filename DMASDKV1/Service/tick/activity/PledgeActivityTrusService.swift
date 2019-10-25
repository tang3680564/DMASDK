//
//  PledgeActivityTrusService.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/10/18.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation

class PledgeActivityTrusService: NSObject {
    
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
    public func createContract(privateKey :String) -> ContractResult{
        let pledgeActivityService = PledgeActivityService(url: url)
        return pledgeActivityService.deploy(privateKey: privateKey)
    }
    
    /**
     * 将token托管给托管合约（上架）
     *
     * @param privateKey
     * @param tokenids
     * @param price
     * @return
     */
    public func onShelves(privateKey : String , tokenIds : NSMutableArray , price : String,pledgeActivityTrustContractAddress:String,ticketContractAddress : String,endTime : String){
        let owner = EthService().exportAddressFromPrivateKey(privateKey: privateKey)
        let tokenNumber : NSMutableArray = []
        for i in 0..<tokenIds.count{
            tokenNumber.add(tokenIds[i])
            if tokenNumber.count == 20{
                let arr = NSMutableArray(array: tokenNumber)
                upTokenData(platAddress: pledgeActivityTrustContractAddress, contractAddress : ticketContractAddress,tokenIDArr : arr,price : price,privateKey : privateKey,owner : owner, endTime: endTime)
                tokenNumber.removeAllObjects()
            }
        }
        upTokenData(platAddress: pledgeActivityTrustContractAddress, contractAddress : ticketContractAddress,tokenIDArr : tokenNumber,price : price,privateKey : privateKey,owner : owner, endTime: endTime)
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
    private func upTokenData(platAddress : String,contractAddress : String,tokenIDArr : NSMutableArray,price : String,privateKey : String,owner : String,endTime:String){
        let urlStr = url
        DispatchQueue.global().async {
            let chargeServer = PledgeActivityService(url: urlStr)
            let result = chargeServer.onSales(contractAddress: contractAddress, platformAddress: platAddress, privateKey: privateKey, owner: owner, endTime: endTime, tokenIds: tokenIDArr as! Array<Any>, price: price)
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
        
    }
    
    /**
     * 移除托管（下架）
     *
     * @param privateKey
     * @param tokenids
     * @return
     */
    public func offShelves(privateKey : String , tokenIds : NSMutableArray,pledgeActivityTrustContractAddress:String,ticketContractAddress : String){
        let tokenNumber : NSMutableArray = []
        for i in 0..<tokenIds.count{
            tokenNumber.add(tokenIds[i])
            if tokenNumber.count == 20{
                let arr = NSMutableArray(array: tokenNumber)
                downTokenData(platAddress: pledgeActivityTrustContractAddress, contractAddress : ticketContractAddress,tokenIDArr : arr,privateKey : privateKey)
                tokenNumber.removeAllObjects()
            }
        }
        downTokenData(platAddress: pledgeActivityTrustContractAddress, contractAddress : ticketContractAddress,tokenIDArr : tokenNumber,privateKey : privateKey)
    }
    
    private func downTokenData(platAddress : String,contractAddress : String,tokenIDArr : NSMutableArray,privateKey : String){
        let urlStr = url
        DispatchQueue.global().async {
            let merchantService = PledgeActivityService(url : urlStr)
            let result = merchantService.offSales(privateKey: privateKey, assetAddress : contractAddress, platAddress: platAddress, tokenArr: tokenIDArr as! Array<Any>)
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
    
    /**
     * 创建订单
     *
     * @param privateKey
     * @param tokenids
     * @param price
     * @return
     */
    public func placeOrder(privateKey : String , tokenId : String , price : String,pledgeActivityTrustContractAddress:String,ticketContractAddress : String,owner : String) -> ContractResult{
        let pledgeActivityService = PledgeActivityService(url: url)
        return pledgeActivityService.createOrder(assetAddress: ticketContractAddress, platAddress: pledgeActivityTrustContractAddress, privateKey: privateKey, tokenId: tokenId, sumPrice: price, owner: owner)
    }
    
    /**
     * 根据托管合约地址获取所有托管的票的合约地址
     *
     * @param pledgeActivityTrustContractAddress
     * @return
     */
    public func getOnShelveContracts(pledgeActivityTrustContractAddress : String) -> ContractResult{
        let pledgeActivityService = PledgeActivityService(url: url)
        let addressArr : NSMutableArray = []
        let tokenArray : NSMutableArray = []
        let pageSize = 0
        let result = pledgeActivityService.getAssetList(pageSize: "\(pageSize)", platAddress: pledgeActivityTrustContractAddress)
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
            return getOnShelveContracts(pledgeActivityTrustContractAddress : pledgeActivityTrustContractAddress,pageSize: pageSize + 1,addressArr: addressArr,tokenArray : tokenArray)
        }
        
    }
    
    private func getOnShelveContracts(pledgeActivityTrustContractAddress : String,pageSize : Int = 0,addressArr : NSMutableArray,tokenArray : NSMutableArray) -> ContractResult{
        let pledgeActivityService = PledgeActivityService(url: url)
        let result = pledgeActivityService.getAssetList(pageSize: "\(pageSize)", platAddress: pledgeActivityTrustContractAddress)
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
            return getOnShelveContracts(pledgeActivityTrustContractAddress : pledgeActivityTrustContractAddress,pageSize: pageSize + 1,addressArr : addressArr,tokenArray : tokenArray)
        }
    }
    
    /**
     * 获取托管合约里面我上架的 tokenID
     *
     * @param pledgeActivityTrustContractAddress
     * @param owner
     * @return
     */
    public func getOnShelves(pledgeActivityTrustContractAddress : String ,owner : String,dmaNodelUrl : String,Success : @escaping ServerResultSuccessResult,Failed : @escaping ServerResultSuccessResult){
        DMAHttpUtil.getServerData(url: dmaNodelUrl + onSale_URL, param: ["trustAddress":pledgeActivityTrustContractAddress,"owner":owner], Success: Success, Failed: Failed)
    }
    
    /**
     * 查询已上架的门票合约地址下的 token
     *
     * @param pledgeActivityTrustContractAddress
     * @param ticketContractAddress
     * @return
     */
    public func getTokenByTicketContractInOnSale(pledgeActivityTrustContractAddress : String , ticketContractAddress : String ) -> ContractResult{
        let pledgeActivityService = PledgeActivityService(url: url)
        let pageSize = 0
        let result = pledgeActivityService.getTokenList(assetAddress: ticketContractAddress, pageSize: "\(pageSize)", platAddress: pledgeActivityTrustContractAddress)
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
            return getTokenByTicketContractInOnSale(pledgeActivityTrustContractAddress: pledgeActivityTrustContractAddress, ticketContractAddress: ticketContractAddress, pageSize: pageSize + 1, tokenIDArray: tokenIDArray, countArray: countArray, ownersArray: ownersArray, priceArray: priceArray)
        }
    }
    
    private func getTokenByTicketContractInOnSale(pledgeActivityTrustContractAddress : String , ticketContractAddress : String,pageSize : Int,tokenIDArray : NSMutableArray,countArray : NSMutableArray,ownersArray : NSMutableArray,priceArray : NSMutableArray) -> ContractResult{
        print("getTokenByTicketContractInOnSale is this pageSize \(pageSize)")
        let pledgeActivityService = PledgeActivityService(url: url)
        let result = pledgeActivityService.getTokenList(assetAddress: ticketContractAddress, pageSize: "\(pageSize)", platAddress: pledgeActivityTrustContractAddress)
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
            return getTokenByTicketContractInOnSale(pledgeActivityTrustContractAddress: pledgeActivityTrustContractAddress, ticketContractAddress: ticketContractAddress, pageSize: pageSize + 1, tokenIDArray: tokenIDArray, countArray: countArray, ownersArray: ownersArray, priceArray: priceArray)
        }
    }
    
    /**
     * 根据票合约地址查询 owner 托管的tokenid
     *
     * @param pledgeActivityTrustContractAddress
     * @param ticketContractAddress
     * @param owner
     * @return
     */
    public func  getTrustTicketTokensByTicketContractAndAddress(pledgeActivityTrustContractAddress : String , ticketContractAddress : String , owner : String) -> ContractResult{
        let result = getTokenByTicketContractInOnSale(pledgeActivityTrustContractAddress: pledgeActivityTrustContractAddress, ticketContractAddress: ticketContractAddress)
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
     * @param pledgeActivityTrustContractAddress
     * @param ticketContractAddress
     * @return
     */
    public func getOffShelves(pledgeActivityTrustContractAddress : String , ticketContractAddress : String,owner : String,dmaNodelUrl : String,Success : @escaping ((NSMutableArray) -> ()),Failed : @escaping ((NSMutableDictionary) -> ())){
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
    ///   - pledgeActivityTrustContractAddress: 门票托管地址
    ///   - ticketContractAddress: 门票合约地址
    ///   - owner: 门票合约地址拥有者
    ///   - dmaNodelUrl: dma 节点地址
    ///   - Success: 已售数量
    ///   - Failed: 失败 json
    public func getTickSlod(pledgeActivityTrustContractAddress : String , ticketContractAddress : String,owner : String,dmaNodelUrl : String,Success : @escaping ((Int) -> ()),Failed : @escaping ((NSMutableDictionary) -> ())){
        let urlStr = url
        var result = getTokenByTicketContractInOnSale(pledgeActivityTrustContractAddress: pledgeActivityTrustContractAddress, ticketContractAddress: ticketContractAddress)
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
        getOffShelves(pledgeActivityTrustContractAddress: pledgeActivityTrustContractAddress, ticketContractAddress: ticketContractAddress, owner: owner, dmaNodelUrl: dmaNodelUrl, Success: { (tokenArr) in
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
     * @param pledgeActivityTrustContractAddress
     * @return
     */
    public func getOrderRecordAll(pledgeActivityTrustContractAddress : String ,dmaNodelUrl : String,Success : @escaping ServerResultSuccessResult,Failed : @escaping ServerResultSuccessResult){
        DMAHttpUtil.getServerData(url: dmaNodelUrl + order_URL, param: ["trustAddress":pledgeActivityTrustContractAddress], Success: Success, Failed: Failed)
    }
    
    /**
     * 获取与address有关的订单记录
     *
     * @return
     */
    public func getOrderRecordByAddress(pledgeActivityTrustContractAddress : String = "", userAddress : String ,dmaNodelUrl : String,Success : @escaping ServerResultSuccessResult,Failed : @escaping ServerResultSuccessResult){
        DMAHttpUtil.getServerData(url: dmaNodelUrl + order_URL, param: ["trustAddress":pledgeActivityTrustContractAddress,"form":userAddress,"to":userAddress], Success: Success, Failed: Failed)
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
    
    /// 结束活动
    ///
    /// - Parameters:
    ///   - chargeActivityTrustContractAddress: 活动托管合约地址
    ///   - privateKey: 票的合约地址拥有者的私钥
    ///   - ticketContractAddress: 票的合约地址
    /// - Returns: return value description
    public func endActivity(pledgeActivityTrustContractAddress : String,privateKey : String,ticketContractAddress : String) -> ContractResult{
        let pledgeActivityService = PledgeActivityService(url: url)
        return pledgeActivityService.endActivity(privateKey: privateKey, assetAddress: ticketContractAddress, contractAddress: pledgeActivityTrustContractAddress)
    }

}
