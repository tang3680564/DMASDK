////
////  TokenContract.swift
////  DMASDK
////
////  Created by Zhangxz& on 2019/3/20.
////  Copyright © 2019 Zhangxz&. All rights reserved.
////
//
//import UIKit
//import BigInt
//import web3swift
//class TokenContract: NSObject {
//    let abi = "TokenDMA"
//
//    
//    /// 资产增发
//    ///
//    /// - Parameters:
//    ///   - privateKey: 私钥
//    ///   - contractAddress: 合约地址
//    ///   - target: 目标地址
//    ///   - amount: 增发金额
//    /// - Returns: hash
//    func addIssue(privateKey:String,contractAddress:String,target:String,amount:String,gasLimit:String,gasPrice:String) -> ContractResult {
//        
//        let param = [target,Web3.Utils.parseToBigUInt(amount, units: .eth) as Any] as [Any]
//        let contract = ContractMethodHelper()
//        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "addIssue", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
//        return result
//    }
//    
//    /// 资产授权
//    ///
//    /// - Parameters:
//    ///   - privateKey: 私钥
//    ///   - contractAddress: 合约地址
//    ///   - spender: 被授权者地址
//    ///   - value: 授权金额
//    /// - Returns: hash
//    func approve(privateKey:String,contractAddress:String,spender:String,value:String,gasLimit:String,gasPrice:String) -> ContractResult {
//        let param = [spender,Web3.Utils.parseToBigUInt(value, units: .eth) as Any] as [Any]
//        let contract = ContractMethodHelper()
//        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "approve", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
//        return result
//    }
//    
//    /// 资产销毁
//    ///
//    /// - Parameters:
//    ///   - privateKey: 私钥
//    ///   - contractAddress: 合约地址
//    ///   - value: 金额
//    /// - Returns: hash
//    func burn(privateKey:String,contractAddress:String,value:String,gasLimit:String,gasPrice:String) -> ContractResult {
//        let param = [Web3.Utils.parseToBigUInt(value, units: .eth) as Any ] as [Any]
//        let contract = ContractMethodHelper()
//        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "burn", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
//        return result
//    }
//    
//    /// 合约销毁
//    ///
//    /// - Parameters:
//    ///   - privateKey: 私钥
//    ///   - contractAddress: 合约地址
//    /// - Returns: hash
//    func kill(privateKey:String,contractAddress:String,gasLimit:String,gasPrice:String) -> ContractResult {
//        let param = [] as [Any]
//        let contract = ContractMethodHelper()
//        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "kill", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
//        return result
//    }
//    
//    /// 撤销授权金额
//    ///
//    /// - Parameters:
//    ///   - privateKey: 私钥
//    ///   - contractAddress: 合约地址
//    ///   - owner: 被授权地址
//    ///   - amount: 撤销授权金额
//    /// - Returns: hash
//    func revokeApprove(privateKey:String,contractAddress:String,owner:String,amount:String,gasLimit:String,gasPrice:String) -> ContractResult {
//        let param = [owner,Web3.Utils.parseToBigUInt(amount, units: .eth) as Any] as [Any]
//        let contract = ContractMethodHelper()
//        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "revokeApprove", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
//        return result
//    }
//    
//    /// 转账
//    ///
//    /// - Parameters:
//    ///   - privateKey: 私钥
//    ///   - contractAddress: 合约地址
//    ///   - to: 接收方地址
//    ///   - value: 金额
//    /// - Returns: hash
//    func transfer(privateKey:String,contractAddress:String,to:String,value:String,gasLimit:String,gasPrice:String) -> ContractResult {
//        let param = [to,Web3.Utils.parseToBigUInt(value, units: .eth) as Any] as [Any]
//        let contract = ContractMethodHelper()
//        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "transfer", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
//        return result
//    }
//    
//    func saveApproveWithArray(privateKey:String,contractAddress:String,to:String,value:String,gasLimit:String,gasPrice:String) -> ContractResult {
//        let param = [to,Web3.Utils.parseToBigUInt(value, units: .eth) as Any] as [Any]
//        let contract = ContractMethodHelper()
//        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "saveApproveWithArray", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
//        return result
//    }
//    
//    /// 被授权者转账
//    ///
//    /// - Parameters:
//    ///   - privateKey: 私钥
//    ///   - contractAddress: 合约地址
//    ///   - from: 资产拥有者
//    ///   - to: 资产接收者
//    ///   - value: 金额
//    /// - Returns: hash
//    func transferFrom(privateKey:String,contractAddress:String,from:String,to:String,value:String,gasLimit:String,gasPrice:String) -> ContractResult {
//        let param = [from,to,Web3.Utils.parseToBigUInt(value, units: .eth) as Any] as [Any]
//        let contract = ContractMethodHelper()
//        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "transferFrom", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
//        return result
//    }
//    
//    /// 合约转让
//    ///
//    /// - Parameters:
//    ///   - privateKey: 私钥
//    ///   - contractAddress: 地址
//    ///   - newOwner: 新合约拥有者
//    /// - Returns: hash
//    func transferOwnership(privateKey:String,contractAddress:String,newOwner:String,gasLimit:String,gasPrice:String) -> ContractResult {
//        let param = [newOwner] as [Any]
//        let contract = ContractMethodHelper()
//        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "transferOwnership", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
//        return result
//    }
////  无私钥
//    
//    func allowance(contractAddress:String,owner:String,spender:String) -> ContractResult {
//        let param = [owner,spender] as [Any]
//        let contract = ContractMethodHelper()
//        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "allowance", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
//        switch result {
//        case .success(let res):
//            let management = ModelType1.deserialize(from: res)
//            let s = Web3.Utils.formatToPrecision(BigUInt(management!._remaining!)!)
//            return ContractResult.success(value:["result":s! as Any])
//        case .failure(let error):
//            return ContractResult.failure(error: error)
//        }
//    }
//    
//    
//    func balanceOf(contractAddress:String,owner:String) -> ContractResult {
//        let param = [owner] as [Any]
//        let contract = ContractMethodHelper()
//        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "balanceOf", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
//        switch result {
//        case .success(let res):
//            let management = ModelType1.deserialize(from: res)
//            let s = Web3.Utils.formatToPrecision(BigUInt(management!._balance!)!)
//            return ContractResult.success(value:["result":s! as Any])
//        case .failure(let error):
//            return ContractResult.failure(error: error)
//        }
//    }
//    
//    
//    func decimals(contractAddress:String) -> ContractResult {
//        let param = [] as [Any]
//        let contract = ContractMethodHelper()
//        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "decimals", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
//        switch result {
//        case .success(let res):
//            let management = ModelType1.deserialize(from: res)
//            return ContractResult.success(value:["result":management!._decimals! as Any])
//        case .failure(let error):
//            return ContractResult.failure(error: error)
//        }
//        
//    }
//    func name(contractAddress:String) -> ContractResult {
//        let param = [] as [Any]
//        let contract = ContractMethodHelper()
//        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "name", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
//        switch result {
//        case .success(let res):
//            let management = ModelType1.deserialize(from: res)
//            return ContractResult.success(value:["result":management?._name! as Any])
//        case .failure(let error):
//            return ContractResult.failure(error: error)
//        }
//    }
//    func owner(contractAddress:String) -> ContractResult {
//        let param = [] as [Any]
//        let contract = ContractMethodHelper()
//        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "owner", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
//        switch result {
//        case .success(let res):
//            let management = ModelType2.deserialize(from: res)
//            let regexStr = "\""
//            let array = management?.a?.components(separatedBy: regexStr)
//            for item in array!{
//                if item.contains("0x")
//                {
//                    management?.a = item
//                }
//            }
//            return ContractResult.success(value:["result":management?.a! as Any])
//        case .failure(let error):
//            return ContractResult.failure(error: error)
//        }
//        
//    }
//    func symbol(contractAddress:String) -> ContractResult {
//        let param = [] as [Any]
//        let contract = ContractMethodHelper()
//        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "symbol", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
//        switch result {
//        case .success(let res):
//            let management = ModelType1.deserialize(from: res)
//            return ContractResult.success(value:["result":management?._symbol! as Any])
//        case .failure(let error):
//            return ContractResult.failure(error: error)
//        }
//        
//    }
//    func totalSupply(contractAddress:String) -> ContractResult {
//        let param = [] as [Any]
//        let contract = ContractMethodHelper()
//        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "totalSupply", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
//        switch result {
//        case .success(let res):
//            let management = ModelType1.deserialize(from: res)
//            let s = Web3.Utils.formatToPrecision(BigUInt(management!._totalSupply!)!)
//
//            return ContractResult.success(value:["result":s as Any])
//        case .failure(let error):
//            return ContractResult.failure(error: error)
//        }
//        
//    }
//}
