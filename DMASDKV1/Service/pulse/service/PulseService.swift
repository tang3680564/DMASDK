//
//  PulseClient.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/7/4.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation


open class PulseService: NSObject {
    
    private let dataService : DataService!;
    private let parser : Parser!;
	
    required public init(mnemonic : String , profileService : ProfileService,accessToken : String) {
        parser = Parser(mnemonic: mnemonic, profileService: profileService, accessToken: accessToken)
        dataService = DataService(mnemonic, profileService, StorageMedium.DEFAULT, accessToken)
    }
    
    /**
     * 提交用户行为数据
     *
     * @param entry
     * @return
     */
    public func pulse(entry : RequestBody,Success : @escaping ((ResponseBody) -> Void) , Failed : @escaping ((String) -> Void)){
        dataService.storeToDataBank(parse: entry, Success: Success, Failed: Failed)
    }
    
    
}
