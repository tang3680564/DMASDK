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
    
    public  func add(filePath:String) -> String {
        let ipfs = IpfsStorage()
        ipfs.url = url
        ipfs.port = port
        return ipfs.add(filePath: filePath)
    }
    public   func add(fileData:Data) -> String {
        let ipfs = IpfsStorage()
        ipfs.url = url
        ipfs.port = port
        return ipfs.add(fileData:fileData)
    }
    public   func getBytes(hash:String) -> Array<UInt8> {
        let ipfs = IpfsStorage()
        ipfs.url = url
        ipfs.port = port
        return ipfs.getBytes(hash:hash)
    }
    public  func getString(hash:String) -> String{
        let ipfs = IpfsStorage()
        ipfs.url = url
        ipfs.port = port
        return ipfs.getString(hash:hash)
    }
    
}
