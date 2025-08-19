import SwiftUI

struct QnaView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Navigation Bar
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                Spacer()
                Text("질의응답")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.clear)
                }
            }
            .padding()
            .background(Color.white)
            
            Divider()
            
            // MARK: - Main Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    QnaRowView(
                        profileImage: Image(systemName: "person.circle.fill"),
                        name: "홍길동",
                        date: "07.07 13:13",
                        content: "동아리 질문 작성 예시입니다.",
                        isReply: false
                    )
                    
                    HStack {
                        Spacer()
                        Text("...")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.vertical, -10)
                    
                    QnaRowView(
                        profileImage: Image(systemName: "person.circle.fill"),
                        name: "Appcenter",
                        date: "07.07 13:13",
                        content: "9월에 모집합니다",
                        isReply: true,
                        isVerified: true
                    )
                    
                    QnaRowView(
                        profileImage: Image(systemName: "person.circle.fill"),
                        name: "익명(작성자)",
                        date: "07.07 13:13",
                        content: "면접이 있을까요?",
                        isReply: true
                    )
                    
                    QnaRowView(
                        profileImage: Image(systemName: "person.circle.fill"),
                        name: "Appcenter",
                        date: "07.07 13:13",
                        content: "@@",
                        isReply: true,
                        isVerified: true
                    )
                }
                .padding()
            }
            
            Spacer()
            
            // MARK: - Reply Input Bar
            VStack {
                Divider()
                HStack(spacing: 15) {
                    Button(action: {}) {
                        Text("익명")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray5))
                            .cornerRadius(20)
                    }
                    HStack {
                        TextField("댓글을 입력하세요.", text: .constant(""))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
        }
        .background(Color(.systemGray6))
        .navigationBarHidden(true)
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
                .resizable()
                .frame(width: 35, height: 35)
                .foregroundColor(.gray)
                .padding(.top, 5)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(name).fontWeight(.semibold)
                    if isVerified {
                        Image(systemName: "checkmark.circle.fill").foregroundColor(.blue)
                    }
                    Text(date).font(.caption).foregroundColor(.gray)
                }
                Text(content).lineLimit(nil)
                HStack(spacing: 5) {
                    Spacer()
                    Button(action: {}) {
                        Text("답글쓰기").font(.caption).foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

struct QnaView_Previews: PreviewProvider {
    static var previews: some View {
        QnaView()
    }
}
