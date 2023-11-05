// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let socketEventSchema = try SocketEventSchema(json)

import Foundation

// MARK: - SocketEventSchema
struct SocketEventSchema: Codable {
    let createSessionRequest: CreateSessionRequest
    let createSessionResponse: CreateSessionResponse
    let joinSessionRequest: JoinSessionRequest
    let joinSessionResponse: JoinSessionResponse
    let errorResponse: ErrorResponse
    let request: Request
    let response: Response

    enum CodingKeys: String, CodingKey {
        case createSessionRequest = "CreateSessionRequest"
        case createSessionResponse = "CreateSessionResponse"
        case joinSessionRequest = "JoinSessionRequest"
        case joinSessionResponse = "JoinSessionResponse"
        case errorResponse = "ErrorResponse"
        case request = "Request"
        case response = "Response"
    }
}

// MARK: SocketEventSchema convenience initializers and mutators

extension SocketEventSchema {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SocketEventSchema.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        createSessionRequest: CreateSessionRequest? = nil,
        createSessionResponse: CreateSessionResponse? = nil,
        joinSessionRequest: JoinSessionRequest? = nil,
        joinSessionResponse: JoinSessionResponse? = nil,
        errorResponse: ErrorResponse? = nil,
        request: Request? = nil,
        response: Response? = nil
    ) -> SocketEventSchema {
        return SocketEventSchema(
            createSessionRequest: createSessionRequest ?? self.createSessionRequest,
            createSessionResponse: createSessionResponse ?? self.createSessionResponse,
            joinSessionRequest: joinSessionRequest ?? self.joinSessionRequest,
            joinSessionResponse: joinSessionResponse ?? self.joinSessionResponse,
            errorResponse: errorResponse ?? self.errorResponse,
            request: request ?? self.request,
            response: response ?? self.response
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - CreateSessionRequest
struct CreateSessionRequest: Codable {
    let hostID, sessionName: String

    enum CodingKeys: String, CodingKey {
        case hostID = "hostId"
        case sessionName
    }
}

// MARK: CreateSessionRequest convenience initializers and mutators

extension CreateSessionRequest {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CreateSessionRequest.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        hostID: String? = nil,
        sessionName: String? = nil
    ) -> CreateSessionRequest {
        return CreateSessionRequest(
            hostID: hostID ?? self.hostID,
            sessionName: sessionName ?? self.sessionName
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - CreateSessionResponse
struct CreateSessionResponse: Codable {
    let sessionID: String

    enum CodingKeys: String, CodingKey {
        case sessionID = "sessionId"
    }
}

// MARK: CreateSessionResponse convenience initializers and mutators

extension CreateSessionResponse {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CreateSessionResponse.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        sessionID: String? = nil
    ) -> CreateSessionResponse {
        return CreateSessionResponse(
            sessionID: sessionID ?? self.sessionID
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - ErrorResponse
struct ErrorResponse: Codable {
    let type, message, stackTrace: String

    enum CodingKeys: String, CodingKey {
        case type, message
        case stackTrace = "stack_trace"
    }
}

// MARK: ErrorResponse convenience initializers and mutators

extension ErrorResponse {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ErrorResponse.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        type: String? = nil,
        message: String? = nil,
        stackTrace: String? = nil
    ) -> ErrorResponse {
        return ErrorResponse(
            type: type ?? self.type,
            message: message ?? self.message,
            stackTrace: stackTrace ?? self.stackTrace
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - JoinSessionRequest
struct JoinSessionRequest: Codable {
    let sessionID, userID: String

    enum CodingKeys: String, CodingKey {
        case sessionID = "sessionId"
        case userID = "userId"
    }
}

// MARK: JoinSessionRequest convenience initializers and mutators

extension JoinSessionRequest {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(JoinSessionRequest.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        sessionID: String? = nil,
        userID: String? = nil
    ) -> JoinSessionRequest {
        return JoinSessionRequest(
            sessionID: sessionID ?? self.sessionID,
            userID: userID ?? self.userID
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - JoinSessionResponse
struct JoinSessionResponse: Codable {
    let users: [User]
}

// MARK: JoinSessionResponse convenience initializers and mutators

extension JoinSessionResponse {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(JoinSessionResponse.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        users: [User]? = nil
    ) -> JoinSessionResponse {
        return JoinSessionResponse(
            users: users ?? self.users
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - User
struct User: Codable {
    let socketID, userID: String

    enum CodingKeys: String, CodingKey {
        case socketID = "socketId"
        case userID = "userId"
    }
}

// MARK: User convenience initializers and mutators

extension User {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(User.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        socketID: String? = nil,
        userID: String? = nil
    ) -> User {
        return User(
            socketID: socketID ?? self.socketID,
            userID: userID ?? self.userID
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Request
struct Request: Codable {
    let oneOf: [OneOf]
}

// MARK: Request convenience initializers and mutators

extension Request {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Request.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        oneOf: [OneOf]? = nil
    ) -> Request {
        return Request(
            oneOf: oneOf ?? self.oneOf
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - OneOf
struct OneOf: Codable {
    let ref: String

    enum CodingKeys: String, CodingKey {
        case ref = "$ref"
    }
}

// MARK: OneOf convenience initializers and mutators

extension OneOf {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(OneOf.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        ref: String? = nil
    ) -> OneOf {
        return OneOf(
            ref: ref ?? self.ref
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Response
struct Response: Codable {
    let status: Status
    let oneOf: [OneOf]
}

// MARK: Response convenience initializers and mutators

extension Response {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Response.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        status: Status? = nil,
        oneOf: [OneOf]? = nil
    ) -> Response {
        return Response(
            status: status ?? self.status,
            oneOf: oneOf ?? self.oneOf
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Status
struct Status: Codable {
    let type: String
}

// MARK: Status convenience initializers and mutators

extension Status {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Status.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        type: String? = nil
    ) -> Status {
        return Status(
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
