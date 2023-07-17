//
//  SearchViewModel.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-16.
//

import Combine

class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var searchResults: [Song] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?

    var musicService: MusicService?

    private var cancellables = Set<AnyCancellable>()

    init() {
        $query
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.isLoading = true
            }
            .store(in: &cancellables)

        $query
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { [weak self] query in
                return (self?.musicService?.searchSongs(query: query)
                    .catch { error -> Just<[Song]> in
                        DispatchQueue.main.async {
                            self?.error = error
                        }
                        return Just([])
                    })!
            }
            .sink { [weak self] results in
                DispatchQueue.main.async {
                    self?.searchResults = results
                    self?.isLoading = false
                }
            }
            .store(in: &cancellables)
    }
}
