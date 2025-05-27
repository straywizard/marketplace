//
//  CatalogView.swift
//  MarketplaceUI
//
//  Created by Ivan Loktionov on 07.04.2025.
//
import SwiftUI
import Observation

struct CatalogView: View {
    
    @State private var path = NavigationPath()
    @State private var product: [Product] = []
    
    @Binding var ProductData: Products
    @Binding var selectedTab: Int
    @State private var searchtext: String = ""
    
    let columns = [GridItem(.adaptive(minimum: 150, maximum: .infinity))]
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(product) { product in
                        ProductCardView(product: product) {
                            path.append(product)
                        } onAddToCart: {
                            ProductData.ProductList.append(product)
                        }
                    }
                }
            }
            .navigationTitle("Catalog")
            .navigationDestination(for: Product.self) { product in
                ProductPageView(ProductData: product)
            }
        }
        .searchable(text: $searchtext)
        .onAppear {
            // network request
            guard product.isEmpty else { return }
            product.append(contentsOf: Product.mocks)
        }
    }
}
#Preview(traits: .sizeThatFitsLayout) {
    CatalogView(ProductData: .constant(Products()), selectedTab: .constant(2))
}


func indexOfID(_ array: [Product], _ id: Int) -> Int {
   var index = 0
   for product in array {
       if product.id == id {
           index = product.id
           break
       }
   }
   return index
}
