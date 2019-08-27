//
//  DidProfile.swift
//  Choosit
//
//  Created by StarryMedia 刘晓祥 on 2019/6/28.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation
import HandyJSON

public class Profile: HandyJSON {
    /**
     * did地址
     */
    public var did : String = "";
    /**
     * 昵称
     */
    public var nickName : String = "";
    /**
     * 头像[full url]
     */
    public var profilePhotoUrl : String = "";
    /**
     * 性别
     */
    public var gender : Gender?;
    /**
     * 电话
     */
    public var phone : String = "";
    /**
     * 地区
     */
    public var region : String = "";
    /**
     * 身份证号码
     */
    public var idCard : String = "";
    /**
     * 邮件
     */
    public var email : String = "";
    
    public var didTime : String = "";
    
    required public init() {}
}


public enum Gender : String{
    case M
    case F
}
