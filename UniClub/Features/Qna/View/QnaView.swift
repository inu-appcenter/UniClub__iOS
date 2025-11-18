import SwiftUI

struct QnaView: View {   // ✅ 이름 변경: QAView -> QnaView
    @StateObject private var viewModel = QnaViewModel()
    
    // MARK: - State Properties
    @State private var searchText = ""
    @State private var showAnsweredOnly = false
    @State private var showMyQuestionsOnly = false
    @State private var isShowingClubPicker = false
    @State private var selectedClub: ClubInfo?

    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                navigationBar
                Divider().background(Color(.systemGray5))
                searchBar
                filterSection
                questionsList
                askButton
            }
            .navigationBarHidden(true)
            .task {
                // initial load
                await MainActor.run {
                    fetchData()
                }
            }
            // reload when filters change
            .onChange(of: selectedClub) { _ in fetchData() }
            .onChange(of: showAnsweredOnly) { _ in fetchData() }
            .onChange(of: showMyQuestionsOnly) { _ in fetchData() }
            .sheet(isPresented: $isShowingClubPicker) {
                SearchClubView { club in       // ✅ ClubPickerView -> SearchClubView
                    self.selectedClub = club
                }
            }
        }
    }
}

// MARK: - Subviews

private extension QnaView {
    
    // 네비게이션 바
    var navigationBar: some View {
        HStack {
            Button(action: {
                // TODO: 뒤로가기 액션 연결 (환경값 dismiss 사용 등)
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
            }
            Spacer()
            Text("질의응답")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
            Spacer()
            Rectangle()
                .fill(Color.clear)
                .frame(width: 20, height: 20)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
    
    // 검색 바
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("질문을 검색해보세요.", text: $searchText)
                .font(.system(size: 15))
                .onSubmit {
                    fetchData()
                }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
    
    // 필터 영역
    var filterSection: some View {
        HStack {
            Button(action: {
                isShowingClubPicker.toggle()
            }) {
                HStack(spacing: 5) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 14))
                    Text(selectedClub?.name ?? "동아리 선택")
                        .font(.system(size: 14, weight: .semibold))
                        .lineLimit(1)
                    
                    if selectedClub != nil {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 14))
                            .onTapGesture {
                                selectedClub = nil   // ✅ 중첩 Button 대신 탭 제스처로만 처리
                            }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.orange.opacity(0.1))
                .foregroundColor(.orange)
                .cornerRadius(8)
            }

            Spacer()

            HStack(spacing: 5) {
                Text("답변 완료만")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                CheckboxView(isChecked: $showAnsweredOnly)
            }

            HStack(spacing: 5) {
                Text("내 질문만")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                CheckboxView(isChecked: $showMyQuestionsOnly)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
    
    // 질문 목록
    var questionsList: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView().padding()
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else {
                VStack(spacing: 15) {
                    ForEach(viewModel.questions) { question in
                        NavigationLink(
                            destination: AnswerView(questionId: question.questionId)
                        ) {
                            QuestionItemView(
                                name: question.nickname,        // ✅ nickname
                                date: "",                       // ⚠️ 이 API에는 날짜 없음
                                tag: question.clubName ?? "",
                                question: question.content,
                                answerCount: question.countAnswer
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.leading, 28)
                .padding(.trailing, 24)
                .padding(.top, 5)
            }
        }
    }
    
    // 질문하기 버튼
    var askButton: some View {
        NavigationLink(destination: QuestionView()) {   // ✅ AskView -> QuestionView
            Text("질문하기")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .cornerRadius(12)
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }


// MARK: - API 연결 함수 (QnaService → HTTPClient 사용)

        @MainActor
        private func fetchData() {
            viewModel.fetchQuestions(
                keyword: searchText,
                clubId: selectedClub?.id,
                isAnsweredOnly: showAnsweredOnly,
                isMyQuestionsOnly: showMyQuestionsOnly
            )
        }
}

// MARK: - Reusable View for each Q&A item (UI만 담당, 하드코딩 X)

struct QuestionItemView: View {
    let name: String
    let date: String
    let tag: String
    let question: String
    let answerCount: Int   // ✅ 누락되어 있던 부분 복구

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .foregroundColor(Color(.systemGray4))

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Text(name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.black)
                        .lineLimit(1)
                    Text(date)
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                    Spacer()
                    Button(action: {
                        // TODO: 더보기 액션 (신고/삭제 등)
                    }) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                }

                if !tag.isEmpty {
                    Text("@\(tag)")
                        .font(.system(size: 12))
                        .foregroundColor(Color.orange)
                        .fontWeight(.medium)
                }

                Text(question)
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Text(answerCount > 0 ? "답변 \(answerCount)개" : "답변 대기중")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
        }
        .padding(14)
        .frame(width: 370, height: 130, alignment: .leading)
        .background(Color.white)
        .cornerRadius(31)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Custom Checkbox View (로컬 UI 상태만, API와 직접 연관 없음)

struct CheckboxView: View {
    @Binding var isChecked: Bool

    var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                .foregroundColor(.orange)
                .imageScale(.large)
        }
    }
}

#Preview {
    QnaView()
}
