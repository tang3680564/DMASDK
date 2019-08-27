//
//  AbstractService.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/7/8.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation


open class AbstractService : NSObject{
    
    let ACCESS_TOKEN = "accessToken";
    public var accessToken = "";
    public var medium : StorageMedium!;
    
   
    /**
     * 调用connector服务
     *
     * @param parse 分析后的数据
     * @return
     */
    public func storeToDataBank(parse : RequestBody,Success : @escaping ((ResponseBody) -> Void) , Failed : @escaping ((String) -> Void)){
        var dic = parse.toJSON()!
        dic[ACCESS_TOKEN] = accessToken
        DMAHttpUtil.getServerData(url: Config.DataService.PUSH, param: dic, Success: { (dic) in
            if let data = dic["data"] as? NSMutableDictionary{
                let model = ResponseBody.deserialize(from: data)!
                Success(model)
            }
        }) { (error) in
            if let msg = error["msg"] as? String{
                Failed(msg)
            }else{
                Failed("error")
            }
            
        }
    }
   
    
    /**
     * 提交行为到DATA bank
     * @param parse
     * @return
     */
    public func saveInitDataToDataBank(parse : RequestBody){
       
    }
    
    /**
     * 提交档案数据到DATA bank
     * @param map
     * @return
     */
    public func saveProfileDataToDataBank(did : String,map : Dictionary<String,String>){
        
    }
    
    /**
     * 查询标签数据从DATA bank
     * @param did
     * @return
     */
    public func getLableDataFromDataBank(pageNumber : Int ,pageSize : Int, did : String,Success : @escaping ((Tags) -> Void), Failed : @escaping ((String) -> Void)){
        let dic : NSMutableDictionary = [:]
        dic["accessToken"] = accessToken
        dic["pageNumber"] = pageNumber
        dic["pageSize"] = pageSize
        dic["did"] = did
        DMAHttpUtil.getServerData(url: Config.DataService.TAGS, param: dic as! Dictionary<String, Any>, Success: { (dic) in
            if let data = dic["data"] as? NSMutableDictionary{
                let model = Tags.deserialize(from: data)!
                Success(model)
            }
        }) { (error) in
            if let msg = error["msg"] as? String{
                Failed(msg)
            }else{
                Failed("error")
            }
        }
    }
    
    /**
     * 查询未同步的标签数据从DATA bank
     * @param did
     * @return
     */
    public func getSyncLableDataFromDataBank(pageNumber : Int,pageSize : Int,did : String,Success : @escaping ((DynamicData) -> Void), Failed : @escaping ((String) -> Void)){
        var dic : Dictionary<String,Any> = [:]
        dic["accessToken"] = accessToken
        dic["pageNumber"] = pageNumber
        dic["pageSize"] = pageSize
        dic["did"] = did
        DMAHttpUtil.getServerData(url: Config.DataService.UNSYNCHRONIZED, param: dic, Success: { (dic) in
            let json = DMAHttpUtil.getServerJsonDic(dic: dic)
            let model = DynamicData.deserialize(from: json)!
            Success(model)
        }) { (error) in
            let msg = DMAHttpUtil.getError(error: error)
            Failed(msg)
        }
    }
    
    /**
     * 查询档案数据从DATA bank
     * @param did
     * @return
     */
    public func getProfileDataFromDataBank(){
    
    }
   
}
