//
//  Web3Util.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/9/2.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation
import web3swift
import BigInt

extension String{
    func getWeb3ValueInWei() -> String?{
        let value = NSDecimalNumber(string: self).multiplying(by: NSDecimalNumber(string: defaultGasPrice))
        if let bWeiValue = BigUInt(value.stringValue){
            let value =  Web3.Utils.formatToPrecision(bWeiValue,formattingDecimals : 8)
            return value
        }
       return "0"
    }
    
    func getWeb3WeiInValue() -> String?{
        if let bWeiValue = BigUInt(self){
            let value =  Web3.Utils.formatToEthereumUnits(bWeiValue)
            return value
        }
        return "0"
    }
    
   
}
