//
//  HomeView.swift
//  MarketplaceUI
//
//  Created by Ivan Loktionov on 09.04.2025.
//

import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: Int
    var body: some View {
        VStack {
            }
        Text("Home Page")
        }
    }


#Preview(traits: .sizeThatFitsLayout) {
    HomeView(selectedTab: .constant(3))
}
