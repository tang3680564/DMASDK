//
//  DeployHelper.swift
//  DMASDK
//
//  Created by Zhangxz& on 2019/3/20.
//  Copyright © 2019 Zhangxz&. All rights reserved.
//

import UIKit
import web3swift
import BigInt

class DeployHelper: NSObject {
    
    var ethNode = assetManagementUrl!
    
    required init(url : String) {
        super.init()
        ethNode = URL(string: url)!
    }
    
    required override init() {
        super.init()
    }
    
    func setupDeploy(privateKey:String,abi:String,bytecode:String,parameters: [AnyObject] = [AnyObject](),gasLimit:String,gasPrice:String) -> ContractResult {
        
        let abi = getAbi(abi: abi)
        let bytecode = Data.fromHex(getAbi(abi: bytecode))
        let ethWallet = EthWallet()
        let keystoreJson = ethWallet.exportKeystoreFromPrivateKeyAndPassword(privateKey: privateKey, passWord: "")
        let keystore = EthereumKeystoreV3.init(keystoreJson!)
        let keystoreManager = KeystoreManager([keystore!])
        let account = keystoreManager.addresses![0]
        print(ethNode)
        print(parameters)
        let web3 = Web3.new(ethNode)
        web3?.provider.network = nil
        web3?.addKeystoreManager(keystoreManager)
        
        let contraction = web3?.contract(abi, at: nil, abiVersion: 2)
        var options = Web3Options.defaultOptions()
        options.gasLimit = BigUInt(gasLimit)
        options.gasPrice = BigUInt(gasPrice)
        options.from = account
        //        let param = [name ,symbol ,metadata ,isburn ] as [Any]
        
        let result = contraction?.deploy(bytecode: bytecode!, parameters: parameters, extraData: Data(), options: options)?.send(password: "", options: options)
        //
        switch result {
        case .success(let res)?:
            return self.waitSearchReceipt(web3: web3, hash: res.hash)
        case .failure(let error)?:
            return ContractResult.failure(error: error)
        case .none:
            return ContractResult.failure(error: "合约创建失败")
        }
    }
    
    func waitSearchReceipt(web3 : web3?,hash : String) -> ContractResult{
        print("waitSearchReceipt")
        sleep(1)
        let reuslt = web3?.eth.getTransactionReceipt(hash)
        guard case .success(let address)? = reuslt else {
            return waitSearchReceipt(web3 : web3,hash : hash)
        }
        return ContractResult.success(value: ["address":address.contractAddress?.address as Any])
    }
    
    
    func getAbi(abi:String) -> String {
//        let path = Bundle(for: type(of: self)).path(forResource: abi, ofType: "json")
        let path = Bundle.main.path(forResource: abi, ofType: "json")
        let data = NSData.init(contentsOfFile: path!)
        let abiString = String.init(data: data! as Data, encoding:.utf8)
        return abiString!
    }
}
