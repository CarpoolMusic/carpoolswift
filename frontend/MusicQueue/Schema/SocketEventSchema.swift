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
    let songObj: Song
    let addSongRequest: AddSongRequest
    let songAddedEvent: SongAddedEvent
    let voteSongRequest: VoteSongRequest
    let voteSongEvent: VoteSongEvent
    let errorResponse: ErrorResponse

    enum CodingKeys: String, CodingKey {
        case createSessionRequest = "CreateSessionRequest"
        case createSessionResponse = "CreateSessionResponse"
        case joinSessionRequest = "JoinSessionRequest"
        case joinSessionResponse = "JoinSessionResponse"
        case songObj = "SongObj"
        case addSongRequest = "AddSongRequest"
        case songAddedEvent = "SongAddedEvent"
        case voteSongRequest = "VoteSongRequest"
        case voteSongEvent = "VoteSongEvent"
        case errorResponse = "ErrorResponse"
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
        songObj: Song? = nil,
        addSongRequest: AddSongRequest? = nil,
        songAddedEvent: SongAddedEvent? = nil,
        voteSongRequest: VoteSongRequest? = nil,
        voteSongEvent: VoteSongEvent? = nil,
        errorResponse: ErrorResponse? = nil
    ) -> SocketEventSchema {
        return SocketEventSchema(
            createSessionRequest: createSessionRequest ?? self.createSessionRequest,
            createSessionResponse: createSessionResponse ?? self.createSessionResponse,
            joinSessionRequest: joinSessionRequest ?? self.joinSessionRequest,
            joinSessionResponse: joinSessionResponse ?? self.joinSessionResponse,
            songObj: songObj ?? self.songObj,
            addSongRequest: addSongRequest ?? self.addSongRequest,
            songAddedEvent: songAddedEvent ?? self.songAddedEvent,
            voteSongRequest: voteSongRequest ?? self.voteSongRequest,
            voteSongEvent: voteSongEvent ?? self.voteSongEvent,
            errorResponse: errorResponse ?? self.errorResponse
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - AddSongRequest
struct AddSongRequest: Codable {
    let sessionID: String
    let song: Song

    enum CodingKeys: String, CodingKey {
        case sessionID = "sessionId"
        case song
    }
}

// MARK: AddSongRequest convenience initializers and mutators

extension AddSongRequest {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AddSongRequest.self, from: data)
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
        song: Song? = nil
    ) -> AddSongRequest {
        return AddSongRequest(
            sessionID: sessionID ?? self.sessionID,
            song: song ?? self.song
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Song
struct Song: Codable {
    let service, id, uri, title: String
    let artist, album: String
    let votes: Int
}

// MARK: Song convenience initializers and mutators

extension Song {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Song.self, from: data)
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
        service: String? = nil,
        id: String? = nil,
        uri: String? = nil,
        title: String? = nil,
        artist: String? = nil,
        album: String? = nil,
        votes: Int? = nil
    ) -> Song {
        return Song(
            service: service ?? self.service,
            id: id ?? self.id,
            uri: uri ?? self.uri,
            title: title ?? self.title,
            artist: artist ?? self.artist,
            album: album ?? self.album,
            votes: votes ?? self.votes
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

// MARK: - SongAddedEvent
struct SongAddedEvent: Codable {
    let song: Song
}

// MARK: SongAddedEvent convenience initializers and mutators

extension SongAddedEvent {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SongAddedEvent.self, from: data)
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
        song: Song? = nil
    ) -> SongAddedEvent {
        return SongAddedEvent(
            song: song ?? self.song
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - VoteSongEvent
struct VoteSongEvent: Codable {
    let songID: String
    let vote: Int

    enum CodingKeys: String, CodingKey {
        case songID = "songId"
        case vote
    }
}

// MARK: VoteSongEvent convenience initializers and mutators

extension VoteSongEvent {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(VoteSongEvent.self, from: data)
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
        songID: String? = nil,
        vote: Int? = nil
    ) -> VoteSongEvent {
        return VoteSongEvent(
            songID: songID ?? self.songID,
            vote: vote ?? self.vote
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - VoteSongRequest
struct VoteSongRequest: Codable {
    let sessionID, songID: String
    let vote: Int

    enum CodingKeys: String, CodingKey {
        case sessionID = "sessionId"
        case songID = "songId"
        case vote
    }
}

// MARK: VoteSongRequest convenience initializers and mutators

extension VoteSongRequest {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(VoteSongRequest.self, from: data)
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
        songID: String? = nil,
        vote: Int? = nil
    ) -> VoteSongRequest {
        return VoteSongRequest(
            sessionID: sessionID ?? self.sessionID,
            songID: songID ?? self.songID,
            vote: vote ?? self.vote
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
