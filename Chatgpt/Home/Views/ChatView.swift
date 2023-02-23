//
//  ChatView.swift
//  Chatgpt
//
//  Created by qinwenzhou on 2023/2/17.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var manager: SessionManager
    @State private var showAlert = false
    
    @State private var inputText = ""
    @State private var isInputEnable = true
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        // 聊天列表
        List(manager.chats) { model in
            ChatCell(model: model)
        }
        .background(
            Color("ListColor")
        )
        .scrollContentBackground(.hidden)
        .safeAreaInset(edge: .bottom) {
            // 输入框
            InputView(
                text: $inputText,
                isEnable: $isInputEnable,
                isFocused: $isInputFocused) {
                    manager.ask(prompt: inputText) { _ in
                        isInputEnable = true
                    } failure: { _ in
                        isInputEnable = true
                    }
                    inputText = ""
                    isInputFocused = false
                    isInputEnable = false
            }
        }
        .toolbar {
            Button {
                showAlert = true
            } label: {
                Image("Avatar")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.plain)
        }
        .alert("您今天最棒了", isPresented: $showAlert) {
            Button("好的", role: .cancel) {
                
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(manager: SessionManager())
    }
}
