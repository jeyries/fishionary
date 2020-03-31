//
//  SearchBar.swift
//  Fishionary
//
//  Created by Julien Eyriès on 24/03/2020.
//  Copyright © 2020 jeyries. All rights reserved.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
    
    @Binding var text: String?
    
    func makeCoordinator() -> SearchBar.Coordinator {
       return Coordinator(text: $text)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar()
        //searchBar.text = text
        searchBar.delegate = context.coordinator
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }

    class Coordinator: NSObject, UISearchBarDelegate {
        
        @Binding var text: String?
        
        init(text: Binding<String?>)
        {
           _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
        {
           text = searchText
        }
        
    }

}

struct SearchBar_Previews: PreviewProvider {
    
    @State static var searchText: String? = "hello"
    
    static var previews: some View {
        SearchBar(text: $searchText)
    }
}


