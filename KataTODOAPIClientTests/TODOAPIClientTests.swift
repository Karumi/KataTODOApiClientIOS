import Foundation
import Nimble
import XCTest
import OHHTTPStubs

@testable import KataTODOAPIClient

class TODOAPIClientTests: XCTestCase {
    private let apiClient = TODOAPIClient()
    private let anyTask = TaskDTO(userId: 1, id: 201, title: "Finish this kata", completed: false)
    private let expectedFirstTask = TaskDTO(userId: 1, id: 1, title: "delectus aut autem", completed: false)
    private let expectedAddedTask = TaskDTO(userId: 1, id: 201, title: "Finish this kata", completed: false)
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        HTTPStubs.setEnabled(true)
        HTTPStubs.onStubMissing { request in
            XCTFail("Missing stub for \(request)")
        }
    }

    override func tearDown() {
        HTTPStubs.removeAllStubs()
        HTTPStubs.setEnabled(false)
        super.tearDown()
    }

    func testShouldBeAbleToGetAllTasks() throws {
        stub(condition: isMethodGET() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos")) { _ in
                let stubPath = OHPathForFile("getTasksResponse.json", type(of: self))
                return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type": "application/json"])
        }
     
        let tasks = try apiClient.getAllTasks().get().first!

        expect(tasks.count).to(equal(200))
        expect(tasks.first!).to(equal(expectedFirstTask))
    }

    func testReturnsNetworkErrorIfThereIsNoConnectionGettingAllTasks() throws {
        stub(condition: isMethodGET() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos")) { _ in
                let notConnectedError = NSError(domain: NSURLErrorDomain,
                                                code: URLError.notConnectedToInternet.rawValue)
                return HTTPStubsResponse(error: notConnectedError)
        }

        expect {
            try self.apiClient.getAllTasks().get()
        }.to(throwError(TODOAPIClientError.networkError))
    }

    func testReturnsUnknowErrorIfTheErrorIsNotHandledGettingAllTasks() throws {
        stub(condition: isMethodGET() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos")) { _ in
                return fixture(filePath: "", status: 418, headers: ["Content-Type": "application/json"])
        }

        expect {
            try self.apiClient.getAllTasks().get()
        }.to(throwError(TODOAPIClientError.unknownError(code: 418)))
    }

    func testShouldBeAbleToGetTasksById() throws {
        stub(condition: isMethodGET() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos/1")) { _ in
                let stubPath = OHPathForFile("getTaskByIdResponse.json", type(of: self))
                return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type": "application/json"])
        }
  
        let task = try apiClient.getTaskById(1).get().first!

        expect(task).to(equal(expectedFirstTask))
    }

    func testReturnsItemNotFoundErrorIfTheTaskIdDoesNotExist() throws {
        stub(condition: isMethodGET() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos/1")) { _ in
                return fixture(filePath: "", status: 404, headers: ["Content-Type": "application/json"])
        }

        expect {
            try self.apiClient.getTaskById(1).get()
        }.to(throwError(TODOAPIClientError.itemNotFound))
    }

    func testReturnsNetworkErrorIfThereIsNoConnectionGettingTaskById() throws {
        stub(condition: isMethodGET() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos/1")) { _ in
                let notConnectedError = NSError(domain: NSURLErrorDomain,
                                                code: URLError.notConnectedToInternet.rawValue)
                return HTTPStubsResponse(error: notConnectedError)
        }

        expect {
            try self.apiClient.getTaskById(1).get()
        }.to(throwError(TODOAPIClientError.networkError))
    }

    func testReturnsUnknowErrorIfTheErrorIsNotHandledGettingTasksById() throws {
        stub(condition: isMethodGET() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos/1")) { _ in
                return fixture(filePath: "", status: 418, headers: ["Content-Type": "application/json"])
        }

        expect {
            try self.apiClient.getTaskById(1).get()
        }.to(throwError(TODOAPIClientError.unknownError(code: 418)))
    }

    func testShouldBeAbleToAddANewTask() throws {
        stub(condition: isMethodPOST() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos")) { _ in
                let stubPath = OHPathForFile("addTaskToUserResponse.json", type(of: self))
                return fixture(filePath: stubPath!, status: 201, headers: ["Content-Type": "application/json"])
        }

        let task = try apiClient.addTaskToUser(1, title: "delectus aut autem", completed: false).get().first!

        expect(task).to(equal(expectedAddedTask))
    }

    func testReturnsNetworkErrorIfThereIsNoConnectionAddingATask() throws {
        stub(condition: isMethodPOST() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos")) { _ in
                let notConnectedError = NSError(domain: NSURLErrorDomain,
                                                code: URLError.notConnectedToInternet.rawValue)
                return HTTPStubsResponse(error: notConnectedError)
        }

        expect { try self.apiClient.addTaskToUser(1, title: "delectus aut autem", completed: false).get() }.to(throwError(TODOAPIClientError.networkError))
    }

    func testReturnsUnknowErrorIfThereIsAnyErrorAddingATask() throws {
        stub(condition: isMethodPOST() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos")) { _ in
                return fixture(filePath: "", status: 418, headers: ["Content-Type": "application/json"])
        }

        expect { try self.apiClient.addTaskToUser(1, title: "delectus aut autem", completed: false).get()
        }.to(throwError(TODOAPIClientError.unknownError(code: 418)))
    }

    func testShouldBeAbleToDeleteATask() throws {
        stub(condition: isMethodDELETE() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos/1")) { _ in
                return fixture(filePath: "", status: 200, headers: ["Content-Type": "application/json"])
        }

        let _ = try apiClient.deleteTaskById(1).get()
    }

    func testReturnsItemNotFoundIfThereIsNoTaskWithIdTheAssociateId() {
        stub(condition: isMethodDELETE() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos/1")) { _ in
                return fixture(filePath: "", status: 404, headers: ["Content-Type": "application/json"])
        }

        expect {
            try self.apiClient.deleteTaskById(1).get()
        }.to(throwError(TODOAPIClientError.itemNotFound))
    }

    func testReturnsNetworkErrorIfThereIsNoConnectionDeletingTask() throws {
        stub(condition: isMethodDELETE() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos/1")) { _ in
                let notConnectedError = NSError(domain: NSURLErrorDomain,
                                                code: URLError.notConnectedToInternet.rawValue)
                return HTTPStubsResponse(error: notConnectedError)
        }
        
        expect {
            try self.apiClient.deleteTaskById(1).get()
        }.to(throwError(TODOAPIClientError.networkError))
    }

    func testReturnsUnknownErrorIfThereIsAnyErrorDeletingTask() throws {
        stub(condition: isMethodDELETE() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos/1")) { _ in
                return fixture(filePath: "", status: 418, headers: ["Content-Type": "application/json"])
        }

        expect {
            try self.apiClient.deleteTaskById(1).get()
        }.to(throwError(TODOAPIClientError.unknownError(code: 418)))
    }

    func testShouldBeAbleToUpdateATask() throws {
        stub(condition: isMethodPUT() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos/\(anyTask.id)")) { _ in
                let stubPath = OHPathForFile("updateTaskResponse.json", type(of: self))
                return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type": "application/json"])
        }

        let task = try apiClient.updateTask(anyTask).get().first!

        expect(task).to(equal(anyTask))
    }

    func testReturnsNetworkErrorIfThereIsNoConnectionUpdatingATask() throws {
        stub(condition: isMethodPUT() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos/\(anyTask.id)")) { _ in
                let notConnectedError = NSError(domain: NSURLErrorDomain,
                                                code: URLError.notConnectedToInternet.rawValue)
                return HTTPStubsResponse(error: notConnectedError)
        }

        expect {
            try self.apiClient.updateTask(self.anyTask).get()
        }.to(throwError(TODOAPIClientError.networkError))
    }

    func testReturnsItemNotFoundErrorIfThereIsNoTaksToUpdateWithTheUsedId() throws {
        stub(condition: isMethodPUT() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos/\(anyTask.id)")) { _ in
                return fixture(filePath: "", status: 404, headers: ["Content-Type": "application/json"])
        }

        expect {
            try self.apiClient.updateTask(self.anyTask).get()
        }.to(throwError(TODOAPIClientError.itemNotFound))
    }

    func testReturnsUnknowErrorIfThereIsAnyHandledErrorUpdatingATask() {
        stub(condition: isMethodPUT() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos/\(anyTask.id)")) { _ in
                return fixture(filePath: "",
                               status: 418,
                               headers: ["Content-Type": "application/json"])
        }

        expect {
            try self.apiClient.updateTask(self.anyTask).get()
        }.to(throwError(TODOAPIClientError.unknownError(code: 418)))
    }
}
