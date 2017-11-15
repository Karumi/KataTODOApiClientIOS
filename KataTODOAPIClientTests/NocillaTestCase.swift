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

open class NocillaTestCase: XCTestCase {

    let nocilla: LSNocilla = LSNocilla.sharedInstance()

    override open func setUp() {
        super.setUp()
        nocilla.start()
    }

    override open func tearDown() {
        nocilla.clearStubs()
        nocilla.stop()
        super.tearDown()
    }

    @discardableResult func stubRequest(_ method: String, _ url: String) -> LSStubRequestDSL {
        return Nocilla.stubRequest(method, (url as NSString) as LSMatcheable)
    }

    func fromJsonFile(_ fileName: String) -> NSString {
        let classBundle = Bundle(for: self.classForCoder)
        let path = classBundle.path(forResource: fileName, ofType: "json")
        let absolutePath =  path ?? ""
        do {
            let content = try String(contentsOfFile: absolutePath, encoding: String.Encoding.utf8)
            if content.last == "\n"{
                return NSString(string: content.substring(to: content.index(before: content.endIndex)))
            } else {
                return NSString(string: content)
            }
        } catch _ {
            print("Error trying to read file \(absolutePath). The file does not exist")
            return NSString(string: "")
        }
    }
}
