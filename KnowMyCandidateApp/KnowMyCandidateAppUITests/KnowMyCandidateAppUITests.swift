//
//  KnowMyCandidateAppUITests.swift
//  KnowMyCandidateAppUITests
//
//  Created by Qianwen Zhang on 11/13/15.
//  Copyright © 2015 Samir Choudhary. All rights reserved.
//

import XCTest

class KnowMyCandidateAppUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSignInWithExsitingAccount() {
        
        let app = XCUIApplication()
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        let emailTextField = elementsQuery.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("janet@gmail.com")
        
        let passwordSecureTextField = elementsQuery.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("123456")
        scrollViewsQuery.childrenMatchingType(.Button).matchingIdentifier("Log In").elementBoundByIndex(1).tap()
        XCTAssertNotNil(app.tabBars)
    
        app.tabBars.buttons["User"].tap()
        app.navigationBars["User"].buttons["Log Out"].tap()
        
    }
    
    func testSignInWithInvalidAccount() {
        
        let app = XCUIApplication()
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        let emailTextField = elementsQuery.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("invalidAccount@gmail.com")
        
        let passwordSecureTextField = elementsQuery.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("123456")
        scrollViewsQuery.childrenMatchingType(.Button).matchingIdentifier("Log In").elementBoundByIndex(1).tap()
        
        let okButton = app.alerts["Invalid credentials"].collectionViews.buttons["OK"]
        okButton.tap()
        
    }
    
    func testSignUpWithExistingAccount() {
        
        let app = XCUIApplication()
        app.buttons["Sign Up"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        let emailTextField = elementsQuery.textFields["Email"]
        emailTextField.tap()
        emailTextField.tap()
        emailTextField.typeText("existingAccount@gmail.com")
        
        let passwordSecureTextField = elementsQuery.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("123456")
        
        let signUpButton = scrollViewsQuery.childrenMatchingType(.Button).matchingIdentifier("Sign Up").elementBoundByIndex(1)
        signUpButton.tap()
        app.alerts["Account already exists"].collectionViews.buttons["OK"].tap()
    }
    
    func testSignUpWithNewAccount() {
        
        let app = XCUIApplication()
        app.buttons["Sign Up"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        let emailTextField = elementsQuery.textFields["Email"]
        emailTextField.tap()
        emailTextField.tap()
        emailTextField.typeText("test8@gmail.com")
        
        let passwordSecureTextField = elementsQuery.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("123456")
        scrollViewsQuery.childrenMatchingType(.Button).matchingIdentifier("Sign Up").elementBoundByIndex(1).tap()
        
        let enterNameTextField = app.textFields["Enter name"]
        enterNameTextField.tap()
        enterNameTextField.typeText("Test")
        
        let tapToSelectAgeTextField = app.textFields["Tap to select age"]
        tapToSelectAgeTextField.tap()
        tapToSelectAgeTextField.tap()
        app.pickerWheels["18"].tap()
        
        let doneButton = app.toolbars.buttons["Done"]
        doneButton.tap()
        app.textFields["Tap to select gender"].tap()
        app.pickerWheels["Male"].tap()
        doneButton.tap()
        app.textFields["Tap to select party affiliation"].tap()
        app.pickerWheels["Democratic"].tap()
        doneButton.tap()
        app.buttons["Next"].tap()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.cells.containingType(.StaticText, identifier:"Absolute right to gun ownership").sliders["50%"].tap()
        collectionViewsQuery.cells.containingType(.StaticText, identifier:"Expand the military").sliders["50%"].tap()
        app.buttons["Submit"].tap()
        XCTAssertNotNil(app.tabBars)
        
        app.tabBars.buttons["User"].tap()
        app.navigationBars["User"].buttons["Log Out"].tap()
    }
}
