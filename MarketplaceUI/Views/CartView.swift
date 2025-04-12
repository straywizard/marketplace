//
//  CartView.swift
//  MarketplaceUI
//
//  Created by Ivan Loktionov on 08.04.2025.
//
import SwiftUI

struct EmptyCartView: View {
    @Binding var selectedTab: Int
    @Binding var ProductData: Products
    var body: some View {
        VStack {
            Text("Seems like you don't have any items here yet.")
                .padding()
                .font(.headline)
            Button("Go to catalog") {
                selectedTab = 1
            }
        }
    }
}


struct CartView: View {
    @Binding var selectedTab: Int
    @Binding var ProductData: Products
    var body: some View {
                List {
                    ForEach(ProductData.ProductList.indices, id: \.self) { index in
                        if (ProductData.ProductList[index].isInCart == true) {
                            Text(ProductData.ProductList[index].name)
                        }
                    }
                }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CartView(selectedTab: .constant(3), ProductData: .constant(Products()))
}


