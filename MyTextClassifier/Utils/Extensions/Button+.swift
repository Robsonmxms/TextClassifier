//
//  ButtonStyle+.swift
//  MyTextClassifier
//
//  Created by Robson Lima Lopes on 18/05/23.
//

import SwiftUI

extension Button {
    @ViewBuilder func destructiveStyle(_ isDestructive: Bool) -> some View {
        if isDestructive {
            self.buttonStyle(DestructiveButtonStyle())
        } else {
            self
        }
    }

    @ViewBuilder func accentStyle(_ isAccent: Bool) -> some View {
        if isAccent {
            self.buttonStyle(AccentButtonStyle())
        } else {
            self
        }
    }
}

extension NavigationLink {
    @ViewBuilder func accentStyle(_ isAccent: Bool) -> some View {
        if isAccent {
            self.buttonStyle(AccentButtonStyle())
        } else {
            self
        }
    }
}

fileprivate struct DestructiveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(Color.red)
            .cornerRadius(5)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

fileprivate struct AccentButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(Color.accentColor)
            .cornerRadius(5)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}
