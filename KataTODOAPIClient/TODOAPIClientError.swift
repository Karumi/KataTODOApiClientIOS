//
//  TODOAPIClientError.swift
//  KataTODOAPIClient
//
//  Created by Pedro Vicente Gomez on 12/02/16.
//  Copyright © 2016 Karumi. All rights reserved.
//

import Foundation
import Alamofire

public enum TODOAPIClientError: Error {

    case networkError
    case itemNotFound
    case unknownError(code: Int)

}

extension Result where Failure == AFError {

    func mapErrorToTODOAPIClientError() -> Result<Success, TODOAPIClientError> {
        return mapError { error in
            switch error {
            case .responseValidationFailed(.unacceptableStatusCode(404)):
                return TODOAPIClientError.itemNotFound
            case .responseValidationFailed(.unacceptableStatusCode(let statusCode)):
                return TODOAPIClientError.unknownError(code: statusCode)
            default:
                return TODOAPIClientError.networkError
            }
        }
    }
}
