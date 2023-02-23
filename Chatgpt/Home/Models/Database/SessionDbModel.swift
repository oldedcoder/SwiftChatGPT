//
//  SessionDbModel.swift
//  Chatgpt
//
//  Created by qinwenzhou on 2023/2/20.
//

import Foundation
import WCDBSwift

final class SessionDbModel: TableCodable {
    static var tableName: String { "session" }
    
    var sessionId: Int64 = 0
    var title: String? = nil
    var createTime: Date? = nil
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = SessionDbModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case sessionId
        case title
        case createTime
    }
    
    init(sessionId: Int64, title: String? = nil, createTime: Date? = nil) {
        self.sessionId = sessionId
        self.title = title
        self.createTime = createTime
    }
}

extension SessionDbModel {
    static func maxSessionId() -> Int64? {
        do {
            return try db?.getValue(on: SessionDbModel.Properties.sessionId.max(), fromTable: SessionDbModel.tableName).int64Value
        } catch let error {
            debugPrint("获取最大session id失败 ->\n\(error.localizedDescription)")
            return nil
        }
    }
    
    static func insert(objects: [SessionDbModel]) {
        do {
            try db?.insert(objects: objects, intoTable: SessionDbModel.tableName)
        } catch let error {
            debugPrint("插入session失败 ->\n\(error.localizedDescription)")
        }
    }
    
    static func allRecords() -> [SessionDbModel]? {
        do {
            return try db?.getObjects(fromTable: SessionDbModel.tableName, orderBy: [SessionDbModel.Properties.createTime.asOrder(by: .descending)])
        } catch let error {
            debugPrint("获取所有session失败 ->\n\(error.localizedDescription)")
            return nil
        }
    }
    
    static func removeAllRecords() {
        do {
            try db?.delete(fromTable: SessionDbModel.tableName)
        } catch let error {
            debugPrint("删除所有session失败 ->\n\(error.localizedDescription)")
        }
    }
}
