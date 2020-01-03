//
//  ErrorCode.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/9/6.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation

public let error_Code = "error_Code"

public enum DMASDKError{
    
    public enum ErrorCode : String {
        case TOKEN_ADDRESS_ERROR = "10001"
        case TOKEN_BALANCE_UNDERFINANCED = "10002"
        case GASLIMINT_SHORT = "10003"
        case BALANCE_UNDERFINANCED = "10004"
        case APPROVE_TOKEN_BALANCE_UNDERFINANCED = "10005"
        case CONTRACT_DEPLOY_ERROR = "10006"
        case PRIVATEKEY_ERROR = "10007"
        case ADDRESS_ERROR = "10008"
        case RPC_REQUEST_FAILED = "20001"
        case RPC_ERROR = "30001"
        case NOT_ENOUGH_TRANSACTION_PARAMETER = "40001"
        case NOT_VALID_DATA_TO_RAW_TX = "40002"
        case NOT_VALID_TYPE_TO_TRANSFER = "40003"
        case PARAMETER_INVALID = "40004"
        case SIGN_DID_INFO_INVALID = "40005"
        case TRANSFER_FAILED = "40006"
        case NO_INFO = "40007"
    }
    
    public enum ErrrorMsg : String{
        case TOKEN_ADDRESS_ERROR = "token地址不存在或错误"
        case TOKEN_BALANCE_UNDERFINANCED = "token余额不足"
        case GASLIMINT_SHORT = "gasLimit缺少"
        case BALANCE_UNDERFINANCED = "余额不足"
        case APPROVE_TOKEN_BALANCE_UNDERFINANCED = "授权token余额不足"
        case CONTRACT_DEPLOY_ERROR = "合约创建失败"
        case PRIVATEKEY_ERROR = "私钥错误"
        case ADDRESS_ERROR = "地址错误"
        case RPC_REQUEST_FAILED = "rpc请求失败"
        case RPC_ERROR = "远程调用失败"
        case NOT_ENOUGH_TRANSACTION_PARAMETER = "参数不足"
        case NOT_VALID_DATA_TO_RAW_TX = "交易数据无效"
        case NOT_VALID_TYPE_TO_TRANSFER = "交易类型无效"
        case PARAMETER_INVALID = "参数无效"
        case SIGN_DID_INFO_INVALID = "did信息签名错误"
        case TRANSFER_FAILED = "交易失败"
        case NO_INFO = "未查询到信息"
       
        
    }
    
    case TOKEN_ADDRESS_ERROR
    case TOKEN_BALANCE_UNDERFINANCED
    case GASLIMINT_SHORT
    case BALANCE_UNDERFINANCED
    case APPROVE_TOKEN_BALANCE_UNDERFINANCED
    case CONTRACT_DEPLOY_ERROR
    case PRIVATEKEY_ERROR
    case ADDRESS_ERROR
    case RPC_REQUEST_FAILED
    case RPC_ERROR
    case NOT_ENOUGH_TRANSACTION_PARAMETER
    case NOT_VALID_DATA_TO_RAW_TX
    case NOT_VALID_TYPE_TO_TRANSFER
    case PARAMETER_INVALID
    case SIGN_DID_INFO_INVALID
    case TRANSFER_FAILED
    case NO_INFO
    
    public func getCodeAndMsg() -> NSMutableDictionary{
        switch self {
        case .TOKEN_ADDRESS_ERROR:
            return self.getErrorCodeJson(code: DMASDKError.ErrorCode.TOKEN_ADDRESS_ERROR, msg: DMASDKError.ErrrorMsg.TOKEN_ADDRESS_ERROR)
        case .TOKEN_BALANCE_UNDERFINANCED:
            return self.getErrorCodeJson(code: DMASDKError.ErrorCode.TOKEN_BALANCE_UNDERFINANCED, msg: DMASDKError.ErrrorMsg.TOKEN_BALANCE_UNDERFINANCED)
        case .GASLIMINT_SHORT:
            return self.getErrorCodeJson(code: DMASDKError.ErrorCode.GASLIMINT_SHORT, msg: DMASDKError.ErrrorMsg.GASLIMINT_SHORT)
        case .BALANCE_UNDERFINANCED:
            return self.getErrorCodeJson(code: DMASDKError.ErrorCode.BALANCE_UNDERFINANCED, msg: DMASDKError.ErrrorMsg.BALANCE_UNDERFINANCED)
        case .APPROVE_TOKEN_BALANCE_UNDERFINANCED:
            return self.getErrorCodeJson(code: DMASDKError.ErrorCode.APPROVE_TOKEN_BALANCE_UNDERFINANCED, msg: DMASDKError.ErrrorMsg.APPROVE_TOKEN_BALANCE_UNDERFINANCED)
        case .RPC_REQUEST_FAILED:
            return self.getErrorCodeJson(code: DMASDKError.ErrorCode.RPC_REQUEST_FAILED, msg: DMASDKError.ErrrorMsg.RPC_REQUEST_FAILED)
        case .CONTRACT_DEPLOY_ERROR:
            return self.getErrorCodeJson(code: DMASDKError.ErrorCode.CONTRACT_DEPLOY_ERROR, msg: DMASDKError.ErrrorMsg.CONTRACT_DEPLOY_ERROR)
        case .PRIVATEKEY_ERROR:
            return self.getErrorCodeJson(code: DMASDKError.ErrorCode.PRIVATEKEY_ERROR, msg: DMASDKError.ErrrorMsg.PRIVATEKEY_ERROR)
        case .ADDRESS_ERROR:
            return self.getErrorCodeJson(code: DMASDKError.ErrorCode.ADDRESS_ERROR, msg: DMASDKError.ErrrorMsg.ADDRESS_ERROR)
        case .RPC_ERROR:
            return self.getErrorCodeJson(code: DMASDKError.ErrorCode.RPC_ERROR, msg: DMASDKError.ErrrorMsg.RPC_ERROR)
        case .NOT_ENOUGH_TRANSACTION_PARAMETER:
            return self.getErrorCodeJson(code: DMASDKError.ErrorCode.NOT_ENOUGH_TRANSACTION_PARAMETER, msg: DMASDKError.ErrrorMsg.NOT_ENOUGH_TRANSACTION_PARAMETER)
        case .NOT_VALID_DATA_TO_RAW_TX:
            return self.getErrorCodeJson(code: DMASDKError.ErrorCode.NOT_VALID_DATA_TO_RAW_TX, msg: DMASDKError.ErrrorMsg.NOT_VALID_DATA_TO_RAW_TX)
        case .NOT_VALID_TYPE_TO_TRANSFER:
            return self.getErrorCodeJson(code: DMASDKError.ErrorCode.NOT_VALID_TYPE_TO_TRANSFER, msg: DMASDKError.ErrrorMsg.NOT_VALID_TYPE_TO_TRANSFER)
        case .PARAMETER_INVALID:
            return self.getErrorCodeJson(code: DMASDKError.ErrorCode.PARAMETER_INVALID, msg: DMASDKError.ErrrorMsg.PARAMETER_INVALID)
        case .SIGN_DID_INFO_INVALID:
            return self.getErrorCodeJson(code: DMASDKError.ErrorCode.SIGN_DID_INFO_INVALID, msg: DMASDKError.ErrrorMsg.SIGN_DID_INFO_INVALID)
        case .TRANSFER_FAILED:
            return self.getErrorCodeJson(code: DMASDKError.ErrorCode.TRANSFER_FAILED, msg: DMASDKError.ErrrorMsg.TRANSFER_FAILED)
        case .NO_INFO:
            return self.getErrorCodeJson(code: DMASDKError.ErrorCode.NO_INFO, msg: DMASDKError.ErrrorMsg.NO_INFO)
        }
    }
    
   
}



extension DMASDKError{
    public func getErrorCodeJson(code : ErrorCode,msg : ErrrorMsg) -> NSMutableDictionary{
        let dic : NSMutableDictionary = [:]
        dic[error_Code] = code.rawValue
        dic[error_Str] = msg.rawValue
        return dic
    }
}



