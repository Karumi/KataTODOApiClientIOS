//
//  TODOAPIClient.swift
//  KataTODOAPIClient
//
//  Created by Pedro Vicente Gomez on 12/02/16.
//  Copyright © 2016 Karumi. All rights reserved.
//

import Foundation
import Alamofire

open class TODOAPIClient {

    public init() {
    }

    open func getAllTasks(_ completion: @escaping (Result<[TaskDTO], TODOAPIClientError>) -> Void) {
        AF.request(TODOAPIClientConfig.tasksEndpoint)
            .validate()
            .responseDecodable { response in
            return completion(response.result.mapErrorToTODOAPIClientError())
        }
    }

    open func getTaskById(_ id: String, completion: @escaping (Result<TaskDTO, TODOAPIClientError>) -> Void) {
        AF.request("\(TODOAPIClientConfig.tasksEndpoint)/\(id)")
            .validate()
            .responseDecodable { response in
            completion(response.result.mapErrorToTODOAPIClientError())
        }
    }

    open func addTaskToUser(_ userId: Int, title: String, completed: Bool,
                            completion: @escaping (Result<TaskDTO, TODOAPIClientError>) -> Void) {
        struct AddTaskToUserParameters: Encodable {
            let userId: Int
            let title: String
            let completed: Bool
        }
        AF.request(TODOAPIClientConfig.tasksEndpoint, method: .post,
                   parameters: AddTaskToUserParameters(
                    userId: userId,
                    title: title,
                    completed: completed), encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable { response in
                completion(response.result.mapErrorToTODOAPIClientError())
            }
    }

    open func deleteTaskById(_ id: String, completion: @escaping (Result<Void, TODOAPIClientError>) -> Void) {
        AF.request("\(TODOAPIClientConfig.tasksEndpoint)/\(id)", method: .delete)
            .validate()
            .response { (response: AFDataResponse<Data?>) in
            completion(response.result.map { _ -> Void in
                return
            }.mapErrorToTODOAPIClientError())
        }
    }

    open func updateTask(_ task: TaskDTO,
                         completion: @escaping (Result<TaskDTO, TODOAPIClientError>) -> Void) {
        AF.request("\(TODOAPIClientConfig.tasksEndpoint)/\(task.id)", method: .put,
                parameters: task, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable { (response: DataResponse<TaskDTO, AFError>) in
                completion(response.result.mapErrorToTODOAPIClientError())
            }
    }

}
