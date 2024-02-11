//
//  Error.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-01-20.
//

import Foundation

class CustomError: NSError {
    
    let type: String
    let message: String
    let stacktrace: [String]
    
    init(type: String, message: String, stacktrace: [String]) {
        self.type = type
        self.message = message
        self.stacktrace = stacktrace
        
        super.init(domain: "com.poles.Carpool", code: 0, userInfo: ["message": message])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toString() -> String {
        let stacktracestring = stacktrace.joined(separator: "\n")
        return "Type: \(type) \nMessage: \(message) \nstacktrace: \(stacktracestring)"
    }
}

class SocketError: CustomError  {
    
    init(message: String, stacktrace: [String]) {
        super.init(type: "SocketError", message: message, stacktrace: stacktrace)
    }
    
    override func toString() -> String {
        super.toString()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class EventError: CustomError {
    init(message: String, stacktrace: [String]) {
        super.init(type: "EventError", message: message, stacktrace: stacktrace)
    }
    
    override func toString() -> String {
        super.toString()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SongConversionError: CustomError {
    init(message: String, stacktrace: [String]) {
        super.init(type: "SongConversionError", message: message , stacktrace: stacktrace)
    }
    
    override func toString() -> String {
        super.toString()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SongResolutionError: CustomError {
    init(message: String, stacktrace: [String]) {
        super.init(type: "SongResolutionError", message: message, stacktrace: stacktrace)
    }
    
    override func toString() -> String {
        super.toString()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UnkownError: CustomError {
    init(stacktrace: [String]) {
        super.init(type: "UnkownError", message: "", stacktrace: stacktrace)
    }
    
    override func toString() -> String {
        super.toString()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class UnknownResponseError: CustomError {
    init(message: String, stacktrace: [String]) {
        super.init(type: "UnknownResponseError", message: message, stacktrace: stacktrace)
    }
    
    override func toString() -> String {
        super.toString()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class QueueUnderflowError: CustomError {
    init(message: String, stacktrace: [String]) {
        super.init(type: "QueueUnderflowError", message: message, stacktrace: stacktrace)
    }
    
    override func toString() -> String {
        super.toString()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SearchError: CustomError {
    init(message: String, stacktrace: [String]) {
        super.init(type: "SearchError", message: message, stacktrace: stacktrace)
    }
    
    override func toString() -> String {
        super.toString()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TokenError: CustomError {
    init(message: String, stacktrace: [String]) {
        super.init(type: "TokenError", message: message, stacktrace: stacktrace)
    }
    
    override func toString() -> String {
        super.toString()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SerializationError: CustomError {
    init(message: String, stacktrace: [String]) {
        super.init(type: "SerializationError", message: message, stacktrace: stacktrace)
    }
    
    override func toString() -> String {
        super.toString()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MediaPlayerError: CustomError {
    init(message: String, stacktrace: [String]) {
        super.init(type: "MediaPlayerError", message: message, stacktrace: stacktrace)
    }
    
    override func toString() -> String {
        super.toString()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
