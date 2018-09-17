//
//  LSStubResponseDSL+Json.swift
//  KataTODOAPIClient
//
//  Created by Sergio Gutiérrez on 28/07/2017.
//  Copyright © 2017 Karumi. All rights reserved.
//

import Foundation
import Nocilla
import SwiftyJSON

extension LSStubResponseDSL {
    open func withJsonBody(_ jsonString: NSString) -> LSStubResponseDSL? {
        let normalizedJsonString = JSON(jsonString).rawString()!
        return self.withBody(NSString(string: normalizedJsonString))
    }
}
