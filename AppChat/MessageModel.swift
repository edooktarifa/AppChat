//
//  MessageModel.swift
//  AppChat
//
//  Created by Phincon on 20/06/22.
//

import Foundation

//"id": 1,
//"body": "pesan pertama",
//"attachment": null,
//"timestamp": "1544086218",
//"from": "A",
//"to": "B"

struct MessageModel: Codable {
    var data: [MessageModelDetail] = []
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    init(_ dict: [String:Any]) {
        let _ = (dict[CodingKeys.data.rawValue] as? [[String:Any]] ?? []).map { (resp) -> [String : Any] in
            self.data.append(MessageModelDetail(resp))
            return resp
        }
    }
}

struct MessageModelDetail: Codable {
    var id: Int?
    var body: String?
    var attachment: String?
    var timestamp: String?
    var from: String?
    var to: String?
    
    enum CodingKeys: String, CodingKey {
        case id, body, attachment, timestamp, from, to
    }
    
    init(_ dict: [String:Any]) {
        self.id = dict[CodingKeys.id.rawValue] as? Int ?? 0
        self.body = dict[CodingKeys.body.rawValue] as? String ?? ""
        self.attachment = dict[CodingKeys.attachment.rawValue] as? String ?? ""
        self.timestamp = dict[CodingKeys.timestamp.rawValue] as? String ?? ""
        self.from = dict[CodingKeys.from.rawValue] as? String ?? ""
        self.to = dict[CodingKeys.to.rawValue] as? String ?? ""
    }
}
