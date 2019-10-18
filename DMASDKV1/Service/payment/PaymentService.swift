//
//  PaymentService.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/5/10.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation
import CommonCrypto
import Alamofire
public typealias JsonResultSuccess = (NSMutableDictionary) -> ()

let error_Code = "code"
public class PaymentService : NSObject{

    private var elaWalletService = ElaService(url : PaymentConfig.elaNodeUrl)
    private var ethWalletService = EthService(url : PaymentConfig.ethNodeUrl)
    
    
    func getServerData(_ url : String,_ param : Dictionary<String, Any>) -> DataRequest{
        var params = param
        let requset = Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: [:])
        
        return requset
    }
    
    func getServerDataByGet(_ url : String,_ param : Dictionary<String, Any>) -> DataRequest{
        var params = param
        let requset = Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: [:])
        return requset
    }
    
    func getDataByServers(_ data : Data) -> NSMutableDictionary{
        var dic : NSMutableDictionary = [:]
        
        do {
            let dics = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            if(dics != nil){
                dic = dics as! NSMutableDictionary
            }
        }
        
        return dic
        
    }
    
    /**
     * @return org.elastos.dma.utility.util.JsonResult
     * @Author YangChuanTong
     * @Description 法币充值ELA
     * @Date 2019/4/28 15:06
     * @Param [response, secret, merchantId, amount, userid, address, notifyURL, callbackURL]
     **/
    public func rechargeELA( secret : String , merchantId : String , amount : String , userId : String , address : String , orderNo: String , notifyURL : String , callbackURL : String,Suceess : @escaping JsonResultSuccess ,Failed : @escaping JsonResultSuccess ){
        let params : NSMutableDictionary = [:]
        params["side"] = Direction.FIAT_TO_ELA
        params.setSortArr(arr: ["side"])
        recharge(params, secret, merchantId, amount, userId, address, orderNo, notifyURL, callbackURL,Suceess, Failed);
    }

    /**
     * @return org.elastos.dma.utility.util.JsonResult
     * @Author YangChuanTong
     * @Description 法币充值DMA
     * @Date 2019/4/28 15:06
     * @Param [response, secret, merchantId, amount, userid, address, notifyURL, callbackURL]
     **/
    public func rechargeDMA(secret : String , merchantId : String , amount : String , userId : String , address : String , orderNo : String , notifyURL : String , callbackURL : String,_ Suceess : @escaping JsonResultSuccess , _ Failed : @escaping JsonResultSuccess ){
        let params : NSMutableDictionary = [:]
        params["side"] = Direction.FIAT_TO_DMA
        params.setSortArr(arr: ["side"])
        recharge(params, secret, merchantId, amount, userId, address, orderNo, notifyURL, callbackURL,Suceess,Failed);
    }

    func paymentMd5(_ params : NSMutableDictionary , _ secret : String) -> String{
        let keys = params.sortArr
        var str = ""
        for keyStr in keys as! [String]{
            str += keyStr + "=" + (params[keyStr] as! String) + "&"
        }
        str += "secretKey=" + secret
        return md5(str)
    }

    func md5(_ string : String) -> String {
        let str = string.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(string.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String)
    }


    private func recharge(_ params : NSMutableDictionary , _ secret : String , _ merchantId : String , _ amount : String, _ userId : String , _ address : String , _ orderNo : String , _ notifyURL : String , _ callbackURL :String,_ Suceess : @escaping JsonResultSuccess ,_ Failed : @escaping JsonResultSuccess ) {
        params["merchantId"] = merchantId
        params["timestamp"] = Date().timeIntervalSince1970
        params["amount"] = amount
        params["userId"] = userId
        params["orderNo"] = orderNo
        params["address"] = address
        params["notifyUrl"] = notifyURL
        params["callbackUrl"] = callbackURL
        params.setSortArr(arr: ["merchantId","timestamp","amount","userId","orderNo","address","notifyUrl","callbackUrl"])
        let sign = paymentMd5(params, secret);
        params["sign"] = sign;
        let url = recharge_url
        let result = getServerData(url, params as! Dictionary<String, Any>);
        result.responseString { (respons) in
            if(respons.result.isSuccess){
                Suceess(self.getDataByServers(respons.data!))
            }else{
                Failed([error_Str:respons.error!])
            }
        }
    }
    
    private func compareTo(_ str1 : String , _ str2 : String) -> Bool{
        let number1 = Double(str1)!
        let number2 = Double(str2)!
        if(number1 < number2){
            return false
        }
        return true
    }


    /**
     * @return org.elastos.dma.utility.util.JsonResult
     * @Author YangChuanTong
     * @Description ela兑换dam
     * @Date 2019/4/29 17:03
     * @Param [secret, merchantId, privateKey, elaValue, dmaAdress, orderNo, notifyURL]
     **/
    public func elaToDma(secret : String , merchantId : String , privateKey: String , _value: String , address : String , orderId : String , userId : String , notifyURL : String ,_ Suceess : @escaping JsonResultSuccess ,_ Failed : @escaping JsonResultSuccess){
    let elaAddress = elaWalletService.exportAddressFromPrivateKey(privateKey: privateKey)
        elaWalletService.getassetbalances(address: elaAddress, success: { (succ) in
            if(!self.compareTo(succ, _value)){
                Failed([error_Str : "Action.UNDERFINANCED"])
                return
            }
            self.elaWalletService.transfer(privateKey: privateKey, to: PaymentConfig.bizElaToDmaAddress, value: _value, success: { (success) in
                let treeMap : NSMutableDictionary = [:];
                treeMap["txid"] = success
                treeMap["side"] = Direction.ELA_TO_DMA
                treeMap.setSortArr(arr: ["txid","side"])
                self.exchange(treeMap: treeMap, secret: secret, merchantId: merchantId, elaValue: _value, dmaAdress: address, orderId: orderId, userId: userId, notifyURL: notifyURL, Suceess, Failed)
            }, Failed: { (erro) in
                Failed([error_Str:"1"])
            })
        }) { (error) in
            Failed([error_Str : error])
        }


    }


    /**
     * @return org.elastos.dma.utility.util.JsonResult
     * @Author YangChuanTong
     * @Description ela兑换dam
     * @Date 2019/4/29 17:03
     * @Param [secret, merchantId, privateKey, elaValue, dmaAdress, orderNo, notifyURL]
     **/
//    public func dmaToEla(secret : String , merchantId : String , privateKey : String , _value : String , address : String , orderId : String , userId : String , notifyURL : String ,_ Suceess : @escaping JsonResultSuccess ,_ Failed : @escaping JsonResultSuccess){
//        let ethAddress = elaWalletService.exportAddressFromPrivateKey(privateKey: privateKey)
//        let balance = ethWalletService.balances(address : ethAddress)
//        if(!compareTo(balance, "0")){
//            Failed([error_Str : "Action.GAS_UNDERFINANCED"])
//            return
//        }
//        let contractBalance = ethWalletService.tokenBalance(contractAddress: ethAddress, owner: PaymentConfig.bizContractAddress)
//        if(!compareTo(contractBalance, _value)){
//            Failed([error_Str : "Action.UNDERFINANCED"])
//            return
//        }
//        let result = ethWalletService.tokenTransfer(contractAddress : PaymentConfig.bizContractAddress ,privatekey: privateKey, to: PaymentConfig.bizDmaToElaAddress, value: _value, gasPrice: PaymentConfig.defaultGasPrice, gasLimit: PaymentConfig.defaultGasLimit)
//        switch result {
//        case .success(let dic):
//            let hash = dic["hash"] as! String
//            let dics : NSMutableDictionary = [:]
//            dics["hash"] = hash
//            dics["side"] = Direction.DMA_TO_ELA
//            dics.setSortArr(arr: ["hash","side"])
//            exchange(treeMap: dics, secret: secret, merchantId: merchantId, elaValue: _value, dmaAdress: address, orderId: orderId, userId: userId, notifyURL: notifyURL, Suceess, Failed)
//        case .failure(let erro):
//            Failed([error_Str : erro])
//        }
//        
////    try {
////    String ethAddress = ethWalletService.exportByPrivateKey(privateKey).getAddress();
////
////    String balance = ethWalletService.balance(ethAddress);
////    if (BigdemicalUtils.compareTo(balance, "0") != 1) {
////    JsonResult.error(Action.GAS_UNDERFINANCED);
////    }
////    String contractBalance = ethWalletService.tokenBalance(ethAddress, PaymentConfig.bizContractAddress);
////    if (BigdemicalUtils.compareTo(contractBalance, _value) != 1) {
////    JsonResult.error(Action.UNDERFINANCED);
////    }
////    if (!elaWalletService.checkAddr(address)) {
////    JsonResult.error(Action.ELA_ADDRESS_ERROR);
////    }
////
////    String hash = ethWalletService.tokenTransfer(PaymentConfig.bizContractAddress, privateKey, PaymentConfig.bizDmaToElaAddress, _value, PaymentConfig.defaultGasPrice, PaymentConfig.defaultGasLimit);
////    //            String hash = "0xb014aaa96462f9a89cf44fb3c583f6e693a07252b9d128637c67fa471732dd64";
////    TreeMap<String, Object> treeMap = new TreeMap<>();
////    treeMap.put("hash", hash);
////    treeMap.put("side", Direction.DMA_TO_ELA.name());
////    return exchange(treeMap, secret, merchantId, _value, address, orderId, userId, notifyURL);
////
////    } catch (Exception e) {
////    e.printStackTrace();
////    }
////    return JsonResult.error(Action.ERROR);
//
//    }


    private  func exchange(treeMap : NSMutableDictionary, secret : String , merchantId : String , elaValue : String , dmaAdress : String , orderId : String , userId : String , notifyURL: String,_ Suceess : @escaping JsonResultSuccess ,_ Failed : @escaping JsonResultSuccess ) {
        treeMap["merchantId"] = merchantId
        treeMap["timestamp"] = Date().timeIntervalSince1970
        treeMap["amount"] = elaValue
        treeMap["address"] = dmaAdress
        treeMap["notifyUrl"] = notifyURL
        treeMap["orderNo"] = orderId
        treeMap["userId"] = userId
        treeMap.setSortArr(arr: ["merchantId","timestamp","amount","address","notifyUrl","orderNo","userId"])
        let sign = paymentMd5(treeMap, secret);
        treeMap["sign"] = sign
        let url = exchange_url;
        let result = getServerData(url, treeMap as! Dictionary<String, Any>);
        result.responseString { (respons) in
            if(respons.result.isSuccess){
                Suceess(self.getDataByServers(respons.data!))
            }else{
                Failed([error_Str:respons.error])
            }
        }
    }

    /**
     * @return org.elastos.dma.utility.util.JsonResult
     * @Author YangChuanTong
     * @Description 根据服务订单号查询订单详情
     * @Date 2019/4/30 16:26
     * @Param [serialNo]
     **/
    public func orderInfo(serialNo : String,_ Suceess : @escaping JsonResultSuccess ,_ Failed : @escaping JsonResultSuccess){
    let url = orderInfo_url + "?serialNo=" + serialNo;
        let result = getServerData(url, [:]);
        result.responseString { (respons) in
            if(respons.result.isSuccess){
                Suceess(self.getDataByServers(respons.data!))
            }else{
                Failed([error_Str:respons.error])
            }
        }

    }

    /**
     * @return org.elastos.dma.utility.util.JsonResult
     * @Author YangChuanTong
     * @Description 订单列表
     * @Date 2019/4/30 16:33
     * @Param [pageNumber, pageSize, user_id, merchantId]
     **/
    private func orderList( _ pageNumber : NSInteger , _ pageSize : NSInteger , _ userId : String? , _ merchantId : String ,_ Suceess : @escaping JsonResultSuccess ,_ Failed : @escaping JsonResultSuccess){
        let url = orderList_url;
        let map : NSMutableDictionary = [:]
        map["pageNumber"] = pageNumber
        map["pageSize"] = pageSize
        map["userId"] = userId
        map["merchantId"] = merchantId
        map.setSortArr(arr: ["pageNumber","pageSize","userId","merchantId"])
        let result = getServerData(url, map as! Dictionary<String, Any>);
        result.responseString { (respons) in
            if(respons.result.isSuccess){
                Suceess(self.getDataByServers(respons.data!))
            }else{
                Failed([error_Str:respons.error])
            }
        }
    }

    /**
     * @return org.elastos.dma.utility.util.JsonResult
     * @Author YangChuanTong
     * @Description 订单列表
     * @Date 2019/4/30 16:34
     * @Param [pageNumber, pageSize, merchantId]
     **/
    public  func orderList(pageNumber : NSInteger, pageSize : NSInteger , merchantId : String,_ Suceess : @escaping JsonResultSuccess , _ Failed : @escaping JsonResultSuccess){
        return orderList(pageNumber, pageSize, nil, merchantId,Suceess,Failed);
    }

    /**
     * @return org.elastos.dma.utility.util.JsonResult
     * @Author YangChuanTong
     * @Description ela与dma兑换详情
     * @Date 2019/4/30 16:36
     * @Param [serialNo]
     **/
    public func exchangeInfo(serialNo : String, _ Suceess : @escaping JsonResultSuccess ,_ Failed : @escaping JsonResultSuccess){
        let url = exchangeInfo_url + "?serialNo=" + serialNo;
        let result = getServerData(url, [:]);
        result.responseString { (respons) in
            if(respons.result.isSuccess){
                Suceess(self.getDataByServers(respons.data!))
            }else{
                Failed([error_Str:respons.error])
            }
        }
    }

    /**
     * @return org.elastos.dma.utility.util.JsonResult
     * @Author YangChuanTong
     * @Description ela与dma兑换记录
     * @Date 2019/4/30 16:36
     * @Param [pageNumber, pageSize, user_id, merchantId]
     **/
    public func exchangeList(pageNumber : NSInteger, pageSize : NSInteger , userId : String , merchantId : String, _ Suceess : @escaping JsonResultSuccess ,_ Failed : @escaping JsonResultSuccess ){
        let url = exchangeList_url;
        let map : NSMutableDictionary = [:]
        map["pageNumber"] = pageNumber
        map["pageSize"] = pageSize
        map["userId"] = userId
        map["merchantId"] = merchantId
        map.setSortArr(arr: ["pageNumber","pageSize","userId","merchantId"])
        let result = getServerData(url, map as! Dictionary<String, Any>);
        result.responseString { (respons) in
            if(respons.result.isSuccess){
                Suceess(self.getDataByServers(respons.data!))
            }else{
                Failed([error_Str:respons.error])
            }
        }
    }

    /**
     * @return org.elastos.dma.utility.util.JsonResult
     * @Author YangChuanTong
     * @Description ela与dma兑换记录
     * @Date 2019/4/30 16:37
     * @Param [pageNumber, pageSize, merchantId]
     **/
    public func exchangeList( pageNumber : NSInteger,  pageSize : NSInteger, merchantId : String,_ Suceess : @escaping JsonResultSuccess , _ Failed : @escaping JsonResultSuccess ){
        orderList(pageNumber, pageSize, nil, merchantId,Suceess,Failed);
    }
}
