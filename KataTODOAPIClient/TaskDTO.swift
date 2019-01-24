//
//  TaskDTO.swift
//  KataTODOAPIClient
//
//  Created by Pedro Vicente Gomez on 12/02/16.
//  Copyright © 2016 Karumi. All rights reserved.
//

import Foundation

public struct TaskDTO: Codable {
    public let userId: String
    public let id: String
    public let title: String
    public let completed: Bool
}
