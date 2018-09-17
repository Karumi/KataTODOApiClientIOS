//: TODOAPIClient Playground

import PlaygroundSupport
import KataTODOAPIClient
import Result

PlaygroundPage.current.needsIndefiniteExecution = true

//: Create a TODOAPIClient instance.
let apiClient = TODOAPIClient()

//: Get all the task already created.
apiClient.getAllTasks { result in
    print(result)
}

//: Get a task using the task id.
apiClient.getTaskById("1") { result in
    print(result)
}

//: Add a new task to a user.
apiClient.addTaskToUser("1", title: "Finish this kata", completed: false) { result in
    print(result)
}

//: Delete a task using the task id.
apiClient.deleteTaskById("1") { result in
    print(result)
}

//: Update a taks.
let taskToUpdate = TaskDTO(userId: "1", id: "2", title: "Finish this kata", completed: false)
apiClient.updateTask(taskToUpdate) { result in
    print(result)
}
