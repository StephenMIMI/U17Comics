//
//  ReadComicModel.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/9.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReadComicModel: NSObject {
    var code: NSNumber?
    var data: ReadComicData?
    
    class func parseData(data: NSData) -> ReadComicModel {
        let json = JSON(data: data)
        let model = ReadComicModel()
        model.code = json["code"].number
        model.data = ReadComicData.parseModel(json["data"])
        return model
    }
}

class ReadComicData: NSObject {
    var message: String?
    var returnData: ReadComicReturnData?
    var stateCode: NSNumber?
    
    class func parseModel(json: JSON) ->ReadComicData {
        let model = ReadComicData()
        model.message = json["message"].string
        model.returnData = ReadComicReturnData.parseModel(json["returnData"])
        model.stateCode = json["stateCode"].number
        return model
    }
}

class ReadComicReturnData: NSObject {
    var chapter_id: String?
    var image_list: Array<ReadComicImage>?
    var type: String?
    var zip_file_high: String?
    
    class func parseModel(json: JSON) -> ReadComicReturnData {
        let model = ReadComicReturnData()
        model.chapter_id = json["chapter_id"].string
        var tmpArray = Array<ReadComicImage>()
        for (_,subjson) in json["image_list"] {
            let tmpModel = ReadComicImage.parseModel(subjson)
            tmpArray.append(tmpModel)
        }
        model.image_list = tmpArray
        model.type = json["type"].string
        model.zip_file_high = json["zip_file_high"].string
        return model
    }
}

class ReadComicImage: NSObject {
    var height: String?
    var image_id: String?
    var images: Array<ReadComicImageData>?
    var img05: String?
    var img50: String?
    var location: String?
    var total_tucao: String?
    var type: String?
    var webp: String?
    var width: String?
    
    class func parseModel(json: JSON) -> ReadComicImage {
        let model = ReadComicImage()
        model.height = json["height"].string
        model.image_id = json["image_id"].string
        var tmpArray = Array<ReadComicImageData>()
        for (_,subjson) in json["images"] {
            let tmpModel = ReadComicImageData.parseModel(subjson)
            tmpArray.append(tmpModel)
        }
        model.images = tmpArray
        model.img05 = json["img05"].string
        model.img50 = json["img50"].string
        model.location = json["location"].string
        model.total_tucao = json["total_tucao"].string
        model.type = json["type"].string
        model.webp = json["webp"].string
        model.width = json["width"].string
        return model
    }
}

class ReadComicImageData: NSObject {
    var height: String?
    var id: String?
    var img05: String?
    var img50: String?
    var sort: String?
    var width: String?
    
    class func parseModel(json: JSON) -> ReadComicImageData {
        let model = ReadComicImageData()
        model.height = json["height"].string
        model.id = json["id"].string
        model.img05 = json["img05"].string
        model.img50 = json["img50"].string
        model.sort = json["sort"].string
        model.width = json["width"].string
        return model
    }
}
