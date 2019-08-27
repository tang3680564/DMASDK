//
//  ProfileService.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/7/8.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation


open class ProfileService : NSObject{
    
    let didServes = ElaDIDService()

    /**
     * 设置代理did信息
     *
     * @param didPrivateKey did私钥
     * @param payPrivateKey 交易费用私钥
     * @param keyMap        信息
     * @return todo 代理付费
     */
    
   
    public func setAgentInfo(mnemonic : String,payPrivateKey : String,keyMap : NSMutableDictionary){
        didServes.setDIDInfo(mnemonic: mnemonic, dic: keyMap)
    }
    
    /**
     * 设置加密代理did信息
     *
     * @param didPrivateKey
     * @param payPrivateKey
     * @param keyMap
     * @return todo 代理付费
     */
    
    public func setEncryptionAgentInfo(mnemonic : String,payPrivateKey : String,map : NSMutableDictionary){
        let dics = NSMutableDictionary(dictionary: map)
        let appEncy = DefaultEncipher()
        let privatKey = didServes.exportPrivateKeyFromMnemonics(mnemonics: mnemonic)
        for key in map.allKeys{
            let values = "\(map[key]!)"
            let encyValues = appEncy.encodeValue(privatKey, values)
            dics[key] = encyValues
        }
        didServes.setDIDInfo(mnemonic: mnemonic, dic: dics)
    }
    
    /**
     * 根据txid 、key获取代理信息
     *
     * @param txid
     * @param key
     * @return
     */
    
    public func getAgentInfoByTxid(txid : String,key : String,Success : @escaping ((Propertys) -> Void), Falied : @escaping ServerResultSuccessResult){
        didServes.getDIDInfoByTxId(txid: txid, Success: { (dic) in
            let model = Propertys()
            model.key = key
            if let values = dic[key] as? String{
                model.value = values
            }else{
                model.value = ""
            }
            Success(model)
        }) { (error) in
            Falied(error)
        }
    }
    
    /**
     * 删除key属性
     *
     * @param privateKey did私钥
     * @param key
     * @return
     */
    
    public func deleteAgentInfo(mnemonic : String,key : String){
        didServes.setDIDInfo(mnemonic: mnemonic, dic: [key:""])
    }
    
    
    /**
     * 修改代理did信息
     *
     * @param mnemonic 助记词
     * @param key           修改key
     * @param propertie     修改属性
     * @return
     */
    
    
    public func updateAgentInfo(mnemonic : String,key : String,propertie : String){
        didServes.setDIDInfo(mnemonic: mnemonic, dic: [key : propertie])
    }
    
    /**
     * 根据txid、key获取加密代理信息
     *
     * @param txid
     * @param privateKey
     * @param key
     * @return
     */
    
    public func getEncryptionAgentInfoByTxid(txid : String,privateKey : String,key : String,Success : @escaping ((Propertys) -> Void), Falied : @escaping ServerResultSuccessResult){
        didServes.getDIDInfoByTxId(txid: txid, Success: { (dic) in
            let ency = DefaultEncipher()
            let model = Propertys()
            for key in dic.allKeys{
                let values = "\(dic[key]!)"
                model.key = "\(key)"
                model.value = ency.decodeValue(privateKey, values)
            }
            Success(model)
            
        }) { (error) in
            Falied(error)
        }
    }
    
    /**
     * 根据did、key获取代理信息
     *
     * @param did
     * @param propertyKey
     * @return
     */
    public func getDIDInfoByKeys(did : String, propertyKey : Array<String>,Success : @escaping ServerResultSuccessResult,Falied : @escaping ServerResultSuccessResult){
        didServes.getDIDInfo(didAddress: did, Success: { (dic) in
            let modelDic : NSMutableDictionary = [:]
            for str in propertyKey{
                if let values = dic[str] as? String{
                    modelDic[str] = values
                }else{
                    modelDic[str] = ""
                }
            }
            Success(modelDic)
        }) { (error) in
            Falied(error)
        }
    }
    
    /**
     * 根据did获取所以代理信息
     *
     * @param did did
     * @return
     */
    
    public func getAllAgentInfo(did : String,Success : @escaping ServerResultSuccessResult,Falied : @escaping ServerResultSuccessResult){
        didServes.getDIDInfo(didAddress: did, status: Propertys.Status.all, Success: Success, Failed: Falied)
    }
    
    /**
     * 根据did获取所以正常使用的代理信息
     *
     * @param did did
     * @return
     */
    public func getNormalAgentInfo(did : String,Success : @escaping ServerResultSuccessResult,Falied : @escaping ServerResultSuccessResult){
        didServes.getDIDInfo(didAddress: did, status: Propertys.Status.normal, Success: Success, Failed: Falied)
    }
    
    /**
     * 根据did获取所有已注销的代理信息
     *
     * @param did
     * @return
     */
    
    public func getDeprecatedAgentInfo(did : String,Success : @escaping ServerResultSuccessResult,Falied : @escaping ServerResultSuccessResult){
        didServes.getDIDInfo(didAddress: did, status: Propertys.Status.deprecated, Success: Success, Failed: Falied)
    }
    
    
    /**
     * 根据did、key获取代理信息
     *
     * @param did did
     * @param key key
     * @return
     */
    
    public func getAgentInfoByKey(did : String, key : String,Success : @escaping ((Propertys) -> Void), Falied : @escaping ServerResultSuccessResult){
        didServes.getDIDInfoByKey(did: did, key: key, Success: { (dic) in
            let model = Propertys()
            for key in dic.allKeys{
                let values = "\(dic[key]!)"
                model.key = "\(key)"
                model.value = values
            }
            Success(model)
        }) { (error) in
            Falied(error)
        }
    }
    
    
    /**
     * 根据did、key获取加密代理信息
     *
     * @param did        did
     * @param privateKey 私钥
     * @param key        key
     * @return
     */
    public func getEncryptionAgentInfoByKey(did : String , privateKey : String , key : String,Success : @escaping ((Propertys) -> Void), Falied : @escaping ServerResultSuccessResult){
        didServes.getDIDInfoByKey(did: did, key: key, Success: { (dic) in
            let ency = DefaultEncipher()
            let model = Propertys()
            for key in dic.allKeys{
                let values = "\(dic[key]!)"
                model.key = "\(key)"
                model.value = ency.decodeValue(privateKey, values)
            }
            Success(model)
        }) { (error) in
            Falied(error)
        }
    }
    
   
    
    /**
     * 根据txid获取json信息
     *
     * @param txid txid
     * @return
     */
    public func getJsonInfoByTxid(txid : String,Success : @escaping ServerResultSuccessResult,Failed : @escaping ServerResultSuccessResult){
        
        didServes.getDIDInfoByTxId(txid: txid, Success: Success, Failed: Failed)
    }
    
    public func getAgentInfoByDIDAndStatus(did : String,status : Propertys.Status,Success : @escaping ((Propertys) -> Void),Failed : @escaping ((String) -> Void)){
        let didServes = ElaDIDService()
        didServes.getDIDInfo(didAddress: did, status: status, Success: { (dic) in
            let model = Propertys.deserialize(from: dic)!
            Success(model)
        }) { (error) in
            Failed("error")
        }
    }
    
    
    public func saveInitDataToDataBank(mnemonic : String,accessToken : String){
        let dataService = DataService(mnemonic, self, StorageMedium.DEFAULT, accessToken)
    }
    
    
    public func saveProfileDataToDataBank(did : String, map : Dictionary<String,String>) -> ResponseBody{
        return ResponseBody()
    }
    
    public func getLableDataFromDataBank(accessToken : String,pageNumber : Int ,pageSize : Int,did : String,mnemonic : String,Success : @escaping ((Tags) -> Void), Failed : @escaping ((String) -> Void)){
        let dataService = DataService(mnemonic, self, StorageMedium.DEFAULT, accessToken)
        dataService.getLableDataFromDataBank(pageNumber: pageNumber, pageSize: pageSize, did: did, Success: Success, Failed: Failed)
    }
    
    public func getSyncLableDataFromDataBank(accessToken : String,pageNumber : Int,pageSize : Int,did : String,mnemonic : String,Success : @escaping ((DynamicData) -> Void), Failed : @escaping ((String) -> Void)){
        let dataService = DataService(mnemonic, self, StorageMedium.DEFAULT, accessToken)
        dataService.getSyncLableDataFromDataBank(pageNumber: pageNumber, pageSize: pageSize, did: did, Success: Success, Failed: Failed)
    }
    
    public func getProfileDataFromDataBank(did : String) -> ResponseBody{
        return ResponseBody()
    }
    
    public func saveInitDataToDataBank(parse : RequestBody) -> ResponseBody{
        return ResponseBody()
    }
}
