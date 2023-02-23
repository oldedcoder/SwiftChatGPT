//
//  ChatModel.swift
//  Chatgpt
//
//  Created by qinwenzhou on 2023/2/20.
//

import Foundation
import Alamofire
import SwiftyJSON

// https://platform.openai.com
private let kOpenaiApiKey = "Your OpenAI API Key"
private let kApiBaseUrl = "https://api.openai.com"

struct ChatModel: Identifiable {
    var id: String
    var sessionId: Int64 = 0
    var name: String
    var avatar: String
    var content: String
    var isChatgpt: Bool
    var isThinking = false
    var createTime: Date
}

extension ChatModel {
    static func newAskModel(sessionId: Int64, prompt: String) -> ChatModel {
        return ChatModel(id: "\(UUID())", sessionId: sessionId, name: "我", avatar: "Avatar", content: prompt, isChatgpt: false, createTime: Date())
    }
    
    static func newAnswerModel(sessionId: Int64, id: String, text: String) -> ChatModel {
        return ChatModel(id: id, sessionId: sessionId, name: "Chatgpt", avatar: "Chatgpt", content: text, isChatgpt: true, createTime: Date())
    }
    
    static func newThinkingModel(sessionId: Int64) -> ChatModel {
        return ChatModel(id: "\(UUID())", sessionId: sessionId, name: "Chatgpt", avatar: "Chatgpt", content: "···", isChatgpt: true, isThinking: true, createTime: Date())
    }
}

// Network
extension ChatModel {
    /// chatgpt 请求接口
    /// - Parameters:
    ///   - prompt: 关键字
    ///   - success: 成功
    ///   - failure: 失败
    static func ask(prompt: String, success: @escaping (_ id: String, _ text: String) -> Void, failure: @escaping (Error?) -> Void) {
        if prompt.count == 0 {
            return
        }
        let parameters: [String: Any] = [
            "model": "text-davinci-003",
            "prompt": prompt,
            "max_tokens": 2048,
        ]
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + kOpenaiApiKey,
            "Content-Type": "application/json"
        ]
        let api = "/v1/completions"
        AF.request(kApiBaseUrl + api, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers) { request in
            request.timeoutInterval = 60
            request.allowsConstrainedNetworkAccess = false
        }.responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSON(data: data)
                    debugPrint("请求成功：\n\(json)")
                    if let choice = json["choices"].array?.first {
                        success(
                            json["id"].stringValue,
                            format(text: choice["text"].stringValue)
                        )
                    } else {
                        debugPrint("解析失败！choices数组为空")
                        failure(nil)
                    }
                } catch let error {
                    debugPrint("解析失败：\n\(error)")
                    failure(nil)
                }
            case .failure(let error):
                debugPrint("请求失败：\n\(error)")
                failure(nil)
            }
        }
    }
    
    /// 格式化chatgpt回答的内容
    /// - Parameter text: chatgpt回答的文本
    /// - Returns: 格式化后的文本
    static func format(text: String) -> String {
        var str = removeHeader(char: "?", in: text)
        str = removeHeader(char: "？", in: text)
        str = removeHeader(char: "\n", in: text)
        return str
    }
    
    /// 递归删除首部指定字符，如问号、换行
    /// - Parameter text: 文本
    /// - Returns: 结果
    static func removeHeader(char: String, in text: String) -> String {
        let str = text as NSString
        let range = str.range(of: char)
        if range.length > 0 && range.location == 0 {
            let subStr = str.replacingOccurrences(of: char, with: "", range: range)
            return removeHeader(char:char, in: subStr)
        } else {
            return text
        }
    }
}

extension ChatModel {
    /// 向本地数据库插入聊天项
    /// - Parameters:
    ///   - chats: 聊天项
    ///   - completion: 完成
    static func insert(chats: [ChatModel], completion: (() -> Void)? = nil) {
        DispatchQueue.global().async {
            let objects = chats.map {
                ChatDbModel(sessionId: $0.sessionId, chatId: $0.id, content: $0.content, isChatgpt: $0.isChatgpt, createTime: $0.createTime)
            }
            ChatDbModel.insert(objects: objects)
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
    
    /// 根据会话编号从本地数据库载入聊天项
    /// - Parameters:
    ///   - sessionId: 会话编号
    ///   - completion: 完成
    static func chats(for sessionId: Int64, completion: @escaping ([ChatModel]?) -> Void) {
        DispatchQueue.global().async {
            let records = ChatDbModel.records(for: sessionId)?.map {
                let name = $0.isChatgpt ? "Chatgpt" : "我"
                let avatar = $0.isChatgpt ? "Chatgpt" : "Avatar"
                return ChatModel(id: $0.chatId, name: name, avatar: avatar, content: $0.content, isChatgpt: $0.isChatgpt, createTime: $0.createTime ?? Date())
            }
            DispatchQueue.main.async {
                completion(records)
            }
        }
    }
    
    /// 根据会话编号删除本地数据库所有聊天项
    /// - Parameters:
    ///   - sessionId: 会话id
    ///   - completion: 完成
    static func removeChats(for sessionId: Int64, completion: (() -> Void)? = nil) {
        DispatchQueue.global().async {
            ChatDbModel.removeRecords(for: sessionId)
            
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
    
    /// 删除本地数据库所有聊天项
    /// - Parameters:
    ///   - completion: 完成
    static func removeAllChats(completion: (() -> Void)? = nil) {
        DispatchQueue.global().async {
            ChatDbModel.removeAllRecords()
            
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
}
