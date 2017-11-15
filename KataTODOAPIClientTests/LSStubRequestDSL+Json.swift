//
//  LSStubResponseDSL+Json.swift
//  KataTODOAPIClient
//
//  Created by Sergio Gutiérrez on 28/07/2017.
//  Copyright © 2017 Karumi. All rights reserved.
//

import Foundation
import Nocilla
import SwiftyJSON

extension LSStubRequestDSL {
    open func withJsonBody(_ jsonString: NSString) -> LSStubRequestDSL? {
        let normalizedJsonString = JSON(jsonString).rawString()!
        return self.withBody(NSString(string: normalizedJsonString))
    }
}

private class JsonMatcheable: NSObject, LSMatcheable {
    private let jsonString: String

    public init(jsonString: String) {
        self.jsonString = jsonString
    }

    func matcher() -> LSMatcher! {
        return JsonMatcher(jsonString: jsonString)
    }
}

private class JsonMatcher: LSMatcher {

    private let jsonString: String

    public init(jsonString: String) {
        self.jsonString = jsonString
    }

    override func matches(_ string: String!) -> Bool {
        return matchesData(string.data(using: String.Encoding.utf8)!)
    }

    override func matchesData(_ data: Data!) -> Bool {
        do {
            let json = try JSON(data: data)
            return jsonString == json.rawString()!
        } catch {
            return false
        }
    }
}
