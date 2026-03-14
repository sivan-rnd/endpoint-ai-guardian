//
//  DefaultPathBucketer.swift
//  EndpointAIGuardianAgent
//
//  Created by sivan on 13/03/2026.
//

import Foundation

import Foundation

final class PathBucketer: PathBucketingProtocol {

    func bucket(for path: String?) -> String {
        guard let path, !path.isEmpty else {
            return "unknown"
        }

        if path.hasPrefix("/Applications/") {
            return "applications"
        }

        if path.hasPrefix("/System/") {
            return "system"
        }

        if path.hasPrefix("/usr/bin/") || path.hasPrefix("/bin/") || path.hasPrefix("/usr/sbin/") {
            return "system_bin"
        }

        if path.hasPrefix("/usr/local/bin/") {
            return "local_bin"
        }

        if path.contains("/Downloads/") {
            return "downloads"
        }

        if path.hasPrefix("/tmp/") || path.hasPrefix("/private/tmp/") {
            return "tmp"
        }

        if path.contains("/Library/LaunchAgents/") {
            return "launch_agents"
        }

        if path.contains("/Library/LaunchDaemons/") {
            return "launch_daemons"
        }

        if path.contains("/models/") {
            return "models_dir"
        }

        if path.contains("/weights/") {
            return "weights_dir"
        }

        if path.hasSuffix("/.zshrc") || path.hasSuffix("/.bash_profile") || path.hasSuffix("/.bashrc") {
            return "shell_profile"
        }

        if path.hasPrefix("/Users/") {
            return "home_custom"
        }

        return "other"
    }
}
