//
//  TopBannerViewModel.swift
//  UniClub
//
//  Created by 제욱 on 8/5/25.
//

import Foundation

struct TopBannerModel: Decodable {
    let imageUrl: String
}

class TopBannerViewModel: ObservableObject {
    @Published var banner: TopBannerModel?

    func fetchBanner(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let decoded = try JSONDecoder().decode(TopBannerModel.self, from: data)
                DispatchQueue.main.async {
                    self.banner = decoded
                }
            } catch {
                print("디코딩 오류: \(error)")
            }
        }.resume()
    }
}
