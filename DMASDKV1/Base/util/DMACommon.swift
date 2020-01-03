//
//  DMACommon.swift
//  DMASDK
//
//  Created by Zhangxz& on 2019/3/20.
//  Copyright © 2019 Zhangxz&. All rights reserved.
//
import Foundation
import UIKit
import web3swift
import HandyJSON



let elakBaseUrl = "/api/v1/"

//根据块号获取txid
let elablocktransactionsheight = elakBaseUrl + "block/transactions/height/"
//根据块号获取块信息
let elablockdetailsheight = elakBaseUrl + "block/details/height/"
//根据块hash获取块信息
let elablockdetailshash = elakBaseUrl + "block/details/hash/"
//获取当前块高度
let elablockheight = elakBaseUrl + "block/height"
//根据txid获取交易信息
let elatransaction = elakBaseUrl + "transaction/"
//根据地址获取余额
let elaassetbalances = elakBaseUrl + "asset/balances/"
//根据地址获取utxo
let eleaassetutxos = elakBaseUrl + "asset/utxos/"
//根据地址获取utxo
let elarawtransaction = elakBaseUrl + "transaction"


public enum ContractResult {
    case success(value:Dictionary<String, Any>)
    case failure(error:Any)
}

public class ModelType2: HandyJSON {
    var a :String?
    required public init() {}
    public func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &a, name: "0")
    }
}
public class ModelType1: HandyJSON {
    public var _name :String?
    public var _symbol :String?
    public var _metadata :String?
    public var _owner :String?
    public var _isBurn :String?
    
    public var _user :String?
    public var _isTransfer:String?
    public var _status:String?
    public var _uri:String?
    public var _vaild:String?
    
    public var _remaining:String?
    public var _balance:String?
    public var _decimals:String?
    public var _totalSupply:String?
    
    
    public var _tId:String?
    public var _value:String?
    public var _cnt:String?
    
    public var _paedgeValue : String?
    public var _pledgeAddress : String?
    required public init() {}
    public func mapping(mapper: HelpingMapper) {
    }
}


extension NSObject{
    public func getGasLimInResult(result : ContractResult) -> (Bool,String,Any?){
        switch result {
        case .success(value: let dic):
            return (true,dic["gas"] as! String,nil)
        case .failure(error: let error):
            return (false,"",error)
        }
    }
    
    public func limAndPriceIsEmpty(gasLimit : inout String,gasPrice : inout String){
        if gasLimit.isEmpty{
            gasLimit = defaultGasLimit
        }
        if gasPrice.isEmpty{
            gasPrice = defaultGasPrice
        }
    }
    
    public func limIsEmpty(gasLimit : inout String,gasPrice : inout String,getGasFee : inout Bool,result : ContractResult) -> ContractResult?{
        if gasLimit.isEmpty{
            limAndPriceIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice)
            let limt = getGasLimInResult(result: result)
            if limt.0 {
                gasLimit = limt.1
                getGasFee = false
            }else{
                return ContractResult.failure(error: limt.2)
            }
        }
        return nil
    }
}
