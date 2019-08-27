//
//  Appraiser.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/7/4.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation
import HandyJSON

open class Appraiser : HandyJSON{
    var did : String?
    var appId : String?
    var category : String?;
    var type : String?;
    var appName : String?;
    /**
     * 统计字段
     */
    var total : CLong?;
    
    required public init() {}
}
