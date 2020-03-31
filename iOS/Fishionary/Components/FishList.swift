//
//  MasterView.swift
//  Fishionary
//
//  Created by Julien Eyriès on 22/03/2020.
//  Copyright © 2020 jeyries. All rights reserved.
//

import SwiftUI

struct FishList: View {
    
    @State var searchText: String? = nil
    
    var objects: [FishAndMatch] {
        return DataManager.shared.filterAnyLanguage(search: searchText)
    }
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
            //Text("searching \(searchText ?? "nothing")")
            List {
                ForEach(objects) { object in
                    NavigationLink(
                        destination: FishDetail(fish: object.fish)
                    ) {
                        FishRow(object: object)
                    }
                }
            }
        }
    }
    
}

struct FishList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FishList()
        }
    }
}


extension FishAndMatch: Identifiable {
    var id: UUID {
        return self.fish.id
    }
}
