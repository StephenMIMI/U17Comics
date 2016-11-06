//
//  ComicDetailTicket.swift
//  U17Comics
//
//  Created by 张翔宇 on 16/11/5.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit
import SwiftyJSON

class ComicDetailTicket: NSObject {
    var code: NSNumber?
    var data: ComicDetailTicketData?
    
    class func parseData(data: NSData) -> ComicDetailTicket {
        let json = JSON(data: data)
        let model = ComicDetailTicket()
        model.code = json["code"].number
        model.data = ComicDetailTicketData.parseModel(json["data"])
        return model
    }
}

class ComicDetailTicketData: NSObject {
    var message: String?
    var returnData: ComicDTReturnData?
    var stateCode: NSNumber?
    
    class func parseModel(json: JSON) -> ComicDetailTicketData {
        let model = ComicDetailTicketData()
        model.message = json["message"].string
        model.returnData = ComicDTReturnData.parseModel(json["returnData"])
        model.stateCode = json["stateCode"].number
        return model
    }
}

class ComicDTReturnData: NSObject {
    var chapter_list: Array<ComicDTChapter>?
    var comic: ComicDTData?
    var comment: ComicDTComment?
    
    class func parseModel(json: JSON) -> ComicDTReturnData {
        let model = ComicDTReturnData()
        var tmpArray = Array<ComicDTChapter>()
        for (_,subjson) in json["chapter_list"] {
            let tmpModel = ComicDTChapter.parseModel(subjson)
            tmpArray.append(tmpModel)
        }
        model.chapter_list = tmpArray
        model.comic = ComicDTData.parseModel(json["comic"])
        model.comment = ComicDTComment.parseModel(json["comment"])
        return model
    }
}

class ComicDTChapter: NSObject {
    var buyed: String?
    var chapter_id: String?
    var is_view: NSNumber?
    var read_state: NSNumber?
    
    class func parseModel(json: JSON) -> ComicDTChapter {
        let model = ComicDTChapter()
        model.buyed = json["buyed"].string
        model.chapter_id = json["chapter_id"].string
        model.is_view = json["is_view"].number
        model.read_state = json["read_state"].number
        return model
    }
}

class ComicDTData: NSObject {
    var comic_id: String?
    var favorite_total: NSNumber?
    var is_auto_buy: NSNumber?
    var is_free: NSNumber?
    var month_ticket: String?
    var monthly_ticket: NSNumber?
    var total_click: NSNumber?
    var total_ticket: NSNumber?
    var total_tucao: NSNumber?
    var vip_discount: NSNumber?
    
    class func parseModel(json: JSON) -> ComicDTData {
        let model = ComicDTData()
        model.comic_id = json["comic_id"].string
        model.favorite_total = json["favorite_total"].number
        model.is_auto_buy = json["is_auto_buy"].number
        model.is_free = json["is_free"].number
        model.month_ticket = json["month_ticket"].string
        model.monthly_ticket = json["monthly_ticket"].number
        model.total_click = json["total_click"].number
        model.total_ticket = json["total_ticket"].number
        model.total_tucao = json["total_tucao"].number
        model.vip_discount = json["vip_discount"].number
        return model
    }
}

class ComicDTComment: NSObject {
    var commentCount: String?
    var commentList: Array<ComicCommentData>?
    
    class func parseModel(json: JSON) -> ComicDTComment {
        let model = ComicDTComment()
        model.commentCount = json["commentCount"].string
        var tmpArray = Array<ComicCommentData>()
        for(_,subjson) in json["commentList"] {
            let tmpModel = ComicCommentData.parseModel(subjson)
            tmpArray.append(tmpModel)
        }
        model.commentList = tmpArray
        return model
    }
}

class ComicCommentData: NSObject {
    var cate: String?
    var color: String?
    var comment_from: String?
    var comment_id: String?
    var content: String?
    var content_filter: String?
    var create_time: String?
    var create_time_str: String?
    var exp: String?
    var face: String?
    var face_type: String?
    var floor: String?
    var group_admin: String?
    var group_author: String?
    var group_custom: String?
    var group_user: String?
    var id: String?
    var imageList: JSON?
    var ip: String?
    var is_delete: String?
    var is_lock: String?
    var is_up: String?
    var level: ComicCommentLevel?
    var likeCount: String?
    var likeState: NSNumber?
    var nickname: String?
    var online_time: String?
    var reply: Array<ComicCommentData>?
    var sex: String?
    var title: String?
    var total_reply: String?
    var user_id: String?
    var vip_exp: String?
    
    class func parseModel(json: JSON) -> ComicCommentData {
        let model = ComicCommentData()
        model.cate = json["cate"].string
        model.color = json["color"].string
        model.comment_from = json["comment_from"].string
        model.comment_id = json["comment_id"].string
        model.content = json["content"].string
        model.content_filter = json["content_filter"].string
        model.create_time = json["create_time"].string
        model.create_time_str = json["create_time_str"].string
        model.exp = json["exp"].string
        model.face = json["face"].string
        model.face_type = json["face_type"].string
        model.floor = json["floor"].string
        model.group_admin = json["group_admin"].string
        model.group_author = json["group_author"].string
        model.group_custom = json["group_custom"].string
        model.group_user = json["group_user"].string
        model.id = json["id"].string
        model.imageList = json["imageList"]
        model.ip = json["ip"].string
        model.is_delete = json["is_delete"].string
        model.is_lock = json["is_lock"].string
        model.is_up = json["is_up"].string
        model.level = ComicCommentLevel.parseModel(json["level"])
        model.likeCount = json["likeCount"].string
        model.likeState = json["likeState"].number
        model.nickname = json["nickname"].string
        model.online_time = json["online_time"].string
        var tmpArray = Array<ComicCommentData>()
        for (_,subjson) in json["reply"] {
            let tmpModel = ComicCommentData.parseModel(subjson)
            tmpArray.append(tmpModel)
        }
        model.reply = tmpArray
        model.sex = json["sex"].string
        model.title = json["title"].string
        model.total_reply = json["total_reply"].string
        model.user_id = json["user_id"].string
        model.vip_exp = json["vip_exp"].string
        return model
    }
}

class ComicCommentLevel: NSObject {
    var album_size: NSNumber?
    var exp_speed: NSNumber?
    var favorite_num: NSNumber?
    var level: NSNumber?
    var max: NSNumber?
    var min_exp: NSNumber?
    var ticket: NSNumber?
    var wage: NSNumber?
    
    class func parseModel(json: JSON) -> ComicCommentLevel {
        let model = ComicCommentLevel()
        model.album_size = json["album_size"].number
        model.exp_speed = json["exp_speed"].number
        model.favorite_num = json["favorite_num"].number
        model.level = json["level"].number
        model.max = json["max"].number
        model.min_exp = json["min_exp"].number
        model.ticket = json["ticket"].number
        model.wage = json["wage"].number
        return model
    }
}
