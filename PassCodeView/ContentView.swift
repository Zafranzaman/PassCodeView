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
        ZStack {
            Color.white
                .ignoresSafeArea(.all)
                .opacity(0.1)
            VStack {
                PassCodeView(passcode: $passcode, countOfDigits: 4, didEnterLastDigit: { passcode in
                    
                    print(passcode)
                })
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
