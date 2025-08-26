import SwiftUI

struct Login: View {
    @State private var studentID = ""
    @State private var password = ""

    var body: some View {
        NavigationStack {  // 화면 전환을 위해 NavigationStack 사용
            VStack {
                // UniClub Logo
                Image("UniClub")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 255/255, green: 102/255, blue: 0/255))
                    .padding(.bottom, 50)
                Spacer()
                Spacer()

                // Student ID Field
                VStack(alignment: .leading) {
                    Text("학번")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    TextField("", text: $studentID)
                        .padding(.bottom, 10)
                        .overlay(Divider(), alignment: .bottom)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 20)

                // Password Field
                VStack(alignment: .leading) {
                    Text("비밀번호")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    SecureField("", text: $password)
                        .padding(.bottom, 10)
                        .overlay(Divider(), alignment: .bottom)
                }
                .padding(.horizontal, 30)

                // Login Button
                Button(action: {
                    // 로그인 동작 처리
                }) {
                    Image("Frame 36")
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 30)
                .padding(.top, 30)

                // 회원가입 버튼 → NavigationLink로 Signup 화면으로 이동
                NavigationLink(destination: Signup()) {
                    Text("회원가입")
                        .foregroundColor(.black)
                        .padding(.vertical, 10)
                }
                .padding(.top, 20)

                Spacer()
            }
            .padding(.top, 50)
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
