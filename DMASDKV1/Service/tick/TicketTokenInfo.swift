//
//  TicketTokenInfo.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/10/16.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation
import HandyJSON

public class TicketTokenInfo : HandyJSON{
    //开始时间
    public var startTime : Int?
    //结束时间
    public var endTime : Int?
    //门票标签
    public var ticketTag : String?
    //门票类型
    public var ticketType : String?
    //门票定价
    public var price : Double?
    //扩展json
    public var json : String?
    
    public var tokenID : String?
    
    public required init() {
    }
}
