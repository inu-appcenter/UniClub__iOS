import SwiftUI

enum ClubSort: String, CaseIterable, Identifiable {
    case name = "이름순"
    case favoriteFirst = "즐겨찾기 우선"
    var id: String { rawValue }
}

struct ClubListView: View {
    let category: ClubCategory?             // nil = 전체
    @Environment(\.dismiss) private var dismiss

    @StateObject private var vm = ClubListViewModel()
    @State private var sort: ClubSort = .name
    @State private var showSearch = false   // 검색 네비게이션용

    private var titleText: String {
        category?.displayName ?? "전체"
    }

    private var filtered: [ClubListItem] {
        let base: [ClubListItem] = {
            if let category { return vm.items.filter { $0.category == category } }
            return vm.items
        }()

        switch sort {
        case .name:
            return base.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
        case .favoriteFirst:
            return base.sorted {
                ($0.favorite ?? false) == ($1.favorite ?? false)
                ? $0.name.localizedCompare($1.name) == .orderedAscending
                : (($0.favorite ?? false) && !($1.favorite ?? false))
            }
        }
    }

    // 정렬 배지에 표시할 현재 라벨
    private var sortLabel: String {
        switch sort {
        case .name: return "정렬순"      // 기본 노출 텍스트
        case .favoriteFirst: return "즐겨찾기 우선"
        }
    }

    var body: some View {
        ZStack {
            // 리스트 섹션 배경 (검정 유지)
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                // MARK: 상단 헤더 (흰 배경)
                ZStack {
                    Color.white.ignoresSafeArea(edges: .top)

                    // 좌/중/우 배치
                    HStack {
                        // ① 뒤로가기 (검정 chevron)
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(width: 44, height: 44, alignment: .center)
                        }

                        Spacer()

                        // ② 가운데 타이틀 (검정)
                        Text(titleText)
                            .font(.custom("NotoSansKR-Medium", size: 15))
                            .foregroundColor(.black)

                        Spacer()

                        // ③ 검색 버튼 (검정 아이콘)
                        Button(action: { showSearch = true }) {
                            Image ("ClubList_search")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 23, alignment: .center)
                                .padding(.trailing, 23)
                        }
                        .background(
                            // 네비게이션 연결 (임시 SearchView)
                            NavigationLink("", isActive: $showSearch) {
                                ClubSearchView() // TODO: 실제 검색 화면으로 교체
                            }
                            .opacity(0)
                        )
                    }
                    .padding(.horizontal, 8)
                }
                .frame(height: 56) // 타이틀/아이콘 높이

                // MARK: 정렬 배지 (우측 정렬, 드롭다운 Menu)
                HStack {
                    Spacer()
                    Menu {
                        // 드롭다운 항목
                        Button("정렬순") { sort = .name }
                        Button("즐겨찾기 우선") { sort = .favoriteFirst }
                    } label: {
                        HStack(spacing: 6) {
                            Text(sortLabel)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.white)
                            Image(systemName: "chevron.down")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(red: 0.236, green: 0.236, blue: 0.236))
                        .clipShape(RoundedRectangle(cornerRadius: 17, style: .continuous))
                    }
                    .padding(.trailing, 16)
                    .padding(.top, 8)
                }
                .background(Color.white) // 정렬 배지도 흰 헤더 영역 안에 위치시키기 위함

                // MARK: 리스트
                ScrollView {
                    LazyVStack(spacing: 21) {
                        ForEach(filtered) { item in
                            ClubRowView(item: item)
                                .onTapGesture {
                                    // TODO: 상세 이동
                                }
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 24)
                    .padding(.top, 12)
                }
                .background(Color.white)
            }
        }
        .task { await vm.load(category: category) }
        .navigationBarBackButtonHidden(true)
    }
}

// 임시 검색 화면 (연결 확인용)
private struct ClubSearchView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("동아리명으로 검색", text: $query)
                    .textFieldStyle(.roundedBorder)
                Button("닫기") { dismiss() }
            }
            .padding()

            Spacer()
            Text("검색 결과가 여기에 표시됩니다.")
                .foregroundStyle(.secondary)
            Spacer()
        }
        .navigationTitle("검색")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
    }
}

#Preview {
    NavigationStack {
        ClubListView(category: nil)
    }
    //.preferredColorScheme(.dark)
}
