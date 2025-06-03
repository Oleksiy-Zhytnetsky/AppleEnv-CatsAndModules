//
//  ContentView.swift
//  CatsUI
//
//  Created by Oleksiy Zhytnetsky on 27.05.2025.
//

import SwiftUI
import Networking

struct ContentView: View {
    
    @State private var cats: [CatData] = []
    @State private var nextPageToLoad = 0
    @State private var isLoadingNextPage = false
    @State private var hasFinishedInitialLoading = false
    
    private struct Const {
        static let PAGE_SIZE = 15
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if (self.hasFinishedInitialLoading) {
                    ScrollView {
                        LazyVStack {
                            ForEach(
                                Array(cats.enumerated()),
                                id: \.element.id
                            ) { idx, cat in
                                NavigationLink(value: cat) {
                                    CatView(cat: cat)
                                        .frame(
                                            height: 300
                                        )
                                        .padding(.bottom, 5)
                                        .padding(.horizontal, 5)
                                }
                                .buttonStyle(.plain)
                                .onAppear {
                                    if (idx >= self.cats.count - 2) {
                                        loadNextPageIfAble()
                                    }
                                }
                            }
                            
                            if (self.isLoadingNextPage) {
                                ProgressView()
                                    .frame(
                                        maxWidth: .infinity
                                    )
                            }
                        }
                    }
                }
                else {
                    Text("Loading...")
                        .lineLimit(1)
                        .font(.system(size: 32, weight: .bold))
                }
            }
            .navigationDestination(for: CatData.self) { selectedCat in
                CatFullscreenView(cat: selectedCat)
            }
        }
        .onAppear {
            loadNextPageIfAble()
        }
        .padding()
    }
    
    private func loadNextPageIfAble() {
        guard !self.isLoadingNextPage else {
            return
        }
        Task {
            await loadPage()
        }
    }
    
    private func loadPage() async {
        self.isLoadingNextPage = true
        defer {
            self.isLoadingNextPage = false
        }
        
        do {
            let resp = try await ApiClient.fetchCats(
                limit: Const.PAGE_SIZE,
                page: self.nextPageToLoad
            )
            if (self.nextPageToLoad == 0) {
                self.hasFinishedInitialLoading = true
            }
            self.nextPageToLoad += 1
            self.cats.append(contentsOf: resp)
        }
        catch {
            print("Error fetching cats: \(error)")
        }
    }
    
}
