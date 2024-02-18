//
//  FitOrNotUITests.swift
//  FitOrNotUITests
//
//  Created by Alfred Carra on 9/18/23.
//

import XCTest
import Firebase

final class FitOrNotUITests: XCTestCase {

    override func setUpWithError() throws {

        continueAfterFailure = false

    }


    func testExample() throws {
        
        let app = XCUIApplication()
        app.launch()
        
        app/*@START_MENU_TOKEN@*/.icons["FitOrNot"]/*[[".otherElements[\"Home screen icons\"]",".icons.icons[\"FitOrNot\"]",".icons[\"FitOrNot\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let signupButton = app.buttons["Sign Up"]
        XCTAssertTrue(signupButton.exists)
        app.buttons["Sign Up"].tap()
        
        let registerButton = app.buttons["Register"]
        XCTAssertTrue(registerButton.exists)
        app.buttons["Register"].tap()
        
        let emailTextField = app.textFields["email@example.com"]
        XCTAssertTrue(emailTextField.exists)
        app.textFields["email@example.com"].tap()
        
        let pSsw0rdSecureTextField = app.secureTextFields["P@ssw0rd!"]
        XCTAssertTrue(pSsw0rdSecureTextField.exists)
        pSsw0rdSecureTextField.tap()
        
        pSsw0rdSecureTextField.tap()
        app.buttons.containing(.image, identifier:"Show").children(matching: .staticText).element.tap()
        app.textFields["P@ssw0rd!"].tap()
        
        let registerButton = app/*@START_MENU_TOKEN@*/.staticTexts["REGISTER"]/*[[".buttons[\"REGISTER\"].staticTexts[\"REGISTER\"]",".staticTexts[\"REGISTER\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(registerButton.exists)
        app/*@START_MENU_TOKEN@*/.staticTexts["REGISTER"]/*[[".buttons[\"REGISTER\"].staticTexts[\"REGISTER\"]",".staticTexts[\"REGISTER\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let gearCircleButton = app.buttons["gear.circle"]
        XCTAssertTrue(gearCircleButton.exists)
        gearCircleButton.tap()
        
        let collectionViewsQuery = app.collectionViews
        XCTAssertTrue(collectionViewsQuery.exists)
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["FAQ"]/*[[".cells.buttons[\"FAQ\"]",".buttons[\"FAQ\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let whatIsFitornotStaticText = app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.staticTexts["What is FitOrNot?"]/*[[".disclosureTriangles[\"What is FitOrNot?\"].staticTexts[\"What is FitOrNot?\"]",".staticTexts[\"What is FitOrNot?\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(whatIsFitornotStaticText.exists)
        
        whatIsFitornotStaticText.tap()
        whatIsFitornotStaticText.tap()
        app.navigationBars["_TtGC7SwiftUI19UIHosting"]/*@START_MENU_TOKEN@*/.staticTexts["FitOrNot"]/*[[".otherElements[\"FitOrNot\"]",".buttons[\"FitOrNot\"].staticTexts[\"FitOrNot\"]",".staticTexts[\"FitOrNot\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let tabBar = app.tabBars["Tab Bar"]
        XCTAssertTrue(tabBar.exists)
        
        let profileButton = tabBar.buttons["Profile"]
        XCTAssertTrue(profileButton.exists)
        profileButton.tap()
        
        let brandsButton = tabBar.buttons["Brands"]
        XCTAssertTrue(brandsButton.exists)
        tabBar.buttons["Brands"].tap()
        
        let homeButton = tabBar.buttons["Home"]
        XCTAssertTrue(homeButton.exists)
        homeButton.tap()
        
        profileButton.tap()
        app.collectionViews["Sidebar"]/*@START_MENU_TOKEN@*/.buttons["Manual Inputs"]/*[[".cells.buttons[\"Manual Inputs\"]",".buttons[\"Manual Inputs\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let ex12TextField = collectionViewsQuery.children(matching: .cell).element(boundBy: 4).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .textField).matching(identifier: "Ex. 12").element(boundBy: 3)
        XCTAssertTrue(ex12TextField.exists)
        ex12TextField.tap()
        
        let maleButton = collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Male"]/*[[".cells",".segmentedControls.buttons[\"Male\"]",".buttons[\"Male\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(maleButton.exists)
        maleButton.tap()
        
        let femaleButton = collectionViewsQuery.buttons["Female"]
        XCTAssertTrue(femaleButton.exists)
        femaleButton.tap()
        
        let updateMeasurementsStaticText = collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Update Measurements"]/*[[".cells",".buttons[\"Update Measurements\"].staticTexts[\"Update Measurements\"]",".staticTexts[\"Update Measurements\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(updateMeasurementsStaticText.exists)
        updateMeasurementsStaticText.tap()
        
        let measureButton = tabBar.buttons["Measure"]
        XCTAssertTrue(measureButton.exists)
        measureButton.tap()
        
        
        homeButton.tap()
        measureButton.tap()
        app.buttons["Add Measurements Manually in Profile!"].tap()
        maleButton.tap()
        maleButton.tap()
        ex12TextField.tap()
        ex12TextField.tap()
        maleButton.tap()
        updateMeasurementsStaticText.tap()
        updateMeasurementsStaticText.tap()
        updateMeasurementsStaticText.tap()
        profileButton.tap()
        homeButton.tap()
        gearCircleButton.tap()
        
        let signoutTap = collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Sign Out"]/*[[".cells",".buttons[\"Sign Out\"].staticTexts[\"Sign Out\"]",".staticTexts[\"Sign Out\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(signoutTap.exists)
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Sign Out"]/*[[".cells",".buttons[\"Sign Out\"].staticTexts[\"Sign Out\"]",".staticTexts[\"Sign Out\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let termsofuseButton = app.buttons["Terms of Use"]
        XCTAssertTrue(termsofuseButton.exists)
        app.buttons["Terms of Use"].tap()
        app.navigationBars["Terms of Use"]/*@START_MENU_TOKEN@*/.buttons["Back"]/*[[".otherElements[\"Back\"].buttons[\"Back\"]",".buttons[\"Back\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let privacypolicyButton = app.buttons["Privacy Policy"]
        XCTAssertTrue(privacypolicyButton.exists)
        app.buttons["Privacy Policy"].tap()
        app.navigationBars["Privacy Policy"]/*@START_MENU_TOKEN@*/.buttons["Back"]/*[[".otherElements[\"Back\"].buttons[\"Back\"]",".buttons[\"Back\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
