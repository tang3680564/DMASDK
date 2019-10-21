//
//  TicketService.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/10/16.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation


public class TicketService : NSObject{
    
    var url = ""
    
    public required init(url : String) {
        super.init()
        self.url = url
    }
    
    private var hashDic : Dictionary<String,String> = Dictionary<String,String>()
    
    /**
     * 创建门票资产合约
     *
     * @param privateKey
     * @param gasPrice
     * @param gasLimit
     * @param name
     * @param symbol
     * @param metadata
     * @return
     */
    public func createTicketContract( privateKey : String, name : String , symbol : String , metadata : TicketContractInfo , gasPrice : String = "" , gasLimit : String = "",ipfsNodelUrl : String,ipfsNodeUpPoint: String) -> ContractResult{
         let assetServer = AssetManagementService(url: url)
         let ipfs = IpfsService(URL: ipfsNodelUrl, serverPost: ipfsNodeUpPoint)
         let hash = ipfs.add(fileData: metadata.toJSONString()?.data(using: .utf8) ?? Data())
         return assetServer.deploy(privateKey: privateKey, name: name, symbol: symbol, metadata: hash, isburn: true, gasLimit: gasLimit, gasPrice: gasPrice)
    }
    
    /**
     * 创建门票
     *
     * @param ticketContractAddress
     * @param privateKey
     * @param gasPrice
     * @param gasLimit
     * @param to                    门票接受者地址
     * @param uri
     * @param tokenDic  key : tokenID , value : token的 uri
     * @return
     */
    public func createTicketToken(ticketContractAddress : String, privateKey : String , to : String , tokenDic : Dictionary<String,TicketTokenInfo>,gasPrice : String = "", gasLimit : String = "",ipfsNodelUrl : String,ipfsNodeUpPoint: String) -> NSMutableArray{
        var dic : Dictionary<NSMutableDictionary,NSMutableArray> = Dictionary<NSMutableDictionary,NSMutableArray>()
        for token in tokenDic{
            if let modelStr = token.value.toJSON(){
                let modelDic = NSMutableDictionary(dictionary: modelStr)
                if let arr = dic[modelDic]{
                    arr.add(token.key)
                }else{
                    let arr : NSMutableArray = []
                    dic[modelDic] = arr
                    arr.add(token.key)
                }
            }
        }
        let hashArr : NSMutableArray = []
        for token in dic{
            let arr = createTicketToken(ticketContractAddress: ticketContractAddress, privateKey: privateKey, to: to, uri: token.key.toJsonString(), tokenIds: token.value as! Array<Any>, ipfsNodelUrl: ipfsNodelUrl, ipfsNodeUpPoint: ipfsNodeUpPoint)
            hashArr.addObjects(from: arr as! [Any])
        }
        return hashArr
        
    }
    
    
    
    private func createTicketToken(ticketContractAddress : String, privateKey : String , to : String , uri : String , tokenIds : Array<Any>,gasPrice : String = "", gasLimit : String = "",ipfsNodelUrl : String,ipfsNodeUpPoint: String) -> NSMutableArray{
        let ipfs = IpfsService(URL: ipfsNodelUrl, serverPost: ipfsNodeUpPoint)
        let hash = ipfs.add(fileData: uri.data(using: .utf8) ?? Data())
        let assetServer = AssetManagementService(url: url)
        let number = NSDecimalNumber(value: tokenIds.count)
        let array : NSMutableArray = []
        let lunNumber = 30
        ///一次 lunNumber 个资产,计算需要进行多少次
        var cishu = NSDecimalNumber(string: number.dividing(by: NSDecimalNumber(value: lunNumber)).stringValue.setPriceDecimal(dicimal: 0,isDown : true)).intValue
        print(cishu)
        let yushu = number.intValue % lunNumber
        ///不整除就批次加 1
        if  yushu != 0 {
            cishu += 1
        }
       
        let resultArr : NSMutableArray = []
        for numberCH in 0..<cishu{
            array.removeAllObjects()
            ///如果下一批次剩余大于 lunNumber 个话 ,创建 lunNumber 个资产
            if numberCH < cishu - 1 {
                let start = numberCH * lunNumber
                let end = numberCH * lunNumber + lunNumber
                for i in start ..< end{
                    array.add(tokenIds[i])
                }
            }
                ///否则创建余下资产
            else{
                let start = numberCH * lunNumber
                let end = tokenIds.count
                for i in start ..< end{
                    array.add(tokenIds[i])
                }
            }
            ///调用发布资产
            let status = assetServer.mintWithArray(privateKey: privateKey, contractAddress: ticketContractAddress, to: to, array: array as! Array<Any>, uri: hash, isTransfer: true, isBurn: true, gasLimit: gasLimit, gasPrice: gasPrice, getGasFee: false)
            if case .success(let dic) = status {
                if let hash = dic["hash"] as? String{
                    resultArr.add(hash)
                }
            }else if case .failure(let error) = status {
                resultArr.add(error)
            }
        }
        return resultArr
    }
    
    /**
     * 门票转移
     *
     * @param ticketContractAddress
     * @param privateKey
     * @param gasPrice
     * @param gasLimit
     * @param from                  门票当前拥有者地址
     * @param to                    接收者地址
     * @param tokenIds
     * @return
     */
    public func ticketTransfer(ticketContractAddress : String , privateKey : String , from : String ,to : String , tokenIds : Array<Any> , gasPrice : String = "", gasLimit : String = "") -> NSMutableArray{
        let assetServer = AssetManagementService(url: url)
        let number = NSDecimalNumber(value: tokenIds.count)
        let array : NSMutableArray = []
        let lunNumber = 30
        ///一次 lunNumber 个资产,计算需要进行多少次
        var cishu = NSDecimalNumber(string: number.dividing(by: NSDecimalNumber(value: lunNumber)).stringValue.setPriceDecimal(dicimal: 0,isDown : true)).intValue
        print(cishu)
        let yushu = number.intValue % lunNumber
        ///不整除就批次加 1
        if  yushu != 0 {
            cishu += 1
        }
        let resultArr : NSMutableArray = []
        for numberCH in 0..<cishu{
            array.removeAllObjects()
            ///如果下一批次剩余大于 lunNumber 个话 ,创建 lunNumber 个资产
            if numberCH < cishu - 1 {
                let start = numberCH * lunNumber
                let end = numberCH * lunNumber + lunNumber
                for i in start ..< end{
                    array.add(tokenIds[i])
                }
            }
                ///否则创建余下资产
            else{
                let start = numberCH * lunNumber
                let end = tokenIds.count
                for i in start ..< end{
                    array.add(tokenIds[i])
                }
            }
            ///调用发布资产
            let status = assetServer.transferFromWithArray(privateKey: privateKey, contractAddress: ticketContractAddress, from: from, to: to, tokenIds: array as! Array<Any>, gasLimit: gasLimit, gasPrice: gasPrice, getGasFee: false)
            if case .success(let dic) = status {
                if let hash = dic["hash"] as? String{
                    resultArr.add(hash)
                }
            }else if case .failure(let error) = status {
                resultArr.add(error)
            }
        }
        return resultArr
    }
    
    /**
     * 销毁门票
     *
     * @param ticketContractAddress
     * @param privateKey
     * @param _owner                门票拥有者地址
     * @param tokenid
     * @param gasPrice
     * @param gasLimit
     * @return
     */
    public func burn(ticketContractAddress : String , privateKey : String , owner : String , tokenId : String , gasPrice : String = "" , gasLimit : String = "" ,getGasFee : Bool = false) -> ContractResult{
        let assetServer = AssetManagementService(url: url)
        let status = assetServer.burn(privateKey: privateKey, contractAddress: ticketContractAddress, owner: owner, tokenId: tokenId, gasLimit: gasLimit, gasPrice: gasPrice, getGasFee: false)
        return status
    }
    
    /**
     * 设置门票是否可转移
     *
     * @param ticketContractAddress
     * @param privateKey
     * @param tokenid
     * @param canTransfer
     * @param gasPrice
     * @param gasLimit
     * @return
     */
    public func setTicketCanTransfer(ticketContractAddress : String ,privateKey :  String , tokenId : String , canTransfer : Bool , gasPrice : String = "" , gasLimit : String = "" ,getGasFee : Bool = false) -> ContractResult{
         let assetServer = AssetManagementService(url: url)
        return assetServer.setCanTransfer(privateKey: privateKey, contractAddress: ticketContractAddress, tokenId: tokenId, canTransfer: canTransfer, gasLimit: gasLimit, gasPrice: gasPrice, getGasFee: getGasFee)
    }
    
    
    
    /**
     * 根据门票合约地址获取门票资产合约信息
     *
     * @param ticketContractAddress
     * @return
     */
    public func getTicketContractInfo(ticketContractAddress : String ,ipfsNodelUrl : String,ipfsNodeDownPoint: String) -> TicketContractInfo?{
        let asset = AssetManagementService(url: url)
        let result = asset.getMetadata(contractAddress: ticketContractAddress)
        switch result {
        case .success(value: let dic):
            let ipfs = IpfsService(URL: ipfsNodelUrl, serverPost: ipfsNodeDownPoint)
            var meteStr = ""
            var meteModel : TicketContractInfo?
            if let hash = dic["result"] as? String {
                meteStr = ipfs.getString(hash: hash)
                meteModel = TicketContractInfo.deserialize(from: meteStr)
            }
            return meteModel
        case .failure(error: let error):
            print(error)
            return nil
        }
    }
    
    /**
     * 根据门票合约地址和门票tokenid获取门票详细信息
     *
     * @param ticketContractAddress
     * @param tokenid
     * @return
     */
    public func getTicketTokenInfo(ticketContractAddress : String , tokenid : String,ipfsNodelUrl : String,ipfsNodeDownPoint: String) -> TicketTokenInfo?{
        let asset = AssetManagementService(url: url)
        let result = asset.getTokenURI(contractAddress: ticketContractAddress, tokenId: tokenid)
        switch result {
        case .success(value: let dic):
            let ipfs = IpfsService(URL: ipfsNodelUrl, serverPost: ipfsNodeDownPoint)
            var meteStr = ""
            var tokenModel : TicketTokenInfo?
            if let hash = dic["result"] as? String {
                if let json = hashDic[hash]{
                    meteStr = json
                    tokenModel = TicketTokenInfo.deserialize(from: meteStr)
                }else{
                    meteStr = ipfs.getString(hash: hash)
                    hashDic[hash] = meteStr
                    tokenModel = TicketTokenInfo.deserialize(from: meteStr)
                }
                
            }
            return tokenModel
        case .failure(error: let error):
            print(error)
            return nil
        }
    }
    
    
    /**
     * 获取发行总量
     *
     * @param ticketContractAddress
     * @return
     */
    public func getTickettotalSupply(ticketContractAddress : String ) -> ContractResult{
        let asset = AssetManagementService(url: url)
        return asset.totalSupply(contractAddress: ticketContractAddress)
    }
    
    
    /**
     * 查询发行的所有门票
     *
     * @param ticketContractAddress
     * @return
     */
    public func getTicketTokens(ticketContractAddress : String,dmaNodelUrl : String,Success : @escaping ((NSMutableArray) -> ()),falied : @escaping ((NSMutableDictionary) -> ())){
        DMAHttpUtil.getServerData(url: dmaNodelUrl + aseet_URL, param: ["contractAddress":ticketContractAddress,"pageNumber":9999999,"pageSize":1], Success: { (dic) in
            let tokenArr : NSMutableArray = []
            guard let data = dic["data"] as? [NSMutableDictionary] else{
                falied(["error":"no search data"])
                return
            }
            for tokenDic in data{
//                let tokenModel = TicketTokenInfo()
//                guard let tokenIDs = tokenDic["tokenId"] else{
//                    falied(["error":"no search tokenId"])
//                    return
//                }
//                guard let metaData = tokenDic["metaData"] else{
//                    falied(["error":"no search tokenId"])
//                    return
//                }
                tokenArr.add(tokenDic)
            }
            Success(tokenArr)
        }) { (error) in
            falied(error)
        }
    }
    
    
    /**
     * 通过节点查询指定的门票实体
     *
     * @param ticketContractAddress
     * @return
     */
    public func getTicketTokenInfo(ticketContractAddress : String,dmaNodelUrl : String,tokenIds : NSMutableArray,ipfsNodelUrl : String,ipfsNodeDownPoint: String,Success : @escaping ((NSMutableArray) -> ()),falied : @escaping ((NSMutableDictionary) -> ())){
        let ipfs = IpfsService(URL: ipfsNodelUrl, serverPost: ipfsNodeDownPoint)
        DMAHttpUtil.getServerData(url: dmaNodelUrl + aseet_URL, param: ["contractAddress":ticketContractAddress,"pageNumber":9999999,"pageSize":1,"tokenIds":tokenIds], Success: { (dic) in
            let tokenArr : NSMutableArray = []
            guard let data = dic["data"] as? [NSMutableDictionary] else{
                falied(["error":"no search data"])
                return
            }
            var meteHash : Dictionary <String,String> = Dictionary<String,String>()
            for tokenDic in data{
                guard let metaData = tokenDic["metaData"] as? String else{
                    falied(["error":"no search tokenId"])
                    return
                }
                if let metaDataStr = meteHash[metaData]{
                    let model = TicketTokenInfo.deserialize(from: metaDataStr)
                    tokenArr.add(model)
                }else{
                    let metaDataStr = ipfs.getString(hash: metaData)
                    let model = TicketTokenInfo.deserialize(from: metaDataStr)
                    meteHash[metaData] = metaDataStr
                    tokenArr.add(model)
                }
            }
            Success(tokenArr)
        }) { (error) in
            falied(error)
        }
    }
    
    /**
     * 查询用户所拥有的门票
     *
     * @param ticketContractAddress
     * @param owner
     * @return
     */
    public func getTicketTokensByOwner(ticketContractAddress : String, owner : String ,dmaNodelUrl : String,Success : @escaping ((NSMutableArray) -> ()),falied : @escaping ((NSMutableDictionary) -> ())){
        DMAHttpUtil.getServerData(url: dmaNodelUrl + aseet_URL, param: ["contractAddress":ticketContractAddress,"owner":owner ,"pageNumber":9999999,"pageSize":1], Success: { (dic) in
            let tokenArr : NSMutableArray = []
            guard let data = dic["data"] as? [NSMutableDictionary] else{
                falied(["error":"no search data"])
                return
            }
            for tokenDic in data{
                guard let tokenIDs = tokenDic["tokenId"] else{
                    falied(["error":"no search tokenId"])
                    return
                }
                tokenArr.add(tokenDic)
            }
            Success(tokenArr)
        }) { (error) in
            falied(error)
        }
    }
    
    /**
     * 查询用户所拥有的门票
     *
     * @param ticketContractAddress
     * @param owner
     * @return
     */
    public func getTicketTokensByOwner(owner : String ,dmaNodelUrl : String,Success : @escaping ((NSMutableArray) -> ()),falied : @escaping ((NSMutableDictionary) -> ())){
        DMAHttpUtil.getServerData(url: dmaNodelUrl + aseet_URL, param: ["owner":owner ,"pageNumber":9999999,"pageSize":1], Success: { (dic) in
            let tokenArr : NSMutableArray = []
            guard let data = dic["data"] as? [NSMutableDictionary] else{
                falied(["error":"no search data"])
                return
            }
            for tokenDic in data{
                guard let tokenIDs = tokenDic["tokenId"] else{
                    falied(["error":"no search tokenId"])
                    return
                }
                tokenArr.add(tokenDic)
            }
            Success(tokenArr)
        }) { (error) in
            falied(error)
        }
    }
    
    
    
    
    /// 查询地址下的的所有门票合约地址以及对应合约地址下的门票
    ///
    /// - Parameters:
    ///   - owner: 查询者地址
    ///   - dmaNodelUrl:  dma 节点地址
    ///   - Success: 返回 json 数组
    ///   - Failed: Failed description
    public func getTicketContract(owner : String,dmaNodelUrl : String,Success : @escaping ((NSMutableArray) -> ()),Failed : @escaping ((NSMutableDictionary) -> ())){
        DispatchQueue.global().async {
            DMAHttpUtil.getServerData(url: dmaNodelUrl + contract_URL, param: ["owner":owner,"pageNumber":1,"pageSize":999999], Success: { (dic) in
                print(dic)
                let myShowCellArr : NSMutableArray = []
                if let data = dic["data"] as? NSMutableArray{
                    for i in 0..<data.count{
                        if let showDic = data[i] as? NSMutableDictionary {
                            myShowCellArr.add(showDic)
                        }
                    }
                }
                Success(myShowCellArr)
            }, Failed: { (error) in
                Failed(error)
                print(error)
            })
        }
    }
    
    /**
     * 获取所有的转移记录
     *
     * @param ticketContractAddress
     * @return
     */
    public func getTransactionRecordAll(ticketContractAddress : String,dmaNodelUrl : String,Success : @escaping ServerResultSuccessResult,Failed : @escaping ServerResultSuccessResult){
         DMAHttpUtil.getServerData(url: dmaNodelUrl + transaction_URL, param: ["contractAddress":ticketContractAddress], Success: Success, Failed: Failed)
    }
    
    /**
     * 当前tokenid的转移记录
     *
     * @param ticketContractAddress
     * @param tokenid
     * @return
     */
    public func getTransactionRecordByTokenid(ticketContractAddress : String , tokenID : String ){
        
    }
    
    /**
     * 根据用户地址查询交易记录
     *
     * @param ticketContractAddress
     * @param address
     * @return
     */
    public func getTransactionRecordByAddress(ticketContractAddress : String = "" , userAddress : String,dmaNodelUrl : String,Success : @escaping ServerResultSuccessResult,Failed : @escaping ServerResultSuccessResult){
        DMAHttpUtil.getServerData(url: dmaNodelUrl + transaction_URL, param: ["contractAddress":ticketContractAddress,"form":userAddress,"to":userAddress], Success: Success, Failed: Failed)
    }
    
}
