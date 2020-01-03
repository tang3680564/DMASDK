//
//  ElastosKeypair.swift
//  lib
//
//  Created by mengxk on 2018/11/3.
//  Copyright © 2018 Elastos. All rights reserved.
//

import Foundation

open class ElastosKeypairCrypto {
  private init() {}

  public static func EciesEncrypt(publicKey: String, plainText: String) -> String? {
    let cipherText = AbstractLayer.EciesEncrypt(publicKey: publicKey, plainText: plainText)
    return cipherText
  }

  public static func EciesDecrypt(privateKey: String, cipherText: String) -> String? {
    let plainText = AbstractLayer.EciesDecrypt(privateKey: privateKey, cipherText: cipherText)
    return plainText
  }
}
