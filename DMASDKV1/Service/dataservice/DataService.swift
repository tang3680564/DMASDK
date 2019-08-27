//
//  DataService.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/7/8.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation

open class DataService : AbstractService{
    private var passportService : ProfileService!;
    private var mnemonic : String = "";
    
    required public init(_ mnemonics : String , _ passportServices : ProfileService , _ mediums : StorageMedium, _ accessTokens : String) {
        super.init()
        super.accessToken = accessTokens;
        super.medium = mediums;
        passportService = passportServices;
        mnemonic = mnemonics;
    }
    
    
    required public init(_ mnemonics : String , _ passportServices : ProfileService) {
        mnemonic = mnemonics;
        passportService = passportServices;
    }
    
    
    
    /**
     * 通过此接口更新链上用户的profile
     * @param property
     * @return
     */
    public func update(property : Propertys){
        let didServe = ElaDIDService()
        let privateKey = didServe.exportPrivateKeyFromMnemonics(mnemonics: mnemonic)
        let defaultEnc = DefaultEncipher()
        let value = defaultEnc.encodeValue(privateKey, property.value)
        let dic : NSMutableDictionary = [:]
        dic[property.key] = value
        didServe.setDIDInfo(mnemonic: mnemonic, dic: dic)
    }
    
}
