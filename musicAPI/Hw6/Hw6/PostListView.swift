import Foundation

struct MusicResponse: Codable {
    let results: [MusicItem]
}

struct MusicItem: Codable, Identifiable {
    let id = UUID()
    let trackName: String?
    let artistName: String?
    let artworkUrl100: String?
    let releaseDate: String?
    let previewUrl: String?
}
