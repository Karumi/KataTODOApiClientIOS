//
//  TODOAPIClient.swift
//  KataTODOAPIClient
//
//  Created by Pedro Vicente Gomez on 12/02/16.
//  Copyright © 2016 Karumi. All rights reserved.
//

import Foundation
import BothamNetworking
import Result

open class TODOAPIClient {

    fileprivate let apiClient: BothamAPIClient
    fileprivate let parser: TaskDTOJSONParser

    public init() {
        self.apiClient = BothamAPIClient(baseEndpoint: TODOAPIClientConfig.baseEndpoint)
        self.apiClient.requestInterceptors.append(DefaultHeadersInterceptor())
        self.parser = TaskDTOJSONParser()
    }

    open func getAllTasks(_ completion: @escaping (Result<[TaskDTO], TODOAPIClientError>) -> Void) {
        apiClient.GET(TODOAPIClientConfig.tasksEndpoint) { result in
            completion(result.mapJSON { json -> [TaskDTO] in
                let tasks: [TaskDTO] = self.parser.fromJSON(json)
                return tasks
            }.mapErrorToTODOAPIClientError())
        }
    }

    open func getTaskById(_ id: String, completion: @escaping (Result<TaskDTO, TODOAPIClientError>) -> Void) {
        apiClient.GET("\(TODOAPIClientConfig.tasksEndpoint)/\(id)") { result in
            completion(result.mapJSON { json -> TaskDTO in
                let task: TaskDTO = self.parser.fromJSON(json)
                return task
            }.mapErrorToTODOAPIClientError())
        }
    }

    open func addTaskToUser(_ userId: String, title: String, completed: Bool,
                            completion: @escaping (Result<TaskDTO, TODOAPIClientError>) -> Void) {
        apiClient.POST(TODOAPIClientConfig.tasksEndpoint,
            body: ["userId": userId as AnyObject,
                    "title": title as AnyObject,
                    "completed": completed as AnyObject]) { result in
            completion(result.mapJSON { json -> TaskDTO in
                let task: TaskDTO = self.parser.fromJSON(json)
                return task
            }.mapErrorToTODOAPIClientError())
        }
    }

    open func deleteTaskById(_ id: String, completion: @escaping (Result<Void, TODOAPIClientError>) -> Void) {
        apiClient.DELETE("\(TODOAPIClientConfig.tasksEndpoint)/\(id)") { result in
            completion(result.map { _ -> Void in
                return
            }.mapErrorToTODOAPIClientError())
        }
    }

    open func updateTask(_ task: TaskDTO,
                         completion: @escaping (Result<TaskDTO, TODOAPIClientError>) -> Void) {
            apiClient.PUT("\(TODOAPIClientConfig.tasksEndpoint)/\(task.id)",
                body: ["id": task.id as AnyObject,
                    "userId": task.userId as AnyObject,
                    "title": task.title as AnyObject,
                    "completed": task.completed as AnyObject]) { result in
                        completion(result.mapJSON { json -> TaskDTO in
                            let task: TaskDTO = self.parser.fromJSON(json)
                            return task
                        }.mapErrorToTODOAPIClientError())
            }
    }

}
