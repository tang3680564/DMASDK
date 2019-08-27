//
//  Tags.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/7/8.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation
import HandyJSON

open class Tags : HandyJSON{
    
    /**
     * 数据源
     */
    var did : String = "";
    /**
     * 什么应用产生的
     */
    var appId : String = "";
    
    /**
     * 计数器
     */
    var count : Int = 0;
    
    /**
     * 数据标签,用于检索
     */
    var tag : String = "";
    /**
     * 数据类型
     */
    var type : String = "";
    /**
     * 分类
     */
    var category : String = "";
    
    
    required public init() {
    }
}
