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
        List(ProductData.ProductList.indices, id: \.self) { index in            
                if (ProductData.ProductList[index].isInCart == true) {
                    HStack {
                        Image(ProductData.ProductList[index].image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 70)
                        .clipped()
                        .aspectRatio(1, contentMode: .fit)
                        .cornerRadius(15)
                        .padding(3)
                        VStack(alignment: .leading) {
                            Text(ProductData.ProductList[index].name)
                            Text("\(ProductData.ProductList[index].price)$")
                        }
                        Spacer()
                        Button {ProductData.ProductList[index].isInCart.toggle()} label: {
                            Image(systemName: "trash")
                                .foregroundColor(.white)
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.roundedRectangle(radius: 5))
                        .tint(Color.red)
                    }
                }
            }
        }
    }


#Preview(traits: .sizeThatFitsLayout) {
    CartView(selectedTab: .constant(3), ProductData: .constant(Products()))
}


