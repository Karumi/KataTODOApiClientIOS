import Foundation
import Alamofire

public enum TODOAPIClientError: Error, Equatable {
    case networkError
    case itemNotFound
    case unknownError(code: Int)
}
