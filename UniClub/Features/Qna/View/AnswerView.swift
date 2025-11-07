import SwiftUI

struct AnswerView: View {   // ✅ 이름 변경: QnaView -> AnswerView
    let questionId: Int
    @StateObject private var viewModel = QnaViewModel()
    @State private var isAnonymous = false
    @State private var newCommentContent: String = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Navigation Bar
            HStack {
                Button(action: { dismiss() }) {
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

            // MARK: - Q&A Detail (✅ API 연결: questionDetail은 서버 응답 데이터)
//            ScrollView {
//                if let question = viewModel.questionDetail {
//                    VStack(alignment: .leading, spacing: 15) {
//                        // 질문 본문
//                        QuestionDetailItemView(
//                            name: question.authorName,
//                            date: question.updatedAt,
//                            tag: question.clubName,
//                            content: question.content
//                        )
//                        .padding(.top, 10)
//
//                        // 답변 목록
//                        ForEach(question.answers) { answer in
//                            AnswerItemView(
//                                name: answer.authorName,
//                                date: answer.createdAt,
//                                content: answer.content,
//                                isAnswered: question.answered
//                            )
//                        }
//                    }
//                    .padding(.horizontal)
//                } else if viewModel.isLoading {
//                    ProgressView().padding()
//                } else {
//                    Text("질문을 불러오는 중 오류가 발생했습니다.")
//                        .foregroundColor(.gray)
//                        .padding()
//                }
//            }

            Spacer()

            // MARK: - Input Field (🔸 UI만 있고, 아직 API 연결 안 된 상태)
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
                        // TODO: 🔗 여기서 QnA 답변/댓글 등록 API 연결 예정
                        // QnaService.postAnswer(questionId:questionId, content:newCommentContent, isAnonymous:isAnonymous)
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
        .navigationBarHidden(true)
    }
}

// 이 아래 QuestionDetailItemView / AnswerItemView 는 기존과 동일 (UI만 담당)
#Preview {
    NavigationStack {
        AnswerView(questionId: 1)
    }
}
