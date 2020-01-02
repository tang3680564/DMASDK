//
//  AssetManagement.swift
//  DMASDK
//
//  Created by Zhangxz& on 2019/3/20.
//  Copyright © 2019 Zhangxz&. All rights reserved.
//

import UIKit
import BigInt
import HandyJSON


public class AssetManagement: NSObject {
//NFTokenDMA
    let abi = "NFTokenDMA"
    
    var url = defultURL
    
    required public init(url : String) {
        super.init()
        self.url = url
    }
    
    required public override init()  {
        super.init()
    }
    
    /// 发布合约
    ///
    /// - Parameters:
    ///   - privateKey: 私钥
    ///   - name: 合约名称
    ///   - symbol: 合约简介
    ///   - metadata: 合约描述
    ///   - isburn: 是否可以销毁
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    /// - Returns: ContractResult
    func setupDeploy(privateKey:String,name:String,symbol:String,metadata:String,isburn:Bool,gasLimit:String,gasPrice:String) -> ContractResult {
        let deployHelper = DeployHelper(url: url)
        let param = [name ,symbol ,metadata ,isburn ] as [Any]
        return deployHelper.setupDeploy(privateKey: privateKey, abi: abi, bytecode: "NFTokenETHData", parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
    }
    
    /// 资产授权
    ///
    /// - Parameters:
    ///   - privateKey: 资产拥有者私钥
    ///   - contractAddress: 合约地址
    ///   - approved: 授权给哪个地址
    ///   - tokenId: 资产 ID
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: ContractResult
    func approve(privateKey:String,contractAddress:String,approved:String,tokenId:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [approved,tokenId] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "approve", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }
    
    
    /// 资产批量授权
    ///
    /// - Parameters:
    ///   - privateKey: 资产拥有者的私钥
    ///   - contractAddress: 合约地址
    ///   - approved: 授权给哪个地址
    ///   - tokenArr: 资产 ID 数组
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: return value description
    func approveWithArray(privateKey:String,contractAddress:String,approved:String,tokenArr:Array<Any>,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [approved,tokenArr] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "approveWithArray", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }
    
    /// 资产销毁
    ///
    /// - Parameters:
    ///   - privateKey: 合约拥有者的私钥
    ///   - contractAddress: 合约地址
    ///   - owner: 资产拥有者的地址
    ///   - tokenId: 资产ID
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: return value description
    func burn(privateKey:String,contractAddress:String,owner:String,tokenId:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [owner,tokenId] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "burn", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }
    
    /// 合约销毁
    ///
    /// - Parameters:
    ///   - privateKey: 合约拥有者的私钥
    ///   - contractAddress: 合约地址
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: return value description
    
    func kill(privateKey:String,contractAddress:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "kill", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }
    
    /// 创建资产
    ///
    /// - Parameters:
    ///   - privateKey: 合约拥有者的私钥
    ///   - contractAddress: 合约地址
    ///   - to: 创建资产给哪个地址
    ///   - tokenId: 资产 ID
    ///   - uri: 资产的描述信息
    ///   - isTransfer: 是否可以转送
    ///   - isBurn: 是否可以销毁
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: return value description
    func mint(privateKey:String,contractAddress:String,to:String,tokenId:String,uri:String,isTransfer:Bool,isBurn:Bool,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [to,tokenId,uri,isTransfer,isBurn] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "mint", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }

    /// 批量创建资产
    ///
    /// - Parameters:
    ///   - privateKey: 合约拥有者的私钥
    ///   - contractAddress: 合约地址
    ///   - to: 创建资产给哪个地址
    ///   - array: 资产 ID 数组
    ///   - uri: 资产描述信息
    ///   - isTransfer: 是否可以转送
    ///   - isBurn: 是否可以销毁
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: return value description
    func mintWithArray(privateKey:String,contractAddress:String,to:String,array:Array<Any>,uri:String,isTransfer:Bool,isBurn:Bool,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [to,array,uri,isTransfer,isBurn] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "mintWithArray", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }
    
    /// 资产批量取消授权
    ///
    /// - Parameters:
    ///   - privateKey: 资产拥有者的私钥
    ///   - contractAddress: 合约地址
    ///   - array: 资产 ID 数组
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: return value description
    func removeApproveWithArray(privateKey:String,contractAddress:String,array:Array<Any>,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [array] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "removeApproveWithArray", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }

    /// 资产取消授权
    ///
    /// - Parameters:
    ///   - privateKey: 资产拥有者的私钥
    ///   - contractAddress: 合约地址
    ///   - tokenId: 资产ID
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: return value description
    func revokeApprove(privateKey:String,contractAddress:String,tokenId:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [tokenId] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "revokeApprove", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }
   
    
    /// 设置合约的所有授权
    ///
    /// - Parameters:
    ///   - privateKey: 合约拥有者的私钥
    ///   - contractAddress: 合约地址
    ///   - operatored: 授权给哪个地址
    ///   - approved: true:授权,false:取消授权
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: return value description
    func safeTransferFrom(privateKey:String,contractAddress:String,from:String,to:String,tokenId:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [from,to,tokenId] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "safeTransferFrom", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }
 
    func setApprovalForAll(privateKey:String,contractAddress:String,operatored:String,approved:Bool,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [operatored,approved] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "setApprovalForAll", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }
    
    func setMetadata(privateKey:String,contractAddress:String,metadata:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [metadata] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "setMetadata", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }
    func setStatus(privateKey:String,contractAddress:String,tokenId:String,status:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [tokenId,status] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "setStatus", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }
    
    
    /// 资产转送
    ///
    /// - Parameters:
    ///   - privateKey: eth私钥
    ///   - contractAddress: 合约地址
    ///   - from: 来自哪个地址
    ///   - to: 转到哪个地址
    ///   - tokenId: 票档 ID
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: return value description
    func transferFrom(privateKey:String,contractAddress:String,from:String,to:String,tokenId:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [from,to,tokenId] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "transferFrom", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }
    
    
    /// 资产转送
    ///
    /// - Parameters:
    ///   - privateKey: eth私钥
    ///   - contractAddress: 合约地址
    ///   - from: 来自哪个地址
    ///   - to: 转到哪个地址
    ///   - tokenIds: 票档 ID
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: return value description
    func transferFromWithArray(privateKey:String,contractAddress:String,from:String,to:String,tokenIds:Array<Any>,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [from,to,tokenIds] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "transferFromWithArray", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }
    
    
    /// 转移合约的拥有者
    ///
    /// - Parameters:
    ///   - privateKey: 合约拥有者的私钥
    ///   - contractAddress: 合约地址
    ///   - newOwner: 转移给哪个地址
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: 估算这次操作所需要的gasfee , true : 进行估算,不进行这次操作, false : 不进行估算,进行这次操作
    /// - Returns: return value description
    func transferOwnership(privateKey:String,contractAddress:String,newOwner:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let param = [newOwner] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "transferOwnership", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }

    
    /// 根据地址查询资产数量
    ///
    /// - Parameters:
    ///   - contractAddress: 合约地址
    ///   - owner: 资产拥有者地址
    /// - Returns: return value description
    func balanceOf(contractAddress:String,owner:String) -> ContractResult {
        let param = [owner] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "balanceOf", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
        switch result {
        case .success(let res):
            let management = ModelType2.deserialize(from: res)
            return ContractResult.success(value:["result":management!.a! as Any])
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
    }
    
    /// 根据资产id获取授权地址
    ///
    /// - Parameters:
    ///   - contractAddress: 合约地址
    ///   - tokenId: 资产 ID
    /// - Returns: return value description
    func getApproved(contractAddress:String,tokenId:String) -> ContractResult {
        let param = [tokenId] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "getApproved", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
        switch result {
        case .success(let res):
            let management = ModelType2.deserialize(from: res)
            let regexStr = "\""
            let array = management?.a?.components(separatedBy: regexStr)
            for item in array!{
                if item.contains("0x")
                {
                    management?.a = item
                }
            }
            return ContractResult.success(value:["result":management!.a! as Any])
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
    }
    
    
    /// 获取合约信息
    ///
    /// - Parameter contractAddress: 合约地址
    /// - Returns: return value description
    func getInfo(contractAddress:String) -> ContractResult {
        let param = [] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "getInfo", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
        switch result {
        case .success(let res):
            let management = ModelType1.deserialize(from: res)
            let regexStr = "\""
            let array = management?._owner?.components(separatedBy: regexStr)
            for item in array!{
                if item.contains("0x")
                {
                    management?._owner = item
                }
            }
            return ContractResult.success(value:["result":management!.toJSONString()! as Any])
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
        
    }
    
   
    
    func getMetadata(contractAddress:String) -> ContractResult {
        let param = [] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "getMetadata", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
        switch result {
        case .success(let res):
            let management = ModelType1.deserialize(from: res)
            return ContractResult.success(value:["result":management!._metadata! as Any])
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
    }
    func getStatus(contractAddress:String,tokenId:String) -> ContractResult {
        let param = [tokenId] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "getStatus", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
        switch result {
        case .success(let res):
            let management = ModelType1.deserialize(from: res)
            return ContractResult.success(value:["result":management!._metadata! as Any])
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
    }
    
    
    /// 根据资产id查询资产信息
    ///
    /// - Parameters:
    ///   - contractAddress: 合约地址
    ///   - tokenId: 资产 ID
    /// - Returns: return value description
    func getTokenInfo(contractAddress:String,tokenId:String) -> ContractResult {
        let param = [tokenId] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "getTokenInfo", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
        switch result {
        case .success(let res):
            let management = ModelType1.deserialize(from: res)
            let regexStr = "\""
            let array = management?._owner?.components(separatedBy: regexStr)
            for item in array!{
                if item.contains("0x")
                {
                    management?._owner = item
                }
            }
            return ContractResult.success(value:["result":management!.toJSONString()! as Any])
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
    }
    
    /// 查询是否拥有合约的授权
    ///
    /// - Parameters:
    ///   - contractAddress: 合约地址
    ///   - owner: 合约拥有着地址
    ///   - operatored: 查询授权的地址
    /// - Returns: return value description
    func isApprovedForAll(contractAddress:String,owner:String,operatored:String) -> ContractResult {
        let param = [owner,operatored] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "isApprovedForAll", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
        switch result {
        case .success(let res):
            let management = ModelType2.deserialize(from: res)
            return ContractResult.success(value:["result":management!.a! as Any])
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
    }
    
    
    /// 获取合约名称
    ///
    /// - Parameter contractAddress: 合约地址
    /// - Returns: return value description
    func name(contractAddress:String) -> ContractResult {
        let param = [] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "name", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
        switch result {
        case .success(let res):
            let management = ModelType1.deserialize(from: res)
            return ContractResult.success(value:["result":management!._name! as Any])
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
    }
    
    
    /// 获取合约的拥有者
    ///
    /// - Parameter contractAddress: 合约地址
    /// - Returns: return value description
    func owner(contractAddress:String) -> ContractResult {
        let param = [] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "owner", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
        switch result {
        case .success(let res):
            let management = ModelType2.deserialize(from: res)
            return ContractResult.success(value:["result":management!.a! as Any])
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
        
    }
    
    
    /// 获取资产的拥有者
    ///
    /// - Parameters:
    ///   - contractAddress: 合约地址
    ///   - tokenId: 资产 ID
    /// - Returns: return value description
    func ownerOf(contractAddress:String,tokenId:String) -> ContractResult {
        let param = [tokenId] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "ownerOf", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
        switch result {
        case .success(let res):
            let management = ModelType1.deserialize(from: res)
            let regexStr = "\""
            let array = management?._owner?.components(separatedBy: regexStr)
            for item in array!{
                if item.contains("0x")
                {
                    management?._owner = item
                }
            }
            return ContractResult.success(value:["result":management!._owner! as Any])
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
    }
    
    
    /// 获取合约简介
    ///
    /// - Parameter contractAddress: 合约地址
    /// - Returns: return value description
    func symbol(contractAddress:String) -> ContractResult {
        let param = [] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "symbol", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
        switch result {
        case .success(let res):
            let management = ModelType1.deserialize(from: res)
            return ContractResult.success(value:["result":management!._symbol! as Any])
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
    }
    
    
    /// 获取固定位置的 tokenID
    ///
    /// - Parameters:
    ///   - contractAddress:  合约地址
    ///   - index: 位置
    /// - Returns: return value description
    func tokenByIndex(contractAddress:String,index:String) -> ContractResult {
        let param = [String(index) as Any] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "tokenByIndex", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
        switch result {
        case .success(let res):
            let management = ModelType2.deserialize(from: res)
            return ContractResult.success(value:["result":management!.a! as Any])
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
    }
    
    
    /// 获取固定位置的资产拥有者的tokenID
    ///
    /// - Parameters:
    ///   - contractAddress: 合约地址
    ///   - owner: 资产拥有者地址
    ///   - index: 位置
    /// - Returns: return value description
    func tokenOfOwnerByIndex(contractAddress:String,owner:String,index:String) -> ContractResult {
        let param = [owner,String(index) as Any] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "tokenOfOwnerByIndex", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
        switch result {
        case .success(let res):
            let management = ModelType2.deserialize(from: res)
            return ContractResult.success(value:["result":management!.a! as Any])
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
    }
    
    
    /// 获取资产描述信息
    ///
    /// - Parameters:
    ///   - contractAddress: 合约地址
    ///   - tokenId: 资产 ID
    /// - Returns: return value description
    func tokenURI(contractAddress:String,tokenId:String) -> ContractResult {
        let param = [tokenId] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "totalSupply", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
        switch result {
        case .success(let res):
            let management = ModelType2.deserialize(from: res)
            return ContractResult.success(value:["result":management!.a! as Any])
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
    }
    
    
    /// 获取合约下面的所有创建的资产
    ///
    /// - Parameter contractAddress: 合约地址
    /// - Returns: return value description
    func totalSupply(contractAddress:String) -> ContractResult {
        let param = [] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "totalSupply", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
        switch result {
        case .success(let res):
            let management = ModelType2.deserialize(from: res)
            return ContractResult.success(value:["result":management!.a! as Any])
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
    }
    
    
    /// 验证资产 ID 在合约中是否有效
    ///
    /// - Parameters:
    ///   - contractAddress: 合约地址
    ///   - tokenId: 资产 ID
    /// - Returns: return value description
    func valid(contractAddress:String,tokenId:String) -> ContractResult {
        let param = [tokenId] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "valid", privateKey: "", parameters: param as [AnyObject], gasLimit: "", gasPrice: "")
        switch result {
        case .success(let res):
            let management = ModelType1.deserialize(from: res)
            return ContractResult.success(value:["result":management!._vaild! as Any])
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
        
    }
    func tokenIds(contractAddress:String,owner:String) -> ContractResult {
        let balanceResult = self.balanceOf(contractAddress: contractAddress, owner: owner)
        var tokenIds:Array<Any> = []

        switch balanceResult {
        case .success(let value):
            let bValue = value["result"] as!String
            if (Int(bValue)!)>0 {
                for i in 0...(Int(bValue)!-1){
                    let tokenIdResult = self.tokenByIndex(contractAddress: contractAddress, index: String(i))
                    switch tokenIdResult{
                    case .success(let value):
                        let tokenId = value["result"] as!String
                        tokenIds.append(tokenId)
                        break
                    case .failure(let error):
                        return ContractResult.failure(error: error)
                        
                    }
                }
            }
            return ContractResult.success(value:["result":tokenIds])
        case .failure(let error):
            return ContractResult.failure(error: error)
        }
    }
}
