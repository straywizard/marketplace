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
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                GroupBox {
                    VStack {
                        NavigationLink(destination: ProductPageView(ProductData: ProductData.ProductList[index]), label: {
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
                                    .scaledToFit()
                                    .font(.footnote)
                                    .padding(4)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 5, style: .circular).fill(Color.primary)
                                            .opacity(0.15)
                                    }
                                Text("\(ProductData.ProductList[index].price)$")
                                    .padding(4)
                                    .font(.footnote)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 5, style: .circular).fill(Color.secondary)
                                            .opacity(0.15)
                                }
                            }
                        })
                    }
                    HStack {
                        Button(action: {ProductData.ProductList[index].isInCart.toggle()}) {
                            Text("Add to cart")
                                .scaledToFit()
                                .minimumScaleFactor(0.5)
                                .font(.footnote)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                                .fontWeight(.semibold)
                                
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.roundedRectangle(radius: 5))
                        .tint(ProductData.ProductList[index].isInCart == true ? Color.green : Color.blue)
                        
                        
                        
                    }
                }
                Button(action: {ProductData.ProductList[index].isFavourite.toggle()}) {
                    Image(systemName: ProductData.ProductList[index].isFavourite == true ? "heart.fill": "heart")
                        .foregroundColor(Color.red)
                        
                .font(.title) }
                .padding(5)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.circle)
                .tint(Color.secondary)
            }
        }
    }
}



