//
//  ContentView.swift
//  PassCodeView
//
//  Created by Zafran on 29/07/2024.
//

import SwiftUI

struct ContentView: View {
    @State  var passcode: String = ""
    var body: some View {
        VStack {
            PassCodeView(passcode: $passcode, countOfDigits: 4, didEnterLastDigit: { passcode in
                
                print(passcode)
            })
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
