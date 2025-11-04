import SwiftUI

struct AskView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isShowingClubSearch = false
    @State private var selectedClub: ClubInfo? // 사용자의 ClubInfo 구조체
    @State private var questionText = ""
    
    private let placeholderText = "질문할 동아리를 검색하세요."

    var body: some View {
        // ZStack을 사용하여 배경색을 지정하고 UI 안정성을 높입니다.
        ZStack {
            Color.white.ignoresSafeArea() // 배경을 흰색으로 변경

            VStack(spacing: 0) {
                // MARK: - 상단 네비게이션 바
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Text("질문하기")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.left").foregroundColor(.clear) // Title 중앙 정렬용
                }
                .padding()
                .background(Color.white)

                // MARK: - 동아리 검색창 (버튼 역할)
                Button(action: {
                    isShowingClubSearch.toggle()
                }) {
                    HStack {
                        Text(selectedClub?.name ?? placeholderText)
                            .foregroundColor(selectedClub == nil ? .gray : .black)
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)

                // MARK: - 내용 (동아리 선택 전 / 후 분기 처리)
                if selectedClub == nil {
                    HStack {
                        Text(placeholderText)
                            .font(.callout)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .background(Color.white)
                } else {
                    VStack(spacing: 0) {
                        if let club = selectedClub {
                            HStack {
                                Text("@\(club.name)")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.orange)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                            .background(Color.white)
                        }
                        
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $questionText)
                                .padding(.horizontal, 4)
                                .background(Color.white)
                            
                            if questionText.isEmpty {
                                Text(placeholderText)
                                    .font(.callout)
                                    .foregroundColor(.gray)
                                    .padding(8)
                                    .allowsHitTesting(false)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                
                Spacer() // 하단 버튼을 아래로 밀어냅니다.
                
                // MARK: - 하단 버튼
                HStack(spacing: 10) {
                    Button(action: {}) {
                        Text("익명")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(UIColor.systemGray5))
                            .foregroundColor(Color.black)
                            .cornerRadius(12)
                    }
                    .frame(width: 80)

                    Button(action: {}) {
                        Text("등록하기")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding()
                .background(Color.white)
            }
            // VStack이 화면 전체 높이를 차지하고, 내용물을 위쪽에 정렬하도록 강제합니다.
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $isShowingClubSearch) {
            // 사용자의 ClubPickerView
            ClubPickerView { club in
                self.selectedClub = club
            }
        }
    }
}

#Preview {
    AskView()
}
