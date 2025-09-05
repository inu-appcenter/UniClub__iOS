import SwiftUI

struct QAView: View {
    @StateObject private var viewModel = QAViewModel()
    @State private var searchText = ""
    @State private var showAnsweredOnly = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // MARK: - Navigation Bar
                HStack {
                    Button(action: {}) {
                        Image(systemName: "chevron.left").opacity(0) // Title 중앙 정렬을 위한 Placeholder
                    }
                    Spacer()
                    Text("질의응답")
                        .font(.headline).fontWeight(.bold)
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "chevron.left").opacity(0)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)

                Divider()

                // MARK: - Search Bar
                HStack {
                    TextField("질문을 검색해보세요.", text: $searchText)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                // MARK: - Filter Section
                 HStack {
                    Button(action: {}) {
                        HStack {
                            Text("동아리 선택")
                            Image(systemName: "chevron.down")
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.orange.opacity(0.1))
                        .foregroundColor(.orange)
                        .cornerRadius(8)
                    }
                    Spacer()
                    HStack {
                        Text("답변 완료만")
                            .font(.subheadline)
                        CheckboxView(isChecked: $showAnsweredOnly)
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
                            ForEach(viewModel.questions) { question in
                                NavigationLink(destination: QnaView(questionId: question.id)) {
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
                // AskView로 viewModel을 EnvironmentObject로 전달
                NavigationLink(destination: AskView().environmentObject(viewModel)) {
                    Text("질문하기")
                        .font(.headline).fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.fetchQuestions(keyword: searchText, isAnsweredOnly: showAnsweredOnly)
            }
            .onChange(of: searchText) { newValue in
                viewModel.fetchQuestions(keyword: newValue, isAnsweredOnly: showAnsweredOnly)
            }
            .onChange(of: showAnsweredOnly) { newValue in
                viewModel.fetchQuestions(keyword: searchText, isAnsweredOnly: newValue)
            }
        }
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
                .font(.largeTitle)
                .foregroundColor(Color.gray)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(name).fontWeight(.bold)
                    Text(date).font(.caption).foregroundColor(.gray)
                    Spacer()
                }
                
                if !tag.isEmpty {
                    Text(tag)
                        .font(.caption)
                        .foregroundColor(Color.orange)
                        .fontWeight(.medium)
                }
                
                Text(question)
                    .font(.body)
                    .padding(.top, 2)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
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

