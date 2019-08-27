//
//  DynamicData.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/7/8.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation
import HandyJSON

open class DynamicData : HandyJSON{
    /**
     * 数据源
     */
    var did : String = "";
    /**
     * 什么应用产生的
     */
    var appId :String = "";
    /**
     * 数据
     */
    var  data : String = "";
    
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
    
    
    /**
     * 同步的状态
     */
    var syncFlag : Bool = false  ;
    
    required public init() {}
}
