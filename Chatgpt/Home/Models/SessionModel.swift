//
//  SessionModel.swift
//  Chatgpt
//
//  Created by qinwenzhou on 2023/2/19.
//

import Foundation
import WCDBSwift

struct SessionModel: Identifiable {
    var id: Int64
    var title: String
    var createTime: Date
    var isNewSession = false
}

// Database
extension SessionModel {
    /// 向本地数据库插入会话项
    /// - Parameters:
    ///   - sessions: 会话项
    ///   - completion: 完成
    static func insert(sessions: [SessionModel], completion: (() -> Void)? = nil) {
        DispatchQueue.global().async {
            let objects = sessions.map {
                SessionDbModel(sessionId: $0.id, title: $0.title, createTime: $0.createTime)
            }
            SessionDbModel.insert(objects: objects)
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
    
    /// 从本地数据库载入所有会话项
    /// - Parameters:
    ///   - completion: 完成
    static func allSessions(completion: @escaping ([SessionModel]?) -> Void) {
        DispatchQueue.global().async {
            let records = SessionDbModel.allRecords()?.map {
                SessionModel(id: $0.sessionId, title: $0.title ?? "", createTime: $0.createTime ?? Date())
            }
            DispatchQueue.main.async {
                completion(records)
            }
        }
    }
    
    /// 删除本地数据库所有会话项
    /// - Parameters:
    ///   - completion: 完成
    static func removeAllSessions(completion: (() -> Void)? = nil) {
        DispatchQueue.global().async {
            SessionDbModel.removeAllRecords()
            
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
}


