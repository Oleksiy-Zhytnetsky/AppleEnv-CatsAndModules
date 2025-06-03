//
//  ContentView.swift
//  CatsUI
//
//  Created by Oleksiy Zhytnetsky on 27.05.2025.
//

import SwiftUI
import Networking
import FirebasePerformance
import FirebaseCrashlytics

struct ContentView: View {
    
    @State private var cats: [CatData] = []
    @State private var nextPageToLoad = 0
    @State private var isLoadingNextPage = false
    @State private var hasFinishedInitialLoading = false
    @State private var showCrashlyticsConsentAlert = false
    
    private struct Const {
        static let PAGE_SIZE = 15
        static let FETCH_CATS_TRACE = "fetch_cats_trace"
        static let SELECTED_CAT_BREED_LOG = "selected_cat_breed_log"
        static let USER_CRASHLYTICS_CONSENT_KEY = "user_crashlytics_consent"
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
                                catViewWrapper(idx, cat)
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
            checkCrashlyticsConsent()
        }
        .alert(isPresented: self.$showCrashlyticsConsentAlert) {
            Alert(
                title: Text("Crash Reporting"),
                message: Text("Do you want to allow the app to send crash reports?"),
                primaryButton: .default(Text("Allow")) {
                    UserDefaults.standard.set(true, forKey: Const.USER_CRASHLYTICS_CONSENT_KEY)
                    Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
                },
                secondaryButton: .cancel(Text("Don’t allow")) {
                    UserDefaults.standard.set(false, forKey: Const.USER_CRASHLYTICS_CONSENT_KEY)
                    Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(false)
                }
            )
        }
        .padding()
    }
    
    @ViewBuilder
    private func catViewWrapper(_ idx: Int, _ cat: CatData) -> some View {
        NavigationLink(value: cat) {
            CatView(cat: cat)
                .frame(
                    height: 300
                )
                .padding(.bottom, 5)
                .padding(.horizontal, 5)
        }
        .onAppear {
            if (idx >= self.cats.count - 2) {
                loadNextPageIfAble()
            }
        }
        .simultaneousGesture(TapGesture().onEnded {
            Crashlytics.crashlytics().log("Tapped on row \(idx)")
            Crashlytics.crashlytics().setCustomValue(
                cat.mainBreed,
                forKey: Const.SELECTED_CAT_BREED_LOG
            )
        })
        .buttonStyle(.plain)
    }
    
    private func checkCrashlyticsConsent() {
        if (UserDefaults.standard.object(forKey: Const.USER_CRASHLYTICS_CONSENT_KEY) == nil) {
            self.showCrashlyticsConsentAlert = true
        }
        else {
            let consentDecision = UserDefaults.standard.bool(forKey: Const.USER_CRASHLYTICS_CONSENT_KEY)
            Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(consentDecision)
        }
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
            let trace = Performance.startTrace(name: Const.FETCH_CATS_TRACE)
            defer {
                trace?.stop()
            }
            
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
