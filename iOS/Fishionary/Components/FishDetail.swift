//
//  DetailView.swift
//  Fishionary
//
//  Created by Julien Eyriès on 22/03/2020.
//  Copyright © 2020 jeyries. All rights reserved.
//

import SwiftUI



struct FishDetail: View {
    
    //let fish: Fish
    let vm: DetailViewModel
    
    init(fish: Fish) {
        vm = DetailViewModel(fish: fish)
    }
    
    @State var showingZoom = false
    
    var body: some View {
        VStack {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(vm.target)
                .padding(10)
                .background(Color(.lightGray))
                .cornerRadius(10)
                .padding(10)
            ForEach(vm.names, id: \.self) { name in
                Text(name)
            }
            CustomTextView(attributedText: vm.concern)
                .onTapGesture { print("hello") }
        }
        .navigationBarTitle(vm.title)
        .navigationBarItems(trailing: zoomButton)
        .sheet(isPresented: $showingZoom) {
            ZoomView(image: self.image)
        }
    }
    
    var image: Image {
        return Image(uiImage: UIImage(contentsOfFile: vm.imagePath)!)
    }
    
    var zoomButton: some View {
        Button(action: { self.showingZoom.toggle() }) {
            Text("View")
        }
    }
    
    
}

struct DetailView_Previews: PreviewProvider {
    
    static let objects: [FishAndMatch] = DataManager.shared.filterAnyLanguage(search: nil)
    
    static var previews: some View {
        NavigationView {
            FishDetail(fish: objects[0].fish)
        }
    }
}

////

private struct CustomTextView: UIViewRepresentable {
    
    let attributedText: NSAttributedString?
    
    func makeUIView(context: UIViewRepresentableContext<CustomTextView>) -> UIView {
        let textView = UITextView()
        textView.attributedText = attributedText
        textView.isEditable = false
        return textView
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<CustomTextView>) {
        // nothing here
    }
    
}
