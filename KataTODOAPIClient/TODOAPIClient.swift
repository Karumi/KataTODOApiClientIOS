//
//  TODOAPIClient.swift
//  KataTODOAPIClient
//
//  Created by Pedro Vicente Gomez on 12/02/16.
//  Copyright © 2016 Karumi. All rights reserved.
//

import Foundation
import BothamNetworking

public class TODOAPIClient {

    private let botham: BothamAPIClient

    public init() {
        self.botham = BothamAPIClient(baseEndpoint: TODOAPIClientConfig.baseEndpoint)
        self.botham.requestInterceptors.append(DefaultHeadersInterceptor())
    }



}