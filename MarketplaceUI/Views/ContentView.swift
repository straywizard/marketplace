//
//  ContentView.swift
//  MarketplaceUI
//
//  Created by Ivan Loktionov on 07.04.2025.
//

import SwiftUI
import Observation

struct ContentView: View {
    @State private var ProductData = Products()
    @State private var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house", value: 0) {
            HomeView(selectedTab: $selectedTab)
            }
            Tab("Catalog", systemImage: "magnifyingglass", value: 1) {
                CatalogView(ProductData: $ProductData, selectedTab: $selectedTab)
            }
            Tab("Cart", systemImage: "cart", value: 2) {
                if ifCartIsFull(ProductData.ProductList) == true {
                    CartView(selectedTab: $selectedTab, ProductData: $ProductData)
                } else {
                    EmptyCartView(selectedTab: $selectedTab, ProductData: $ProductData)
                }
            }
                .badge(badgeCount(ProductData.ProductList))
            Tab("Profile", systemImage: "person", value: 3) {

            }
            .badge("!")
        }
    }
}

#Preview {
    ContentView()
}

func badgeCount (_ array: [Product]) -> Int {
    var count = 0
    for i in array{
        if i.isInCart == true {
            count += 1
        }
    }
    return count
}

func ifCartIsFull (_ array: [Product]) -> Bool {
    var isfull = false
    for i in array {
        if i.isInCart == true {
            isfull = true
            break
        }
    }
    return isfull
}
