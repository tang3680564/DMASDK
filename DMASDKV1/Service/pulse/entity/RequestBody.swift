//
//  RequestBody.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/7/4.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation
import HandyJSON

open class RequestBody : HandyJSON{
    /**
     * 原文
     */
    var data : Any? ;
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
    var category : String = "" ;
    
    var did : String = "" ;
    
    required public init() {}
}
