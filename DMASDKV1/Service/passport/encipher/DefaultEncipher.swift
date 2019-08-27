//
//  DefaultEncipher.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/7/4.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation


open class DefaultEncipher : NSObject,Encipher{
    func encodeValue(_ secretKey: String, _ source: String) -> String {
        return EncipherUtil.Endcode_AES_ECB(strToEncode: source, key: secretKey)
    }
    
    func decodeValue(_ secretKey: String, _ cipherText: String) -> String {
        return EncipherUtil.Decode_AES_ECB(strToDecode: cipherText, key: secretKey)
    }
    
}
