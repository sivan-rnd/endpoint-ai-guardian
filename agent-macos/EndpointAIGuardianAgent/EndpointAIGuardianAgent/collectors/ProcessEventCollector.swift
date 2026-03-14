//
//  ProcessEventCollector.swift
//  EndpointAIGuardianAgent
//
//  Created by sivan on 13/03/2026.
//

import Foundation

final class ProcessEventCollector: ProcessCollectorProtocol {
    var onEvent: (@Sendable (RawProcessEvent) -> Void)?

    func start() -> CollectorStartResult {
        return .failure(.notImplemented)
    }

    func stop() {
    }
}
