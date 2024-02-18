//
//  Adidas.swift
//  FitOrNot
//
//  Created by Ali Farhat on 10/6/23.
//  TO BE USED IN A LATER DATE IF WE WERE TO WORK ON THIS OUTSIDE OF CLASS TIME - AF



import SwiftUI

struct Adidas: View {
    
    var body: some View {
        @State var gender: String = "Male"
        NavigationView{
            List{
                Section{
                    HStack{
                        Text("Adidas")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width:72, height:72)
                            .background(Color(red: 0.13, green: 0.51, blue: 0.87))
                            .clipShape(Circle())
                        
                        VStack(alignment:.leading, spacing: 4){
                            Text("Your size is: ")
                                .fontWeight(.semibold)
                                .padding(.top,4)
                            Text("Below some suggested options!")
                                .font(.footnote)
                                .foregroundColor(.gray)
                            
                            
                            
                            
                        }
                        
                    }
                    
                }
                
                Section {
                    VStack{
                        if (gender == "Male")
                        {
                            
                            
                            /*
                             
                             HTMLView(htmlString: Shirt1)
                             .frame(width: 300, height: 400)
                             .fixedSize(horizontal: true, vertical: true)
                             .aspectRatio(contentMode: .fit)
                             */
                             
                             NavigationLink(destination: Test()) {
                             Text("Click for future page")
                             }
                             }
                             
                             /*
                             else {
                             HTMLView(htmlString: Shirt1Women)
                             .frame(width: 300, height: 400)
                             .fixedSize(horizontal: true, vertical: true)
                             .aspectRatio(contentMode: .fit)
                             }
                             */
                        }
                    }
                }
                // Force Light Mode
                .preferredColorScheme(.light)
            }
        }
    }


struct Adidas_Preview: PreviewProvider {
    static var previews: some View {
        Adidas()
    }
}

