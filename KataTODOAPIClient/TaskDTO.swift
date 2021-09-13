import Foundation

public struct TaskDTO: Codable, Equatable {
    public let userId: Int
    public let id: Int
    public let title: String
    public let completed: Bool

    public init(userId: Int, id: Int, title: String, completed: Bool) {
        self.userId = userId
        self.id = id
        self.title = title
        self.completed = completed
    }
}
