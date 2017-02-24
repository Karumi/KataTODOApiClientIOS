//
//  TaskDTOParser.swift
//  KataTODOAPIClient
//
//  Created by Pedro Vicente Gomez on 12/02/16.
//  Copyright © 2016 Karumi. All rights reserved.
//

import Foundation
import SwiftyJSON

class TaskDTOJSONParser {

    func fromJSON(_ json: JSON) -> [TaskDTO] {
        return json.arrayValue.map { fromJSON($0) }
    }

    func fromJSON(_ json: JSON) -> TaskDTO {
        return TaskDTO(userId: json["userId"].stringValue,
            id: json["id"].stringValue,
            title: json["title"].stringValue,
            completed: json["completed"].boolValue)
    }

}
