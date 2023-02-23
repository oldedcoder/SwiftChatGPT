//
//  InputView.swift
//  Chatgpt
//
//  Created by qinwenzhou on 2023/2/18.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    @Binding var isEnable: Bool
    var isFocused: FocusState<Bool>.Binding
    var onSubmit: () -> Void
    
    @State private var height: CGFloat = 64
    
    private let kFontSize: CGFloat = 16
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                // 换行键
                Button("") {
                    text = text + "\n"
                }
                .hidden()
                .keyboardShortcut(.return)
                
                Rectangle()
                    .fill(Color("ListColor"))
                
                Rectangle()
                    .fill(fillColor())
                    .cornerRadius(24)
                    .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                    .overlay {
                        TextField("", text: $text, axis: .vertical)
                            .lineLimit(20)
                            .font(.system(size: kFontSize))
                            .textFieldStyle(.plain)
                            .disableAutocorrection(true)
                            .disabled(!isEnable)
                            .focused(isFocused)
                            .background(fillColor())
                            .padding(.horizontal, 36)
                            .onChange(of: text, perform: { newValue in
                                let paddingOffset = CGFloat(36 + 16*2) // TextField is 36, Rectangle is 16*2 (leading & trailing).
                                let size = CGSize(width: proxy.size.width - paddingOffset, height: .infinity)
                                let h = sizeToFit(with: text, in: size)
                                height = max(h + 44, 64)
                            })
                            .onSubmit {
                                onSubmit()
                            }
                    }
            }
        }
        .frame(height: height)
    }
    
    private func fillColor() -> Color {
        return isEnable ? Color("EnableInputColor") : Color("DisableInputColor")
    }
    
    private func sizeToFit(with string: String, in limitSize: CGSize) -> CGFloat {
        let range = NSMakeRange(0, string.count)
        let attributeString = NSMutableAttributedString(string: string)
        // 字体
        let font = NSFont.systemFont(ofSize: kFontSize)
        attributeString.addAttribute(.font, value: font, range: range)
        // 行距
//        let style = NSMutableParagraphStyle()
//        style.lineSpacing = 4
//        attributeString.addAttribute(.paragraphStyle, value: style, range: range)
        // 字距
//        attributeString.addAttribute(.kern, value: 4, range: range)
        // 计算高度
        return attributeString.boundingRect(with: limitSize, options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).height
    }
}

struct InputView_Previews: PreviewProvider {
    @State static var text = ""
    @State static var isEnable = true
    @FocusState static var isFocused
    
    static var previews: some View {
        InputView(text: $text, isEnable: $isEnable, isFocused: $isFocused) {}
    }
}
