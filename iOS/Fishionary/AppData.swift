//
//  AppData.swift
//  Fishionary
//
//  Created by Julien Eyriès on 24/03/2020.
//  Copyright © 2020 jeyries. All rights reserved.
//

import Combine
import SwiftUI

final class AppData: ObservableObject {
    @Published var showingModal = false
    @Published var showingSelectedFish = false
    @Published var selectedFish = DetailViewModel.defaultFish
}

extension AppData {
    func showSelectedFish(fish: Fish) {
        selectedFish = fish
        showingModal = false
        showingSelectedFish = true
    }
}
