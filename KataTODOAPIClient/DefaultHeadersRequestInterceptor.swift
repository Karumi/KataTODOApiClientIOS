//
//  DefaultHeadersRequestInterceptor.swift
//  KataTODOAPIClient
//
//  Created by Pedro Vicente Gomez on 12/02/16.
//  Copyright © 2016 Karumi. All rights reserved.
//

import Foundation
import BothamNetworking

class DefaultHeadersInterceptor: BothamRequestInterceptor {

    func intercept(_ request: HTTPRequest) -> HTTPRequest {
        return request.appendingHeaders(["Content-Type": "application/json",
            "Accept": "application/json"])
    }

}
