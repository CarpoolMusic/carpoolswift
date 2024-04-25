import Foundation

// Base Custom Error class with an optional stack trace
class CustomError: NSError {
    
    let type: String
    let message: String
    var stacktrace: [String]?
    
    init(type: String, message: String, stacktrace: [String]? = Thread.callStackSymbols) {
        self.type = type
        self.message = message
        self.stacktrace = stacktrace
        super.init(domain: "com.poles.Carpool", code: 0, userInfo: ["message": message])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toString(includeStackTrace: Bool = true) -> String {
        let stackTraceString = includeStackTrace ? stacktrace?.joined(separator: "\n") ?? "No stack trace" : "Stack trace omitted"
        return "Type: \(type) \nMessage: \(message) \nStack Trace: \(stackTraceString)"
    }
}

// Subclassing CustomError for specific errors with the same optional stack trace functionality
class SocketError: CustomError {
    init(message: String, stacktrace: [String]? = Thread.callStackSymbols) {
        super.init(type: "SocketError", message: message, stacktrace: stacktrace)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomURLError: CustomError {
    init(message: String, stacktrace: [String]? = Thread.callStackSymbols) {
        super.init(type: "URLError", message: message, stacktrace: stacktrace)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class URLSessionError: CustomError {
    init(message: String, stacktrace: [String]? = Thread.callStackSymbols) {
        super.init(type: "EncodingError", message: message, stacktrace: stacktrace)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class EncodingError: CustomError {
    init(message: String, stacktrace: [String]? = Thread.callStackSymbols) {
        super.init(type: "EncodingError", message: message, stacktrace: stacktrace)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SessionManagerError: CustomError {
    init(message: String, stacktrace: [String]? = Thread.callStackSymbols) {
        super.init(type: "SessionManagerError", message: message, stacktrace: stacktrace)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class EventError: CustomError {
    init(message: String, stacktrace: [String]? = Thread.callStackSymbols) {
        super.init(type: "EventError", message: message, stacktrace: stacktrace)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SongConversionError: CustomError {
    init(message: String, stacktrace: [String]? = Thread.callStackSymbols) {
        super.init(type: "SongConversionError", message: message, stacktrace: stacktrace)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SongResolutionError: CustomError {
    init(message: String, stacktrace: [String]? = Thread.callStackSymbols) {
        super.init(type: "SongResolutionError", message: message, stacktrace: stacktrace)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UnknownError: CustomError {
    init(message: String = "An unknown error occurred.", stacktrace: [String]? = Thread.callStackSymbols) {
        super.init(type: "UnknownError", message: message, stacktrace: stacktrace)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UnknownResponseError: CustomError {
    init(message: String, stacktrace: [String]? = Thread.callStackSymbols) {
        super.init(type: "UnknownResponseError", message: message, stacktrace: stacktrace)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class QueueUnderflowError: CustomError {
    init(message: String, stacktrace: [String]? = Thread.callStackSymbols) {
        super.init(type: "QueueUnderflowError", message: message, stacktrace: stacktrace)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SearchError: CustomError {
    init(message: String, stacktrace: [String]? = Thread.callStackSymbols) {
        super.init(type: "SearchError", message: message, stacktrace: stacktrace)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TokenError: CustomError {
    init(message: String, stacktrace: [String]? = Thread.callStackSymbols) {
        super.init(type: "TokenError", message: message, stacktrace: stacktrace)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SerializationError: CustomError {
    init(message: String, stacktrace: [String]? = Thread.callStackSymbols) {
        super.init(type: "SerializationError", message: message, stacktrace: stacktrace)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MediaPlayerError: CustomError {
    init(message: String, stacktrace: [String]? = Thread.callStackSymbols) {
        super.init(type: "MediaPlayerError", message: message, stacktrace: stacktrace)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class APIError: CustomError {
    init(message: String, stacktrace: [String]? = Thread.callStackSymbols) {
        super.init(type: "APIError ", message: message, stacktrace: stacktrace)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UnkownError: CustomError {
    init(stacktrace: [String]? = Thread.callStackSymbols) {
        super.init(type: "MediaPlayerError", message: "Unkown Error", stacktrace: stacktrace)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

