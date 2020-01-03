//
//  ElastosKeypair.swift
//  lib
//
//  Created by mengxk on 2018/11/3.
//  Copyright © 2018 Elastos. All rights reserved.
//

import Foundation

open class ElastosKeypairSign {
  private init() {}
  
  public static func GenerateRawTransaction(transaction: String) -> String? {
    let rawTx = AbstractLayer.GenerateRawTransaction(transaction: transaction)
    return rawTx
  }
  
  public static func GetMultiSignAddress(publicKeys: [String], length: Int,
                                         requiredSignCount: Int) -> String? {
    let multiSignAddr = AbstractLayer.GetMultiSignAddress(publicKeys: publicKeys,
                                                          length: Int32(length),
                                                          requiredSignCount: Int32(requiredSignCount))
    return multiSignAddr
  }
  
  public static func MultiSignTransaction(privateKey: String, publicKeys: [String], length: Int,
                                          requiredSignCount: Int,
                                          transaction: String) -> String? {
    let multiSignTx = AbstractLayer.MultiSignTransaction(privateKey: privateKey,
                                                         publicKeys: publicKeys,
                                                         length: Int32(length),
                                                         requiredSignCount: Int32(requiredSignCount),
                                                         transaction: transaction)
    return multiSignTx
  }
  
  public static func SerializeMultiSignTransaction(transaction: String) -> String? {
    let serialMultiSignTx = AbstractLayer.SerializeMultiSignTransaction(transaction: transaction)
    return serialMultiSignTx
  }
  
  public static func GetSignedSigners(transaction: String, outLen: inout Int) -> [String]? {
    var signerLen : Int32 = 0
    let signerArray = AbstractLayer.GetSignedSigners(transaction: transaction, outLen: &signerLen)
    outLen = Int(signerLen)
    return signerArray
  }
}
