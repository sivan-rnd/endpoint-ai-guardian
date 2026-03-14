//
//  NormalizedEventModels.swift
//  EndpointAIGuardianAgent
//
//  Created by sivan on 13/03/2026.
//

import Foundation

import Foundation

enum EventTypeEnum: String, Codable {
    case processExec = "process_exec"
    case fileWrite = "file_write"
    case fileOpen = "file_open"
    case networkConnect = "network_connect"
}

struct NormalizedMetaData: Codable {
    let eventId: String
    let eventType: EventTypeEnum
    let timestamp: String
    let hostId: String
    let username: String
    let sessionType: String
    var derived: DerivedInfo
}

struct NormalizedEvent: Codable {
    var metaData: NormalizedMetaData
    var process: ProcessInfo?
    var parent: ParentInfo?
    var file: FileInfo?
    var network: NetworkInfo?
}

struct ProcessInfo: Codable {
    let pid: Int32
    let name: String
    let path: String
    let bundleId: String?
    let isSigned: Bool?
    let signingId: String?
    let teamId: String?
    let firstSeen: Bool?
    let firstSeenAgeDays: Int?
}

struct ParentInfo: Codable {
    let pid: Int32
    let name: String
    let path: String
}

struct DerivedInfo: Codable {
    let hourOfDay: Int
    let dayOfWeek: Int
    let pathBucket: String
    let parentChildSeenBefore: Bool?
    let processFrequency7d: Int?
}

struct FileInfo: Codable {
    let path: String
    let pathBucket: String
    let `extension`: String
    let isSensitivePath: Bool
}

struct NetworkInfo: Codable {
    let destinationHost: String?
    let destinationIP: String
    let destinationPort: Int
    let isLoopback: Bool
    let destinationSeenBefore: Bool?
}

