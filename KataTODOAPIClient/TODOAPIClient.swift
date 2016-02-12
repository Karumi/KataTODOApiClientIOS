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

public class TODOAPIClient {

    private let botham: BothamAPIClient
    private let parser: TaskDTOParser

    public init() {
        self.botham = BothamAPIClient(baseEndpoint: TODOAPIClientConfig.baseEndpoint)
        self.botham.requestInterceptors.append(DefaultHeadersInterceptor())
        self.parser = TaskDTOParser()
    }

    public func getAllTasks(completion: (Result<[TaskDTO], TODOAPIClientError>) -> ()) {
        botham.GET(TODOAPIClientConfig.tasksEndpoint) { result in
            result.mapJSON { json in
                let tasks: [TaskDTO] = self.parser.fromJSON(json)
                completion(Result.Success(tasks))
            }.mapErrorToTODOAPIClientError()
        }
    }

    public func getTaskById(id: String, completion: (Result<TaskDTO, TODOAPIClientError>) -> ()) {
        botham.GET("\(TODOAPIClientConfig.tasksEndpoint)/\(id)") { result in
            result.mapJSON { json in
                let task: TaskDTO = self.parser.fromJSON(json)
                completion(Result.Success(task))
            }.mapErrorToTODOAPIClientError()
        }
    }

    public func addTaskToUser(userId: String, title: String, completed: Bool,
            completion: (Result<TaskDTO, TODOAPIClientError>) -> ()) {
        botham.POST(TODOAPIClientConfig.tasksEndpoint,
            body: ["userId": userId,
                    "title": title,
                    "completed": completed]){ result in
            result.mapJSON { json in
                let task: TaskDTO = self.parser.fromJSON(json)
                completion(Result.Success(task))
            }.mapErrorToTODOAPIClientError()
        }
    }

    public func deleteTaskById(id: String, completion: (Result<Void, TODOAPIClientError>) -> ()) {
        botham.DELETE("\(TODOAPIClientConfig.tasksEndpoint)/\(id)") { result in
            result.mapJSON { json in
                completion(Result.Success())
            }.mapErrorToTODOAPIClientError()
        }
    }

    public func updateTask(task: TaskDTO,
        completion: (Result<TaskDTO, TODOAPIClientError>) -> ()) {
            botham.PUT("\(TODOAPIClientConfig.tasksEndpoint)/\(task.id)",
                body: ["id": task.id,
                    "userId": task.userId,
                    "title": task.title,
                    "completed": task.completed]){ result in
                        result.mapJSON { json in
                            let task: TaskDTO = self.parser.fromJSON(json)
                            completion(Result.Success(task))
                        }.mapErrorToTODOAPIClientError()
            }
    }


}