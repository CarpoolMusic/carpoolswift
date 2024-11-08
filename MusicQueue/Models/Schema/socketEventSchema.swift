// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let socketEventSchema = try SocketEventSchema(json)

import Foundation

// MARK: - SocketEventSchema
struct SocketEventSchema: Codable {
    let loginRequest: LoginRequest
    let createUserRequest: CreateUserRequest
    let createSessionRequest: CreateSessionRequest
    let createSessionResponse: CreateSessionResponse
    let joinSessionRequest: JoinSessionRequest
    let joinSessionResponse: JoinSessionResponse
    let song: Song
    let addSongRequest: AddSongRequest
    let songAddedEvent: SongAddedEvent
    let removeSongRequest: RemoveSongRequest
    let songRemovedEvent: SongRemovedEvent
    let voteSongRequest: VoteSongRequest
    let voteSongEvent: VoteSongEvent
    let errorResponse: ErrorResponse

    enum CodingKeys: String, CodingKey {
        case loginRequest = "LoginRequest"
        case createUserRequest = "CreateUserRequest"
        case createSessionRequest = "CreateSessionRequest"
        case createSessionResponse = "CreateSessionResponse"
        case joinSessionRequest = "JoinSessionRequest"
        case joinSessionResponse = "JoinSessionResponse"
        case song = "Song"
        case addSongRequest = "AddSongRequest"
        case songAddedEvent = "SongAddedEvent"
        case removeSongRequest = "RemoveSongRequest"
        case songRemovedEvent = "SongRemovedEvent"
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
        loginRequest: LoginRequest? = nil,
        createUserRequest: CreateUserRequest? = nil,
        createSessionRequest: CreateSessionRequest? = nil,
        createSessionResponse: CreateSessionResponse? = nil,
        joinSessionRequest: JoinSessionRequest? = nil,
        joinSessionResponse: JoinSessionResponse? = nil,
        song: Song? = nil,
        addSongRequest: AddSongRequest? = nil,
        songAddedEvent: SongAddedEvent? = nil,
        removeSongRequest: RemoveSongRequest? = nil,
        songRemovedEvent: SongRemovedEvent? = nil,
        voteSongRequest: VoteSongRequest? = nil,
        voteSongEvent: VoteSongEvent? = nil,
        errorResponse: ErrorResponse? = nil
    ) -> SocketEventSchema {
        return SocketEventSchema(
            loginRequest: loginRequest ?? self.loginRequest,
            createUserRequest: createUserRequest ?? self.createUserRequest,
            createSessionRequest: createSessionRequest ?? self.createSessionRequest,
            createSessionResponse: createSessionResponse ?? self.createSessionResponse,
            joinSessionRequest: joinSessionRequest ?? self.joinSessionRequest,
            joinSessionResponse: joinSessionResponse ?? self.joinSessionResponse,
            song: song ?? self.song,
            addSongRequest: addSongRequest ?? self.addSongRequest,
            songAddedEvent: songAddedEvent ?? self.songAddedEvent,
            removeSongRequest: removeSongRequest ?? self.removeSongRequest,
            songRemovedEvent: songRemovedEvent ?? self.songRemovedEvent,
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
    let id, appleID, spotifyID, uri: String
    let title, artist, album, artworkURL: String
    let votes: Int

    enum CodingKeys: String, CodingKey {
        case id, appleID, spotifyID, uri, title, artist, album
        case artworkURL = "artworkUrl"
        case votes
    }
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
        id: String? = nil,
        appleID: String? = nil,
        spotifyID: String? = nil,
        uri: String? = nil,
        title: String? = nil,
        artist: String? = nil,
        album: String? = nil,
        artworkURL: String? = nil,
        votes: Int? = nil
    ) -> Song {
        return Song(
            id: id ?? self.id,
            appleID: appleID ?? self.appleID,
            spotifyID: spotifyID ?? self.spotifyID,
            uri: uri ?? self.uri,
            title: title ?? self.title,
            artist: artist ?? self.artist,
            album: album ?? self.album,
            artworkURL: artworkURL ?? self.artworkURL,
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
    let hostID, socketID, sessionName: String

    enum CodingKeys: String, CodingKey {
        case hostID = "hostId"
        case socketID = "socketId"
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
        socketID: String? = nil,
        sessionName: String? = nil
    ) -> CreateSessionRequest {
        return CreateSessionRequest(
            hostID: hostID ?? self.hostID,
            socketID: socketID ?? self.socketID,
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

// MARK: - CreateUserRequest
struct CreateUserRequest: Codable {
    let email, username, password: String
}

// MARK: CreateUserRequest convenience initializers and mutators

extension CreateUserRequest {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CreateUserRequest.self, from: data)
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
        email: String? = nil,
        username: String? = nil,
        password: String? = nil
    ) -> CreateUserRequest {
        return CreateUserRequest(
            email: email ?? self.email,
            username: username ?? self.username,
            password: password ?? self.password
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

// MARK: - LoginRequest
struct LoginRequest: Codable {
    let identifier, password: String
}

// MARK: LoginRequest convenience initializers and mutators

extension LoginRequest {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(LoginRequest.self, from: data)
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
        identifier: String? = nil,
        password: String? = nil
    ) -> LoginRequest {
        return LoginRequest(
            identifier: identifier ?? self.identifier,
            password: password ?? self.password
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - RemoveSongRequest
struct RemoveSongRequest: Codable {
    let sessionID, id: String

    enum CodingKeys: String, CodingKey {
        case sessionID = "sessionId"
        case id
    }
}

// MARK: RemoveSongRequest convenience initializers and mutators

extension RemoveSongRequest {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RemoveSongRequest.self, from: data)
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
        id: String? = nil
    ) -> RemoveSongRequest {
        return RemoveSongRequest(
            sessionID: sessionID ?? self.sessionID,
            id: id ?? self.id
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

// MARK: - SongRemovedEvent
struct SongRemovedEvent: Codable {
    let id: String
}

// MARK: SongRemovedEvent convenience initializers and mutators

extension SongRemovedEvent {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SongRemovedEvent.self, from: data)
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
        id: String? = nil
    ) -> SongRemovedEvent {
        return SongRemovedEvent(
            id: id ?? self.id
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
    let id: String
    let vote: Int
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
        id: String? = nil,
        vote: Int? = nil
    ) -> VoteSongEvent {
        return VoteSongEvent(
            id: id ?? self.id,
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
    let sessionID, id: String
    let vote: Int

    enum CodingKeys: String, CodingKey {
        case sessionID = "sessionId"
        case id, vote
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
        id: String? = nil,
        vote: Int? = nil
    ) -> VoteSongRequest {
        return VoteSongRequest(
            sessionID: sessionID ?? self.sessionID,
            id: id ?? self.id,
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
