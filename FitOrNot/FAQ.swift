//
//  FAQ.swift
//  FitOrNot
//
//  Created by Ali Farhat on 11/7/23.
//

import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FAQData: Identifiable, Codable {
    @DocumentID var id: String?
    var question: [String]
    var answer: [String]
}

// ViewModel to manage and fetch FAQs from the database -AF
class FAQViewModel: ObservableObject {
    private var db = Firestore.firestore()
    @Published var faqs = [FAQData]()
    
    func fetchFAQData() async {
        do {
            // Fetch documents from the "faqs" collection - AF
            let querySnapshot = try await Firestore.firestore().collection("faqs").getDocuments()
            // Map all the documents to FAQData objects and update the @Published variable - AF
            self.faqs = querySnapshot.documents.compactMap { document in
                try? document.data(as: FAQData.self)
            }
        } catch {
            print("Failed to fetch FAQ data: \(error.localizedDescription)")
        }
    }
}
// View to display a list of FAQs - AF
struct FAQlist: View {
    var faq: FAQData
    var body: some View {
        VStack {
            // Display each question and answer pair from the firebase to the view - AF
            ForEach(0..<faq.question.count, id: \.self) { index in
                DisclosureGroup(faq.question[index]) {
                    VStack {
                        Text(faq.answer[index])
                    }
                    .bold()
                }.accentColor(Color.blue).padding(5)
            }.padding()
        }
    }
}
// View for the main FAQ screen - AF
struct FAQ: View {
    @ObservedObject var faqViewModel = FAQViewModel()
    var body: some View {
        VStack{
            // UI layout for the FAQ screen - AF
            VStack{
                VStack{
                    Text("Frequently Asked Questions")
                }
                .offset(y:15)
                .font(Font.custom("Koulen", size: 21))
                // Scroll view displaying the list of FAQs - AF
                ScrollView{
                    ForEach(faqViewModel.faqs) { faq in
                        FAQlist(faq: faq)
                    }
                    .multilineTextAlignment(.center)
                }
                .onAppear {
                    // Fetch FAQs when the view appears - AF
                    Task {
                        await faqViewModel.fetchFAQData()
                    }
                }
                .padding()
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }.background{
                Color(red: 1, green: 1, blue: 1).clipShape(RoundedRectangle(cornerRadius:20))}
            .padding()
            .offset(y:75)
        }
        .background{
            Color(red: 0.89, green: 0.89, blue: 0.89)}
        .ignoresSafeArea()
        //Force Light Mode - AF
        .preferredColorScheme(.light)
    }
}

#Preview {
    FAQ()
}
