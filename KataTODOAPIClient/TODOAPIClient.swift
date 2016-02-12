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

    public func getAll(completion: (Result<[TaskDTO], TODOAPIClientError>) -> ()) {
        botham.GET(TODOAPIClientConfig.tasksEndpoint) { result in
            result.mapJSON { json in
                let tasks: [TaskDTO] = self.parser.fromJSON(json)
                completion(Result.Success(tasks))
            }.mapErrorToTODOAPIClientError()
        }
    }

    public func getByTaskId(id: String, completion: (Result<TaskDTO, TODOAPIClientError>) -> ()) {
        botham.GET("\(TODOAPIClientConfig.tasksEndpoint)/\(id)") { result in
            result.mapJSON { json in
                let task: TaskDTO = self.parser.fromJSON(json)
                completion(Result.Success(task))
                }.mapErrorToTODOAPIClientError()
        }
    }

}