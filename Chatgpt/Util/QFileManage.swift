//
//  QFileManage.swift
//  Chatgpt
//
//  Created by qinwenzhou on 2023/2/19.
//

import Foundation

struct QFileManage {
    /// 创建文件夹
    static func createDirectory(at path: String) {
        let isExisted = FileManager.default.fileExists(atPath: path)
        guard !isExisted else { return }
        let url = URL(fileURLWithPath: path)
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            debugPrint("创建文件夹失败！Path: \(path), Error: \(error.localizedDescription)")
        }
    }
}

extension QFileManage {
    /// 库目录
    static func libraryDirectory() -> String {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last!
    }
    
    /// 数据库目录
    static func databaseDirectory() -> String {
        let path = libraryDirectory() + "/database"
        createDirectory(at: path)
        return path
    }
    
    /// 文档目录
    static func documentsDirectory() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
    }
    
    /// 图片目录
    static func imagesDirectory() -> String {
        let path = documentsDirectory() + "/images"
        createDirectory(at: path)
        return path
    }
}
