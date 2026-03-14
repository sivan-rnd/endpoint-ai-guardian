//
//  RawEventModels.swift
//  EndpointAIGuardianAgent
//
//  Created by sivan on 13/03/2026.
//

import Foundation

enum RawEventSource: String, Codable {
    case endpointSecurity = "endpoint_security"
    case workspace = "workspace"
    case fsevents = "fsevents"
    case networkExtension = "network_extension"
    case unknown = "unknown"
}

enum RawSessionType: String, Codable {
    case interactive
    case background
    case unknown
}

struct RawEventMetadata: Codable {
    let uuid: UUID
    let timestamp: Date
    let source: RawEventSource

    let processId: Int32?
    let parentProcessId: Int32?

    let processName: String?
    let executablePath: String?
    let bundleId: String?

    let username: String?
    let sessionType: RawSessionType
}

protocol RawEvent {
    var metadata: RawEventMetadata { get }
}

struct RawProcessEvent: RawEvent, Codable {
    enum Kind: String, Codable {
        case exec
        case launch
        case terminate
        case fork
        case unknown
    }

    let metadata: RawEventMetadata
    let kind: Kind
}

struct RawFileEvent: RawEvent, Codable {
    enum Kind: String, Codable {
        case open
        case write
        case create
        case delete
        case rename
        case unknown
    }

    let metadata: RawEventMetadata
    let kind: Kind
    let filePath: String
}

struct RawNetworkEvent: RawEvent, Codable {
    enum Kind: String, Codable {
        case connect
        case disconnect
        case listen
        case unknown
    }

    let metadata: RawEventMetadata
    let kind: Kind
    let destinationHost: String?
    let destinationIP: String?
    let destinationPort: Int?
    let isLoopback: Bool?
}
