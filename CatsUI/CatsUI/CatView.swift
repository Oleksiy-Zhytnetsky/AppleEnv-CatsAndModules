//
//  CatView.swift
//  CatsUI
//
//  Created by Oleksiy Zhytnetsky on 27.05.2025.
//

import SwiftUI
import Networking

struct CatView: View {
    
    public let cat: CatData
    
    var body: some View {
        ZStack {
            Color.secondary
                .opacity(0.2)
                .zIndex(0)
            
            VStack {
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
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    default:
                        ProgressView()
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: 250
                            )
                    }
                }
            }
            .zIndex(1)
        }
    }
    
}
