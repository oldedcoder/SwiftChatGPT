//
//  SessionView.swift
//  Chatgpt
//
//  Created by qinwenzhou on 2023/2/19.
//

import SwiftUI

struct SessionView: View {
    @ObservedObject var manager: SessionManager
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            // 新建聊天
            Button {
                manager.createNewSession()
            } label: {
                Image("NewChat")
                    .resizable()
                    .frame(width: 12, height: 12)
                Spacer()
                    .frame(width: 8)
                Text("新建聊天")
                    .font(.system(size: 14))
            }
            .buttonStyle(.plain)
            .frame(height: 24)
            .keyboardShortcut("n", modifiers: .command)
            
            Spacer()
                .frame(height: 16)
            
            // 列表
            List(manager.sessions) { model in
                SessionCell(model: model)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        manager.sessionId = model.id
                    }
                    .listRowBackground(manager.sessionId == model.id ? Color("ListColor") : Color.clear)
            }
            .background(.clear)
            .scrollContentBackground(.hidden)
            
            Spacer()
                .frame(height: 16)
            
            // 清除记录
            Button {
                showAlert = true
            } label: {
                Image("ClearRecord")
                    .resizable()
                    .frame(width: 12, height: 12)
                Spacer()
                    .frame(width: 8)
                Text("清除记录")
                    .font(.system(size: 14))
            }
            .frame(maxWidth: .infinity, maxHeight: 56)
            .buttonStyle(.plain)
            .background(Color("ListColor"))
        }
        .alert("您确定要清除所有会话记录吗", isPresented: $showAlert) {
            Button("清除", role: .destructive) {
                manager.removeAllSessions()
            }
            Button("取消", role: .cancel) {
                
            }
        }
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView(manager: SessionManager())
    }
}
