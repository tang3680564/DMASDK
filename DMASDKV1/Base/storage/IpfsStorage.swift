//
//  IpfsStorage.swift
//  DMASDK
//
//  Created by Zhangxz& on 2019/3/25.
//  Copyright © 2019 Zhangxz&. All rights reserved.
//

import UIKit
import SwiftIpfsApi
import SwiftBase58
import SwiftMultihash

public class IpfsStorage: NSObject {
    var url:String!
    var port:String!

    func add(filePath:String) -> String {
        do {
            let api = try IpfsApi(host: url, port: Int(port)!)
            var b58string:String?
            let group = DispatchGroup()
            group.enter()

            try api.add(filePath) { (m) in
                b58string = b58String((m.first?.hash!)!)
                group.leave()
            }
            group.wait()
            return b58string ?? ""
        } catch {
            return error.localizedDescription
        }
    }
    func add(fileData:Data) -> String {
        do {
            let api = try IpfsApi(host: url, port: Int(port)!)
            let group = DispatchGroup()
            var b58string:String?
            group.enter()
            try api.add(fileData) { (m) in
                b58string = b58String((m.first?.hash!)!)
                group.leave()
            }
            group.wait()
            return b58string ?? ""
        } catch {
            return error.localizedDescription
        }
    }
    func getBytes(hash:String) -> Array<UInt8> {
        let api = try!IpfsApi(host: url, port: Int(port)!)
        var uint8:Array<UInt8> = Array()
        let group = DispatchGroup()
        if let multihash = try?fromB58String(hash){
            group.enter()
            try! api.get(multihash) { (result) in
                uint8 = result
                group.leave()
            }
            group.wait()
        }

        return uint8
    }
    func getString(hash:String) -> String{
        let api = try!IpfsApi(host: url, port: Int(port)!)
        let multihash = try!fromB58String(hash)
        let group = DispatchGroup()
        group.enter()
        var uint8:Array<UInt8>?

        try! api.get(multihash) { (result) in
            uint8 = result
            group.leave()
        }
        group.wait()
        return String.init(bytes: uint8!, encoding: .utf8)!
    }

}
