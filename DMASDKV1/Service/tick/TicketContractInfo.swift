//
//  TicketContractInfo.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/10/16.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation
import HandyJSON

public class TicketContractInfo : HandyJSON {
    
    public var dmaTag = "DMA_Ticket";//固定字段，标识DMA票务类型。
    //开始时间
    public var startTime : Int?
    //结束时间
    public var endTime : Int?
    ///扩展标签，使用者自定义
    public var dmaExtenfTag : String?
    ///门票主题，使用者自定义
    public var title : String?
    ///门票描述，使用者自定义
    public var describe : String?
    ///门票封面图片，使用者自定义
    public var imgUrl : String?
    ///主办地理位置，使用者自定义
    public var position : String?
    ///类型，使用者自定义
    public var type : String?
    ///扩展json，使用者自定义
    public var json : String?
    ///地址
    public var location : String?
    ///发行总量
    public var totalSupply : String?
    
    public required init() {
    }
}
