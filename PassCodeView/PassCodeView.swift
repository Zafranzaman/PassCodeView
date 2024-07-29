//
//  PassCodeView.swift
//  PassCodeView
//
//  Created by Zafran on 29/07/2024.
//

import Foundation
import SwiftUI

struct PassCodeView: View {
    @Binding var passcode: String
    let countOfDigits: Int
    let didEnterLastDigit: (String) -> Void

    @State private var activeIndex: Int = 0
    
    private var imageNames: [String] {
        (0..<countOfDigits).map { index in
            if index < passcode.count {
                return "passcode.fill.inactive"
            } else if index == activeIndex {
                return "passcode.empty.active"
            } else {
                return "passcode.empty.inactive"
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                ForEach(0..<countOfDigits, id: \.self) { index in
                    Image(uiImage: UIImage(named: imageNames[index]) ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
            }
            .padding()
            
            HiddenTextField(text: $passcode, countOfDigits: countOfDigits, isFirstResponder: true) { newValue in
                if newValue.count <= countOfDigits {
                    passcode = newValue
                    activeIndex = min(newValue.count, countOfDigits - 1)
                    
                    if newValue.count == countOfDigits {
                        didEnterLastDigit(newValue)
                    }
                }
            }
            .frame(width: 0, height: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
    }
}

struct HiddenTextField: UIViewRepresentable {
    @Binding var text: String
    var countOfDigits: Int
    var isFirstResponder: Bool = false
    var onChange: (String) -> Void

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: HiddenTextField

        init(parent: HiddenTextField) {
            self.parent = parent
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            if updatedText.count <= parent.countOfDigits {
                parent.text = updatedText
                parent.onChange(updatedText)
            }
            return false
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.textContentType = .oneTimeCode
        textField.delegate = context.coordinator
        textField.tintColor = .clear
        textField.textColor = .clear
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        if isFirstResponder {
            uiView.becomeFirstResponder()
        }
    }
}

struct PassCodeView_Previews: PreviewProvider {
    static var previews: some View {
        PassCodeView(passcode: .constant(""), countOfDigits: 4, didEnterLastDigit: { _ in })
    }
}
