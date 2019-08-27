//
//  ElastosKeypair.swift
//  lib
//
//  Created by mengxk on 2018/11/3.
//  Copyright © 2018 Elastos. All rights reserved.
//

import Foundation

open class ElastosKeypair {
  private init() {}
  
  
  public static func GetSinglePublicKey(seed: Data, seedLen: Int) -> String? {
    let pubKey = AbstractLayer.GetSinglePublicKey(seed: seed, seedLen: seedLen)
    return pubKey
  }
  
  public static func GetSinglePrivateKey(seed: Data, seedLen: Int) -> String? {
    let privKey = AbstractLayer.GetSinglePrivateKey(seed: seed, seedLen: seedLen)
    return privKey
  }
  
  public static func GetPublicKeyFromPrivateKey(privateKey: String) -> String? {
    let pubKey = AbstractLayer.GetPublicKeyFromPrivateKey(privateKey: privateKey)
    return pubKey
  }
  
  public static func GenerateMnemonic(language: String, words: String?) -> String? {
    let mnemonic = AbstractLayer.GenerateMnemonic(language: language, words: words)
    return mnemonic
  }
  
  public static func GetAddress(publicKey: String) -> String? {
    let address = AbstractLayer.GetAddress(publicKey: publicKey)
    return address
  }

  public static func IsAddressValid(address: String) -> Bool {
    let valid = AbstractLayer.IsAddressValid(address: address)
    return valid
  }

  public static func GetSeedFromMnemonic(seed: inout Data,
                                         mnemonic: String,
                                         language: String, words: String?,
                                         mnemonicPassword: String) -> Int {
    let seedLen = AbstractLayer.GetSeedFromMnemonic(seed: &seed,
                                                    mnemonic: mnemonic,
                                                    language: language,
                                                    words: words,
                                                    mnemonicPassword: mnemonicPassword)
    return seedLen
  }
  
  public static func Sign(privateKey: String?, data: Data, len: Int, signedData: inout Data) -> Int {
    let signedDataLen = AbstractLayer.Sign(privateKey: privateKey,
                                           data: data,
                                           len: len,
                                           signedData: &signedData)
    
    return signedDataLen
  }
    
  public static func Verify(publicKey: String?, data: Data, len: Int, signedData:Data,signedLen:Int) -> Bool {
    let verifyResult = AbstractLayer.Verify(publicKey: publicKey,
                                            data: data,
                                            len: len,
                                            signedData: signedData,
                                            signedLen: signedLen)

    return verifyResult
  }
}
