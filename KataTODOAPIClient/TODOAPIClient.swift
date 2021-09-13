import Alamofire
import Combine
import Foundation

open class TODOAPIClient {
    public init() {}

    open func getAllTasks() -> AnyPublisher<[TaskDTO], TODOAPIClientError> {
        AF.request(TODOAPIClientConfig.tasksEndpoint).publishApiResponse()
    }

    open func getTaskById(_ id: Int) -> AnyPublisher<TaskDTO, TODOAPIClientError> {
        AF.request("\(TODOAPIClientConfig.tasksEndpoint)/\(id)").publishApiResponse()
    }

    open func addTaskToUser(
        _ userId: Int,
        title: String,
        completed: Bool
    ) -> AnyPublisher<TaskDTO, TODOAPIClientError> {
        let parameters = AddTaskToUserParameters(userId: userId, title: title, completed: completed)
        return AF.request(
            TODOAPIClientConfig.tasksEndpoint,
            method: .post,
            parameters: parameters,
            encoder: JSONParameterEncoder.default)
            .publishApiResponse()
    }

    open func deleteTaskById(_ id: Int) -> AnyPublisher<Void, TODOAPIClientError> {
        AF.request("\(TODOAPIClientConfig.tasksEndpoint)/\(id)", method: .delete)
            .validate().publishUnserialized().value().map { _ in }
            .mapError(asTODOAPIError)
            .eraseToAnyPublisher()
    }

    open func updateTask(_ task: TaskDTO) -> AnyPublisher<TaskDTO, TODOAPIClientError> {
        AF.request(
            "\(TODOAPIClientConfig.tasksEndpoint)/\(task.id)",
            method: .put,
            parameters: task,
            encoder: JSONParameterEncoder.default
        ).publishApiResponse()
    }
}

private extension DataRequest {
    func publishApiResponse<T: Decodable>() -> AnyPublisher<T, TODOAPIClientError> {
        self.validate()
            .publishDecodable()
            .value()
            .mapError(asTODOAPIError)
            .eraseToAnyPublisher()
    }
}

private extension TODOAPIClient {
    struct AddTaskToUserParameters: Encodable {
        let userId: Int
        let title: String
        let completed: Bool
    }
}

private func asTODOAPIError(_ error: AFError) -> TODOAPIClientError {
    switch error {
    case .responseValidationFailed(.unacceptableStatusCode(404)):
        return .itemNotFound
    case .responseValidationFailed(.unacceptableStatusCode(let statusCode)):
        return .unknownError(code: statusCode)
    default:
        return .networkError
    }
}
