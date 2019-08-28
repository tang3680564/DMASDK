//
//  MerchantServiceConfig.swift
//  DMASDK
//
//  Created by Zhangxz& on 2019/3/26.
//  Copyright © 2019 Zhangxz&. All rights reserved.
//

import UIKit
import Foundation

public let assetManagementUrl = URL(string: "http://47.105.136.158:20636")
public let defultURL = "http://47.105.136.158:20636"
public let baseUrl = "http://127.0.0.1:9994/api/1.0/payment"

public let recharge_url = baseUrl + "/recharge"
public let orderInfo_url = baseUrl + "/common/orderInfo"
public let orderList_url = baseUrl + "/common/orderList"
public let exchangeInfo_url = baseUrl + "common/exchangeInfo"
public let exchangeList_url = baseUrl + "common/exchangeList"
public let exchange_url = baseUrl + "/exchange"

public let platformWallet = "0x51f56e19f4e2c71fc5ffa4cd25520480c7708030"
public let isBurn = true
public let defaultGasPrice = "10000000000"
public let defaultGasLimit = "6002513"
public let transferGasLimit = "21000" 
//public let reSellGasLimit = "80000"
public let firstExpenses = "50"
public let secondExpenses = "10"
public let expenses = "10"
public let API_URL = "http://dmaconnect.starrymedia.com/api/1.0/"
public let merchainContract = "contract/"
public let merchainSave = "save.do"
public let merchainDeploy = API_URL+merchainContract+merchainSave

public let merchainAsset = "asset/"
public let merchainsaveAsset = "saveAssets.do"
public let merchainMint = API_URL+merchainAsset+merchainsaveAsset

public let merchainshelfRecords = "shelfRecords/"
public let merchainsaveshelfRecords = "saveShelfRecords.do"
public let merchainSale = API_URL+merchainshelfRecords+merchainsaveshelfRecords

public let merchainorderInfo = "orderInfo/"
public let merchainorderInfoDetails = "orderInfoDetails/"

public let merchainosaverderInfo = "saveOrder.do"
public let merchainosaverderInfoJson = "info.json"
public let merchainosaverderInfoList = "all.list"
public let merchainopendingList = "pending.list"

public let merchaincreateorderInfo = API_URL+merchainorderInfo+merchainosaverderInfo
public let merchaingetorderInfo = API_URL+merchainorderInfo+merchainosaverderInfoJson
public let merchaingetorderInfoList = API_URL+merchainorderInfo+merchainosaverderInfoList
public let merchaingetorderInfoDetails = API_URL+merchainorderInfoDetails+merchainosaverderInfoList


public let merchaingetmyContract = API_URL+merchainContract+merchainosaverderInfoList
public let merchaingetshelfRecords = API_URL+merchainshelfRecords+merchainosaverderInfoList
public let merchaingetshelfRecordsDetails = API_URL+merchainshelfRecords+merchainosaverderInfoList

public let merchaingetshelfRecordsPendingDetails = API_URL+merchainshelfRecords+merchainopendingList

public class Config{
    public class Pulses {
        static let MODULE = API_URL + "pulse/";
        public static let ADD = MODULE + "add.do";
    }
    
    public class DataService {
        static let MODULE = API_URL + "dataService/";
        public static let PUSH = MODULE + "push.do";//存储个人数据到数据银行
        //            public static final String PUSH = MODULE + "push.do";//提交行为到DATA bank
        //            public static final String PUSH = MODULE + "push.do";//提交档案数据到DATA bank
        public static let TAGS = MODULE + "tags.page";//查询标签数据从DATA bank
        //            public static final String PUSH = MODULE + "push.do";//查询档案数据从DATA bank
        
        public static let ALL = MODULE + "all.page";//查询所有数据
        public static let SYNC_HISTORY = MODULE + "sync/history.page";//查询已经同步的数据
        public static let UNSYNCHRONIZED = MODULE + "unSynchronized.page";//查询未同步的数据
    }
    
    public class Appraiser {
        static let  MODULE = API_URL + "appraiser/";
        public static let  ALL = MODULE + "dashboard.page";
    }
    
   
    
    
}



