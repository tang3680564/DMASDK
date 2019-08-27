//
//  CarrierHelper.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/5/22.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation
import ElastosCarrierSDK
public class MessageService : NSObject{
    
    private static let sharedInstance = MessageBase()
    
    public required override init() {
        super.init()
    }
    /**
     * carrier is connected ?
     *
     * @return
     */
    
   public func isConnected() -> Bool{
        return MessageService.sharedInstance.isConnected();
    }
    
    /**
     * run carrier
     */
    
    public func run() {
        MessageService.sharedInstance.start()
    }
    
    /**
     * clean carrier
     */
    
    public func cleanup() {
//        cleanup()
    }
    
    /**
     * kill carrier
     */
    
    public func kill() {
        MessageService.sharedInstance.kill()
    }
    
    /**
     * stop send file
     *
     * @param fileId fileId
     */
    
    public func stopFile(fileId : String ) {
//        stopFile(fileId: fileId)
    }
    
    /**
     * send a file to friend
     *
     * @param userId
     * @param filePath
     * @return
     */
    
     public func sendFile(userId : String , filePath : String ) -> String {
        return MessageService.sharedInstance.sendFile(userId: userId, filePath: filePath);
    }
    
    /**
     * get my carrier address
     *
     * @return
     */
    
     public func  getAddress() -> String{
        return MessageService.sharedInstance.getAddress();
    }
    
    /**
     * get my carrier userId ,not eq carrier address
     *
     * @return
     */
    
     public func  getUserId() -> String{
        return MessageService.sharedInstance.getUserId();
    }
    
    /**
     * valid address
     *
     * @param address carrier address
     * @return
     */
    
     public func  isValidAddress(address : String ) -> Bool {
        return MessageService.sharedInstance.isValidAddress(address: address);
    }
    
    /**
     * valid userId
     *
     * @param userId carrier userId ,not eq carrier address
     * @return
     */
    
     public func isValidUserId(userId : String ) -> Bool {
        return MessageService.sharedInstance.isValidUserId(userId: userId);
    }
    
    /**
     * add friend
     *
     * @param address  carrier address
     * @param message  m
     * @param nickname
     * @return
     */
    
     public func addFriend(address : String , message : String , nickname : String ) -> Bool{
        return MessageService.sharedInstance.addFriend(address: address, message: message, nickname: nickname);
    }
    
    /**
     * accept friend request
     *
     * @param userId   friend userId
     * @param nickname nick name
     * @return
     */
    
     public func acceptFriend(userId : String , nickname : String ) -> Bool {
        return MessageService.sharedInstance.acceptFriend(userId: userId, nickname: nickname);
    }
    
    /**
     * remove friend by userId
     *
     * @param userId userId
     * @return
     */
    
     public func removeFriend(userId : String ) -> Bool{
        return MessageService.sharedInstance.removeFriend(userId: userId);
    }
    
    /**
     * send message to userId
     *
     * @param userId
     * @param message
     * @return
     */
    
     public func sendFriendMessage(userId : String , message : String ) -> Bool{
        return MessageService.sharedInstance.sendFriendMessage(userId: userId, message: message);
    }
    
    /**
     * profile
     *
     * @return
     */
    /// -> UserInfo
     public func getSelfInfo() -> CarrierUserInfo?{
        return MessageService.sharedInstance.getSelfInfo();
    }
    
    /**
     * set profile
     *
     * @param userInfo
     * @return
     */
    /// 参数 UserInfo userInfo
     public func  setSelfInfo(userInfo : CarrierUserInfo) -> Bool{
        return MessageService.sharedInstance.setSelfInfo(userInfo: userInfo);
    }
    
    /**
     * get friend by userId
     *
     * @param userId
     * @return
     */
    /// -> FriendInfo
    public func  getFriend(userId : String ) -> CarrierFriendInfo?{
        return MessageService.sharedInstance.getFriendInfo(userId: userId)
    }
    
     public func initFriendFileSeesion(userID : String){
        MessageService.sharedInstance.initFriendFileSeesion(userID: userID)
    }
    
    /**
     * get my friends
     *
     * @return
     */
    /// -> List<FriendInfo>
     public func getFriends() -> Array<CarrierFriendInfo>?{
        return MessageService.sharedInstance.getFriends()
    }
    
    /**
     * get elastosCarrier instance
     *
     * @return
     */
    /// -> ElastosCarrier
     public func getElastosCarrier() -> Carrier {
        return MessageService.sharedInstance.sharedInstance
    }
    
    ///检测好友是否在线
     public func cheackFriendIsConnect(userId : String ) -> Bool{
        return MessageService.sharedInstance.cheackFriendIsConnect(userId: userId)
    }
    
    public func setMessageDelegate(delegate : MessageDelegate){
        MessageService.sharedInstance.delegate = delegate
    }
}
