//
//  TODOAPIClientError.swift
//  KataTODOAPIClient
//
//  Created by Pedro Vicente Gomez on 12/02/16.
//  Copyright © 2016 Karumi. All rights reserved.
//

import Foundation
import BothamNetworking

public enum TODOAPIClientError: Error {

    case networkError
    case itemNotFound
    case unknownError(code: Int)

}

extension Result where Failure == BothamAPIClientError {

    func mapErrorToTODOAPIClientError() -> Result<Success, TODOAPIClientError> {
        return mapError { error in
            switch error {
            case BothamAPIClientError.httpResponseError(404, _):
                return TODOAPIClientError.itemNotFound
            case BothamAPIClientError.httpResponseError(let statusCode, _):
                return TODOAPIClientError.unknownError(code: statusCode)
            default:
                return TODOAPIClientError.networkError
            }
        }
    }
}
