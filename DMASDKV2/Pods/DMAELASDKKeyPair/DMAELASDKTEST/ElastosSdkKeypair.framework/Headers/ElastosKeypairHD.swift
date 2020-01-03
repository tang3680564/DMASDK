//
//  ElastosKeypair.swift
//  lib
//
//  Created by mengxk on 2018/11/3.
//  Copyright © 2018 Elastos. All rights reserved.
//

import Foundation

open class ElastosKeypairHD {
  private init() {}
  
  public static let EXTERNAL_CHAIN = 0;
  public static let INTERNAL_CHAIN = 1;
  
  public static let COIN_TYPE_ELA = 0;

  
  public static func GetMasterPublicKey(seed: Data, seedLen: Int, coinType: Int) -> Data? {
    var masterPubKeyLen: Int32 = 0
    let masterPubKey = AbstractLayer.GetMasterPublicKey(seed: seed, seedLen: Int32(seedLen), coinType: Int32(coinType),
                                                        masterPubKeyLen: &masterPubKeyLen)
    
    return masterPubKey
  }
  
  public static func GenerateSubPrivateKey(seed: Data, seedLen: Int,
                                           coinType: Int, chain: Int, index: Int) -> String? {
    let subPrivKey = AbstractLayer.GenerateSubPrivateKey(seed: seed, seedLen: Int32(seedLen),
                                                         coinType: Int32(coinType),
                                                         chain: Int32(chain), index: Int32(index))
    return subPrivKey
  }
  
  public static func GenerateSubPublicKey(masterPublicKey: Data, chain: Int, index: Int) -> String? {
    let subPubKey = AbstractLayer.GenerateSubPublicKey(masterPublicKey: masterPublicKey,
                                                       chain: Int32(chain), index: Int32(index))
    return subPubKey
  }
}
