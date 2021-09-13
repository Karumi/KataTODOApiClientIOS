// swiftlint:disable force_try
// swiftlint:disable type_body_length
import Foundation
import Nimble
import XCTest
import OHHTTPStubs

@testable import KataTODOAPIClient

class TODOAPIClientTests: XCTestCase {
    private let apiClient = TODOAPIClient()
    private let anyTask = TaskDTO(userId: 1, id: 2, title: "Finish this kata", completed: true)
    
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

    func testParsesTasksProperlyGettingAllTheTasks() throws {
        stub(condition: isMethodGET() &&
            isHost("jsonplaceholder.typicode.com") &&
            isPath("/todos")) { _ in
                let stubPath = OHPathForFile("getTasksResponse.json", type(of: self))
                return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type": "application/json"])
        }

        let tasks = try apiClient.getAllTasks().get().first!

        expect(tasks.count).to(equal(200))
        assertTaskContainsExpectedValues(tasks.first!)
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

    fileprivate func assertTaskContainsExpectedValues(_ task: TaskDTO) {
        expect(task.id).to(equal(1))
        expect(task.userId).to(equal(1))
        expect(task.title).to(equal("delectus aut autem"))
        expect(task.completed).to(beFalse())
    }
}
