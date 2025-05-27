//
//  Products.swift
//  MarketplaceUI
//
//  Created by Ivan Loktionov on 07.04.2025.
//
import SwiftUI

struct Product: Identifiable, Equatable, Hashable {
    //let id: UUID = UUID()
    let id: Int
    var name = "-"
    var price = "-"
    var image = "No image"
    var description = "No description"
    
    var isInCart: Bool = false
    var isFavourite: Bool = false
}

extension Product {
    static let mock = Product(
        id: 1,
        name: "Mock Product",
        price: "100",
        image: "iPhone SE"
    )
    
    static let mocks: [Product] = [
        Product(id: 111111, name: "IPhone SE 2020", price: "250", image: "iphonese"),
        Product(id: 222222, name: "MacBook M2", price: "1000", image: "macbookm2", description: "soyboy attribute"),
        Product(id: 333333, name: "Apple Watch Series 10", price: "400", image: "applewatchseries10", description: "100% useless"),
        Product(id: 444444, name: "Soy Milk", price: "20", image: "soymilk", description: "my wife's boyfriend LOVES this liquid"),
        Product(id: 555555, name: "One Robux", price: "799", image: "robux", description: "one robux")
    ]
}

struct Credentials {
    var phoneNumber: String = ""
    var password: String = ""
}

@Observable
final class Auth {
    var loginData = Credentials()
    var isLoggedIn: Bool = false
}

@Observable
final class Products {
    var ProductList: [Product] = []
}
