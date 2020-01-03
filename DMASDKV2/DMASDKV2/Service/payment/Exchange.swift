//
//  Exchange.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/9/25.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation
import web3swift
import DMASDKV1
public class Exchange: NSObject {
    
    var url = ""
    
    var abi = "Exchange"
    
    required init(url : String) {
        super.init()
        self.url = url
    }
    
    
    
    /// eth 转 token20 资产
    ///
    /// - Parameters:
    ///   - privateKey: 私钥
    ///   - contractAddress: 转换的合约地址
    ///   - value: 转账金额
    ///   - address: 转账给哪个地址
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: getGasFee description
    /// - Returns: return value description
    public func ethExchangeToken(privateKey : String,contractAddress : String,value : String , address : String,gasLimit : String = "" ,gasPrice : String = "" ,getGasFee : Bool = false) -> ContractResult{
        let param : NSMutableArray = [Web3.Utils.parseToBigUInt(value, units: .eth)!,address]
        let contract = ContractMethodHelper(url: url)
        var gasLimit = gasLimit
        var gasPrice = gasPrice
        var getGasFee = getGasFee
       
        if !getGasFee{
            let result = contract.getContract(abi: abi, contractAddress: contractAddress, method: "ethExchangeToken", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice, weiValue: value, getGasFee: true)
            let isError = limIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice, getGasFee: &getGasFee, result: result)
            if let result = isError{
                return result
            }
        }else{
            limAndPriceIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice)
        }
        let result = contract.getContract(abi: abi, contractAddress: contractAddress, method: "ethExchangeToken", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice, weiValue: value, getGasFee: getGasFee)
        guard case .success(let dic) = result else{
            return result
        }
        guard let hash = dic["hash"] as? String else{
            return result
        }
       
        return ContractResult.success(value: ["hash" : hash,"gas" : gasLimit.getWeb3ValueInWei() ?? "0"])
    }
    
    
    
   
    /// token20 转 eth
    ///
    /// - Parameters:
    ///   - privateKey:  转账的私钥
    ///   - token20ContractAddress: token20 的合约地址
    ///   - contractAddress: 转换的合约地址
    ///   - value: 转账金额
    ///   - address: 转账给哪个地址
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    ///   - getGasFee: getGasFee description
    public func tokenExchangeEth(privateKey : String,token20ContractAddress : String,contractAddress : String,value : String , address : String,gasLimit : String = "",gasPrice : String = "",getGasFee : Bool = false) -> ContractResult{
        let tokenContract = TokenContract(url: url)
        let result = tokenContract.approve(privateKey: privateKey, contractAddress: token20ContractAddress, spender: contractAddress, value: value)
        switch result {
        case .success(value: let dic):
            print(dic)
            guard let hash = dic["hash"] as? String else{
                return ContractResult.failure(error: DMASDKError.RPC_REQUEST_FAILED.getCodeAndMsg())
            }
            guard var gasUse = dic["gas"] as? String else{
                return ContractResult.failure(error: DMASDKError.RPC_REQUEST_FAILED.getCodeAndMsg())
            }
            let delup = DeployHelper(url: url)
            let web3 = Web3.new(URL(string: url)!)
            web3?.provider.network = nil
            _ = delup.waitSearchReceipt(web3: web3, hash: hash)
            let param : NSMutableArray = [Web3.Utils.parseToBigUInt(value, units: .eth)!,address]
            let contract = ContractMethodHelper(url: url)
            var gasLimit = gasLimit
            var gasPrice = gasPrice
            var getGasFee = getGasFee
            if !getGasFee{
                let result = contract.getContract(abi: abi, contractAddress: contractAddress, method: "TokenExchangeEth", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice, getGasFee: true)
                let isError = limIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice, getGasFee: &getGasFee, result: result)
                if let result = isError{
                    return result
                }
            }else{
                limAndPriceIsEmpty(gasLimit: &gasLimit, gasPrice: &gasPrice)
            }
            let result = contract.getContract(abi: abi, contractAddress: contractAddress, method: "TokenExchangeEth", privateKey: privateKey, parameters: param as [AnyObject], gasLimit: gasLimit, gasPrice: gasPrice,getGasFee: getGasFee)
            gasUse = NSDecimalNumber(string: gasUse).adding(NSDecimalNumber(string: gasLimit)).stringValue
            let useGasLimt = gasUse.getWeb3ValueInWei() ?? "0"
            guard case .success(let dic) = result else{
                return result
            }
            guard let hashs = dic["hash"] as? String else{
                return result
            }
            return ContractResult.success(value: ["hash" : hashs,"gas" : useGasLimt])
        case .failure(error: let error):
            print(error)
            return ContractResult.failure(error: DMASDKError.APPROVE_TOKEN_BALANCE_UNDERFINANCED.getCodeAndMsg())
        }
    }
    
    
    
}
