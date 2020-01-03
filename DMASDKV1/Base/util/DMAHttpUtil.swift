//
//  DMAHttpUtil.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/7/4.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation
import Alamofire

let error_Str = "error_Str"

public typealias ServerResultSuccessResult = (NSMutableDictionary) -> ()

public class DMAHttpUtil: NSObject {
    
   
    
    public static func getServerData(url : String,param : Dictionary<String, Any>,Success : @escaping ServerResultSuccessResult,Failed : @escaping ServerResultSuccessResult){
        var params = param
        let requset = Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: [:])
        requset.responseString { (respons) in
            switch respons.result{
            case .success(_):
                let result = getDataByServersInSuccess(respons.data!)
                if(result.0){
                    Success(result.1)
                }else{
                    Failed(result.1)
                }
            case .failure(let erro):
                Failed([error_Str : erro])
            }
        }
    }
    
    public static func getServerDataByGet(url : String,param : Dictionary<String, Any>,Success : @escaping ServerResultSuccessResult,Failed : @escaping ServerResultSuccessResult){
        var params = param
        print(params)
        let requset = Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: [:])
        requset.responseString { (respons) in
            switch respons.result{
            case .success(_):
                let result = getDataByServersInSuccess(respons.data!)
                if(result.0){
                    Success(result.1)
                }else{
                    print("ccccsss")
                    print(url)
                    print(result.1)
                    Failed(result.1)
                }
            case .failure(let erro):
                Failed([error_Str : erro])
            }
        }
    }
    
    public static func getDataByServersInSuccess(_ data : Data) -> (Bool,NSMutableDictionary){
        var dic : NSMutableDictionary = [:]
        
        do {
            let dics = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            if(dics != nil){
                dic = dics as! NSMutableDictionary
            }
        }
        if(dic["code"] as? String == "0" || dic["code"] as? String == "74") || dic["code"] as? Int == 0 || dic["success"] as? Bool == true || dic["status"] as? Int == 200 {
            return (true,dic)
        }else if let dicStatus = dic["status"] as? NSMutableDictionary{
            let error_code = dicStatus["error_code"] as? Int
            if(error_code == 0){
                return (true,dic)
            }else{
                return (false,dic)
            }
        }
        else{
            return (false,dic)
        }
        
        
    }
    
    public static func getServerJsonDic(dic : NSMutableDictionary) -> NSMutableDictionary{
        if let data = dic["data"] as? NSMutableDictionary{
            return data
        }
        return [:]
    }
    
    public static func getError(error : NSMutableDictionary) -> String{
        if let msg = error["msg"] as? String{
            return msg
        }
        return "error"
    }
}
