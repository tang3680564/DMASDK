//
//  Encipher.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/7/4.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation
import CryptoSwift
import CommonCrypto

protocol Encipher {
    
    func encodeValue(_ secretKey : String, _ source : String) -> String;
    
    func decodeValue(_ secretKey : String, _ cipherText : String) -> String;
    
}

class EncipherUtil : NSObject{
    public static func Endcode_AES_ECB(strToEncode:String,key : String)->String {
        // 从String 转成data
        let data = strToEncode.data(using: String.Encoding.utf8)
        
        // byte 数组
        var encrypted: [UInt8] = []
        do {
            
            encrypted = try AES(key: Padding.zeroPadding.add(to: key.bytes, blockSize: 16), blockMode: ECB(), padding: .pkcs5).encrypt(data!.bytes)
            
        } catch {
        }
        
        let encoded =  Data(encrypted)
        //加密结果要用Base64转码
        return encoded.toHexString()
    }
    
    //  MARK:  AES-ECB128解密
    public static func Decode_AES_ECB(strToDecode:String,key : String)->String {
        //decode base64
        let data = Data(hex: strToDecode) as NSData
        // byte 数组
        var encrypted: [UInt8] = []
        let count = data.length
        
        // 把data 转成byte数组
        for i in 0..<count {
            var temp:UInt8 = 0
            data.getBytes(&temp, range: NSRange(location: i,length:1 ))
            encrypted.append(temp)
        }
        
        // decode AES
        var decrypted: [UInt8] = []
        do {
            decrypted = try AES(key: Padding.zeroPadding.add(to: key.bytes, blockSize: 16), blockMode: ECB(), padding: .pkcs5).decrypt(encrypted)
            
        } catch {
        }
        
        // byte 转换成NSData
        let encoded = Data(decrypted)
        var str = ""
        //解密结果从data转成string
        str = String(bytes: encoded.bytes, encoding: .utf8)!
        return str
    }
    
    static func MD5(_ string : String) -> String {
        let str = string.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(string.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String)
    }
}
