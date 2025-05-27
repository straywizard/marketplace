//
//  CartView.swift
//  MarketplaceUI
//
//  Created by Ivan Loktionov on 08.04.2025.
//

import SwiftUI

struct CartView: View {
    
    @Binding var selectedTab: Int
    @Binding var ProductData: Products
    
    var body: some View {
        if ProductData.ProductList.isEmpty {
            VStack {
                Text("Seems like you don't have any items here yet.")
                    .padding()
                    .font(.headline)
                
                Button("Go to catalog") {
                    selectedTab = 1
                }
            }
        } else {
            List($ProductData.ProductList, editActions: .delete) { $product in
                HStack {
                    Image(product.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 70)
                        .clipped()
                        .aspectRatio(1, contentMode: .fit)
                        .cornerRadius(15)
                        .padding(3)
                    
                    VStack(alignment: .leading) {
                        Text(product.name)
                        Text("\(product.price)$")
                    }
                }
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CartView(selectedTab: .constant(3), ProductData: .constant(Products()))
}
