//
//  String+Extension.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/5/5.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation

let huansuanBil = NSDecimalNumber(1)

extension String{
    
    func getLabel() -> String {
        if NSLocalizedString(self, comment: "") == self{
            let paths = Bundle.main.path(forResource: "en", ofType: "lproj")
            let strs =  NSLocalizedString(self, tableName: nil, bundle: Bundle.init(path: paths!)!, value: "", comment: "")
            return  strs
        }
        return NSLocalizedString(self, comment: "");
    }
    
    static func cheackStringIsNoBlank(str : String?) -> Bool{
        if(str == nil || str == ""){
            return false
        }
        return true
    }
    
    func cheackIsNumber() -> Bool{
        let pattern = "^[0-9]+$"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self)
    }
    
    func cheackEmail() -> Bool{
        let pattern = "^[A-Za-z\\d]+([-_.][A-Za-z\\d]+)*@([A-Za-z\\d]+[-.])+[A-Za-z\\d]{2,4}$"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self)
    }
    
    func cheackIsPrice() -> Bool{
        let patterns = "^[0-9]+$"
        let pattern = "^\\d+(\\.\\d{0,20})?$"
        let result = NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self) || NSPredicate(format: "SELF MATCHES %@", patterns).evaluate(with: self)
        return result
    }
    
    func cheackIsDMAReSell() -> Bool{
        let patterns = "^[0-9]+$"
        let pattern = "^\\d+(\\.\\d{0,2})?$"
        let result = NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self) || NSPredicate(format: "SELF MATCHES %@", patterns).evaluate(with: self)
        return result
    }
    
    func cheackIsDmaAddress() -> Bool{
        let pattern = "^0x.+"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self)
    }
    
    func cheackIsElaAddress() -> Bool{
        let pattern = "^E.+|^e.+"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self)
    }
    
    ///获取字符串高度H
    func getNormalStrH(str: String, strFont: CGFloat, w: CGFloat) -> CGFloat {
        return getNormalStrSize(str: str, font: strFont, w: w, h: CGFloat.greatestFiniteMagnitude).height
    }
    
    ///获取字符串高度H
    func getNormalStrH(strFont: CGFloat, w: CGFloat) -> CGFloat {
        return getNormalStrSize(str: self, font: strFont, w: w, h: CGFloat.greatestFiniteMagnitude).height
    }
    
    ///获取字符串宽度
    func getNormalStrW(strFont: CGFloat, h: CGFloat) -> CGFloat {
        return getNormalStrSize(str: self, font: strFont, w: CGFloat.greatestFiniteMagnitude, h: h).width
    }
    
    /**获取字符串尺寸--私有方法*/
    private func getNormalStrSize(str: String? = nil, attriStr: NSMutableAttributedString? = nil, font: CGFloat, w: CGFloat, h: CGFloat) -> CGSize {
        if str != nil {
            let strSize = (str! as NSString).boundingRect(with: CGSize(width: w, height: h), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: font)], context: nil).size
            return strSize
        }
        
        if attriStr != nil {
            let strSize = attriStr!.boundingRect(with: CGSize(width: w, height: h), options: .usesLineFragmentOrigin, context: nil).size
            return strSize
        }
        
        return CGSize(width: 0, height: 0)
        
    }
    
    func setPriceDecimal(dicimal : Int,isDown : Bool = false) -> String{
        var priceStr = ""
        let oldStr = String(self)
        let numberFormatter = NumberFormatter()
        if let _ = Double(oldStr){
            let price = NSNumber(value: Double(oldStr)!)
            //设置固定小数位
            numberFormatter.minimumFractionDigits = dicimal
            numberFormatter.maximumFractionDigits = dicimal
            if isDown{
                numberFormatter.roundingMode = .down
            }
            //设置最小整数
            numberFormatter.minimumIntegerDigits = 1
           
            //        numberFormatter.usesGroupingSeparator = true //设置用组分隔
            //        numberFormatter.groupingSeparator = "," //分隔符号
            //        numberFormatter.groupingSize = 3  //分隔位数
            if let _ = numberFormatter.string(from: price){
                priceStr = numberFormatter.string(from: price)!
            }else{
                return oldStr
            }
            
        }else{
            return oldStr
        }
        
        return priceStr
    }
    
    func elaToUsd(usdPrice : Double) -> String{
        var elaPrice = NSDecimalNumber(string: self)
        let usdPrices = NSDecimalNumber(value: usdPrice)
        elaPrice = elaPrice.dividing(by: huansuanBil)
        return elaPrice.multiplying(by: usdPrices).stringValue
    }
    

}
