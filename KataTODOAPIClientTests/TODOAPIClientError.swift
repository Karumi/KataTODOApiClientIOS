//
//  TODOAPIClientError.swift
//  KataTODOAPIClient
//
//  Created by Pedro Vicente Gomez on 12/02/16.
//  Copyright © 2016 Karumi. All rights reserved.
//

import Foundation
@testable import KataTODOAPIClient

extension TODOAPIClientError: Equatable {}

public func == (lhs: TODOAPIClientError, rhs: TODOAPIClientError) -> Bool {
    switch (lhs, rhs) {
    case (.NetworkError, .NetworkError):
        return true
    case (.ItemNotFound, .ItemNotFound):
        return true
    case let (.UnknownError(code1), .UnknownError(code2)):
        return code1 == code2
    default:
        return false
    }
}