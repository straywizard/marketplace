//
//  ProfileView.swift
//  MarketplaceUI
//
//  Created by Ivan Loktionov on 14.04.2025.
//
import SwiftUI

struct LoginScreen: View {
    @Binding var login: Auth
    var body: some View {
        VStack() {
            Text("Login")
            TextField("Phone Number", text: $login.loginData.phoneNumber)
                .border(.black)
            SecureField("Password", text: $login.loginData.password)
                .border(.black)
        }
    }
}

struct ProfileView: View {
    var body: some View {
        VStack {
            Text("Profile")
        }
    }
}

#Preview(traits: .sizeThatFitsLayout){
    ProfileView()
}
