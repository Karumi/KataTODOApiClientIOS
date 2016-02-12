//
//  NocillaTestCase.swift
//  KataTODOAPIClient
//
//  Created by Pedro Vicente Gomez on 12/02/16.
//  Copyright © 2016 Karumi. All rights reserved.
//

import Foundation
import XCTest
import Nocilla

public class NocillaTestCase: XCTestCase {

    public let nocilla: LSNocilla = LSNocilla.sharedInstance()

    public override func setUp() {
        super.setUp()
        nocilla.start()
    }

    public override func tearDown() {
        nocilla.clearStubs()
        nocilla.stop()
        super.tearDown()
    }

    public func fromJSONFile(fileName: String) -> String {
        let classBundle = NSBundle(forClass: self.classForCoder)
        let path = classBundle.pathForResource(fileName, ofType: "json")
        let absolutePath =  path ?? ""
        do {
            return try String(contentsOfFile: absolutePath, encoding: NSUTF8StringEncoding)
        } catch _ {
            print("Error trying to read file \(absolutePath). The file does not exist")
            return ""
        }
    }
    
}