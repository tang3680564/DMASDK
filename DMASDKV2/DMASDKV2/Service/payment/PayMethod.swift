//
//  PayMethod.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/5/10.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation

enum PayMethod : String {
    case ALIPAY
    case WECHAT
    case UNION_PAY
}

var myNameKey = 1

extension NSMutableDictionary{
    public var sortArr : NSMutableArray {
        get{
            if let rs = objc_getAssociatedObject(self, &myNameKey) as? NSMutableArray {
                return rs
            }
            return NSMutableArray()
        }
        set{
            objc_setAssociatedObject(self, &myNameKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setSortArr(arr : Array<String>){
        if(sortArr.count == 0){
            sortArr = NSMutableArray(array: arr)
        }else{
            for str in arr{
                if(!sortArr.contains(str)){
                    sortArr.add(str)
                }
            }
            
        }
        
    }
    
    
}
