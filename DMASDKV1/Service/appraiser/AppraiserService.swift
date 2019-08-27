//
//  AppraiserClient.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/7/4.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation


open class AppraiserService : NSObject{
    
    public func info(accessToken : String,pageNumber : Int ,pageSize : Int,did : String,tag : String,type: String,category : String,Success : @escaping ServerResultSuccessResult , Failed : @escaping ServerResultSuccessResult){
        var dic : Dictionary<String,Any> = [:]
        dic["accessToken"] = accessToken
        dic["pageNumber"] = pageNumber
        dic["pageSize"] = pageSize
        dic["did"] = did
        dic["tag"] = tag
        dic["type"] = type
        dic["category"] = category
        DMAHttpUtil.getServerData(url: Config.Appraiser.ALL, param: dic, Success: Success, Failed: Failed)
    }
}
