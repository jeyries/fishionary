//
//  DetailView.swift
//  Fishionary
//
//  Created by Julien Eyriès on 22/03/2020.
//  Copyright © 2020 jeyries. All rights reserved.
//

import SwiftUI



struct FishDetail: View {
    
    @EnvironmentObject private var appData: AppData
    
    @ObservedObject var vm: ViewModel
    
    init(fish: Fish) {
        vm = .init(fish: fish)
    }
    
    @State var showingZoom = false
    
    var body: some View {
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
        .onAppear { self.vm.compute() } // compute the details only when the view appear
        .navigationBarTitle(vm.title)
        .navigationBarItems(trailing: zoomButton)
        .sheet(isPresented: $showingZoom) { ZoomView(image: self.image)
        }
    }
    
    var image: Image {
        guard let uiImage = UIImage(contentsOfFile: vm.imagePath) else { return Image(systemName: "star") }
        return Image(uiImage: uiImage)
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
                .environmentObject(AppData())
        }
    }
}

extension FishDetail {
    class ViewModel: ObservableObject {
        
        @Published var title: String = "title"
        @Published var imagePath: String  = "imagePath"
        @Published var targetDescription: String = "targetDescription"
        @Published var names: [String] = []
        @Published var concern: NSAttributedString? = nil
        
        private let fish: Fish
        
        init(fish: Fish) {
            self.fish = fish
        }
        
        func compute() {
            let submodel = DetailViewModel(fish: fish, source: "english", target: "scientific")
            print(submodel.title)
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

