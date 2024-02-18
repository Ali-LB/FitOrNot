//
//  Settings.swift
//  FitOrNot
//
//  Created by Ali Farhat on 9/20/23.
//

import SwiftUI

struct Settings: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isDeleteConfirmed = false

    var body: some View {
        NavigationView{
            List {
                Section("Community") {
                    NavigationLink(destination: FAQ()) {
                        Label("FAQ", systemImage: "folder.circle")
                    }
                   // NavigationLink(destination: SupportTicket()) {
                     //   Label("Send a support ticket", systemImage: "tray.and.arrow.down")
                   // }
                }
                Section("Account") {
                    Button {
                        viewModel.signOut()
                    } label: {
                        ProfileRowView(ImageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                    }
                    
                    Button {
                        Task {
                            isDeleteConfirmed.toggle()
                        }
                    } label: {
                        ProfileRowView(ImageName: "xmark.circle.fill", title: "Delete Account", tintColor: .red)
                    }
                }
                .alert(isPresented: $isDeleteConfirmed) {
                    Alert(
                        title: Text("Confirm Delete"),
                        message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                        primaryButton: .destructive(Text("Yes")) {
                            Task {
                                do {
                                    try await viewModel.deleteAccount()
                                } catch {
                                    print(error)
                                }
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                
                if let isAdmin = viewModel.currentUser?.isAdmin, isAdmin {
                    Section("Admin") {
                        NavigationLink(destination: BrandAdmin()) {
                            Label("Brand URL Settings", systemImage: "folder.circle")
                        }
                        
                        Button {
                            Task {
                                isDeleteConfirmed.toggle()
                            }
                        } label: {
                            ProfileRowView(ImageName: "xmark.circle.fill", title: "Delete Account", tintColor: .red)
                        }
                    }
                }
            }
        }
        .background{
            Color(red: 0.89, green: 0.89, blue: 0.89)}
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
                    // 1
                    .toolbar {

                        // 2
                        ToolbarItem(placement: .navigationBarLeading) {

                            Button {
                                // 3
                                print("Custom Action")
                                dismiss()

                            } label: {
                                // 4
                                HStack {

                                    Image(systemName: "chevron.backward")
                                    Text("FitOrNot")
                                }
                            }
                        }
                    }
    }
}

#Preview {
    Settings()
}
