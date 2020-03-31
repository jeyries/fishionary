//
//  SettingsView.swift
//  Fishionary
//
//  Created by Julien Eyriès on 22/03/2020.
//  Copyright © 2020 jeyries. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject private var appData: AppData

    let props = DataManager.shared.filter_props()
    
    var pickerContent: some View {
        ForEach(props, id: \.name) { prop in
            Text(prop.header).tag(prop.name)
        }
    }
    
    var body: some View {
        VStack {
            Image("home-background-transparent")
                .resizable()
                .scaledToFit()
                .frame(width: nil, height: 200, alignment: .center)
        
            Form {
                Section {
                    Picker(selection: $appData.source,
                           label: Text("Source"),
                           content: { pickerContent })
                        .pickerStyle(WheelPickerStyle())
                }
                
                Section {
                    Picker(selection: $appData.target,
                           label: Text("Target"),
                           content: { pickerContent })
                        .pickerStyle(WheelPickerStyle())
                }
                
            }
        }
    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AppData())
    }
}
