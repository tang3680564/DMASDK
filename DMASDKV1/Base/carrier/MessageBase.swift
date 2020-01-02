//
//  MessageBase.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/6/5.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation
import ElastosCarrierSDK
public protocol MessageDelegate : CarrierDelegate{
   
}
class MessageBase : NSObject{
    var connected=false
    var delegate : MessageDelegate?
    var fileDelegate : CarrierFileTransferDelegate?
    var transfer : CarrierFileTransfer?
    var sendFileTransfer : CarrierFileTransfer?
    var fromAddress = ""
    var filePath = ""
    var tempUserId = ""
    static let SelfInfoChanged = NSNotification.Name("kNotificationSelfInfoChanged")
    static let DeviceListChanged = NSNotification.Name("kNotificationDeviceListChanged")
    static let DeviceStatusChanged = NSNotification.Name("kNotificationDeviceStatusChanged")
    
    // MARK: - Variables
    var status = CarrierConnectionStatus.Disconnected;
    @objc(sharedInstance)
    var sharedInstance: Carrier!
    var fileManager : CarrierFileTransferManager?
    //public let delegate = self
    public let options = CarrierOptions()
    
    fileprivate var networkManager : NetworkReachabilityManager?
    fileprivate static let checkURL = "https://apache.org"
    
    //var devices = [Device]()
    
    // MARK: - Private variables
    
    override init() {
        Carrier.setLogLevel(.Debug)
    }
    
    public func isConnected() -> Bool {
        return connected
    }
    
    public func kill() {
        connected=false
        sharedInstance.kill()
    }
    
    public func start() {
        do {
            print("Start")
            
            if networkManager == nil {
                let url = URL(string: MessageBase.checkURL)
                networkManager = NetworkReachabilityManager(host: url!.host!)
                print("Network reachable")
            }
            
            guard networkManager!.isReachable else {
                print("network is not reachable")
                networkManager?.listener = { [weak self] newStatus in
                    if newStatus == .reachable(.ethernetOrWiFi) || newStatus == .reachable(.wwan) {
                        self?.start()
                    }
                }
                networkManager?.startListening()
                return
            }
            
            if networkManager!.isReachable{
                print("Network is reachable")
            }
            
            let carrierDirectory: String = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0] + "/carrier"
            if !FileManager.default.fileExists(atPath: carrierDirectory) {
                var url = URL(fileURLWithPath: carrierDirectory)
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                
                var resourceValues = URLResourceValues()
                resourceValues.isExcludedFromBackup = true
                try url.setResourceValues(resourceValues)
            }
            
            let options = CarrierOptions()
            options.bootstrapNodes = [BootstrapNode]()
            
            let bootstrapNode = BootstrapNode()
            
            bootstrapNode.ipv4 = "13.58.208.50"
            bootstrapNode.port = "33445"
            bootstrapNode.publicKey = "89vny8MrKdDKs7Uta9RdVmspPjnRMdwMmaiEW27pZ7gh"
            options.bootstrapNodes?.append(bootstrapNode)
            
            bootstrapNode.ipv4 = "18.216.102.47"
            bootstrapNode.port = "33445"
            bootstrapNode.publicKey = "G5z8MqiNDFTadFUPfMdYsYtkUDbX5mNCMVHMZtsCnFeb"
            options.bootstrapNodes?.append(bootstrapNode)
            
            bootstrapNode.ipv4 = "18.216.6.197"
            bootstrapNode.port = "33445"
            bootstrapNode.publicKey = "H8sqhRrQuJZ6iLtP2wanxt4LzdNrN2NNFnpPdq1uJ9n2"
            options.bootstrapNodes?.append(bootstrapNode)
            
            bootstrapNode.ipv4 = "52.83.171.135"
            bootstrapNode.port = "33445"
            bootstrapNode.publicKey = "5tuHgK1Q4CYf4K5PutsEPK5E3Z7cbtEBdx7LwmdzqXHL"
            options.bootstrapNodes?.append(bootstrapNode)
            
            bootstrapNode.ipv4 = "52.83.191.228"
            bootstrapNode.port = "33445"
            bootstrapNode.publicKey = "3khtxZo89SBScAMaHhTvD68pPHiKxgZT6hTCSZZVgNEm"
            options.bootstrapNodes?.append(bootstrapNode)
            
            let hiveBootstrapNode = HiveBootstrapNode()
            hiveBootstrapNode.ipv4 = "18.217.147.205"
            hiveBootstrapNode.port = "9094"
            options.hivebootstrapNodes?.append(hiveBootstrapNode)
            
            hiveBootstrapNode.ipv4 = "18.219.53.133"
            hiveBootstrapNode.port = "9094"
            options.hivebootstrapNodes?.append(hiveBootstrapNode)
            
            options.bootstrapNodes?.append(bootstrapNode)
            
            options.udpEnabled = true
            options.persistentLocation = carrierDirectory
            
            try Carrier.initializeSharedInstance(options: options, delegate: self)
            print("carrier instance created")
          
            sharedInstance = Carrier.sharedInstance()
            do {
                try CarrierFileTransferManager.initializeSharedInstance(carrier: sharedInstance) { (carr, str, info) in
                    self.fileManager = CarrierFileTransferManager.sharedInstance()
                    do {
                        if self.fromAddress != str {
                           self.transfer = try self.fileManager?.createFileTransfer(to: str, withFileInfo: nil, delegate: self)
                            self.fromAddress = str
                        }
                       print("aaass")
                       print(self.transfer)
                       try self.transfer!.acceptConnectionRequest()
                       
                    }catch let error {
                        print(error.localizedDescription)
                    }
                }
                
            }catch{
                
            }
            
            
            try! sharedInstance.start(iterateInterval: 1000)
            print("carrier started, waiting for ready")
            
        }
        catch {
            NSLog("Start carrier instance error : \(error.localizedDescription)")
        }
    }
    
    public func getAddress() -> String{
        let address=sharedInstance.getAddress()
        return address
    }
    
    
    func cheackFriendIsConnect(userId : String ) -> Bool{
        if let friend = getFriendInfo(userId: userId){
            if friend.status == CarrierConnectionStatus.Connected{
                return true
            }else{
                return false
            }
        }else{
            return false
        }
        
    }
    
    public func getUserId() -> String{
        let userId=sharedInstance.getUserId()
        return userId
    }
    
    public func isValidAddress(address: String) -> Bool{
        return Carrier.isValidAddress(address)
    }
    
    public func isValidUserId(userId: String) -> Bool{
        return Carrier.isValidUserId(userId)
    }
    
    public func addFriend(address: String, message: String, nickname: String) -> Bool{
        var response:Bool=true
        do{
          
            try sharedInstance.addFriend(with: address, withGreeting: message)
        }
        catch is CarrierError{
            response=false
        }
        catch{}
        return response
    }
    
    public func acceptFriend(userId: String, nickname: String) -> Bool{
        var response:Bool=true
        do{
           
            try sharedInstance.acceptFriend(with: userId)
           
        }
        catch is CarrierError{
            response=false
        }
        catch{}
        return response
    }
    
    public func removeFriend(userId: String) -> Bool{
        var response:Bool=true
        do{
            try sharedInstance.removeFriend(userId)
        }
        catch is CarrierError{
            response=false
        }
        catch{}
        return response
    }
    
    public func sendFriendMessage(userId: String, message: String) -> Bool{
        let messageData:Data!=message.data(using: .utf8)
        var response:Bool=true
        do{
            
            try sharedInstance.sendFriendMessage(to: userId, withData: messageData)
        }
        catch is CarrierError{
            response=false
        }
        catch{}
        return response
    }
    
    public func getSelfInfo() -> CarrierUserInfo? {
        var userInfo:CarrierUserInfo?
        do{
            try userInfo=sharedInstance.getSelfUserInfo()
        }
        catch is CarrierError{
            userInfo=nil
        }
        catch{}
        return userInfo
    }
    
    public func setSelfInfo(userInfo: CarrierUserInfo) -> Bool{
        var response:Bool=true
        do{
            try sharedInstance.setSelfUserInfo(userInfo)
        }
        catch is CarrierError{
            response=false
        }
        catch{}
        return response
    }
    
    public func getFriendInfo(userId: String) -> CarrierFriendInfo? {
        var friendInfo:CarrierFriendInfo?
        do{
            try friendInfo=sharedInstance.getFriendInfo(userId)
        }
        catch is CarrierError{
            friendInfo=nil
        }
        catch{}
        return friendInfo
    }
    
    public func getPresenceStatus() -> String {
        var status="Available"
        do{
            var presenceStatus=CarrierPresenceStatus.None
            try presenceStatus=sharedInstance.getSelfPresence()
            if presenceStatus == CarrierPresenceStatus.None {
                status="Available"
            }
            else if presenceStatus == CarrierPresenceStatus.Away {
                status="Away"
            }
            else if presenceStatus == CarrierPresenceStatus.Busy {
                status="Busy"
            }
        }
        catch{}
        return status
    }
    
    public func setPresenceStatus(status: String) -> Bool {
        var response:Bool=true
        var presenceStatus=CarrierPresenceStatus.None
        if status == "Available" {
            presenceStatus=CarrierPresenceStatus.None
        }
        else if status == "Away" {
            presenceStatus=CarrierPresenceStatus.Away
        }
        else if status == "Busy" {
            presenceStatus=CarrierPresenceStatus.Busy
        }
        do{
            try sharedInstance.setSelfPresence(presenceStatus)
        }
        catch is CarrierError{
            response=false
        }
        catch{}
        return response
    }
    
    public func setMessageDelegate(delegates : MessageDelegate){
        self.delegate = delegates
    }
    
    func sendFile(userId : String , filePath : String ) -> String{
        do{
                self.fileManager = CarrierFileTransferManager.sharedInstance()
//                if tempUserId != userId{
//                 self.sendFileTransfer = try fileManager!.createFileTransfer(to: userId, withFileInfo: nil, delegate: self)
//                    tempUserId = userId
//                }
                let sendFileTransfers = try fileManager!.createFileTransfer(to: userId, withFileInfo: nil, delegate: self)
//                let fileId = try sendFileTransfers.acquireFileId(by: filePath)
//                try sendFileTransfers.sendConnectionRequest()
//                try sendFileTransfers.sendData(fileId: fileId, withData: UIImage(contentsOfFile: filePath)!.pngData()!)
        }catch let erro{
            print(erro.localizedDescription)
        }
        return ""
    }
    
    func initFriendFileSeesion(userID : String){
        do{
            if fileManager != nil{
                try fileManager!.createFileTransfer(to: userID, withFileInfo: nil, delegate: self)
            }else{
                print("fileManager is null")
            }
        }catch let error{
            print(error.localizedDescription)
        }
        
    }
    
    func getFriends() -> Array<CarrierFriendInfo>?{
        return try? sharedInstance.getFriends()
    }
}

// MARK: - CarrierDelegate
extension MessageBase : CarrierDelegate {
    
    func didBecomeReady(_ carrier: Carrier) {
        delegate?.didBecomeReady?(carrier)
        print("MainDelegate - didBecomeReady")
    }
    
    func connectionStatusDidChange(_ carrier: Carrier, _ newStatus: CarrierConnectionStatus) {
        print("MainDelegate - connectionStatusDidChange - "+newStatus.description)
        if newStatus == CarrierConnectionStatus.Connected {
            connected=true
            print(sharedInstance.getAddress())
        }
        else {
            connected=false
        }
         delegate?.connectionStatusDidChange?(carrier, newStatus)
    }
    
    func friendConnectionDidChange(_ carrier: Carrier, _ friendId: String, _ newStatus: CarrierConnectionStatus) {
        print("MainDelegate - friendConnectionDidChange - "+friendId+" - "+newStatus.description)
        delegate?.friendConnectionDidChange?(carrier, friendId, newStatus)
//        let friend=localDatabase.getFriendByUserId(userId: friendId)
//        if friend?.status == "pending" {
//            friend?.status="active"
//            localDatabase.update()
//        }
//
//        if newStatus == CarrierConnectionStatus.Connected {
//            localRepository.insertOnlineFriend(friend: friend!)
//        }
//        else{
//            localRepository.removeOnlineFriend(userId: friendId)
//        }
    }
    
    func newFriendAdded(_ carrier: Carrier, _ newFriend: CarrierFriendInfo) {
        print("MainDelegate - newFriendAdded - "+newFriend.userId!)
        delegate?.newFriendAdded?(carrier, newFriend)
//        let presenceStatus=getStringPresenceStatus(presence: newFriend.presence)
//        let friend=localDatabase.getFriendByUserId(userId: newFriend.userId!)
//        if friend == nil {
//            localDatabase.addFriend(userId: newFriend.userId!, nickname: tempNickname, status: "pending", type: "sent", message: tempMessage, hasUnread: false, presenceStatus: presenceStatus)
//        }
//        else {
//            var nickname=newFriend.userId
//            if tempAcceptedUserId != nil && tempAcceptedUserId == newFriend.userId {
//                nickname=tempAcceptedNickname
//            }
//            friend!.nickname=nickname
//            friend!.status="active"
//            friend!.presenceStatus=presenceStatus
//            localDatabase.update()
//        }
    }
    
    func friendRemoved(_ carrier: Carrier, _ friendId: String) {
        print("MainDelegate - friendRemoved - "+friendId)
        delegate?.friendRemoved?(carrier, friendId)
//        localDatabase.deleteFriendByUserId(userId: friendId)
//        localRepository.removeFriend(userId: friendId)
    }
    
    func didReceiveFriendRequest(_ carrier: Carrier, _ userId: String, _ userInfo: CarrierUserInfo, _ hello: String) {
        print("MainDelegate - didReceiveFriendRequest - "+userId+" - "+hello)
        self.acceptFriend(userId: userId, nickname: hello)
        delegate?.didReceiveFriendRequest?(carrier, userId, userInfo, hello)
//        let friend=localDatabase.getFriendByUserId(userId: userId)
//        if friend == nil {
//            var nickname=userInfo.name
//            if nickname == nil || nickname!.isEmpty {
//                nickname=userId
//            }
//            localDatabase.addFriend(userId: userId, nickname: nickname!, status: "pending", type: "received", message: hello, hasUnread: false, presenceStatus: "available")
//        }
    }
    
    func didReceiveFriendMessage(_ carrier: Carrier, _ from: String, _ data: Data) {
        delegate?.didReceiveFriendMessage?(carrier, from, data)
//        let messageText=String(data: data, encoding: .utf8)!
//        print("MainDelegate - didReceiveFriendMessage - "+from+" - "+messageText)
//        let message=localDatabase.addMessage(userId: from, text: messageText, datetime: Date.getCurrenDateTime(), type: "received", fileId: "null")
//        localRepository.insertMessage(message: message)
    }
    
    func didReceiveFriendInviteRequest(_ carrier: Carrier, _ from: String, _ data: String) {
        print("MainDelegate - didReceiveFriendInviteRequest - ")
        delegate?.didReceiveFriendInviteRequest?(carrier, from, data)
    }
    
    func friendPresenceDidChange(_ carrier: Carrier, _ friendId: String, _ newPresence: CarrierPresenceStatus) {
        print("MainDelegate - friendPresenceDidChange - "+friendId+" - "+newPresence.description)
        delegate?.friendPresenceDidChange?(carrier, friendId, newPresence)
//        let friend = localDatabase.getFriendByUserId(userId: friendId)
//        friend?.presenceStatus=getStringPresenceStatus(presence: newPresence)
//        localDatabase.update()
//        localRepository.updateOnlineFriendStatus(userId: friendId)
        
    }
    
    private func getStringPresenceStatus(presence: CarrierPresenceStatus) -> String {
        var status="available";
        if presence==CarrierPresenceStatus.None {
            status="available"
        }
        else if presence==CarrierPresenceStatus.Away {
            status="away"
        }
        else if presence==CarrierPresenceStatus.Busy {
            status="busy"
        }
        return status
    }
}

extension MessageBase : CarrierFileTransferDelegate{
    func fileTransferStateDidChange(_ fileTransfer: CarrierFileTransfer, _ newState: CarrierFileTransferConnectionState) {
        print("fileTransferStateDidChange")
        if(newState == CarrierFileTransferConnectionState.Closed){
            fileTransfer.close()
        }else if(newState == CarrierFileTransferConnectionState.Connected){
            print(fileTransfer.getPeer())
//            try? fileTransfer.acceptConnectionRequest()
//            if !self.filePath.isEmpty{
//                do{
//                    let fileId = try fileTransfer.acquireFileId(by: self.filePath)
//                    print(fileId)
//                    if let image = UIImage(contentsOfFile: self.filePath){
//                        try fileTransfer.sendData(fileId: fileId, withData: image.pngData()!)
//                    }
//                }catch{
//                    print(error.localizedDescription)
//                }
//
//            }
            
        }
    }
    
    func didReceiveFileRequest(_ fileTransfer: CarrierFileTransfer, _ fileId: String, _ fileName: String, _ fileSize: UInt64) {
//        try? fileTransfer.pendTransfering(fileId: fileId)
        print("didReceiveFileRequest")
        print(fileTransfer)
        print(fileId)
        print(fileName)
        print(fileSize)
        do{
            try fileTransfer.sendPullRequest(fileId: fileId, withOffset: fileSize)
        }catch{
            print(error.localizedDescription)
        }
        
       
    }
    
    func didReceivePullRequest(_ fileTransfer: CarrierFileTransfer, _ fileId: String, _ offset: UInt64) {
        print("didReceivePullRequest")
    }
    
    func didReceiveFileTransferData(_ fileTransfer: CarrierFileTransfer, _ fileId: String, _ data: Data) -> Bool {
        print("didReceiveFileTransferData")
        print(data.count)
        if(data.count > 0){
            
        }
        return true
    }
    
    func fileTransferPending(_ fileTransfer: CarrierFileTransfer, _ fileId: String) {
        print("fileTransferPending")
    }
    
    func fileTransferResumed(_ fileTransfer: CarrierFileTransfer, _ fileId: String) {
        print("fileTransferResumed")
    }
    
    func fileTransferWillCancel(_ fileTransfer: CarrierFileTransfer, _ fileId: String, _ status: Int, _ reason: String) {
        print("fileTransferWillCancel")
    }
}
