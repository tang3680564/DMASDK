//
//  Group.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/5/22.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation


class GroupService : GroupHelper{
    
    
    override init() {
        super.init()
    }
    
    /**
     * create new group
     * @param name group title
     * @return
     */
 
    override func  createRoom(_ name : String ) -> String{
       return super.createRoom(name)
    }
    
    /**
     * invite a friend to room
     * @param groupId
     * @param userId
     * @return
     */
    //@Override
    override func inviteToRoom( _ groupId : String , _ userId : String ) -> Bool{
        return super.inviteToRoom(groupId, userId)
    }
    
    /**
     * accept invite request
     * @param cookieText
     * @param hostUserId
     * @return
     */
    //@Override
    override func joinRoom(_ cookieText : String , _ hostUserId : String) -> Bool{
        return super.joinRoom(cookieText, hostUserId)
    }
    
    /**
     * close room
     * @param groupId
     * @return
     */
    ///@Override
    override func closeRoom(_ groupId : String) -> Bool{
    return super.closeRoom(groupId)
    }
    
    /**
     * delete room
     * @param groupId
     * @return
     */
    //@Override
    override func deleteRoom(_ groupId : String ) -> Bool{
    return super.deleteRoom(groupId);
    }
    
    /**
     * set room title
     * @param groupId
     * @param title
     * @return
     */
    //@Override
    override func setRoomTitle(_ groupId : String , _ title : String ) -> Bool {
    return super.setRoomTitle(groupId, title)
    }
    
    /**
     * send room message
     * @param groupId
     * @param message
     * @return
     */
    //@Override
    override func sendRoomMessage(_ groupId : String , _ message : String ) -> Bool{
    return super.sendRoomMessage(groupId, message)
    }
    
    /**
     * peer list
     * @param groupId
     * @return
     */
    //@Override
    override func getPeerList(_ groupId : String ){
        super.getPeerList(groupId)
    }
}
