import SwiftUI

struct login: View {
    @State private var studentID = ""
    @State private var password = ""
    
    // 회원가입 화면 활성화 여부를 제어할 상태 변수
    @State private var isSignUpLinkActive = false

    var body: some View {
        NavigationView {
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
                    APIService.shared.login(studentID: studentID, password: password) { result in
                        switch result {
                        case .success(let response):
                            print("로그인 성공! 토큰: \(response.accessToken)")
                        case .failure(let error):
                            print("로그인 실패: \(error.localizedDescription)")
                        }
                    }
                }) {
                    Image("Frame 36")
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 30)
                .padding(.top, 30)

                // Sign Up Button with NavigationLink
                NavigationLink(
                    destination: SignUp(isSignUpLinkActive: $isSignUpLinkActive), // 바인딩 전달
                    isActive: $isSignUpLinkActive // 상태 변수와 연결
                ) {
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

struct login_Previews: PreviewProvider {
    static var previews: some View {
        login()
    }
}
