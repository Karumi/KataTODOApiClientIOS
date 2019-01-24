//
//  TODOAPIClientTests.swift
//  KataTODOAPIClient
//
//  Created by Pedro Vicente Gomez on 12/02/16.
//  Copyright © 2016 Karumi. All rights reserved.
//

import Foundation
import Nimble
import XCTest
import Result
import OHHTTPStubs
@testable import KataTODOAPIClient

class TODOAPIClientTests: XCTestCase {

    override func setUp() {
        super.setUp()
        OHHTTPStubs.onStubMissing { request in
            XCTFail("Missing stub for \(request)")
        }
    }

    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }

    fileprivate let apiClient = TODOAPIClient()
    fileprivate let anyTask = TaskDTO(userId: "1", id: "2", title: "Finish this kata", completed: true)

    func testSendsContentTypeHeader() {
        stub(condition: isMethodGET() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos")) { _ in
                return fixture(filePath: "", status: 200, headers: ["Content-Type":"application/json"])
        }

        var result: Result<[TaskDTO], TODOAPIClientError>?
        apiClient.getAllTasks { response in
            result = response
        }

        expect(result).toEventuallyNot(beNil())
    }

    func testParsesTasksProperlyGettingAllTheTasks() {
        stub(condition: isMethodGET() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos")) { _ in
                let stubPath = OHPathForFile("getTasksResponse.json", type(of: self))
                return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type":"application/json"])
        }

        var result: Result<[TaskDTO], TODOAPIClientError>?
        apiClient.getAllTasks { response in
            result = response
        }

        expect(result?.value?.count).toEventually(equal(200))
        assertTaskContainsExpectedValues((result?.value?[0])!)
    }

    func testReturnsNetworkErrorIfThereIsNoConnectionGettingAllTasks() {
        stub(condition: isMethodGET() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos")) { _ in
                let notConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue)
                return OHHTTPStubsResponse(error:notConnectedError)
        }

        var result: Result<[TaskDTO], TODOAPIClientError>?
        apiClient.getAllTasks { response in
            result = response
        }

        expect(result?.error).toEventually(equal(TODOAPIClientError.networkError))
    }

    func testReturnsUnknowErrorIfTheErrorIsNotHandledGettingAllTasks() {
        stub(condition: isMethodGET() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos")) { _ in
                return fixture(filePath: "", status: 418, headers: ["Content-Type":"application/json"])
        }

        var result: Result<[TaskDTO], TODOAPIClientError>?
        apiClient.getAllTasks { response in
            result = response
        }

        expect(result?.error).toEventually(equal(TODOAPIClientError.unknownError(code: 418)))
    }

    func testParsesTaskProperlyGettingTaskById() {
        stub(condition: isMethodGET() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos/1")) { _ in
                let stubPath = OHPathForFile("getTaskByIdResponse.json", type(of: self))
                return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type":"application/json"])
        }

        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.getTaskById("1") { response in
            result = response
        }

        expect(result).toEventuallyNot(beNil())
        assertTaskContainsExpectedValues((result?.value)!)
    }

    func testReturnsItemNotFoundErrorIfTheTaskIdDoesNotExist() {
        stub(condition: isMethodGET() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos/1")) { _ in
                return fixture(filePath: "", status: 404, headers: ["Content-Type":"application/json"])
        }

        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.getTaskById("1") { response in
            result = response
        }

        expect(result?.error).toEventually(equal(TODOAPIClientError.itemNotFound))
    }

    func testReturnsNetworkErrorIfThereIsNoConnectionGettingTaskById() {
        stub(condition: isMethodGET() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos/1")) { _ in
                let notConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue)
                return OHHTTPStubsResponse(error:notConnectedError)
        }

        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.getTaskById("1") { response in
            result = response
        }

        expect(result?.error).toEventually(equal(TODOAPIClientError.networkError))
    }

    func testReturnsUnknowErrorIfTheErrorIsNotHandledGettingTasksById() {
        stub(condition: isMethodGET() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos/1")) { _ in
                return fixture(filePath: "", status: 418, headers: ["Content-Type":"application/json"])
        }

        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.getTaskById("1") { response in
            result = response
        }

        expect(result?.error).toEventually(equal(TODOAPIClientError.unknownError(code: 418)))
    }

    func testSendsTheCorrectBodyAddingANewTask() {
        stub(condition: isMethodPOST() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos") &&
            hasJsonBody(["userId": "1",
                         "title": "Finish this kata",
                         "completed": false])) { _ in
                            let stubPath = OHPathForFile("addTaskToUserResponse.json", type(of: self))
                            return fixture(filePath: stubPath!, status: 201, headers: ["Content-Type":"application/json"])
        }

        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.addTaskToUser("1", title: "Finish this kata", completed: false) { response in
            result = response
        }

        expect(result).toEventuallyNot(beNil())
        expect(result?.error).toEventually(beNil())
    }

    func testParsesTheTaskCreatedProperlyAddingANewTask() {
        stub(condition: isMethodPOST() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos")) { _ in
                let stubPath = OHPathForFile("addTaskToUserResponse.json", type(of: self))
                return fixture(filePath: stubPath!, status: 201, headers: ["Content-Type":"application/json"])
        }

        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.addTaskToUser("1", title: "delectus aut autem", completed: false) { response in
            result = response
        }

        expect(result).toEventuallyNot(beNil())
        assertTaskContainsExpectedValues((result?.value)!)
    }

    func testReturnsNetworkErrorIfThereIsNoConnectionAddingATask() {
        stub(condition: isMethodPOST() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos")) { _ in
                let notConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue)
                return OHHTTPStubsResponse(error:notConnectedError)
        }

        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.addTaskToUser("1", title: "delectus aut autem", completed: false) { response in
            result = response
        }

        expect(result?.error).toEventually(equal(TODOAPIClientError.networkError))
    }

    func testReturnsUnknowErrorIfThereIsAnyErrorAddingATask() {
        stub(condition: isMethodPOST() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos")) { _ in
                return fixture(filePath: "", status: 418, headers: ["Content-Type":"application/json"])
        }

        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.addTaskToUser("1", title: "delectus aut autem", completed: false) { response in
            result = response
        }

        expect(result?.error).toEventually(equal(TODOAPIClientError.unknownError(code: 418)))
    }
    //
    //    func testSendsTheRequestToTheCorrectPathDeletingATask() {
    //        _ = stubRequest("DELETE", "http://jsonplaceholder.typicode.com/todos/1")
    //            .andReturn(200)
    //
    //        var result: Result<Void, TODOAPIClientError>?
    //        apiClient.deleteTaskById("1") { response in
    //            result = response
    //        }
    //
    //        expect(result).toEventuallyNot(beNil())
    //        expect(result?.error).to(beNil())
    //    }
    //
    //    func testReturnsItemNotFoundIfThereIsNoTaskWithIdTheAssociateId() {
    //        _ = stubRequest("DELETE", "http://jsonplaceholder.typicode.com/todos/1")
    //            .andReturn(404)
    //
    //        var result: Result<Void, TODOAPIClientError>?
    //        apiClient.deleteTaskById("1") { response in
    //            result = response
    //        }
    //
    //        expect(result?.error).toEventually(equal(TODOAPIClientError.itemNotFound))
    //    }
    //
    func testReturnsNetworkErrorIfThereIsNoConnectionDeletingTask() {
        stub(condition: isMethodDELETE() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos/1")) { _ in
                let notConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue)
                return OHHTTPStubsResponse(error:notConnectedError)
        }

        var result: Result<Void, TODOAPIClientError>?
        apiClient.deleteTaskById("1") { response in
            result = response
        }

        expect(result?.error).toEventually(equal(TODOAPIClientError.networkError))
    }

    func testReturnsUnknownErrorIfThereIsAnyErrorDeletingTask() {
        stub(condition: isMethodDELETE() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos/1")) { _ in
                return fixture(filePath: "", status: 418, headers: ["Content-Type":"application/json"])
        }

        var result: Result<Void, TODOAPIClientError>?
        apiClient.deleteTaskById("1") { response in
            result = response
        }

        expect(result?.error).toEventually(equal(TODOAPIClientError.unknownError(code: 418)))
    }

    func testSendsTheExpectedBodyUpdatingATask() {
        stub(condition: isMethodPUT() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos/2") &&
            hasJsonBody(["id": "2",
                         "userId": "1",
                         "title": "Finish this kata",
                         "completed": true])) { _ in
                            let stubPath = OHPathForFile("updateTaskResponse.json", type(of: self))
                            return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type":"application/json"])
        }

        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.updateTask(anyTask) { response in
            result = response
        }

        expect(result).toEventuallyNot(beNil())
    }
    //
    //    func testParsesTheTaskProperlyUpdatingATask() {
    //        _ = stubRequest("PUT", "http://jsonplaceholder.typicode.com/todos/\(anyTask.id)")
    //            .andReturn(200)?
    //            .withBody(fromJsonFile("updateTaskResponse"))
    //
    //        var result: Result<TaskDTO, TODOAPIClientError>?
    //        apiClient.updateTask(anyTask) { response in
    //            result = response
    //        }
    //
    //        expect(result).toEventuallyNot(beNil())
    //        assertUpdatedTaskContainsExpectedValues((result?.value)!)
    //    }
    //
    func testReturnsNetworkErrorIfThereIsNoConnectionUpdatingATask() {
        stub(condition: isMethodPUT() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos/\(anyTask.id)")) { _ in
                let notConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue)
                return OHHTTPStubsResponse(error:notConnectedError)
        }

        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.updateTask(anyTask) { response in
            result = response
        }

        expect(result?.error).toEventually(equal(TODOAPIClientError.networkError))
    }
    //
    //    func testReturnsItemNotFoundErrorIfThereIsNoTaksToUpdateWithTheUsedId() {
    //        _ = stubRequest("PUT", "http://jsonplaceholder.typicode.com/todos/\(anyTask.id)")
    //            .andReturn(404)
    //
    //        var result: Result<TaskDTO, TODOAPIClientError>?
    //        apiClient.updateTask(anyTask) { response in
    //            result = response
    //        }
    //
    //        expect(result?.error).toEventually(equal(TODOAPIClientError.itemNotFound))
    //    }
    //
    //    func testReturnsUnknowErrorIfThereIsAnyHandledErrorUpdatingATask() {
    //        _ = stubRequest("PUT", "http://jsonplaceholder.typicode.com/todos/\(anyTask.id)")
    //            .andReturn(418)
    //
    //        var result: Result<TaskDTO, TODOAPIClientError>?
    //        apiClient.updateTask(anyTask) { response in
    //            result = response
    //        }
    //
    //        expect(result?.error).toEventually(equal(TODOAPIClientError.unknownError(code: 418)))
    //    }

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


