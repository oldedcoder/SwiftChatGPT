//
//  SessionCell.swift
//  Chatgpt
//
//  Created by qinwenzhou on 2023/2/19.
//

import SwiftUI

struct SessionCell: View {
    var model: SessionModel
    
    var body: some View {
        HStack {
            Image("Chat")
                .resizable()
                .frame(width: 14, height: 14)
            
            Text(model.title)
                .font(.system(size: 14))
            
            Spacer()
        }
        .padding(.vertical, 12)
    }
}

struct SessionCell_Previews: PreviewProvider {
    static var previews: some View {
        let model = SessionModel(id: 0, title: "你好，ChatGPT！", createTime: Date())
        return SessionCell(model: model)
    }
}
