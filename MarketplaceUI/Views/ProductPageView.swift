//
//  ProductPageView.swift
//  MarketplaceUI
//
//  Created by Ivan Loktionov on 08.04.2025.
//

import SwiftUI

struct ProductPageView: View {
    var ProductData: Product
    var body: some View {
        VStack {
            Image("\(ProductData.image)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                
            
            HStack {
                Text(ProductData.name)
                Text("\(ProductData.price)$")
                    
            }
            Text(ProductData.description)
            Text("\(ProductData.productID)")
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ProductPageView(ProductData: Product(name: "IPhone SE 2020", price: "250", image: "iphonese", productID: 111111))
}
