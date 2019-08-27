//
//  AppIdEncipher.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/7/4.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation


open class AppIdEncipher: NSObject,Encipher {
    
    var appId = ""
    
    required public init(appIds : String) {
        super.init()
        appId = appIds
    }
    
    func encodeValue(_ secretKey: String, _ source: String) -> String {
        return EncipherUtil.Endcode_AES_ECB(strToEncode: source, key: genSecretKey(secretKey))
    }
    
    func decodeValue(_ secretKey: String, _ cipherText: String) -> String {
        return EncipherUtil.Decode_AES_ECB(strToDecode: cipherText, key: genSecretKey(secretKey))
    }
    
    func encodeKey(_ key: String) -> String {
        return appId + "." + key;
    }
    
    func decodeKey(_ key: String) -> String {
        return (key as NSString).substring(to: appId.count + 1);
    }
    
    func genSecretKey(_ key: String) -> String {
        return EncipherUtil.MD5(appId + key);
    }
    
    
}
