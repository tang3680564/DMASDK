//
//  ElastosKeypair.swift
//  lib
//
//  Created by mengxk on 2018/11/3.
//  Copyright © 2018 Elastos. All rights reserved.
//

import Foundation

open class ElastosKeypairDID {
  private init() {}

  public static func GetDid(publicKey: String) -> String? {
    let address = AbstractLayer.GetDid(publicKey: publicKey)
    return address
  }
}
