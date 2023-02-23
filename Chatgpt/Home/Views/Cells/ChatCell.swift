//
//  ChatCell.swift
//  Chatgpt
//
//  Created by qinwenzhou on 2023/2/17.
//

import SwiftUI

struct ChatCell: View {
    var model: ChatModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 4) {
                Image(model.avatar)
                    .padding(.leading, 16)
                Text(model.name)
                    .foregroundColor(Color("NameColor"))
            }
            Text(model.content)
                .textSelection(.enabled)
                .font(.title3)
                .padding(.leading, 16)
            Spacer()
                .frame(height: 24)
        }
    }
}

struct ChatCell_Previews: PreviewProvider {
    static var previews: some View {
        let model = ChatModel(id: "0", sessionId: 0, name: "我", avatar: "Avatar", content: "你好，Chatgpt！", isChatgpt: false, createTime: Date())
        return ChatCell(model: model)
    }
}
