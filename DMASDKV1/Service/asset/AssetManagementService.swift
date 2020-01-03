//
//  AssetManagementService.swift
//  DMASDK
//
//  Created by Zhangxz& on 2019/3/25.
//  Copyright © 2019 Zhangxz&. All rights reserved.
//

import Foundation

open class AssetManagementService: NSObject {
    
    var url = defultURL
    
    
    /// 初始化
    ///
    /// - Parameter url: 节点地址
    public required init(url : String) {
        super.init()
        self.url = url
        asset = AssetManagement(url: url)
    }
    
    private var asset = AssetManagement()
    
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
    public func deploy(privateKey:String,name:String,symbol:String,metadata:String,isburn:Bool,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        
        var gasLimit = gasLimit
        var gasPrice = gasPrice
        var getGasFee = getGasFee
        if !getGasFee{
            let result = asset.setupDeploy(privateKey: privateKey, name: name, symbol: symbol, metadata: metadata, isburn: isburn, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : true)
            let isError = limIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice, getGasFee: &getGasFee, result: result)
            if let result = isError{
                return result
            }
        }else{
            limAndPriceIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice)
        }
        
        let  result = asset.setupDeploy(privateKey: privateKey, name: name, symbol: symbol, metadata: metadata, isburn: isburn, gasLimit: gasLimit, gasPrice: gasPrice)
        switch result {
        case .success(value: let dic):
            let address = dic["address"] as! String
            return ContractResult.success(value: ["assetAddress" : address])
        case .failure(error: let error):
            return ContractResult.failure(error: error)
        }
        return result
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
    public  func approve(privateKey:String,contractAddress:String,approved:String,tokenId:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let result = asset.approve(privateKey: privateKey, contractAddress: contractAddress, approved: approved, tokenId: tokenId, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
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
    public  func approveWithArray(privateKey:String,contractAddress:String,approved:String,tokenArr:Array<Any>,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let result = asset.approveWithArray(privateKey: privateKey, contractAddress: contractAddress, approved: approved, tokenArr: tokenArr, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
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
    public  func burn(privateKey:String,contractAddress:String,owner:String,tokenId:String,gasLimit:String = "",gasPrice:String = "",getGasFee : Bool = false) -> ContractResult {
        var gasLimit = gasLimit
        var gasPrice = gasPrice
        var getGasFee = getGasFee
        if !getGasFee{
            let result = asset.burn(privateKey: privateKey, contractAddress: contractAddress, owner: owner, tokenId: tokenId, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
            let isError = limIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice, getGasFee: &getGasFee, result: result)
            if let result = isError{
                return result
            }
        }else{
            limAndPriceIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice)
        }
        
        let result = asset.burn(privateKey: privateKey, contractAddress: contractAddress, owner: owner, tokenId: tokenId, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
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
    public  func kill(privateKey:String,contractAddress:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let result = asset.kill(privateKey: privateKey, contractAddress: contractAddress, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
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
    public   func mint(privateKey:String,contractAddress:String,to:String,tokenId:String,uri:String,isTransfer:Bool,isBurn:Bool,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let result = asset.mint(privateKey: privateKey, contractAddress: contractAddress, to: to, tokenId: tokenId, uri: uri, isTransfer: isTransfer, isBurn: isBurn, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
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
    public  func mintWithArray(privateKey:String,contractAddress:String,to:String,array:Array<Any>,uri:String,isTransfer:Bool,isBurn:Bool,gasLimit:String = "" ,gasPrice:String = "",getGasFee : Bool = false) -> ContractResult {
        var gasLimit = gasLimit
        var gasPrice = gasPrice
        var getGasFee = getGasFee
        if !getGasFee{
            let result = asset.mintWithArray(privateKey: privateKey, contractAddress: contractAddress, to: to, array: array, uri: uri, isTransfer: isTransfer, isBurn: isBurn, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee: true)
            let isError = limIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice, getGasFee: &getGasFee, result: result)
            if let result = isError{
                return result
            }
        }else{
            limAndPriceIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice)
        }
        
        let result = asset.mintWithArray(privateKey: privateKey, contractAddress: contractAddress, to: to, array: array, uri: uri, isTransfer: isTransfer, isBurn: isBurn, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee: getGasFee)
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
    public  func removeApproveWithArray(privateKey:String,contractAddress:String,array:Array<Any>,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let result = asset.removeApproveWithArray(privateKey: privateKey, contractAddress: contractAddress, array: array, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
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
    public  func revokeApprove(privateKey:String,contractAddress:String,tokenId:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let result = asset.revokeApprove(privateKey: privateKey, contractAddress: contractAddress, tokenId: tokenId, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
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
    public  func setApprovalForAll(privateKey:String,contractAddress:String,operatored:String,approved:Bool,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let result = asset.setApprovalForAll(privateKey: privateKey, contractAddress: contractAddress, operatored: operatored, approved: approved, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }
    
    public    func setMetadata(privateKey:String,contractAddress:String,metadata:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let result = asset.setMetadata(privateKey: privateKey, contractAddress: contractAddress, metadata: metadata, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }
    public func setStatus(privateKey:String,contractAddress:String,tokenId:String,status:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let result = asset.setStatus(privateKey: privateKey, contractAddress: contractAddress, tokenId: tokenId, status: status, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
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
    public  func transferFrom(privateKey:String,contractAddress:String,from:String,to:String,tokenId:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let result = asset.transferFrom(privateKey: privateKey, contractAddress: contractAddress, from: from, to: to, tokenId: tokenId, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
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
    public func transferFromWithArray(privateKey:String,contractAddress:String,from:String,to:String,tokenIds:Array<Any>,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let result = asset.transferFromWithArray(privateKey: privateKey, contractAddress: contractAddress, from: from, to: to, tokenIds: tokenIds, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
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
    public  func transferOwnership(privateKey:String,contractAddress:String,newOwner:String,gasLimit:String,gasPrice:String,getGasFee : Bool = false) -> ContractResult {
        let result = asset.transferOwnership(privateKey: privateKey, contractAddress: contractAddress, newOwner: newOwner, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee : getGasFee)
        return result
    }
    
    
    
    /// 根据地址查询资产数量
    ///
    /// - Parameters:
    ///   - contractAddress: 合约地址
    ///   - owner: 资产拥有者地址
    /// - Returns: return value description
    public  func balanceOf(contractAddress:String,owner:String) -> ContractResult {
        let result = asset.balanceOf(contractAddress: contractAddress, owner: owner)
        return result
    }
    
    
    /// 根据资产id获取授权地址
    ///
    /// - Parameters:
    ///   - contractAddress: 合约地址
    ///   - tokenId: 资产 ID
    /// - Returns: return value description
    public   func getApproved(contractAddress:String,tokenId:String) -> ContractResult {
        let result = asset.getApproved(contractAddress: contractAddress, tokenId: tokenId)
        return result
    }
    
    
    /// 获取合约信息
    ///
    /// - Parameter contractAddress: 合约地址
    /// - Returns: return value description
    public  func getContractInfo(contractAddress:String) -> ContractResult {
        let result = asset.getInfo(contractAddress: contractAddress)
        return result
    }
    
    public  func getMetadata(contractAddress:String) -> ContractResult {
        let result = asset.getMetadata(contractAddress: contractAddress)
        return result
    }
    public  func getStatus(contractAddress:String,tokenId:String) -> ContractResult {
        let result = asset.getStatus(contractAddress: contractAddress, tokenId: tokenId)
        return result
    }
    
    
    /// 查询是否拥有合约的授权
    ///
    /// - Parameters:
    ///   - contractAddress: 合约地址
    ///   - owner: 合约拥有着地址
    ///   - operatored: 查询授权的地址
    /// - Returns: return value description
    public  func isApprovedForAll(contractAddress:String,owner:String,operatored:String) -> ContractResult {
        let result = asset.isApprovedForAll(contractAddress: contractAddress, owner: owner, operatored: operatored)
        return result
    }
    
    
    
    /// 获取合约名称
    ///
    /// - Parameter contractAddress: 合约地址
    /// - Returns: return value description
    public  func getContractName(contractAddress:String) -> ContractResult {
        let result = asset.name(contractAddress: contractAddress)
        return result
    }
    
    
    /// 获取合约的拥有者
    ///
    /// - Parameter contractAddress: 合约地址
    /// - Returns: return value description
    public  func getContractOwner(contractAddress:String) -> ContractResult {
        let result = asset.owner(contractAddress: contractAddress)
        return result
    }
    
    
    /// 获取资产的拥有者
    ///
    /// - Parameters:
    ///   - contractAddress: 合约地址
    ///   - tokenId: 资产 ID
    /// - Returns: return value description
    public func getTokenOwner(contractAddress:String,tokenId:String) -> ContractResult {
        let result = asset.ownerOf(contractAddress: contractAddress, tokenId: tokenId)
        return result
    }
    
    
    /// 获取合约简介
    ///
    /// - Parameter contractAddress: 合约地址
    /// - Returns: return value description
    public  func getContractSymbol(contractAddress:String) -> ContractResult {
        let result = asset.symbol(contractAddress: contractAddress)
        return result
    }
    
    
    /// 获取固定位置的 tokenID
    ///
    /// - Parameters:
    ///   - contractAddress:  合约地址
    ///   - index: 位置
    /// - Returns: return value description
    public  func tokenByIndex(contractAddress:String,index:String) -> ContractResult {
        let result = asset.tokenByIndex(contractAddress: contractAddress, index: index)
        return result
    }
    
    
    /// 获取固定位置的资产拥有者的tokenID
    ///
    /// - Parameters:
    ///   - contractAddress: 合约地址
    ///   - owner: 资产拥有者地址
    ///   - index: 位置
    /// - Returns: return value description
    public func tokenOfOwnerByIndex(contractAddress:String,owner:String,index:String) -> ContractResult {
        let result = asset.tokenOfOwnerByIndex(contractAddress: contractAddress, owner: owner, index: index)
        return result
    }
    
    
    /// 获取资产描述信息
    ///
    /// - Parameters:
    ///   - contractAddress: 合约地址
    ///   - tokenId: 资产 ID
    /// - Returns: return value description
    public func getTokenURI(contractAddress:String,tokenId:String) -> ContractResult {
        let result = asset.tokenURI(contractAddress: contractAddress, tokenId: tokenId)
        return result
    }
    
    
    /// 获取合约下面的所有创建的资产
    ///
    /// - Parameter contractAddress: 合约地址
    /// - Returns: return value description
    public func totalSupply(contractAddress:String) -> ContractResult {
        let result = asset.totalSupply(contractAddress: contractAddress)
        return result
    }
    
    
    /// 设置资产是否可以转移
    ///
    /// - Parameters:
    ///   - privateKey: 资产拥有者的私钥
    ///   - contractAddress: 资产地址
    ///   - tokenId: 资产 ID
    ///   - canTransfer: 是否可以转移
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: getGasFee description
    /// - Returns: hash
    public func setCanTransfer(privateKey : String,contractAddress : String,tokenId : String,canTransfer : Bool,gasLimit:String = "",gasPrice:String = "",getGasFee : Bool = false) -> ContractResult{
        var gasLimit = gasLimit
        var gasPrice = gasPrice
        var getGasFee = getGasFee
        if !getGasFee{
            let result = asset.setCanTransfer(privateKey: privateKey, contractAddress: contractAddress, tokenId: tokenId, canTransfer: canTransfer, gasLimit: gasLimit, gasPrice: gasPrice, getGasFee: true)
            let isError = limIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice, getGasFee: &getGasFee, result: result)
            if let result = isError{
                return result
            }
        }else{
            limAndPriceIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice)
        }
        return asset.setCanTransfer(privateKey: privateKey, contractAddress: contractAddress, tokenId: tokenId, canTransfer: canTransfer, gasLimit: gasLimit, gasPrice: gasPrice, getGasFee: getGasFee)
    }
    
    /// 验证资产 ID 在合约中是否有效
    ///
    /// - Parameters:
    ///   - contractAddress: 合约地址
    ///   - tokenId: 资产 ID
    /// - Returns: return value description
    public func isValid(contractAddress:String,tokenId:String) -> ContractResult {
        let result = asset.valid(contractAddress: contractAddress, tokenId: tokenId)
        return result
    }
    
    
    /// 获取资产是否可以转送
    ///
    /// - Parameters:
    ///   - contractAddress: 资产地址
    ///   - tokenId:  tokenID
    /// - Returns: return value description
    public func getCanTransfer(contractAddress:String,tokenId:String) -> ContractResult {
        let result = asset.getCanTransfer(contractAddress: contractAddress, tokenId: tokenId)
        return result
    }
    
    
    public func tokenIds(contractAddress:String,owner:String) -> ContractResult {
        let result = asset.tokenIds(contractAddress: contractAddress, owner: owner)
        return result
    }
    
    
}
