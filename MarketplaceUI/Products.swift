//
//  Products.swift
//  MarketplaceUI
//
//  Created by Ivan Loktionov on 07.04.2025.
//
import Foundation
import Observation




struct Product {
    //let id: UUID = UUID()
    var name: String = "-"
    var price: String = "-"
    var image: String = "No image"
    var description: String = "No description"
    let productID: Int
    
    var isInCart: Bool = false
    var isFavourite: Bool = false

    }
    

@Observable
class Products {
        var ProductList: [Product] = [
            Product(name: "IPhone SE 2020", price: "250", image: "iphonese", productID: 111111),
            Product(name: "MacBook M2", price: "1000", image: "macbookm2", description: "soyboy attribute", productID: 222222),
            Product(name: "Apple Watch Series 10", price: "400", image: "applewatchseries10", description: "100% useless", productID: 333333),
            Product(name: "Soy Milk", price: "20", image: "soymilk", description: "my wife's boyfriend LOVES this liquid", productID: 444444),
            Product(name: "One Robux", price: "799", image: "robux", description: "one robux", productID: 555555)
    ]
}

@Observable
class Cart {
    var cartList: [Product] = []
}
