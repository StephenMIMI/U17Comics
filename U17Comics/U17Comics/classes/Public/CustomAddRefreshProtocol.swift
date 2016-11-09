//
//  CustomAddRefreshProtocol.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/9.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit
import MJRefresh

protocol CustomAddRefreshProtocol {
    func addRefresh(header: (()->())?, footer:(()->())?)
}
