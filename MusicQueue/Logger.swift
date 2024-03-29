//
//  Logger.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-03-14.
//

import Foundation
import os

extension Logger {
    /// Logs a debug message with optional stack trace.
    func debug(_ message: String, includeStackTrace: Bool = false) {
        let finalMessage = includeStackTrace ? messageWithStackTrace(message) : message
        log(level: .debug, "\(finalMessage)")
    }

    /// Logs an error message with optional stack trace.
    func error(_ message: String, includeStackTrace: Bool = true) {
        let finalMessage = includeStackTrace ? messageWithStackTrace(message) : message
        log(level: .error, "\(finalMessage)")
    }

    /// Logs a fault message with stack trace.
    func fault(_ message: String, includeStackTrace: Bool = true) {
        let finalMessage = includeStackTrace ? messageWithStackTrace(message) : message
        log(level: .fault, "\(finalMessage)")
    }

    /// Prepends stack trace to the log message if requested.
    private func messageWithStackTrace(_ message: String) -> String {
        let stackTrace = Thread.callStackSymbols.joined(separator: "\n")
        return "\(message)\nStack Trace:\n\(stackTrace)"
    }
}
