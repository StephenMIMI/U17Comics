//
//  ClassifyModel.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/14.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit
import SwiftyJSON

class ClassifyModel: NSObject {
    var code: NSNumber?
    var data: ClassifyData?
    
    class func parseData(data: NSData) -> ClassifyModel {
        let json = JSON(data: data)
        let model = ClassifyModel()
        model.code = json["code"].number
        model.data = ClassifyData.parseModel(json["data"])
        return model
    }
}

class ClassifyData: NSObject {
    var message: String?
    var returnData: ClassifyReturnData?
    var stateCode: NSNumber?
    
    class func parseModel(json: JSON) -> ClassifyData {
        let model = ClassifyData()
        model.message = json["message"].string
        model.returnData = ClassifyReturnData.parseModel(json["returnData"])
        model.stateCode = json["stateCode"].number
        return model
    }
}

class ClassifyReturnData: NSObject {
    var rankingList: Array<ClassifyRankData>?
    var recommendSearch: String?
    var topList: Array<ClassifyTopList>?
    
    class func parseModel(json: JSON) -> ClassifyReturnData {
        let model = ClassifyReturnData()
        var tmpArray = Array<ClassifyRankData>()
        for (_,subjson) in json["rankingList"] {
            let tmpModel = ClassifyRankData.parseModel(subjson)
            tmpArray.append(tmpModel)
        }
        model.rankingList = tmpArray
        model.recommendSearch = json["recommendSearch"].string
        var tmpArray1 = Array<ClassifyTopList>()
        for (_,subjson) in json["topList"] {
            let tmpModel = ClassifyTopList.parseModel(subjson)
            tmpArray1.append(tmpModel)
        }
        model.topList = tmpArray1
        return model
    }
}

class ClassifyRankData: NSObject {
    var argCon: NSNumber?
    var argName: String?
    var argValue: NSNumber?
    var cover: String?
    var sortName: String?
    
    class func parseModel(json: JSON) -> ClassifyRankData {
        let model = ClassifyRankData()
        model.argCon = json["argCon"].number
        model.argName = json["argName"].string
        model.argValue = json["argValue"].number
        model.cover = json["cover"].string
        model.sortName = json["sortName"].string
        return model
    }
}

class ClassifyTopList: NSObject {
    var cover: String?
    var extra: ClassifyExtraData?
    var sortId: String?
    var sortName: String?
    
    class func parseModel(json: JSON) -> ClassifyTopList {
        let model = ClassifyTopList()
        model.cover = json["cover"].string
        model.extra = ClassifyExtraData.parseModel(json["extra"])
        model.sortId = json["sortId"].string
        model.sortName = json["sortName"].string
        return model
    }
}

class ClassifyExtraData: NSObject {
    var tabList: Array<ClassifyTabList>?
    var title: String?
    
    class func parseModel(json: JSON) -> ClassifyExtraData {
        let model = ClassifyExtraData()
        var tmpArray = Array<ClassifyTabList>()
        for (_,subjson) in json["tabList"] {
            let tmpModel = ClassifyTabList.parseModel(subjson)
            tmpArray.append(tmpModel)
        }
        model.tabList = tmpArray
        model.title = json["title"].string
        return model
    }
}

class ClassifyTabList: NSObject {
    var argCon: NSNumber?
    var argName: String?
    var argValue: NSNumber?
    var tabTitle: String?
    
    class func parseModel(json: JSON) -> ClassifyTabList {
        let model = ClassifyTabList()
        model.argCon = json["argCon"].number
        model.argName = json["argName"].string
        model.argValue = json["argValue"].number
        model.tabTitle = json["tabTitle"].string
        return model
    }
}
