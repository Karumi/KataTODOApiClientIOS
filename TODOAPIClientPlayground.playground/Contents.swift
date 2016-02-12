//: TODOAPIClient Playground

import XCPlayground
import KataTODOAPIClient
import Result

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

let apiClient = TODOAPIClient()

apiClient.getAll { result in
    print(result)
}

apiClient.getByTaskId("1") { result in
    print(result)
}

apiClient.addTaskToUser("1", title: "Finish this kata", completed: false) { result in
    print(result)
}

apiClient.deleteTaskById("1") { result in
    print(result)
}