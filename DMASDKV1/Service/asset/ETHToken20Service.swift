//
//  ETHToken20Service.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/9/5.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation

public class ETHToken20Service : NSObject {
    var url = ""
    var tokenContract : TokenContract!
    
    public required init(url : String) {
        self.url = url
        tokenContract = TokenContract(url: url)
    }
    
    
    /// 发布合约
    ///
    /// - Parameters:
    ///   - privateKey: 私钥
    ///   - name: 合约名称
    ///   - symbol: 合约简介
    ///   - totalSupply: 发行总量
    ///   - tokenDecimals: 代币允许的小数位
    ///   - gasLimit: gasLimit description
    ///   - gasPrice: gasPrice description
    /// - Returns: ContractResult
    func setupDeploy(privateKey:String,name:String,symbol:String,totalSupply:String,tokenDecimals : Int  = 18,gasLimit:String,gasPrice:String) -> ContractResult {
        return tokenContract.setupDeploy(privateKey: privateKey, name: name, symbol: symbol, totalSupply: totalSupply, tokenDecimals: tokenDecimals, gasLimit: gasLimit, gasPrice: gasPrice)
    }
    
    /**
     * 返回string类型的ERC20代币的名字
     *
     * @param tokenAddress 代币地址
     * @return
     */
    public func getContractName(tokenAddress : String) -> ContractResult{
        return tokenContract.name(contractAddress: tokenAddress)
    }
    
    /**
     * 返回string类型的ERC20代币的符号
     *
     * @param tokenAddress 代币地址
     * @return
     */
    public func getContractSymbol(tokenAddress : String) -> ContractResult{
        return tokenContract.symbol(contractAddress: tokenAddress)
    }
    
    /**
     * 支持几位小数点后几位
     *
     * @param tokenAddress 代币地址
     * @return
     */
    public func decimals(tokenAddress : String ) -> ContractResult{
        return tokenContract.decimals(contractAddress: tokenAddress)
    }
    
    /**
     * 发行代币的总量
     *
     * @param tokenAddress 代币地址
     * @return
     */
    public func totalSupply(tokenAddress : String) -> ContractResult{
        return tokenContract.totalSupply(contractAddress: tokenAddress)
    }
    
    /**
     * 获取该地址代币的余额
     *
     * @param tokenAddress 代币地址
     * @param owner        代币拥有者地址
     * @return
     */
    public func balanceOf(tokenAddress : String , owner : String ) -> ContractResult{
        return tokenContract.balanceOf(contractAddress: tokenAddress, owner: owner)
    }
    
    
    /**
     * 将自己的token转账给_to地址，_value为转账个数
     *
     * @param tokenAddress 代币地址
     * @param to           接收方地址
     * @param value        转账个数
     * @return
     */
    public func transfer(tokenAddress : String ,privateKey : String ,to : String , value : String , gasPrice : String = "" , gasLimit: String = "" ,getGasFee : Bool = false) -> ContractResult{
        if gasLimit.isEmpty || getGasFee{
            let result = tokenContract.transfer(privateKey: privateKey, contractAddress: tokenAddress, to: to, value: value, gasLimit: defaultGasLimit, gasPrice: defaultGasPrice,getGasFee: true)
            if getGasFee{
                return result
            }
            guard case .success(let dic) = result else{
                return result
            }
            guard let gas = dic["gas"] else{
                return tokenContract.transfer(privateKey: privateKey, contractAddress: tokenAddress, to: to, value: value, gasLimit: defaultGasLimit, gasPrice: defaultGasPrice)
            }
            if !banlanceIsOverLimt(privateKey : privateKey,gasLimt: "\(gas)"){
                return ContractResult.failure(error: DMASDKError.BALANCE_UNDERFINANCED.getCodeAndMsg())
            }
            return tokenContract.transfer(privateKey: privateKey, contractAddress: tokenAddress, to: to, value: value, gasLimit: "\(gas)", gasPrice: defaultGasPrice)
        }
        return tokenContract.transfer(privateKey: privateKey, contractAddress: tokenAddress, to: to, value: value, gasLimit: gasLimit, gasPrice: gasPrice)
    }
    
    /**
     * 批准_spender账户从自己的账户转移_value个token。可以分多次转移。
     *
     * @param tokenAddress 代币地址
     * @param spender      花费者地址
     * @param value        可花费个数
     * @return
     */
    public func approve(tokenAddress : String , privateKey : String , spender : String , value : String , gasPrice : String = "" , gasLimit : String = "" ,getGasFee : Bool = false) -> ContractResult{
        if gasLimit.isEmpty || getGasFee{
            let result = tokenContract.approve(privateKey: privateKey, contractAddress: tokenAddress, spender: spender, value: value, gasLimit: defaultGasLimit, gasPrice: defaultGasPrice,getGasFee: true)
            if getGasFee{
                return result
            }
            guard case .success(let dic) = result else{
                return result
            }
            guard let gas = dic["gas"] else{
                return tokenContract.approve(privateKey: privateKey, contractAddress: tokenAddress, spender: spender, value: value, gasLimit: defaultGasLimit, gasPrice: defaultGasPrice)
            }
            if !banlanceIsOverLimt(privateKey : privateKey,gasLimt: "\(gas)"){
                return ContractResult.failure(error: DMASDKError.BALANCE_UNDERFINANCED.getCodeAndMsg())
            }
            return tokenContract.approve(privateKey: privateKey, contractAddress: tokenAddress, spender: spender, value: value, gasLimit: "\(gas)", gasPrice: defaultGasPrice)
        }
        return tokenContract.approve(privateKey: privateKey, contractAddress: tokenAddress, spender: spender, value: value, gasLimit: gasLimit, gasPrice: gasPrice)
    }
    
    /**
     * 与approve搭配使用，approve批准之后，调用transferFrom函数来转移token。
     *
     * @param tokenAddress 代币地址
     * @param from         代币拥有者地址
     * @param to           代币接收者地址
     * @param value        转移个数
     * @return
     */
    public func transferFrom(tokenAddress : String , privateKey : String , from : String , to : String , value: String , gasPrice : String = "" , gasLimit : String = "" ,getGasFee : Bool = false ) -> ContractResult{
        
        if gasLimit.isEmpty || getGasFee{
            let result = tokenContract.transferFrom(privateKey: privateKey, contractAddress: tokenAddress, from: from, to: to, value: value, gasLimit: gasLimit, gasPrice: gasPrice,getGasFee: true)
            if getGasFee{
                return result
            }
            guard case .success(let dic) = result else{
                return result
            }
            guard let gas = dic["gas"] else{
                return tokenContract.transferFrom(privateKey: privateKey, contractAddress: tokenAddress, from: from, to: to, value: value, gasLimit: defaultGasLimit, gasPrice: defaultGasPrice)
            }
            if !banlanceIsOverLimt(privateKey : privateKey,gasLimt: "\(gas)"){
                return ContractResult.failure(error: DMASDKError.BALANCE_UNDERFINANCED.getCodeAndMsg())
            }
            return tokenContract.transferFrom(privateKey: privateKey, contractAddress: tokenAddress, from: from, to: to, value: value, gasLimit: "\(gas)", gasPrice: defaultGasPrice)
        }
        return tokenContract.transferFrom(privateKey: privateKey, contractAddress: tokenAddress, from: from, to: to, value: value, gasLimit: gasLimit, gasPrice: gasPrice)
    }
    
    /**
     * 返回_spender还能提取token的个数。
     *
     * @param tokenAddress 代币地址
     * @param owner
     * @param spender
     * @return
     */
    public func allowance(tokenAddress : String , owner : String , spender : String ) -> ContractResult{
        return tokenContract.allowance(contractAddress: tokenAddress, owner: owner, spender: spender)
    }
    
    
    public func getStatusByHash(hash : String ) -> ContractResult{
        let ethWallet = EthWallet()
        ethWallet.url = url
        return ethWallet.getStatusByHash(hash: hash)
    }
    
    
    
    /// 判断余额是否足够支付gasfee
    func banlanceIsOverLimt(address : String = "",privateKey : String = "" , gasLimt : String) -> Bool{
        var ethAddress = address
        let ethServer = EthService(url: url)
        if address.isEmpty{
            if privateKey.isEmpty{
                return false
            }
            ethAddress = ethServer.exportAddressFromPrivateKey(privateKey: privateKey)
        }
        let result = ethServer.balance(address: ethAddress)
        guard case .success(let dic) = result else{
            return false
        }
        guard let balance = dic["balance"] as? String else{
            return false
        }
        if NSDecimalNumber(string: balance).doubleValue > NSDecimalNumber(string: gasLimt).doubleValue{
            return true
        }
        return false
    }
}
