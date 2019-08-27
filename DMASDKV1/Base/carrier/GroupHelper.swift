//
//  Group.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/5/22.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation


class GroupHelper : NSObject{
    
    
    override init() {
        super.init()
    }
    
    /**
     * create new group
     * @param name group title
     * @return
     */
    //@Override
    func  createRoom(_ name : String ) -> String{
        return ""
    }
    
    /**
     * invite a friend to room
     * @param groupId
     * @param userId
     * @return
     */
    //@Override
    func  inviteToRoom( _ groupId : String , _ userId : String ) -> Bool{
        return false
    }
    
    /**
     * accept invite request
     * @param cookieText
     * @param hostUserId
     * @return
     */
    //@Override
    func joinRoom(_ cookieText : String , _ hostUserId : String) -> Bool{
        return false
    }
    
    /**
     * close room
     * @param groupId
     * @return
     */
    ///@Override
    func closeRoom(_ groupId : String) -> Bool{
        return false
    }
    
    /**
     * delete room
     * @param groupId
     * @return
     */
    //@Override
    func deleteRoom(_ groupId : String ) -> Bool{
        return false;
    }
    
    /**
     * set room title
     * @param groupId
     * @param title
     * @return
     */
    //@Override
    func setRoomTitle(_ groupId : String , _ title : String ) -> Bool {
        return false
    }
    
    /**
     * send room message
     * @param groupId
     * @param message
     * @return
     */
    //@Override
    func sendRoomMessage(_ groupId : String , _ message : String ) -> Bool{
        return false
    }
    
    /**
     * peer list
     * @param groupId
     * @return
     */
    //@Override
    func getPeerList(_ groupId : String ){
        
    }
}
