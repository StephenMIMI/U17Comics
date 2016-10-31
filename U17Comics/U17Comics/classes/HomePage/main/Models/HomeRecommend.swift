//
//  HomeRecommend.swift
//  U17Comics
//
//  Created by qianfeng on 16/10/24.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomeRecommend: NSObject {
    var code: String?
    var data: HomeRecommendData?
    
    class func parseData(data: NSData) -> HomeRecommend {
        let json = JSON(data: data)
        let model = HomeRecommend()
        model.code = json["code"].string
        model.data = HomeRecommendData.parseModel(json["data"])
        return model
    }
}

class HomeRecommendData: NSObject {
    var message: String?
    var returnData: HomeReturnData?
    var stateCode: NSNumber?
    
    class func parseModel(json: JSON) -> HomeRecommendData {
        let model = HomeRecommendData()
        model.message = json["message"].string
        model.returnData = HomeReturnData.parseModel(json["returnData"])
        model.stateCode = json["stateCode"].number
        return model
    }
}

class HomeReturnData: NSObject {
    var comicLists: Array<HomeComicList>?
    var galleryItems: Array<HomeGalleryItem>?
    var textItems: Array<HomeTextItem>?
    
    class func parseModel(json: JSON) -> HomeReturnData {
        let model = HomeReturnData()
        var tmpComicLists = Array<HomeComicList>()
        for (_,subjson) in json["comicLists"] {
            tmpComicLists.append(HomeComicList.parseModel(subjson))
        }
        model.comicLists = tmpComicLists
        
        var tmpGalleryArray = Array<HomeGalleryItem>()
        for (_,subjson) in json["galleryItems"] {
            tmpGalleryArray.append(HomeGalleryItem.parseModel(subjson))
        }
        model.galleryItems = tmpGalleryArray
        
        var tmpTextItemArray = Array<HomeTextItem>()
        for (_,subjson) in json["textItems"] {
            tmpTextItemArray.append(HomeTextItem.parseModel(subjson))
        }
        model.textItems = tmpTextItemArray
        return model
    }
}

class HomeComicList: NSObject {
    var argName: String?
    var argType: NSNumber?
    var argValue: NSNumber?
    var comics: Array<HomeComicData>?
    var comicType: NSNumber?
    var description1: String?
    var itemTitle: String?
    var newTitleIconUrl: String?
    var titleIconUrl: String?
    
    class func parseModel(json: JSON) -> HomeComicList {
        let model = HomeComicList()
        model.argName = json["argName"].string
        model.argType = json["argType"].number
        model.argValue = json["argValue"].number
        
        //初始化一个临时空数组
        var tmpComicArray = Array<HomeComicData>()
        for (_,subjson) in json["comics"] {
            tmpComicArray.append(HomeComicData.parseModel(subjson))
        }
        model.comics = tmpComicArray
        model.comicType = json["comicType"].number
        model.description1 = json["description"].string
        model.itemTitle = json["itemTitle"].string
        model.newTitleIconUrl = json["newTitleIconUrl"].string
        model.titleIconUrl = json["titleIconUrl"].string
        return model
    }
}

class HomeComicData: NSObject {
    var author_name: String?
    var chapterNew: NSNumber?
    var comicId: NSNumber?
    var cornerInfo: String?
    var cover: String?
    var is_vip: NSNumber?
    var name: String?
    var short_description: String?
    var ext: Array<HomeTextExt>?
    var tags: Array<String>?
    
    class func parseModel(json: JSON) -> HomeComicData {
        let model = HomeComicData()
        model.author_name = json["author_name"].string
        model.chapterNew = json["chapterNew"].number
        model.comicId = json["comicId"].number
        model.cornerInfo = json["cornerInfo"].string
        model.cover = json["cover"].string
        model.is_vip = json["is_vip"].number
        model.name = json["name"].string
        model.short_description = json["short_description"].string
        //初始化一个临时空数组
        var tmpExtArray = Array<HomeTextExt>()
        for (_,subjson) in json["ext"] {
            tmpExtArray.append(HomeTextExt.parseModel(subjson))
        }
        model.ext = tmpExtArray
        //初始化一个临时空数组
        var tmpTags = Array<String>()
        for (_,subjson) in json["tags"] {
            tmpTags.append(subjson.string!)
        }
        model.tags = tmpTags
        return model
    }
}


class HomeGalleryItem: NSObject {
    var content: String?
    var cover: String?
    var ext: Array<HomeGalleryExt>?
    var id: NSNumber?
    var linkType: NSNumber?
    var title: String?
    
    class func parseModel(json: JSON) -> HomeGalleryItem {
        let model = HomeGalleryItem()
        model.content = json["content"].string
        model.cover = json["cover"].string
        
        var tmpExtArray = Array<HomeGalleryExt>()
        for (_,subjson) in json["ext"] {
            tmpExtArray.append(HomeGalleryExt.parseModel(subjson))
        }
        model.ext = tmpExtArray
        model.id = json["id"].number
        model.linkType = json["linkType"].number
        model.title = json["title"].string
        return model
    }
}

class HomeGalleryExt: NSObject {
    var key: String?
    var val: String?
    
    class func parseModel(json: JSON) -> HomeGalleryExt {
        let model = HomeGalleryExt()
        model.key = json["key"].string
        model.val = json["val"].string
        return model
    }
}

class HomeTextItem: NSObject {
    var content: String?
    var cover: String?
    var ext: Array<HomeTextExt>?
    var id: NSNumber?
    var linkType: NSNumber?
    var title: String?
    
    class func parseModel(json: JSON) -> HomeTextItem {
        let model = HomeTextItem()
        model.content = json["content"].string
        model.cover = json["cover"].string
        
        var tempHomeTextExtArray = Array<HomeTextExt>()
        for (_,subjson) in json["ext"] {
            tempHomeTextExtArray.append(HomeTextExt.parseModel(subjson))
        }
        model.ext = tempHomeTextExtArray
        model.id = json["id"].number
        model.linkType = json["linkType"].number
        model.title = json["title"].string
        return model
    }
}

class HomeTextExt: NSObject {
    var content: String?
    var key: String?
    var title: String?
    var val: String?
    class func parseModel(json: JSON) -> HomeTextExt {
        let model = HomeTextExt()
        model.content = json["content"].string
        model.key = json["key"].string
        model.title = json["title"].string
        model.val = json["val"].string
        return model
    }
}