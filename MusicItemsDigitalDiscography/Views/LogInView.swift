//
//  LogInView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 20.04.2024.
//

import SwiftUI
import FirebaseAuth
import _AuthenticationServices_SwiftUI

struct LogInView: View {
    @ObservedObject var viewModel = AuthenticationViewModel()

    var body: some View {
        ZStack {
            Color("SystemBrightWhite").ignoresSafeArea(.all)
            VStack {
                Spacer()
                if viewModel.isAuthenticated {
                    Button("Sign Out") {
                        viewModel.signOut()
                    }
                    .frame(width: 350, height: 55)
                    .background(Color("AccentColor"))
                    .foregroundStyle(Color.white)
                    .cornerRadius(8)
                } else {
                    VStack(spacing: 20){
                        Spacer()
                        Image("LogInViewImage")
                            .resizable()
                            .cornerRadius(15)
                            .frame(width: 200, height: 200)
                            .shadow(radius: 5)
                        Text("Digiamp")
                            .font(.custom("Supreme-Bold", size: 24))
                            .foregroundStyle(Color.black)
                        Spacer()
                        
                        VStack(spacing: 20) {
                            SignInWithAppleButton(.signIn) { request in
                              viewModel.handleSignInWithAppleRequest(request)
                            } onCompletion: { result in
                              viewModel.handleSignInWithAppleCompletion(result)
                            }
                            .signInWithAppleButtonStyle(.black)
                            .frame(width: 350, height: 50)
                            .cornerRadius(8)
                            
                            Button(action: {
                                Task {
                                    let success = await viewModel.signInWithGoogle()
                                    if !success {
                                        print("Failed to sign in with Google.")
                                    }
                                }
                            }, label: {
                                HStack {
                                    Image("GoogleIcon")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                    Text("Sign In with Google")
                                        .font(.system(size: 20))
                                    .bold()
                                }
                            })
                            .frame(width: 350, height: 50)
                            .background(Color.white)
                            .foregroundColor(Color.black)
                            .cornerRadius(8)
                            .shadow(radius: 2)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    LogInView()
}
