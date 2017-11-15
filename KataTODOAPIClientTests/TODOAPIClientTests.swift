//
//  TODOAPIClientTests.swift
//  KataTODOAPIClient
//
//  Created by Pedro Vicente Gomez on 12/02/16.
//  Copyright © 2016 Karumi. All rights reserved.
//

import Foundation
import Nocilla
import Nimble
import XCTest
import Result
@testable import KataTODOAPIClient

class TODOAPIClientTests: NocillaTestCase {

    fileprivate let apiClient = TODOAPIClient()
    fileprivate let anyTask = TaskDTO(userId: "1", id: "2", title: "Finish this kata", completed: true)

    func testSendsContentTypeHeader() {
        stubRequest("GET", "http://jsonplaceholder.typicode.com/todos")
            .withHeaders(["Content-Type": "application/json", "Accept": "application/json"])?
            .andReturn(200)

        var result: Result<[TaskDTO], TODOAPIClientError>?
        apiClient.getAllTasks { response in
            result = response
        }

        expect(result).toEventuallyNot(beNil())
    }

    func testParsesTasksProperlyGettingAllTheTasks() {
        stubRequest("GET", "http://jsonplaceholder.typicode.com/todos")
            .andReturn(200)?
            .withJsonBody(fromJsonFile("getTasksResponse"))

        var result: Result<[TaskDTO], TODOAPIClientError>?
        apiClient.getAllTasks { response in
            result = response
        }

        expect(result?.value?.count).toEventually(equal(200))
        assertTaskContainsExpectedValues((result?.value?[0])!)
    }

    func testReturnsNetworkErrorIfThereIsNoConnectionGettingAllTasks() {
        stubRequest("GET", "http://jsonplaceholder.typicode.com/todos")
            .andFailWithError(NSError.networkError())

        var result: Result<[TaskDTO], TODOAPIClientError>?
        apiClient.getAllTasks { response in
            result = response
        }

        expect(result?.error).toEventually(equal(TODOAPIClientError.networkError))
    }

    func testReturnsUnknowErrorIfTheErrorIsNotHandledGettingAllTasks() {
        stubRequest("GET", "http://jsonplaceholder.typicode.com/todos")
            .andReturn(418)

        var result: Result<[TaskDTO], TODOAPIClientError>?
        apiClient.getAllTasks { response in
            result = response
        }

        expect(result?.error).toEventually(equal(TODOAPIClientError.unknownError(code: 418)))
    }

    func testParsesTaskProperlyGettingTaskById() {
        stubRequest("GET", "http://jsonplaceholder.typicode.com/todos/1")
            .andReturn(200)?
            .withJsonBody(fromJsonFile("getTaskByIdResponse"))

        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.getTaskById("1") { response in
            result = response
        }

        expect(result).toEventuallyNot(beNil())
        assertTaskContainsExpectedValues((result?.value)!)
    }

    func testReturnsItemNotFoundErrorIfTheTaskIdDoesNotExist() {
        stubRequest("GET", "http://jsonplaceholder.typicode.com/todos/1")
            .andReturn(404)

        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.getTaskById("1") { response in
            result = response
        }

        expect(result?.error).toEventually(equal(TODOAPIClientError.itemNotFound))
    }

    func testReturnsNetworkErrorIfThereIsNoConnectionGettingTaskById() {
        stubRequest("GET", "http://jsonplaceholder.typicode.com/todos/1")
            .andFailWithError(NSError.networkError())

        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.getTaskById("1") { response in
            result = response
        }

        expect(result?.error).toEventually(equal(TODOAPIClientError.networkError))
    }

    func testReturnsUnknowErrorIfTheErrorIsNotHandledGettingTasksById() {
        stubRequest("GET", "http://jsonplaceholder.typicode.com/todos/1")
            .andReturn(418)

        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.getTaskById("1") { response in
            result = response
        }

        expect(result?.error).toEventually(equal(TODOAPIClientError.unknownError(code: 418)))
    }

    func testSendsTheCorrectBodyAddingANewTask() {
        _ = stubRequest("POST", "http://jsonplaceholder.typicode.com/todos")
            .withJsonBody(fromJsonFile("addTaskToUserRequest"))?
            .andReturn(201)?.withJsonBody(fromJsonFile("addTaskToUserResponse"))

        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.addTaskToUser("1", title: "Finish this kata", completed: false) { response in
            result = response
        }

        expect(result).toEventuallyNot(beNil())
        expect(result?.error).toEventually(beNil())
    }

    func testParsesTheTaskCreatedProperlyAddingANewTask() {
        stubRequest("POST", "http://jsonplaceholder.typicode.com/todos")
            .andReturn(201)?
            .withJsonBody(fromJsonFile("addTaskToUserResponse"))

        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.addTaskToUser("1", title: "delectus aut autem", completed: false) { response in
            result = response
        }

        expect(result).toEventuallyNot(beNil())
        assertTaskContainsExpectedValues((result?.value)!)
    }

    func testReturnsNetworkErrorIfThereIsNoConnectionAddingATask() {
        stubRequest("POST", "http://jsonplaceholder.typicode.com/todos")
            .andFailWithError(NSError.networkError())

        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.addTaskToUser("1", title: "delectus aut autem", completed: false) { response in
            result = response
        }

        expect(result?.error).toEventually(equal(TODOAPIClientError.networkError))
    }

    func testReturnsUnknowErrorIfThereIsAnyErrorAddingATask() {
        stubRequest("POST", "http://jsonplaceholder.typicode.com/todos")
            .andReturn(418)

        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.addTaskToUser("1", title: "delectus aut autem", completed: false) { response in
            result = response
        }

        expect(result?.error).toEventually(equal(TODOAPIClientError.unknownError(code: 418)))
    }

    func testSendsTheRequestToTheCorrectPathDeletingATask() {
        stubRequest("DELETE", "http://jsonplaceholder.typicode.com/todos/1")
            .andReturn(200)

        var result: Result<Void, TODOAPIClientError>?
        apiClient.deleteTaskById("1") { response in
            result = response
        }

        expect(result).toEventuallyNot(beNil())
        expect(result?.error).to(beNil())
    }

    func testReturnsItemNotFoundIfThereIsNoTaskWithIdTheAssociateId() {
        stubRequest("DELETE", "http://jsonplaceholder.typicode.com/todos/1")
            .andReturn(404)

        var result: Result<Void, TODOAPIClientError>?
        apiClient.deleteTaskById("1") { response in
            result = response
        }

        expect(result?.error).toEventually(equal(TODOAPIClientError.itemNotFound))
    }

    func testReturnsNetworkErrorIfThereIsNoConnectionDeletingTask() {
        stubRequest("DELETE", "http://jsonplaceholder.typicode.com/todos/1")
            .andFailWithError(NSError.networkError())

        var result: Result<Void, TODOAPIClientError>?
        apiClient.deleteTaskById("1") { response in
            result = response
        }

        expect(result?.error).toEventually(equal(TODOAPIClientError.networkError))
    }

    func testReturnsUnknownErrorIfThereIsAnyErrorDeletingTask() {
        stubRequest("DELETE", "http://jsonplaceholder.typicode.com/todos/1")
            .andReturn(418)

        var result: Result<Void, TODOAPIClientError>?
        apiClient.deleteTaskById("1") { response in
            result = response
        }

        expect(result?.error).toEventually(equal(TODOAPIClientError.unknownError(code: 418)))
    }

    func testSendsTheExpectedBodyUpdatingATask() {
        stubRequest("PUT", "http://jsonplaceholder.typicode.com/todos/2")
            .withJsonBody(fromJsonFile("updateTaskRequest"))?
            .andReturn(200)?
            .withJsonBody(fromJsonFile("updateTaskResponse"))

        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.updateTask(anyTask) { response in
            result = response
        }

        expect(result).toEventuallyNot(beNil())
    }

    func testParsesTheTaskProperlyUpdatingATask() {
        stubRequest("PUT", "http://jsonplaceholder.typicode.com/todos/\(anyTask.id)")
            .andReturn(200)?
            .withJsonBody(fromJsonFile("updateTaskResponse"))

        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.updateTask(anyTask) { response in
            result = response
        }

        expect(result).toEventuallyNot(beNil())
        assertUpdatedTaskContainsExpectedValues((result?.value)!)
    }

    func testReturnsNetworkErrorIfThereIsNoConnectionUpdatingATask() {
        stubRequest("PUT", "http://jsonplaceholder.typicode.com/todos/\(anyTask.id)")
            .andFailWithError(NSError.networkError())

        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.updateTask(anyTask) { response in
            result = response
        }

        expect(result?.error).toEventually(equal(TODOAPIClientError.networkError))
    }

    func testReturnsItemNotFoundErrorIfThereIsNoTaksToUpdateWithTheUsedId() {
        stubRequest("PUT", "http://jsonplaceholder.typicode.com/todos/\(anyTask.id)")
            .andReturn(404)

        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.updateTask(anyTask) { response in
            result = response
        }

        expect(result?.error).toEventually(equal(TODOAPIClientError.itemNotFound))
    }

    func testReturnsUnknowErrorIfThereIsAnyHandledErrorUpdatingATask() {
        stubRequest("PUT", "http://jsonplaceholder.typicode.com/todos/\(anyTask.id)")
            .andReturn(418)

        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.updateTask(anyTask) { response in
            result = response
        }

        expect(result?.error).toEventually(equal(TODOAPIClientError.unknownError(code: 418)))
    }

    fileprivate func assertTaskContainsExpectedValues(_ task: TaskDTO) {
        expect(task.id).to(equal("1"))
        expect(task.userId).to(equal("1"))
        expect(task.title).to(equal("delectus aut autem"))
        expect(task.completed).to(beFalse())
    }

    fileprivate func assertUpdatedTaskContainsExpectedValues(_ task: TaskDTO) {
        expect(task.id).to(equal("2"))
        expect(task.userId).to(equal("1"))
        expect(task.title).to(equal("Finish this kata"))
        expect(task.completed).to(beTrue())
    }

}
