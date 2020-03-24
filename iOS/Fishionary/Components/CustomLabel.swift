//
//  CustomLabel.swift
//  Fishionary
//
//  Created by Julien Eyriès on 24/03/2020.
//  Copyright © 2020 jeyries. All rights reserved.
//

import SwiftUI

struct CustomLabel: UIViewRepresentable {
    
    let attributedText: NSAttributedString?
    
    func makeUIView(context: UIViewRepresentableContext<CustomLabel>) -> UILabel {
        let label = UILabel()
        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: UIViewRepresentableContext<CustomLabel>) {
        uiView.attributedText = attributedText
    }
    
}
