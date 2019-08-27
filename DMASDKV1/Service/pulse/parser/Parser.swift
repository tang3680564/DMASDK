//
//  Parser.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/7/8.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation


open class Parser : NSObject{
    private let PATH_SEPARATOR = ".";
    private var mnemonic = "";
    private var dataService : DataService!;
    private var profileService : ProfileService!;
    
    required public init(mnemonic : String,profileService : ProfileService,accessToken : String) {
        dataService = DataService(mnemonic, profileService, StorageMedium.DEFAULT, accessToken);
        self.profileService = profileService;
        self.mnemonic = mnemonic;
    }
    
    public func parse(entry : RequestBody) -> ParserResult{
        let parserResult = ParserResult()
        parserResult.category = entry.category
        parserResult.did = entry.did
        parserResult.tag = entry.tag
        parserResult.type = entry.type
        return parserResult
    }
    
    private func addNewKey(key : String, result : NSMutableArray,parserResult : ParserResult){
        let e = Propertys();
        e.key = key
        e.value = parserResult.toJSONString()!
        result.add(e)
    }
    
    private func genAnchorPoint(entry : RequestBody) -> String{
        return entry.did + PATH_SEPARATOR + entry.category + PATH_SEPARATOR + entry.type + PATH_SEPARATOR + entry.tag + PATH_SEPARATOR
    }

    
}





