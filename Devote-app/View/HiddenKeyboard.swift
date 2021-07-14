//
//  HiddenKeyboard.swift
//  Devote-app
//
//  Created by TI Digital on 13/07/21.
//

import SwiftUI

#if canImport(UIKit)//import from uikit
extension View{
    func hiddenKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
