//
//  TaskDTO.swift
//  KataTODOAPIClient
//
//  Created by Pedro Vicente Gomez on 12/02/16.
//  Copyright © 2016 Karumi. All rights reserved.
//

import Foundation

public struct TaskDTO {

    public let userId: String
    public let id: String
    public let title: String
    public let completed: Bool

    public init(userId: String, id: String, title: String, completed: Bool) {
        self.userId = userId
        self.id = id
        self.title = title
        self.completed = completed
    }

}