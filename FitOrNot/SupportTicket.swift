//
//  SupportTicket.swift
//  FitOrNot
//
//  Created by Yusef Marini on 11/15/23.
//

import SwiftUI


    
    
struct SupportTicket: View {
    @State private var issueTitle: String = ""
    @State private var issueDetails: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Issue Title")) {
                    TextField("Ex. I cannot save my profile data", text: $issueTitle)
                }
                
                Section(header: Text("Issue Details")) {
                    TextField("Ex. My problem with saving began when...", text: $issueDetails)
                        .frame(minHeight: 150) // Height of the text box
                }
                
                Button("Submit") {
                    // Submitting the support ticket
                    submitIssue()
                }
            }
            .navigationBarTitle("Support Ticket Submission Form", displayMode: .inline)
        }
    }
    
    func submitIssue() {
        // Link to database later
        print("Issue Title: \(issueTitle)")
        print("Issue Details: \(issueDetails)")
    }
}


struct SupportTicketView_Previews: PreviewProvider {
    static var previews: some View {
        SupportTicket()
    }
}



#Preview {
    SupportTicket()
}
