//
//  CatalogView.swift
//  MarketplaceUI
//
//  Created by Ivan Loktionov on 07.04.2025.
//
import SwiftUI
import Observation

struct CatalogView: View {
    @Binding var ProductData: Products
    @Binding var selectedTab: Int
    @State private var searchtext: String = ""
    let columns = [GridItem(.adaptive(minimum: 150, maximum: .infinity))]
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(ProductData.ProductList.indices, id: \.self) { index in
                        ProductCardView(ProductData: $ProductData, index: index)
                    }
                }
            }
            .navigationTitle("Catalog")
        }
        .searchable(text: $searchtext)
    }
}
#Preview(traits: .sizeThatFitsLayout) {
    CatalogView(ProductData: .constant(Products()), selectedTab: .constant(2))
}


func indexOfID(_ array: [Product], _ id: Int) -> Int {
   var index = 0
   for product in array {
       if product.productID == id {
           index = product.productID
           break
       }
   }
   return index
}
