//
//  ComicReadedModel.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/10.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class ComicReadedModelArray: NSObject, NSCoding {
    var readedArray: [ComicReadedModel]?
    
    init(readedArray: [ComicReadedModel]? = nil ) {
        self.readedArray = []
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(readedArray, forKey: "readedArray")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        readedArray = aDecoder.decodeObjectForKey("readedArray") as? [ComicReadedModel]
    }
}

class ComicReadedModel: NSObject , NSCoding {
    var comicId: String?
    var chapterName: String?
    var chapterId: String?
    
    init(comicId: String? = nil, chapterName: String? = nil, chapterId: String? = nil) {
        self.comicId = comicId
        self.chapterName = chapterName
        self.chapterId = chapterId
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(comicId, forKey: "comicId")
        aCoder.encodeObject(chapterName, forKey: "chapterName")
        aCoder.encodeObject(chapterId, forKey: "chapterId")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        comicId = aDecoder.decodeObjectForKey("comicId") as? String
        chapterName = aDecoder.decodeObjectForKey("chapterName") as? String
        chapterId = aDecoder.decodeObjectForKey("chapterId") as? String
    }
}
