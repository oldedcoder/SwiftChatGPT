//
//  ChatgptApp.swift
//  Chatgpt
//
//  Created by qinwenzhou on 2023/2/17.
//

import SwiftUI
import WCDBSwift

var db: Database?

@main
struct ChatgptApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        // 创建数据库
        let path = QFileManage.databaseDirectory() + "/chatgpt.db"
        debugPrint("数据库路径：\(path)")
        db = Database(withPath:path)
        do {
            // 建表
            try db?.run(transaction: {
                try db?.create(table: SessionDbModel.tableName, of: SessionDbModel.self)
                try db?.create(table: ChatDbModel.tableName, of: ChatDbModel.self)
            })
        } catch let error {
            debugPrint("创建数据库失败！Error: \(error.localizedDescription)")
        }
    }
}
