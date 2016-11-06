//
//  Const.swift
//  U17Comics
//
//  Created by qianfeng on 16/10/24.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.mainScreen().bounds.width
let screenHeight = UIScreen.mainScreen().bounds.height

//淡绿色
let lightGreen = UIColor.init(red: 134/255.0, green: 222/255.0, blue: 97/255.0, alpha: 1.0)



//首页推荐
let homeRecommendUrl = "http://app.u17.com/v3/appV3_1/android/phone/comic/boutiqueListNew"
//首页更多页面
let homeMoreUrl = "http://app.u17.com/v3/appV3_1/android/phone/list/commonComicList"
//首页不知道什么鬼更多页面
let homeUnknownMoreUrl = "http://app.u17.com/v3/appV3_1/android/phone/comic/special?argCon=1&page=1"
//首页VIP
let homeVIPUrl = "http://app.u17.com/v3/appV3_1/android/phone/list/commonComicList?argValue=14&argName=topic&argCon=2&page=1"
//首页订阅
let homeSubscribeUrl = "http://app.u17.com/v3/appV3_1/android/phone/list/commonComicList?argValue=12&argName=topic&argCon=2&page=1"

//首页排行
let homeRankUrl = "http://app.u17.com/v3/appV3_1/android/phone/rank/list"
let homeRankDetail = "http://app.u17.com/v3/appV3_1/android/phone/list/commonComicList?"
//作品详情
let comicsDetailUrl = "http://app.u17.com/v3/appV3_1/android/phone/comic/detail_static_new?comicid="
//作品月票数量和评论
let comicsTicketUrl = "http://app.u17.com/v3/appV3_1/android/phone/comic/detail_realtime?comicid="
