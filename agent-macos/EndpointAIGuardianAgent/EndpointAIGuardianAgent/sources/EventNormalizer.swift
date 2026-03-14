//
//  EventNormalizer.swift
//  EndpointAIGuardianAgent
//
//  Created by sivan on 13/03/2026.
//

import Foundation

final class EventNormalizer: EventNormalizerProtocol {

    private let pathBucketer: PathBucketingProtocol
    private let isoFormatter: ISO8601DateFormatter

    init(pathBucketer: PathBucketingProtocol) {
        self.pathBucketer = pathBucketer
        self.isoFormatter = ISO8601DateFormatter()
        self.isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    }

    func normalize(rawEvent: RawProcessEvent) -> NormalizedEvent? {
        guard let metaData = normalizedMetaData(from: rawEvent.metadata, eventType: .processExec) else {
            return nil
        }
        
        let processPath = rawEvent.metadata.executablePath ?? "unknown"
        let processName = rawEvent.metadata.processName ?? "unknown"

        let processInfo = ProcessInfo(
            pid: rawEvent.metadata.processId ?? -1,
            name: processName,
            path: processPath,
            bundleId: rawEvent.metadata.bundleId,
            isSigned: nil,
            signingId: nil,
            teamId: nil,
            firstSeen: nil,
            firstSeenAgeDays: nil
        )

        let parentInfo: ParentInfo? = {
            guard let parentPid = rawEvent.metadata.parentProcessId else {
                return nil
            }

            return ParentInfo(
                pid: parentPid,
                name: "unknown",
                path: "unknown"
            )
        }()
        
        return NormalizedEvent(
            metaData: metaData,
            process: processInfo,
            parent: parentInfo,
            file: nil,
            network: nil
        )
    }

    func normalize(rawEvent: RawFileEvent) -> NormalizedEvent? {
        return nil
    }

    func normalize(rawEvent: RawNetworkEvent) -> NormalizedEvent? {
        return nil
    }
    
    
    private func normalizedMetaData(from metadata: RawEventMetadata, eventType: EventTypeEnum) -> NormalizedMetaData? {
        let calendar = Calendar(identifier: .gregorian)

        let hour = calendar.component(.hour, from: metadata.timestamp)
        let weekday = calendar.component(.weekday, from: metadata.timestamp)

        let derived = DerivedInfo(
            hourOfDay: hour,
            dayOfWeek: weekday,
            pathBucket: pathBucketer.bucket(for: metadata.executablePath),
            parentChildSeenBefore: nil,
            processFrequency7d: nil
        )

      return NormalizedMetaData (
            eventId: UUID().uuidString,
            eventType: eventType,
            timestamp: isoFormatter.string(from: metadata.timestamp),
            hostId: Host.current().localizedName ?? "unknown-host",
            username: metadata.username ?? NSUserName(),
            sessionType: metadata.sessionType.rawValue,
            derived: derived
        )
    }
}

