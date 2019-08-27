//
//  Property.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/7/8.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation
import HandyJSON

open class Propertys : HandyJSON {
    var  key : String = "";
    var  value : String  = "";
    var  status : Status?;
    required public init() {}
    
    public enum Status : String{
        case normal
        case deprecated
        case all
    }
    
}



