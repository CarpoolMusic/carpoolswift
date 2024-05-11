//
//  Logger.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-03-14.
//

import Foundation
import os

protocol CustomLoggerProtocol {
    /// Logs a debug message with optional stack trace.
    func info(_ message: String)
    
    /// Logs a debug message with optional stack trace.
    func debug(_ message: String)

    /// Logs an error message with optional stack trace.
    func error(_ error: CustomError)
    
    /// Logs an unkown error message with optional stack trace.
    func error(_ message: String)

    /// Logs a fault message with stack trace.
    func fault(_ error: CustomError)
}

extension CustomLoggerProtocol {
    
}

class CustomLogger: CustomLoggerProtocol {
    
    private let _logger = Logger()
    
    /// Logs a debug message with optional stack trace.
    func info(_ message: String) {
        let finalMessage = messageWithStackTrace(message, Thread.callStackSymbols)
        _logger.log(level: .info, "I \(finalMessage)")
    }
    
    /// Logs a debug message with optional stack trace.
    func debug(_ message: String) {
        let finalMessage = messageWithStackTrace(message, Thread.callStackSymbols)
        _logger.log(level: .debug, "D \(finalMessage)")
    }

    /// Logs an error with optional stack trace.
    func error(_ error: CustomError) {
        let finalMessage = messageWithStackTrace(error.message, error.stacktrace)
        _logger.log(level: .error, "X \(finalMessage)")
    }
    
    /// Logs an unkown error with optional stack trace.
    func error(_ message: String) {
        let finalMessage = messageWithStackTrace(message, Thread.callStackSymbols)
        _logger.log(level: .error, "X \(finalMessage)")
    }

    /// Logs a fault message with stack trace.
    func fault(_ error: CustomError) {
        let finalMessage = messageWithStackTrace(error.message, error.stacktrace)
        _logger.log(level: .fault, "F \(finalMessage)")
    }

    /// Prepends stack trace to the log message if requested.
    private func messageWithStackTrace(_ message: String, _ stacktrace: [String]?) -> String {
        let parsedStacktrace = parseStackTrace(stacktrace)
        return "\(message)\nStack Trace:\n\(parsedStacktrace)"
    }
    
    func parseStackTrace(_ stackTrace: [String]?) -> String {
        guard let stackTrace = stackTrace else {
            return "No stack trace available"
        }
        
        var parsedStackTrace = ""
        
        for line in stackTrace {
            let pattern = #"^(\d+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(.+)$"#
            
            if let match = line.range(of: pattern, options: .regularExpression) {
                let components = line[match].components(separatedBy: " ")
                
                if components.count >= 6 {
                    let frameNumber = components[0]
                    let module = components[1]
                    let address = components[2]
                    let symbol = components[4]
                    let extraInfo = components[5...].joined(separator: " ")
                    
                    let formattedLine = "Frame \(frameNumber): \(module) (\(address)) - \(symbol) \(extraInfo)\n"
                    parsedStackTrace += formattedLine
                }
            }
        }
        
        return parsedStackTrace
    }
}
