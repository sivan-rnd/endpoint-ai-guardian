//
//  CollectorsFactory.swift
//  EndpointAIGuardianAgent
//
//  Created by sivan on 13/03/2026.
//

import Foundation

final class Factory {
    static func defaultProcessCollector() -> ProcessCollectorProtocol {
        return WorkspaceProcessCollector()
    }
}
