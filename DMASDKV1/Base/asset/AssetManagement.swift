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
    let abi = "NFTokenETH"
    
    var url = defultURL
    
    required public init(url : String) {
        super.init()
        self.url = url
    }
    
    required public override init()  {
        super.init()
    }
    
    func setupDeploy(privateKey:String,name:String,symbol:String,metadata:String,isburn:Bool,gasLimit:String,gasPrice:String) -> ContractResult {
        let deployHelper = DeployHelper(url: url)
        let param = [name ,symbol ,metadata ,isburn ] as [Any]
        return deployHelper.setupDeploy(privateKey: privateKey, abi: abi, bytecode: "NFTokenETHData", parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
    }
    
    func approve(privateKey:String,contractAddress:String,approved:String,tokenId:String,gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [approved,tokenId] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "approve", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
        return result
    }
    
    func approveWithArray(privateKey:String,contractAddress:String,approved:String,tokenArr:Array<Any>,gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [approved,tokenArr] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "approveWithArray", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
        return result
    }
    func burn(privateKey:String,contractAddress:String,owner:String,tokenId:String,gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [owner,tokenId] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "burn", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
        return result
    }
    func kill(privateKey:String,contractAddress:String,gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "kill", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
        return result
    }
    func mint(privateKey:String,contractAddress:String,to:String,tokenId:String,uri:String,isTransfer:Bool,isBurn:Bool,gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [to,tokenId,uri,isTransfer,isBurn] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "mint", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
        return result
    }

    func mintWithArray(privateKey:String,contractAddress:String,to:String,array:Array<Any>,uri:String,isTransfer:Bool,isBurn:Bool,gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [to,array,uri,isTransfer,isBurn] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "mintWithArray", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
        return result
    }
    func removeApproveWithArray(privateKey:String,contractAddress:String,array:Array<Any>,gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [array] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "removeApproveWithArray", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
        return result
    }

    func revokeApprove(privateKey:String,contractAddress:String,tokenId:String,gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [tokenId] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "revokeApprove", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
        return result
    }
   
    func safeTransferFrom(privateKey:String,contractAddress:String,from:String,to:String,tokenId:String,gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [from,to,tokenId] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "safeTransferFrom", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
        return result
    }
 
    func setApprovalForAll(privateKey:String,contractAddress:String,operatored:String,approved:String,gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [operatored,approved] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "setApprovalForAll", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
        return result
    }
    
    func setMetadata(privateKey:String,contractAddress:String,metadata:String,gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [metadata] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "setMetadata", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
        return result
    }
    func setStatus(privateKey:String,contractAddress:String,tokenId:String,status:String,gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [tokenId,status] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "setStatus", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
        return result
    }
    
    func transferFrom(privateKey:String,contractAddress:String,from:String,to:String,tokenId:String,gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [from,to,tokenId] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "transferFrom", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
        return result
    }
    func transferFromWithArray(privateKey:String,contractAddress:String,from:String,to:String,tokenIds:Array<Any>,gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [from,to,tokenIds] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "transferFromWithArray", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
        return result
    }
    func transferOwnership(privateKey:String,contractAddress:String,newOwner:String,gasLimit:String,gasPrice:String) -> ContractResult {
        let param = [newOwner] as [Any]
        let contract = ContractMethodHelper(url: url)
        let result = contract.getContract(abi: abi,contractAddress:contractAddress,method: "transferOwnership", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice)
        return result
    }
//    无私钥
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
