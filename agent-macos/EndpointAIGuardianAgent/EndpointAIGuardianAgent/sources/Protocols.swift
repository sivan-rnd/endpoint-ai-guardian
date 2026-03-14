//
//  collectors.swift
//  EndpointAIGuardianAgent
//
//  Created by sivan on 13/03/2026.
//

import Foundation

enum CollectorError: Error {
    case unknown
    case notImplemented
    case permissionDenied
    case startupFailed(String)
}

enum CollectorStartResult {
    case success
    case failure(CollectorError)
}

protocol CollectorProtocol: AnyObject {
    func start() -> CollectorStartResult
    func stop()
}

protocol ProcessCollectorProtocol: CollectorProtocol {
    var onEvent: (@Sendable (RawProcessEvent) -> Void)? { get set }
}

protocol EventNormalizerProtocol {
    func normalize(rawEvent: RawProcessEvent) -> NormalizedEvent?
    func normalize(rawEvent: RawFileEvent) -> NormalizedEvent?
    func normalize(rawEvent: RawNetworkEvent) -> NormalizedEvent?
}

protocol PathBucketingProtocol {
    func bucket(for path: String?) -> String
}

