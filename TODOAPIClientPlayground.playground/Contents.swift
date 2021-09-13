//: TODOAPIClient Playground

import Combine
import KataTODOAPIClient
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//: Create a TODOAPIClient instance.
let apiClient = TODOAPIClient()
var subscriptions = Set<AnyCancellable>()
//: Get all the task already created.
apiClient.getAllTasks().sink(
    receiveCompletion: { _ in },
    receiveValue: { print("Got all tasks: \($0.count) tasks") }
).store(in: &subscriptions)

//: Get a task using the task id.
apiClient.getTaskById(1).sink(
    receiveCompletion: { _ in },
    receiveValue: { print("Got task by id: \($0)") }
).store(in: &subscriptions)

//: Add a new task to a user.
apiClient.addTaskToUser(1, title: "Finish this kata", completed: false).sink(
    receiveCompletion: { _ in },
    receiveValue: { print("Added task to user: \($0)") }
).store(in: &subscriptions)

//: Delete a task using the task id.
apiClient.deleteTaskById(1).sink(
    receiveCompletion: { _ in },
    receiveValue: { print("Deleted task: id 1") }
).store(in: &subscriptions)

//: Update a taks.
let taskToUpdate = TaskDTO(userId: 1, id: 2, title: "Finish this kata", completed: false)
apiClient.updateTask(taskToUpdate).sink(
    receiveCompletion: { _ in },
    receiveValue: { print("Updated task: \($0)") }
).store(in: &subscriptions)
