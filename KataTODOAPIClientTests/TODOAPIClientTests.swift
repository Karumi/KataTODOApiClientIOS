//
//  TODOAPIClientTests.swift
//  KataTODOAPIClient
//
//  Created by Pedro Vicente Gomez on 12/02/16.
//  Copyright © 2016 Karumi. All rights reserved.
//
// swiftlint:disable force_try
// swiftlint:disable type_body_length
import Foundation
import Nimble
import XCTest
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
            hasHeaderNamed("Content-Type", value: "application/json") &&
            isPath("/todos")) { _ in
                return fixture(filePath: "", status: 200, headers: ["Accept": "application/json"])
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
                return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type": "application/json"])
        }

        var result: Result<[TaskDTO], TODOAPIClientError>?
        apiClient.getAllTasks { response in
            result = response
        }

        expect { try? result?.get().count }.toEventually(equal(200))
        assertTaskContainsExpectedValues((try! result?.get()[0])!)
    }

    func testReturnsNetworkErrorIfThereIsNoConnectionGettingAllTasks() {
        stub(condition: isMethodGET() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos")) { _ in
                let notConnectedError = NSError(domain: NSURLErrorDomain,
                                                code: URLError.notConnectedToInternet.rawValue)
                return OHHTTPStubsResponse(error: notConnectedError)
        }

        var result: Result<[TaskDTO], TODOAPIClientError>?
        apiClient.getAllTasks { response in
            result = response
        }

        expect { try result?.get() }.toEventually(throwError(TODOAPIClientError.networkError))
    }

    fileprivate func assertTaskContainsExpectedValues(_ task: TaskDTO) {
        expect(task.id).to(equal("1"))
        expect(task.userId).to(equal("1"))
        expect(task.title).to(equal("delectus aut autem"))
        expect(task.completed).to(beFalse())
    }
}
