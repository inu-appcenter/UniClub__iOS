import SwiftUI

struct QAView: View {
    @StateObject private var viewModel = QAViewModel()
    
    // MARK: - State Properties
    @State private var searchText = ""
    @State private var showAnsweredOnly = false
    @State private var showMyQuestionsOnly = false
    @State private var isShowingClubPicker = false
    @State private var selectedClub: ClubInfo?

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // MARK: - Navigation Bar
                HStack {
                    Button(action: {}) {
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

                Divider().background(Color(.systemGray5))

                // MARK: - Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("질문을 검색해보세요.", text: $searchText)
                        .font(.system(size: 15))
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.vertical, 10)

                // MARK: - Filter Section
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
                                Button {
                                    selectedClub = nil
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 14))
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

                // MARK: - Q&A List
                ScrollView {
                    if viewModel.isLoading {
                        ProgressView().padding()
                    } else {
                        VStack(spacing: 15) {
                            // Question 모델이 Identifiable을 따르므로 id를 명시할 필요 없음
                            ForEach(viewModel.questions) { question in
                                NavigationLink(destination: QnaView(questionId: question.questionId)) {
                                    QuestionItemView(
                                        name: question.authorName,
                                        date: question.createdAt,
                                        tag: question.clubName ?? "",
                                        question: question.content
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 5)
                    }
                }

                Spacer()

                // MARK: - Ask Button
                NavigationLink(destination: AskView()) {
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
            .navigationBarHidden(true)
            .sheet(isPresented: $isShowingClubPicker) {
                ClubPickerView { club in
                    self.selectedClub = club
                }
            }
            .onAppear(perform: fetchData)
            .onChange(of: searchText) { _ in fetchData() }
            .onChange(of: showAnsweredOnly) { _ in fetchData() }
            .onChange(of: showMyQuestionsOnly) { _ in fetchData() }
            .onChange(of: selectedClub) { _ in fetchData() }
        }
    }
    
    // [수정] @MainActor 추가
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

// MARK: - Reusable View for each Q&A item
struct QuestionItemView: View {
    let name: String
    let date: String
    let tag: String
    let question: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 30))
                .foregroundColor(Color(.systemGray4))

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.black)
                    Text(date)
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                    Spacer()
                    Button(action: {}) {
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
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .padding(.top, 2)
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Custom Checkbox View
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

// MARK: - Preview
struct QAView_Previews: PreviewProvider {
    static var previews: some View {
        QAView()
    }
}
