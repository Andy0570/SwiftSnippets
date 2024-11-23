//
//  JSONable.swift
//  SeaTao
//
//  Created by Qilin Hu on 2023/5/11.
//

import SwiftyJSON

protocol JSONable {
    init(json: JSON)
}

struct ModelResponse<T: JSONable>: JSONable {
    let code: Int
    let msg: String
    let data: T

    init(json: JSON) {
        code = json["code"].intValue
        msg = json["msg"].stringValue
        data = T(json: json["data"])
    }
}

struct ArrayResponse<T: JSONable>: JSONable {
    let code: Int
    let count: Int
    let data: [T]

    init(json: JSON) {
        code = json["code"].intValue
        count = json["count"].intValue
        data = json["data"].arrayValue.compactMap { T(json: $0) }
    }
}

struct StringResponse: Decodable {
    let code: Int
    let msg: String
    let data: String
}
