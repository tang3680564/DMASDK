//
//  NSMutableDictionary+Extension.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/7/10.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation

extension NSMutableDictionary{
    
    func toJsonString() -> String{
        var str = ""
        weak var weakSelf = self
        if weakSelf == nil{
            return str
        }
        do {
             let data = try JSONSerialization.data(withJSONObject: weakSelf!, options: .sortedKeys)
             str = String(data: data, encoding: String.Encoding.utf8)!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        } catch {
            print(error)
            return str
        }
        return str
    }
}
