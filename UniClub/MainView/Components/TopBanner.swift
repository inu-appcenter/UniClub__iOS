//
//  TopBanner.swift
//  ProjectTest
//
//  Created by 제욱 on 7/26/25.
//
import SwiftUI

struct TopBanner: View {
    @StateObject private var viewModel = TopBannerViewModel()
    let apiURL: String

    var body: some View {
        Group {
            if let urlString = viewModel.banner?.imageUrl,
               let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 324, height: 249)
                        .clipped()
                        .cornerRadius(21)
                } placeholder: {
                    Color.gray.opacity(0.3)
                        .frame(width: 324, height: 249)
                        .cornerRadius(21)
                }
            } else {
                Color.gray.opacity(0.2)
                    .frame(width: 324, height: 249)
                    .cornerRadius(21)
            }
        }
        .onAppear {
            viewModel.fetchBanner(from: apiURL)
        }
    }
}

#Preview {
    TopBanner(apiURL: "https://mocki.io/v1/dbacf174-5888-46fa-9e29-9b117dc7f0a1")
}
