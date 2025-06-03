//
//  CatFullscreenView.swift
//  CatsUI
//
//  Created by Oleksiy Zhytnetsky on 27.05.2025.
//

import SwiftUI
import Networking

struct CatFullscreenView: View {
    
    public let cat: CatData
    
    var body: some View {
        ZStack {
            Color.secondary
                .opacity(0.2)
                .zIndex(0)
            
            AsyncImage(
                url: URL(string: cat.url)
            ) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                default:
                    ProgressView()
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity
                        )
                }
            }
            .zIndex(1)
        }
    }
}
