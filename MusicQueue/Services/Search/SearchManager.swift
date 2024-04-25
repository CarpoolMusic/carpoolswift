import Combine

protocol SearchManagerProtocol {
    func initiateSearch(query: String, limit: Int)
}

protocol SearchManagerBaseProtocol {
    func searchSongs(query: String, limit: Int) async throws -> [SongProtocol]
}

class SearchManager: ObservableObject, SearchManagerProtocol, SearchManagerBaseProtocol {
    @Injected private var logger: CustomLoggerProtocol
    private var base: SearchManagerBaseProtocol
    
    @Published var songs: [SongProtocol] = []
    
    // Subjects and Publishers
    private var searchQueryPublisher = PassthroughSubject<(String, Int), Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(_ base: SearchManagerBaseProtocol) {
        self.base = base
        setupSearchPublisher()
    }
    
    private func setupSearchPublisher() {
        // Debounce search queries
        searchQueryPublisher
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .removeDuplicates(by: { (lhs, rhs) -> Bool in
                lhs.0 == rhs.0 && lhs.1 == rhs.1 // Avoid repeating the same query and limit
            })
            .sink { [weak self] query, limit in
                self?.performSearch(query: query, limit: limit)
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(query: String, limit: Int) {
        if query.isEmpty {
            self.songs = []
            return
        }
        Task {
            do {
                let results: [SongProtocol] = try await base.searchSongs(query: query, limit: limit)
                DispatchQueue.main.async { [weak self] in
                    self?.logger.debug("New results from search \(results)")
                    self?.songs = results
                }
            } catch let error as CustomError {
                logger.error(error)
                
            } catch {
                logger.error("\(error)")
            }
        }
    }
    
    func initiateSearch(query: String, limit: Int) {
        // Send queries to the search query publisher
        searchQueryPublisher.send((query, limit))
    }
    
    internal func searchSongs(query: String, limit: Int) async throws -> [SongProtocol] {
        return try await base.searchSongs(query: query, limit: limit)
    }
}
