//
//  CatView.swift
//  CatsUI
//
//  Created by Oleksiy Zhytnetsky on 27.05.2025.
//

import SwiftUI
import Networking
import FirebasePerformance

struct CatView: View {
    
    @State private var loadImgTrace: Trace? = nil
    
    private struct Const {
        static let LOAD_CAT_IMG_TRACE = "load_cat_img_trace"
    }
    
    public let cat: CatData
    
    var body: some View {
        ZStack {
            Color.secondary
                .opacity(0.2)
                .zIndex(0)
            
            VStack {
                Button("Crash") {
                    fatalError("Crash was triggered")
                }
                
                HStack {
                    Text("Breed: \(cat.mainBreed)")
                        .lineLimit(1)
                        .font(.system(size: 22))
                        .padding(.leading, 5)
                    
                    Spacer()
                }
                
                AsyncImage(
                    url: URL(string: cat.url)
                ) { phase in
                    switch phase {
                    case .empty:
                        progressSpinner()
                            .task {
                                if (self.loadImgTrace == nil) {
                                    self.loadImgTrace = Performance.startTrace(
                                        name: Const.LOAD_CAT_IMG_TRACE
                                    )
                                }
                            }
                        
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .task {
                                self.loadImgTrace?.stop()
                            }
                        
                    default:
                        progressSpinner()
                            .task {
                                self.loadImgTrace?.stop()
                            }
                    }
                }
            }
            .zIndex(1)
        }
    }
    
    @ViewBuilder
    private func progressSpinner() -> some View {
        ProgressView()
            .frame(
                maxWidth: .infinity,
                maxHeight: 250
            )
    }
    
}
