//
//  main.swift
//  EndpointAIGuardianAgent
//
//  Created by sivan on 13/03/2026.
//

import Foundation

let collector = Factory.defaultProcessCollector()

collector.onEvent = { event in
    print("kind=\(event.kind.rawValue) name=\(event.metadata.processName ?? "unknown") pid=\(event.metadata.processId ?? -1)")
}

switch collector.start() {
case .success:
    print("ProcessCollector started")
    RunLoop.main.run()

case .failure(let error):
    print("Failed to start collector: \(error)")
}

