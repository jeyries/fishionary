//
//  DetailView.swift
//  Fishionary
//
//  Created by Julien Eyriès on 22/03/2020.
//  Copyright © 2020 jeyries. All rights reserved.
//

import SwiftUI
import struct Kingfisher.LocalFileImageDataProvider
import KingfisherSwiftUI


struct FishDetail: View {
    
    @EnvironmentObject private var appData: AppData
    
    @ObservedObject var vm: ViewModel
    
    init(fish: Fish) {
        vm = .init(fish: fish)
    }
    
    @State var showingZoom = false
    
    var body: some View {
        ZStack {
            if self.showingZoom {
                self.destination
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1.0)))
            } else {
                self.content
            }
        }
            .onAppear { self.update() } // compute the details only when the view appear
            .navigationBarTitle(vm.title)
            .navigationBarItems(trailing: zoomButton)
            //.sheet(isPresented: $showingZoom) { ZoomView(image: self.image) }
    }
    
    var image: KFImage {
        let provider = LocalFileImageDataProvider(fileURL: URL(fileURLWithPath: vm.imagePath))
        return KFImage(source: .provider(provider))
        //return KFImage(URL(fileURLWithPath: vm.imagePath))
    }
    
    var zoomButton: some View {
        Button(action: { self.showingZoom.toggle() }) {
            Text("Zoom")
        }
    }
    
    var destination: some View {
        ZoomView(image: AnyView(self.image))
    }
    
    var content: some View {
        ZStack {
            Color(.white)
            VStack {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text(vm.targetDescription)
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
        }
        
    }
    
    func update() {
         vm.compute(source: appData.source, target: appData.target)
    }
    
    
}

struct DetailView_Previews: PreviewProvider {
    
    static let objects: [FishAndMatch] = DataManager.shared.filterAnyLanguage(search: nil)
    
    static var previews: some View {
        NavigationView {
            FishDetail(fish: objects[0].fish)
                .environmentObject(AppData())
        }
    }
}

extension FishDetail {
    class ViewModel: ObservableObject {
        
        @Published var title: String = ""
        @Published var imagePath: String  = ""
        @Published var targetDescription: String = ""
        @Published var names: [String] = []
        @Published var concern: NSAttributedString? = nil
        
        private let fish: Fish
        
        init(fish: Fish) {
            self.fish = fish
        }
        
        func compute(source: String, target: String) {
            let submodel = DetailViewModel(fish: fish, source: source, target: target)
            title = submodel.title
            imagePath = submodel.imagePath
            targetDescription = submodel.targetDescription
            names = submodel.names
            // compute concern on background thread
            DispatchQueue.global().async {
                let concern = submodel.concern
                DispatchQueue.main.async {
                    self.concern = concern
                }
            }
        }
    }
}

