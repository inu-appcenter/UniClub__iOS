import SwiftUI

struct QuestionView: View {    // ✅ AskView -> QuestionView
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isShowingClubSearch = false
    @State private var selectedClub: ClubInfo?
    @State private var questionText = ""
    @State private var isAnonymous = false   // ✅ 익명 상태도 같이 관리
    
    private let placeholderText = "질문할 동아리를 검색하세요."

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

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
                    Image(systemName: "chevron.left").foregroundColor(.clear)
                }
                .padding()
                .background(Color.white)

                // MARK: - 동아리 검색창
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

                // MARK: - 내용
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
                                Text("동아리에 하고 싶은 질문을 적어주세요.")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                                    .padding(8)
                                    .allowsHitTesting(false)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                
                Spacer()
                
                // MARK: - 하단 버튼
                HStack(spacing: 10) {
                    Button(action: {
                        isAnonymous.toggle()
                    }) {
                        Text("익명")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isAnonymous ? Color.orange : Color(UIColor.systemGray5))
                            .foregroundColor(isAnonymous ? .white : .black)
                            .cornerRadius(12)
                    }
                    .frame(width: 80)

                    Button(action: {
                        // TODO: 🔗 질문 등록 API 연결 예정
                        // QnaService.postQuestion(clubId:selectedClub?.id, content:questionText, isAnonymous:isAnonymous)
                    }) {
                        Text("등록하기")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(questionText.isEmpty || selectedClub == nil ? Color.gray : Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .disabled(questionText.isEmpty || selectedClub == nil)
                }
                .padding()
                .background(Color.white)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $isShowingClubSearch) {
            SearchClubView { club in   // ✅ ClubPickerView -> SearchClubView
                self.selectedClub = club
            }
        }
    }
}

#Preview {
    QuestionView()
}
