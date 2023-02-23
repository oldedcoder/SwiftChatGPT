//
//  SessionManager.swift
//  Chatgpt
//
//  Created by qinwenzhou on 2023/2/20.
//

import SwiftUI

class SessionManager: ObservableObject {
    @Published var sessionId: Int64 = 0 {
        willSet {
            if sessionId != newValue {
                ChatModel.chats(for: newValue) { chats in
                    self.chats = chats ?? [ChatModel]()
                }
            }
        }
    }
    @Published var sessions = [SessionModel]()
    @Published var chats = [ChatModel]()
    
    
    init() {
        sessionId = SessionDbModel.maxSessionId() ?? 0
        
        SessionModel.allSessions { sessions in
            self.sessions = sessions ?? [SessionModel]()
            self.createNewSession()
        }
    }

    func createNewSession() {
        if let newSession = sessions.filter({$0.isNewSession}).first {
            sessionId = newSession.id
            
        } else {
            sessionId = sessionId + 1
            
            let sessionModel = SessionModel(id: sessionId, title: "", createTime: Date(), isNewSession: true)
            sessions.insert(sessionModel, at: 0)
        }
    }
    
    func removeAllSessions() {
        chats.removeAll()
        ChatModel.removeAllChats()
        
        sessions.removeAll()
        SessionModel.removeAllSessions()
        
        createNewSession()
    }
    
    func ask(prompt: String, success: @escaping (ChatModel) -> Void, failure: @escaping (Error?) -> Void) {
        guard !prompt.isEmpty else {
            failure(nil)
            return
        }
        
        // 保存新会话
        if let session = sessions.filter({$0.id == sessionId}).first, session.isNewSession {
            let sessionModel = SessionModel(id: sessionId, title: prompt, createTime: Date())
            var tempSessions = sessions.filter({!$0.isNewSession})
            tempSessions.insert(sessionModel, at: 0)
            sessions = tempSessions
            SessionModel.insert(sessions: [sessionModel])
        }
        
        // 在会话中插入聊天项
        let askModel = ChatModel.newAskModel(sessionId: sessionId, prompt: prompt)
        let thinkingModel = ChatModel.newThinkingModel(sessionId: sessionId)
        chats.append(contentsOf: [askModel, thinkingModel])
        ChatModel.insert(chats: [askModel])
        
        // 发起Api请求
        ChatModel.ask(prompt: prompt, success: { id, text in
            let answerModel = ChatModel.newAnswerModel(sessionId: self.sessionId, id: id, text: text)
            var tempChats = self.chats.filter({!$0.isThinking})
            tempChats.append(answerModel)
            self.chats = tempChats
            ChatModel.insert(chats: [answerModel])
            success(answerModel)
        }, failure: failure)
    }
}
