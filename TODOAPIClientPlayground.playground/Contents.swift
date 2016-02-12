//: TODOAPIClient Playground

import XCPlayground
import KataTODOAPIClient
import Result

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

let apiClient = TODOAPIClient()

apiClient.getAll { result in
    if let tasks = result.value {
        tasks.forEach {
            print($0)
        }
    }
}

apiClient.getByTaskId("1") { result in
    if let task = result.value {
        print(task)
    }
}