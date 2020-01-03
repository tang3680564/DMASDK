//
//  IpfsService.swift
//  DMASDK
//
//  Created by Zhangxz& on 2019/3/25.
//  Copyright © 2019 Zhangxz&. All rights reserved.
//

import Foundation

open class IpfsService: NSObject {
    
    public var url:String?
    public var port:String?
    
    required public init(URL : String , serverPost : String) {
        url = URL
        port = serverPost
    }
    
    
    /// 根据文件路径上传到 ipfs
    ///
    /// - Parameter filePath:  文件路径
    /// - Returns: 存储成功返回的 hash
    
    public  func add(filePath:String) -> String {
        let ipfs = IpfsStorage()
        ipfs.url = url
        ipfs.port = port
        return ipfs.add(filePath: filePath)
    }
    
    /// 存储数据到ipfs
    ///
    /// - Parameter fileData: Data
    /// - Returns: 存储成功返回的 hash
    public   func add(fileData:Data) -> String {
        let ipfs = IpfsStorage()
        ipfs.url = url
        ipfs.port = port
        return ipfs.add(fileData:fileData)
    }
    
    
    /// 根据存储的 hash 获取存储的数据
    ///
    /// - Parameter hash: 存储成功返回的 hash
    /// - Returns: Data数据
    public   func getBytes(hash:String) -> Array<UInt8> {
        let ipfs = IpfsStorage()
        ipfs.url = url
        ipfs.port = port
        return ipfs.getBytes(hash:hash)
    }
    
    /// 根据存储的 hash 获取存储的string
    ///
    /// - Parameter hash: 存储成功返回的 hash
    /// - Returns: string
    public  func getString(hash:String) -> String{
        let ipfs = IpfsStorage()
        ipfs.url = url
        ipfs.port = port
        return ipfs.getString(hash:hash)
    }
    
}
