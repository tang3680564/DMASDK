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

class ModelType2: HandyJSON {
    var a :String?
    required init() {}
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &a, name: "0")
    }
}
class ModelType1: HandyJSON {
    var _name :String?
    var _symbol :String?
    var _metadata :String?
    var _owner :String?
    var _isBurn :String?
    
    var _user :String?
    var _isTransfer:String?
    var _status:String?
    var _uri:String?
    var _vaild:String?
    
    var _remaining:String?
    var _balance:String?
    var _decimals:String?
    var _totalSupply:String?
    
    
    var _tId:String?
    var _value:String?
    var _cnt:String?
    
    var _paedgeValue : String?
    var _pledgeAddress : String?
    required init() {}
    func mapping(mapper: HelpingMapper) {
    }
}
