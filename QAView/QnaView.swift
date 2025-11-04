import SwiftUI

struct QnaView: View {
    let questionId: Int // >>>>>> 수정된 부분: Int 타입으로 변경 <<<<<<
    @StateObject private var viewModel = QnaDetailViewModel()
    @State private var isAnonymous = false
    @State private var newCommentContent: String = ""

    var body: some View {
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

            // MARK: - Q&A Detail
            ScrollView {
                if let question = viewModel.questionDetail {
                    VStack(alignment: .leading, spacing: 15) {
                        // Original Question
                        QuestionDetailItemView(
                            name: question.authorName,
                            date: question.updatedAt, // updatedAt 사용
                            tag: question.clubName,
                            content: question.content
                        )
                        .padding(.top, 10)

                        // Answer and Comments
                        ForEach(question.answers) { answer in
                             // API의 answers 배열을 사용해 답변 목록 표시
                             // content가 "삭제된 댓글입니다."인 경우 처리가 필요할 수 있습니다.
                             AnswerItemView(
                                 name: answer.authorName,
                                 date: answer.createdAt,
                                 content: answer.content,
                                 isAnswered: question.answered
                             )
                        }
                    }
                    .padding(.horizontal)
                } else if viewModel.isLoading {
                    ProgressView().padding()
                } else {
                    Text("질문을 불러오는 중 오류가 발생했습니다.")
                        .foregroundColor(.gray)
                        .padding()
                }
            }

            Spacer()

            // MARK: - Input Field
            VStack(spacing: 0) {
                Divider()
                    .background(Color(.systemGray5))

                HStack(spacing: 15) {
                    Button(action: {
                        isAnonymous.toggle()
                    }) {
                        Text("익명")
                            .font(.subheadline)
                            .foregroundColor(isAnonymous ? .white : .black)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(isAnonymous ? Color.orange : Color(.systemGray5))
                            .cornerRadius(18)
                    }

                    TextField("댓글을 입력하세요.", text: $newCommentContent)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)

                    Button(action: {
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                    }
                    .disabled(newCommentContent.isEmpty)
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.fetchQuestionDetail(questionId: questionId)
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Question and Answer Item Views (내부 코드는 변경 없음)
struct QuestionDetailItemView: View {
    let name: String
    let date: String
    let tag: String?
    let content: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 30))
                .foregroundColor(Color(red: 1.0, green: 0.5, blue: 0.0))

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

                if let tag = tag, !tag.isEmpty {
                    Text("@\(tag)")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 1.0, green: 0.5, blue: 0.0))
                        .fontWeight(.medium)
                }

                Text(content)
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                    .padding(.top, 2)
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct AnswerItemView: View {
    let name: String
    let date: String
    let content: String
    let isAnswered: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 30))
                .foregroundColor(Color(red: 1.0, green: 0.5, blue: 0.0))
                .padding(.top, 5)

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.black)

                    if isAnswered {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.orange)
                            .font(.caption)
                    }

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

                Text(content)
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                    .padding(.top, 2)
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
