//
//  RechargeStatus.swift
//  Uptick
//
//  Created by StarryMedia 刘晓祥 on 2019/5/10.
//  Copyright © 2019 starrymedia. All rights reserved.
//

import Foundation


public enum RechargeStatus : String{
    case CLOSED = "-1" //用户取消订单
    case FIAT_TO_USDT_INIT = "1"//法币到usdt 订单创建
    case FIAT_TO_USDT_WAIT_PAY = "2"//法币到usdt 订单创建等待付款
    case FIAT_TO_USDT_ERROR = "3"//法币到usdt 订单取消
    case FIAT_TO_USDT_PAY = "4"//法币到usdt 用户已付款
    case FIAT_TO_USDT_SEND = "5"//法币到usdt 商家发货
    case FIAT_TO_USDT_SUCCESS = "6"//法币到usdt 交易成功
    case USDT_TO_ELA_INTI = "7"//usdt到ela订单创建
    case USDT_TO_ELA_ERROR = "8"//usdt到ela订单取消
    case USDT_TO_ELA_SUCCESS = "9"//usdt到ela订单成功
    case ELA_WITHDRAW_INIT = "10"//ela 提现订单成功
    case ELA_WITHDRAW_ERROR = "11"//ela 提现订单成功
    case ELA_WITHDRAW_SUCCESS = "12"//ela 提现订单成功
    case ELA_TO_DMA_INIT = "13"//ela到dma订单创建
    case ELA_TO_DMA_SEND = "14"//ela到dma订单创建
    case ELA_TO_DMA_ERROR = "15"//ela到dma订单失败
    case ELA_TO_DMA_SUCCESS = "16"//ela到dma订单成功
    case DMA_TO_ELA_INIT = "17"//dma到ela订单创建
    case DMA_TO_ELA_SEND = "18"//dma到ela订单创建
    case DMA_TO_ELA_ERROR = "19"//dma到ela订单失败
    case DMA_TO_ELA_SUCCESS = "20"//dma到ela订单成功
}
