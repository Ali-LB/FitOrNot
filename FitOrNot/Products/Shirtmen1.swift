//
//  Shirtmen1.swift
//  FitOrNot
//
//  Created by Mustafa Marini on 10/16/23.
//


import SwiftUI
import SwiftSoup
import UIKit

struct Shirtmen1: View {
    
    
    let Shirt1 = """
                <div class="pr2-sm css-1ou6bb2"><h1 id="pdp_product_title" class="headline-2 css-16cqcdq" data-test="product-title">Nike Pro Dri-FIT</h1><h2 class="headline-5 pb1-sm d-sm-ib" data-test="product-sub-title">Men's Slim Fit Short-Sleeve Top</h2><div class="mb3-sm"><div class="headline-5 mt3-sm mr2-sm" style="display: inline-block;"><div class="product-price__wrapper css-13hq5b3"><div class="product-price is--current-price css-s56yt7 css-xq7tty" data-test="product-price-reduced">$16.97</div><div class="product-price is--striked-out css-tpaepq" data-test="product-price"><span class="visually-hidden">Discounted from </span>$28</div><span class="css-14jqfub" data-testid="OfferPercentage">39% off</span></div></div><p id="promo-message" class="headline-5 mt2-sm mb2-sm mt1-lg mb6-lg" data-testid="promo-message" style="color: green;"></p></div></div>
            """
    
    let Shirt1Image = """
            <img data-fade-in="css-147n82m" class="css-viwop1 u-full-width u-full-height css-m5dkrx" src="https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/6fb72e16-d4cf-4ffe-b121-7be39b371291/pro-dri-fit-mens-slim-fit-short-sleeve-top-H7B5f3.png" alt="Nike Pro Dri-FIT Men's Slim Fit Short-Sleeve Top" style="object-fit: contain;">
            """
    
    
    
    
    
    
    
    
    var body: some View {
        
        NavigationView{
            VStack{
                
                HTMLView(htmlString: Shirt1)
                
                
                HTMLView(htmlString: Shirt1Image)
                    .frame(width: 300, height: 500)
                
                Button("Purchase it for yourself!") {
                    if let url = URL(string: "https://www.nike.com/t/pro-dri-fit-mens-slim-fit-short-sleeve-top-H7B5f3/DD1982-010?nikemt=true&cp=87485117400_search_--x-20415947966---c-----9016866-13661564-00195241671857&gclid=EAIaIQobChMIhJOMntj7gQMVwwytBh1jnAv7EAQYASABEgJFNvD_BwE&gclsrc=aw.ds") {
                        UIApplication.shared.open(url)
                        
                    }
                    
                    // Force Light Mode
                }
            }
        }
        
    }
}


struct Shirtmen1_Preview: PreviewProvider {
    static var previews: some View {
        Shirtmen1()
    }
}

