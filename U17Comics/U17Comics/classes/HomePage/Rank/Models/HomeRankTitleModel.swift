//
//  HomeRankTitleModel.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/3.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomeRankTitleModel: NSObject {
    var code: NSNumber?
    var data: HomeRankTitleData?
    
    class func parseData(data: NSData) -> HomeRankTitleModel {
        let json = JSON(data: data)
        let model = HomeRankTitleModel()
        model.code = json["code"].number
        model.data = HomeRankTitleData.parseModel(json["data"])
        return model
    }
}

class HomeRankTitleData: NSObject {
    var message: String?
    var returnData: HomeRankTitleArray?
    var stateCode: NSNumber?
    
    class func parseModel(json: JSON) -> HomeRankTitleData {
        let model = HomeRankTitleData()
        model.message = json["message"].string
        model.returnData = HomeRankTitleArray.parseModel(json["returnData"])
        model.stateCode = json["stateCode"].number
        return model
    }
}

class HomeRankTitleArray: NSObject {
    var rankinglist: Array<HomeRankTitleReturnData>?
    
    class func parseModel(json: JSON) -> HomeRankTitleArray {
        let model = HomeRankTitleArray()
        var tmpArray = Array<HomeRankTitleReturnData>()
        for (_,subjson) in json["rankinglist"] {
            let tmpModel = HomeRankTitleReturnData.parseModel(subjson)
            tmpArray.append(tmpModel)
        }
        model.rankinglist = tmpArray
        return model
    }
}

class HomeRankTitleReturnData: NSObject {
    var argName: String?
    var argValue: String?
    var cover: String?
    var rankingType: String?
    var subTitle: String?
    var title: String?
    
    class func parseModel(json: JSON) -> HomeRankTitleReturnData {
        let model = HomeRankTitleReturnData()
        model.argName = json["argName"].string
        model.argValue = json["argValue"].string
        model.cover = json["cover"].string
        model.rankingType = json["rankingType"].string
        model.subTitle = json["subTitle"].string
        model.title = json["title"].string
        return model
    }
}
