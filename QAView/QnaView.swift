import SwiftUI

struct QnaView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = QnaDetailViewModel()
    
    let questionId: Int // 이전 뷰에서 전달받을 질문 ID
    
    @State private var replyText = ""
    @State private var isAnonymousReply = false
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Navigation Bar
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
                Text("질의응답")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                // Title을 중앙에 정렬하기 위한 투명 버튼
                Image(systemName: "chevron.left").font(.title2).opacity(0)
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            Divider().padding(.top, 10)
            
            // MARK: - Main Content
            if viewModel.isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else if let detail = viewModel.questionDetail {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // 원본 질문
                        QnaRowView(
                            profileImage: Image(systemName: "person.circle.fill"),
                            name: detail.authorName,
                            date: detail.createdAt, // 날짜 형식 변환 필요
                            content: detail.content,
                            isReply: false
                        )
                        
                        // 답변 목록
                        ForEach(detail.answers) { answer in
                            QnaRowView(
                                profileImage: Image(systemName: "person.circle.fill"), // 프로필 이미지 API 응답에 따라 변경
                                name: answer.authorName,
                                date: answer.createdAt, // 날짜 형식 변환 필요
                                content: answer.content,
                                isReply: true
                                // isVerified: answer.isVerified ?? false
                            )
                        }
                    }
                    .padding()
                }
            } else {
                Spacer()
                Text("질문을 불러오지 못했습니다.")
                    .foregroundColor(.gray)
                Spacer()
            }
            
            // MARK: - Reply Input Bar
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: 15) {
                    // 익명 버튼
                    Button(action: { isAnonymousReply.toggle() }) {
                        Text("익명")
                            .font(.subheadline)
                            .fontWeight(isAnonymousReply ? .bold : .regular)
                            .foregroundColor(isAnonymousReply ? .white : .black)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(isAnonymousReply ? Color.orange : Color(.systemGray5))
                            .cornerRadius(20)
                    }
                    
                    // 댓글 입력 필드와 전송 버튼
                    HStack {
                        TextField("댓글을 입력하세요.", text: $replyText)
                            .padding(.leading, 12)
                        
                        Button(action: postReply) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.title2)
                                .foregroundColor(replyText.isEmpty ? .gray : .orange)
                        }
                        .disabled(replyText.isEmpty)
                        .padding(.trailing, 8)
                    }
                    .padding(.vertical, 4)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
            .background(Color.white)
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear {
            viewModel.fetchQuestionDetail(questionId: questionId)
        }
    }
    
    private func postReply() {
        guard !replyText.isEmpty else { return }
        
        viewModel.postAnswer(questionId: questionId, content: replyText, isAnonymous: isAnonymousReply) { success in
            if success {
                // 성공 시, 입력 필드 초기화하고 데이터 새로고침
                self.replyText = ""
                self.isAnonymousReply = false
                viewModel.fetchQuestionDetail(questionId: questionId)
            } else {
                // TODO: 사용자에게 답변 등록 실패 알림
                print("답변 등록 실패")
            }
        }
    }
}

struct QnaRowView: View {
    var profileImage: Image
    var name: String
    var date: String
    var content: String
    var isReply: Bool
    var isVerified: Bool = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if isReply {
                Image(systemName: "arrow.turn.down.right")
                    .foregroundColor(.gray)
                    .padding(.leading, 20)
            }
            
            profileImage
                .font(.largeTitle)
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .center) {
                    Text(name).fontWeight(.semibold)
                    if isVerified {
                        Image(systemName: "checkmark.circle.fill").foregroundColor(.blue)
                    }
                    Text(date).font(.caption).foregroundColor(.gray)
                }
                Text(content)
                    .fixedSize(horizontal: false, vertical: true) // 텍스트가 길어질 경우 줄바꿈
            }
        }
    }
}

struct QnaView_Previews: PreviewProvider {
    static var previews: some View {
        // Preview를 위해 임의의 ID를 전달
        QnaView(questionId: 1)
    }
}
