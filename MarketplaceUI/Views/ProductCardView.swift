//
//  ProductCardView.swift
//  MarketplaceUI
//
//  Created by Ivan Loktionov on 07.04.2025.
//

import SwiftUI
struct ProductCardView: View {
    @Binding var ProductData: Products
    var index: Int
    var body: some View {
        GroupBox {
            VStack {
                Image(ProductData.ProductList[index].image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0,
                           maxWidth: .infinity,
                           minHeight: 0,
                           maxHeight: .infinity)
                    .clipped()
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(15)
                    .padding(3)
                Text(ProductData.ProductList[index].name)
                    .font(.footnote)
                    .scaledToFit()
                    .padding(4)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5, style: .circular).fill(Color.primary)
                            .opacity(0.15)
                    }
                Text("\(ProductData.ProductList[index].name)$")
                    .padding(4)
                    .font(.footnote)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5, style: .circular).fill(Color.secondary)
                            .opacity(0.15)
                    }
                HStack {
                    Button(action: {ProductData.ProductList[index].isInCart.toggle()}) {
                        Image(systemName: ProductData.ProductList[index].isInCart == true ? "basket.fill" : "basket")
                            .font(.title)
                            .foregroundColor(Color.white)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.circle)
                    .foregroundColor(.green)
                    .tint(ProductData.ProductList[index].isInCart == true ? Color.green : Color.blue)
                    
                    Spacer()
                    Button(action: {ProductData.ProductList[index].isFavourite.toggle()}) {
                        Image(systemName: ProductData.ProductList[index].isFavourite == true ? "heart.fill" : "heart")
                            .foregroundColor(Color.red)
                            .font(.title)
                        
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.circle)
            }
                    
                }
            }
    }
}

