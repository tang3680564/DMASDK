//
//  TicketOrderInfo.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/10/18.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation
import HandyJSON

public class TicketOrderInfo : HandyJSON{
    ///资产地址
    public var contractAddress : String?
    ///交易发起者
    public var from : String?
    ///交易目标着
    public var to : String?
    ///合约名字
    public var name : String?
    ///订单金额
    public var orderPrice : String?
    ///订单状态
    public var orderStatus : String?
    ///数量
    public var quantity : String?
    ///托管地址
    public var trustAddress : String?
    ///交易创建时间
    public var createTime : String?
    ///交易状态
    public var status : String?
    
    public var orderItems : Array<orderTokenInfo>?
    
    public required init() {
        
    }
}

public class orderTokenInfo : HandyJSON{
    
    public var contractAddress : String?
    
    public var from : String?
    
    public var to : String?
    
    public var quantity : String?
    
    public var name : String?
    
    public var level : String?
    
    public var orderPrice : String?
    
    public var trustAddress : String?
    
    public var tokenId : String?
    
    public var createTime : String?
    
    public required init() {
        
    }
}
