import SwiftUI

// ContentView: 음악 검색 및 표시를 위한 메인 뷰
struct ContentView: View {
    // 검색어 상태
    @State private var searchTerm: String = ""
    // 음악 데이터 배열
    @State private var musicItems: [MusicItem] = []
    // 로딩 상태
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 검색창과 취소 버튼
                HStack {
                    TextField("검색", text: $searchTerm)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .onChange(of: searchTerm) { _ in
                            // 검색어 변경 시 비동기 검색
                            Task { await fetchMusic() }
                        }
                    Button("취소") {
                        searchTerm = ""
                        Task { await fetchMusic() }
                    }
                    .foregroundColor(.blue)
                    .padding(.trailing)
                }
                .padding(.top)
                
                // 검색 여부에 따라 리스트 또는 그리드 표시
                if searchTerm.isEmpty {
                    // 검색 전: 리스트 레이아웃
                    List {
                        if isLoading {
                            ProgressView("Loading...")
                                .padding()
                        } else {
                            ForEach(musicItems) { item in
                                HStack {
                                    AsyncImage(url: URL(string: item.artworkUrl100 ?? "")) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(8)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 60, height: 60)
                                    }
                                    VStack(alignment: .leading) {
                                        Text(item.trackName ?? "No Title")
                                            .font(.headline)
                                        Text(item.artistName ?? "Unknown Artist")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        if let releaseDate = item.releaseDate {
                                            Text(releaseDate.prefix(10))
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding(.leading, 8)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .listStyle(.plain)
                } else {
                    // 검색 후: 3열 그리드 레이아웃
                    ScrollView {
                        if isLoading {
                            ProgressView("Loading...")
                                .padding()
                        } else {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 100)), count: 3), spacing: 10) {
                                ForEach(musicItems) { item in
                                    VStack {
                                        AsyncImage(url: URL(string: item.artworkUrl100 ?? "")) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 100)
                                                .cornerRadius(8)
                                        } placeholder: {
                                            ProgressView()
                                                .frame(width: 100, height: 100)
                                        }
                                        Text(item.trackName ?? "No Title")
                                            .font(.caption)
                                            .lineLimit(1)
                                            .multilineTextAlignment(.center)
                                        Text(item.artistName ?? "Unknown Artist")
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                            .lineLimit(1)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(width: 120, height: 150)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .task {
                // 뷰 로드 시 초기 데이터 가져오기
                await fetchMusic()
            }
        }
    }
    
    // 음악 데이터를 가져오는 비동기 함수
    private func fetchMusic() async {
        do {
            let apiService = APIService()
            isLoading = true
            // 검색어가 비어있으면 "차트"로 검색
            let term = searchTerm.isEmpty ? "차트" : searchTerm
            print("Fetching music with term: \(term)")
            let results = try await apiService.fetchMusic(searchTerm: term)
            print("Fetch completed with \(results.count) items")
            musicItems = results
            isLoading = false
        } catch {
            print("Fetch failed: \(error.localizedDescription)")
            musicItems = []
            isLoading = false
        }
    }
}

// 미리보기 제공
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
