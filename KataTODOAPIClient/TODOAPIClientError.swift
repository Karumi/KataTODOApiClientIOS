//
//  TODOAPIClientError.swift
//  KataTODOAPIClient
//
//  Created by Pedro Vicente Gomez on 12/02/16.
//  Copyright © 2016 Karumi. All rights reserved.
//

import Foundation
import Result
import BothamNetworking

public enum TODOAPIClientError: ErrorType {

    case NetworkError
    case ItemNotFound
    case UnknownError(code: Int)

}

extension ResultType where Error == BothamAPIClientError {

    func mapErrorToTODOAPIClientError() -> Result<Value, TODOAPIClientError> {
        return mapError { error in
            switch error {
            case BothamAPIClientError.HTTPResponseError(404, _):
                return TODOAPIClientError.ItemNotFound
            case BothamAPIClientError.HTTPResponseError(let statusCode, _):
                return TODOAPIClientError.UnknownError(code: statusCode)
            default:
                return TODOAPIClientError.NetworkError
            }
        }
    }
}