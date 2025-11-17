import SwiftUI

// 동아리 정보 모델 (나중엔 서버 DTO → Domain으로 바인딩)
struct ClubInfo: Identifiable, Equatable,Hashable {
    let id: Int
    let name: String
    let category: String
}

struct SearchClubView: View {      // ✅ ClubPickerView -> SearchClubView
    @Environment(\.presentationMode) var presentationMode
    
    var onClubSelected: (ClubInfo) -> Void
    
    @StateObject private var viewModel = SearchClubViewModel()
    
    @State private var searchText = ""
    @State private var selectedClub: ClubInfo?
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Navigation Bar
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                }
                Spacer()
                Text("동아리 선택")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                Spacer()
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 20, height: 20)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            Divider().background(Color(.systemGray5))
            
            // MARK: - Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("동아리명을 입력하세요.", text: $searchText)
                    .font(.system(size: 15))
                    .onSubmit {
                        viewModel.search(keyword: searchText)
                    }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            // MARK: - 상태 영역 (로딩 / 에러 / 리스트)
            if viewModel.isLoading {
                ProgressView("불러오는 중...")
                    .padding()
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 8) {
                    Text(error)
                        .foregroundColor(.red)
                    Button("다시 시도") {
                        viewModel.search(keyword: searchText)
                    }
                    .font(.system(size: 14, weight: .semibold))
                }
                .padding()
            } else if viewModel.clubs.isEmpty {
                VStack(spacing: 8) {
                    Text("검색 결과가 없습니다.")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text("검색어를 입력해 동아리를 찾아보세요.")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .padding(.top, 30)
            } else {
                // MARK: - Club List
                List(selection: $selectedClub) {
                    ForEach(viewModel.clubs) { club in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(club.name)
                                    .font(.system(size: 15, weight: .semibold))
                                Text(club.category)
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            
                            if club == selectedClub {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.orange)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedClub = club
                        }
                    }
                }
                .listStyle(.plain)
            }
            
            // MARK: - 확인 버튼
            Button(action: {
                guard let selected = selectedClub else { return }
                onClubSelected(selected)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text(selectedClub == nil ? "동아리 선택" : "\(selectedClub!.name) 선택 완료")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedClub == nil ? Color.gray : Color.black)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .disabled(selectedClub == nil)
        }
        .onAppear {
            // 처음에는 빈 keyword로 전체 목록/인기 동아리 불러오고 싶다면:
            viewModel.search(keyword: "")
        }
        .onChange(of: searchText) { newValue in
            // 🔸 타이핑할 때마다 바로 검색하고 싶으면 이걸 유지
            // 너무 자주 호출되면 나중에 디바운싱 추가 고려
            viewModel.search(keyword: newValue)
        }
    }
}

#Preview {
    SearchClubView { selectedClub in
        print("선택된 동아리: \(selectedClub.name)")
    }
}
