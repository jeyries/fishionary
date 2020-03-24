//
//  MasterView.swift
//  Fishionary
//
//  Created by Julien Eyriès on 22/03/2020.
//  Copyright © 2020 jeyries. All rights reserved.
//

import SwiftUI

struct FishList: View {
    
    let objects: [FishAndMatch] = DataManager.shared.filterAnyLanguage(search: nil)
    
    var body: some View {
        List {
            ForEach(objects) { object in
                NavigationLink(
                    destination: FishDetail(fish: object.fish)
                ) {
                    FishRow(fish: object.fish)
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

extension Fish: Identifiable {
    var id: String {
        return self.name(target: "scientific")
    }
}

extension FishAndMatch: Identifiable {
    var id: String {
        return self.fish.id
    }
}

