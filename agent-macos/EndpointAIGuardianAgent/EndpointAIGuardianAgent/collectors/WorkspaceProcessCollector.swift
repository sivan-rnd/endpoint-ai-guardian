//
//  WorkspaceProcessCollector.swift
//  EndpointAIGuardianAgent
//
//  Created by sivan on 13/03/2026.
//

import Foundation
import AppKit

final class WorkspaceProcessCollector: ProcessCollectorProtocol {

    var onEvent: (@Sendable (RawProcessEvent) -> Void)?

    private let workspace: NSWorkspace
    private let notificationCenter: NotificationCenter

    private var launchObserver: NSObjectProtocol?
    private var terminateObserver: NSObjectProtocol?

    private var isRunning = false

    init(
        workspace: NSWorkspace = .shared,
        notificationCenter: NotificationCenter = NSWorkspace.shared.notificationCenter
    ) {
        self.workspace = workspace
        self.notificationCenter = notificationCenter
    }

    deinit {
        stop()
    }

    func start() -> CollectorStartResult {
        guard !isRunning else {
            return .success
        }

        emitStartupSnapshot()

        launchObserver = notificationCenter.addObserver(
            forName: NSWorkspace.didLaunchApplicationNotification,
            object: workspace,
            queue: nil
        ) { [weak self] notification in
            self?.handleWorkspaceNotification(notification, kind: .launch)
        }

        terminateObserver = notificationCenter.addObserver(
            forName: NSWorkspace.didTerminateApplicationNotification,
            object: workspace,
            queue: nil
        ) { [weak self] notification in
            self?.handleWorkspaceNotification(notification, kind: .terminate)
        }

        isRunning = true
        return .success
    }

    func stop() {
        if let launchObserver {
            notificationCenter.removeObserver(launchObserver)
            self.launchObserver = nil
        }

        if let terminateObserver {
            notificationCenter.removeObserver(terminateObserver)
            self.terminateObserver = nil
        }

        isRunning = false
    }

    // MARK: - Startup

    private func emitStartupSnapshot() {
        for app in workspace.runningApplications {
            guard let event = makeRawProcessEvent(from: app, kind: .launch) else {
                continue
            }
            onEvent?(event)
        }
    }

    // MARK: - Notifications

    private func handleWorkspaceNotification(
        _ notification: Notification,
        kind: RawProcessEvent.Kind
    ) {
        guard
            let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
            let event = makeRawProcessEvent(from: app, kind: kind)
        else {
            return
        }

        onEvent?(event)
    }

    // MARK: - Mapping

    private func makeRawProcessEvent(
        from app: NSRunningApplication,
        kind: RawProcessEvent.Kind
    ) -> RawProcessEvent? {
        let executablePath = app.executableURL?.path
        let processName = app.localizedName
            ?? executablePath.flatMap { URL(fileURLWithPath: $0).lastPathComponent }

        guard let processName else {
            return nil
        }

        let metadata = RawEventMetadata(
            uuid: UUID(),
            timestamp: Date(),
            source: .workspace,
            processId: app.processIdentifier,
            parentProcessId: nil,
            processName: processName,
            executablePath: executablePath,
            bundleId: app.bundleIdentifier,
            username: NSUserName(),
            sessionType: .interactive
        )

        return RawProcessEvent(
            metadata: metadata,
            kind: kind
        )
    }
}
