//
//  ElastosWallet.swift
//  lib
//
//  Created by mengxk on 2018/11/3.
//  Copyright © 2018 Elastos. All rights reserved.
//

import Foundation

open class ElastosWalletSDK  {
    private init() {}
    
//    private static let Ela_Language = ["zh":"chinese","es":"spanish","en":"english","fr":"french","ja":"japanese"]
//    public static func GenerateMnemonic(language: String = "en")->String{
//         
//        let lang = detectLang(Lang: language)
//        return GenerateMnemonic(language: Ela_Language[lang]!, words: getWords(Language: lang)) ?? ""
//        
//    }
//    
//    public static func GenerateMnemonic(language: String, words: String?) -> String? {
//        
//        //Get menmonic
//        let mnemonic = AbstractLayer.IdentityManager.GetMnemonic(language: language, words: words)
//        return mnemonic
//    }
//    
//    public static func GenerateSeed(mnemonic:String,language: String = "en",mnemonicPassword: String = "")->String{
//        
//        let lang = detectLang(Lang: language)
//        return GenerateSeed(mnemonic:mnemonic,language: Ela_Language[lang]!, words: getWords(Language: lang),mnemonicPassword:mnemonicPassword) ?? ""
//    }
//    
//    public static func GenerateSeed(mnemonic:String,language: String,words:String, mnemonicPassword: String?) -> String? {
//        
//        //Get menmonic
//        let seed = AbstractLayer.IdentityManager.GetSeed(mnemonic: mnemonic, language: language, words: words, mnemonicPassword: mnemonicPassword)
//        return seed
//    }
//    
//    public static func GetSignInfo(path:String,url:String,seed:String,jsonData:String) ->String? {
//        
//        //Get SignInfo
//        let signInfo = AbstractLayer.IdentityManager.GetSignInfo(path:path,url:url,seed:seed,jsonData:jsonData)
//        return signInfo
//        
//    }
//    
//    public static func GetInfo(path:String,seed:String,key:String) ->String? {
//        
//        //Get SignInfo
//        let info = AbstractLayer.IdentityManager.GetInfo(path:path,seed:seed,key:key)
//        return info
//        
//    }
//    
//    private static func detectLang(Lang:String)->String{
//        
//        switch String(describing: Lang) {
//        case "zh-Hans-US","zh-Hans-CN","zh-Hant-CN","zh-TW","zh-HK","zh-Hans","zh":
//            return "zh"
//        case "es":
//            return "es"
//        case "fr":
//            return "fr"
//        case "ja":
//            return "ja"
//        default:
//            return "en"
//        }
//    }
//    
//    private static func getWords(Language: String = "en")->String{
//        
//        let path = Bundle.main.path(forResource: detectLang(Lang: Language) + "-BIP39Words",ofType: "txt")
//        let mWords = try!String.init(contentsOf: URL.init(fileURLWithPath: path!), encoding: String.Encoding.utf8)
//        return mWords
//        
//    }
    
}

