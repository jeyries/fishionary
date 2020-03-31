//
//  CustomTextView.swift
//  Fishionary
//
//  Created by Julien Eyriès on 24/03/2020.
//  Copyright © 2020 jeyries. All rights reserved.
//

import SwiftUI


struct CustomTextView: UIViewRepresentable {
    
    let attributedText: NSAttributedString?
    
    func makeUIView(context: UIViewRepresentableContext<CustomTextView>) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<CustomTextView>) {
        uiView.attributedText = attributedText
    }
    
}
