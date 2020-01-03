//
//  SwiftMultihash.swift
//  SwiftMultihash
//
//  Created by Matteo Sartori on 18/05/15.
//  Licensed under MIT See LICENCE for details 
//

import Foundation
import SwiftHex
import SwiftBase58

import VarInt

enum MultihashError : Error {
    case unknownCode
    case hashTooShort
    case hashTooLong
    case VarIntBufferTooShort
    case VarIntTooLarge
    case lengthNotSupported
    case hexConversionFail
    case inconsistentLength(Int)
}

// English language error strings.
extension MultihashError {
    var description: String {
        get {
            switch self {
            case .unknownCode:
                return "Unknown multihash code."
            case .hashTooShort:
                return "Multihash too short. Must be > 3 bytes"
            case .hashTooLong:
                return "Multihash too long. Must be < 129 bytes"
            case .VarIntBufferTooShort:
                return "Unsigned Variable Integer buffer too short."
            case .VarIntTooLarge:
                return "Unsigned Variable int is too big. Max is 64 bits."
            case .lengthNotSupported:
                return "Multihash does not yet support digests longer than 127 bytes"
            case .hexConversionFail:
                return "Error occurred in hex conversion."
            case .inconsistentLength(let len):
                return "Multihash length inconsistent. \(len)"
            }
        }
    }
}

let
SHA1        = 0x11,
SHA2_256    = 0x12,
SHA2_512    = 0x13,
SHA3        = 0x14,
BLAKE2B     = 0x40,
BLAKE2S     = 0x41

let Names: [String : Int] = [
    "sha1"      : SHA1,
    "sha2-256"  : SHA2_256,
    "sha2-512"  : SHA2_512,
    "sha3"      : SHA3,
    "blake2b"   : BLAKE2B,
    "blake2s"   : BLAKE2S
]

let Codes: [Int : String] = [
    SHA1        : "sha1",
    SHA2_256    : "sha2-256",
    SHA2_512    : "sha2-512",
    SHA3        : "sha3",
    BLAKE2B     : "blake2b",
    BLAKE2S     : "blake2s"
]

let DefaultLengths: [Int : Int] = [
    SHA1        : 20,
    SHA2_256    : 32,
    SHA2_512    : 64,
    SHA3        : 64,
    BLAKE2B     : 64,
    BLAKE2S     : 32
]

public struct DecodedMultihash {
    public let
        code    : Int,
        name    : String?,
        length  : Int,
        digest  : [UInt8]
}

public struct Multihash {
    public let value: [UInt8]
    
    public init(_ val: [UInt8]) {
        self.value = val
    }
}

extension Multihash : Equatable {
    public func hexString() -> String {
        return SwiftHex.encodeToString(hexBytes: value)
    }
    
    public func string() -> String {
        return self.hexString()
    }
}

public func ==(lhs: Multihash, rhs: Multihash) -> Bool {
    return lhs.value == rhs.value
}


/// Read and strip the unsigned variable int buffer size value from front of buffer
///
/// - Parameter buffer: The buffer prefixed with the size of the payload as an uvarint
/// - Returns: the size as an int64 and the buffer with the uvarint indicating size removed.
/// - Throws: <#throws value description#>
func uVarInt(buffer: [UInt8]) throws -> (UInt64, [UInt8]) {
    let (size, bytesRead) = VarInt.uVarInt(buffer)
    if bytesRead == 0 { throw MultihashError.VarIntBufferTooShort }
    if bytesRead < 0 { throw MultihashError.VarIntTooLarge }
    
    // Return the size as read from the uvarint and the buffer without the uvarint
    return (size, Array(buffer[bytesRead..<buffer.count]))
}

public func fromHexString(_ theString: String) throws -> Multihash {
    
    let buf = try SwiftHex.decodeString(hexString: theString) 
    
    return try cast(buf)
}

public func b58String(_ mhash: Multihash) -> String {
    return SwiftBase58.encode(mhash.value)
}


public func fromB58String(_ str: String) throws -> Multihash {
    let decodedBytes = SwiftBase58.decode(str)
    return try cast(decodedBytes)
}

public func cast(_ buf: [UInt8]) throws -> Multihash {
    let dm = try decodeBuf(buf)

    if validCode(dm.code) == false {
        throw MultihashError.unknownCode
    }

    return Multihash(buf)
}

public func decodeBuf(_ buf: [UInt8]) throws -> DecodedMultihash {
    
    if buf.count < 3 {
        throw MultihashError.hashTooShort
    }

    let (code, buffer) = try uVarInt(buffer: buf)
    let (digestLength, buf) = try uVarInt(buffer: buffer)
    
    if digestLength > Int32.max {
        throw MultihashError.hashTooLong
    }

//    let dm = DecodedMultihash(code: Int(buf[0]), name: Codes[Int(buf[0])], length: Int(buf[1]), digest: Array(buf[2..<buf.count]))
    let dm = DecodedMultihash(code: Int(code), name: Codes[Int(code)], length: Int(digestLength), digest: buf)
    
    let strbuf = buf.map { String(format:"%02X ", $0) }.joined()
    print("the buf is \(strbuf)")

//    let b0 = varInt(buf) //Int(buf[0])
//    print("The var int read is \(b0.0) and was \(b0.1) bytes")

    if dm.digest.count != dm.length {
        throw MultihashError.inconsistentLength(dm.length)
    }

   return dm
}

/// Encode a hash digest along with the specified function code
/// Note: The length is derived from the length of the digest.
public func encodeBuf(_ buf: [UInt8], code: Int?) throws -> [UInt8] {
    if validCode(code) == false {
        throw MultihashError.unknownCode
    }
    
    if buf.count > 129 {
        throw MultihashError.hashTooLong
    }
    
    var pre = [0,0] as [UInt8]
    
    pre[0] = UInt8(code!)
    pre[1] = UInt8(buf.count)
    pre.append(contentsOf: buf)

    return pre
}

public func encodeName(_ buf: [UInt8], name: String) throws -> [UInt8] {
    return try encodeBuf(buf, code: Names[name])
}

/// ValidCode checks whether a multihash code is valid.
public func validCode(_ code: Int?) -> Bool {
    
    if let c = code {
        if appCode(c) == true {
            return true
        }
        
        if let _ = Codes[c] {
            return true
        }
    }
    return false
}

/// AppCode checks whether a multihash code is part of the App range.
public func appCode(_ code: Int) -> Bool {
    return code >= 0 && code < 0x10
}
