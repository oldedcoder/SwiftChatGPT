//
//  ChatDbModel.swift
//  Chatgpt
//
//  Created by qinwenzhou on 2023/2/20.
//

import Foundation
import WCDBSwift

final class ChatDbModel: TableCodable {
    static var tableName: String { "chat" }
    
    var sessionId: Int64 = 0
    var chatId: String = ""
    var content: String = ""
    var isChatgpt: Bool = false
    var createTime: Date? = nil
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = ChatDbModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case sessionId
        case chatId
        case content
        case isChatgpt
        case createTime
    }
    
    init(sessionId: Int64, chatId: String, content: String, isChatgpt: Bool, createTime: Date) {
        self.sessionId = sessionId
        self.chatId = chatId
        self.content = content
        self.isChatgpt = isChatgpt
        self.createTime = createTime
    }
}

extension ChatDbModel {
    static func insert(objects: [ChatDbModel]) {
        do {
            try db?.insert(objects: objects, intoTable: ChatDbModel.tableName)
        } catch let error {
            debugPrint("插入chat失败 ->\n\(error.localizedDescription)")
        }
    }
    
    static func records(for sessionId: Int64) -> [ChatDbModel]? {
        do {
            return try db?.getObjects(fromTable: ChatDbModel.tableName, where: ChatDbModel.Properties.sessionId == sessionId, orderBy: [ChatDbModel.Properties.createTime.asOrder(by: .ascending)])
        } catch let error {
            debugPrint("获取chat失败, session id -> \(sessionId)\n\(error.localizedDescription)")
            return nil
        }
    }
    
    static func removeRecords(for sessionId: Int64) {
        do {
            try db?.delete(fromTable: ChatDbModel.tableName, where: ChatDbModel.Properties.sessionId == sessionId)
        } catch let error {
            debugPrint("删除chat失败, session id -> \(sessionId)\n\(error.localizedDescription)")
        }
    }
    
    static func removeAllRecords() {
        do {
            try db?.delete(fromTable: ChatDbModel.tableName)
        } catch let error {
            debugPrint("删除所有chat失败 -> \n\(error.localizedDescription)")
        }
    }
}
