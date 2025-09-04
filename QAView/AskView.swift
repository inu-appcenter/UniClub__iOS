import SwiftUI

struct AskView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: QAViewModel // QAView에서 전달받은 ViewModel
    
    @State private var questionText = ""
    @State private var selectedClubId: Int? = 1 // 예시 ID, 실제로는 선택 UI 필요
    @State private var isAnonymous = false
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Navigation Bar
            HStack {
                Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                Spacer()
                Text("질문하기").font(.headline)
                Spacer()
                Image(systemName: "chevron.left").foregroundColor(.clear) // Title 중앙 정렬용
            }
            .padding()
            .background(Color.white)
            
            Divider()
            
            // MARK: - Main content area
            VStack(alignment: .leading, spacing: 20) {
                // TODO: 동아리 검색 및 선택 UI 구현
                // 예:
                // Text("질문할 동아리: Appcenter (예시)")
                //     .padding(.horizontal)
                
                // Question Text Editor
                ZStack(alignment: .topLeading) {
                    if questionText.isEmpty {
                        Text("동아리 부원들에게 궁금한 것을 물어보세요.")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                    }
                    TextEditor(text: $questionText)
                        .padding(.horizontal, 15)
                        .opacity(questionText.isEmpty ? 0.25 : 1)
                }
                
                Spacer()
            }
            .padding(.top, 20)
            
            // MARK: - Bottom Buttons
            HStack(spacing: 15) {
                Button(action: { isAnonymous.toggle() }) {
                    Text("익명")
                        .fontWeight(.semibold)
                        .foregroundColor(isAnonymous ? .orange : .gray)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(12)
                }
                
                Button(action: postQuestion) {
                    Text("등록하기")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid() ? Color.orange : Color.gray)
                        .cornerRadius(12)
                }
                .disabled(!isFormValid())
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .navigationBarHidden(true)
    }
    
    private func isFormValid() -> Bool {
        return !questionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && selectedClubId != nil
    }
    
    private func postQuestion() {
        guard let clubId = selectedClubId else { return }
        
        viewModel.postQuestion(clubId: clubId, content: questionText, isAnonymous: isAnonymous) { success in
            if success {
                presentationMode.wrappedValue.dismiss()
            } else {
                // TODO: 사용자에게 질문 등록 실패 알림
                print("질문 등록 실패")
            }
        }
    }
}

struct AskView_Previews: PreviewProvider {
    static var previews: some View {
        AskView()
            .environmentObject(QAViewModel()) // Preview를 위해 ViewModel 주입
    }
}
