//
//  ProductCardView.swift
//  MarketplaceUI
//
//  Created by Ivan Loktionov on 07.04.2025.
//

import SwiftUI

struct ProductCardView: View {
    
    let product: Product
    let onSelect: () -> Void
    let onAddToCart: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            GroupBox {
                VStack {
                    Button {
                        onSelect()
                    } label: {
                        VStack {
                            Image(product.image)
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
                            
                            Text(product.name)
                                .scaledToFit()
                                .font(.footnote)
                                .padding(4)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 5, style: .circular).fill(Color.primary)
                                        .opacity(0.15)
                                }
                            Text("\(product.price)$")
                                .padding(4)
                                .font(.footnote)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 5, style: .circular).fill(Color.secondary)
                                        .opacity(0.15)
                                }
                        }
                    }
                }
                
                HStack {
                    Button {
                        onAddToCart()
                    } label: {
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
                    .tint(product.isInCart ? Color.green : Color.blue)
                }
            }
            Button {
                // product.isFavourite.toggle()
            } label: {
                Image(systemName: product.isFavourite ? "heart.fill": "heart")
                    .foregroundColor(Color.red)
                    .font(.title)
            }
            .padding(5)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.circle)
            .tint(Color.secondary)
        }
    }
}

#Preview {
    ProductCardView(product: .mock, onSelect: {}, onAddToCart: {})
}
