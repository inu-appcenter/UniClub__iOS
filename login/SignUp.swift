import SwiftUI

struct Signup: View {
    @State private var studentID = ""
    @State private var password = ""
    @State private var name = ""
    @State private var major = "학과를 선택해주세요."
    @State private var isStudentVerified = false

    // 학과 목록
    let majors = ["컴퓨터공학과", "전자공학과", "기계공학과", "디자인학과", "경영학과", "건축학과"]

    var body: some View {
        ZStack {
            // 전체 배경을 흰색으로 설정
            Color(red: 247/255, green: 247/255, blue: 247/255).edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading, spacing: 20) {
                Text("UniClub")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                    .padding(.top, 50)
                
                // "학교 포털 계정을 입력해주세요." 텍스트 박스
                HStack(spacing: 10) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.white)
                    Text("학교 포털 계정을 입력해주세요.")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color(red: 255/255, green: 102/255, blue: 0/255))
                .cornerRadius(10)
            
                // 학번 입력 필드
                Text("학번을 입력해주세요.")
                    .font(.subheadline)
                    .foregroundColor(.black)
                TextField("", text: $studentID)
                    .foregroundColor(.black)
                    .padding(.bottom, 10)
                    .overlay(Divider().background(Color.gray), alignment: .bottom)
            
                // 비밀번호 입력 필드
                Text("비밀번호를 입력해주세요.")
                    .font(.subheadline)
                    .foregroundColor(.black)
                SecureField("", text: $password)
                    .foregroundColor(.black)
                    .padding(.bottom, 10)
                    .overlay(Divider().background(Color.gray), alignment: .bottom)

                Spacer()
                // 이름 입력 필드 (조건부)
                Text("이름을 입력해주세요.")
                    .font(.subheadline)
                    .foregroundColor(isStudentVerified ? .black : .gray)
                TextField("이름을 입력해주세요", text: $name)
                    .foregroundColor(.black)
                    .padding(.bottom, 10)
                    .overlay(Divider().background(isStudentVerified ? Color.gray : Color.clear), alignment: .bottom)
                    .disabled(!isStudentVerified)
                
                // 학과 선택 리스트 (사진 기반 디자인 적용)
                Text("학과를 선택해주세요.")
                    .font(.subheadline)
                    .foregroundColor(isStudentVerified ? .black : .gray)
                
                Menu {
                    ForEach(majors, id: \.self) { major in
                        Button(action: {
                            self.major = major
                        }) {
                            Text(major)
                        }
                    }
                } label: {
                    HStack {
                        Text(major)
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(width: 300, height: 40)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .disabled(!isStudentVerified)
                
                // 조건부 버튼
                if isStudentVerified {
                    // 재학생 확인이 완료되면 '다음으로' 버튼이 나타남
                    Button(action: {
                        // "다음으로" 버튼 클릭 시 동작
                    }) {
                        Text("다음")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 150)
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)
                } else {
                    // 재학생 확인이 완료되지 않았으면 '재학생 확인' 버튼이 나타남
                    Button(action: {
                        if !studentID.isEmpty && !password.isEmpty {
                            isStudentVerified = true
                        }
                    }) {
                        HStack {
                            Text("재학생 확인")
                        }
                        .font(.headline)
                        .foregroundColor(
                            !studentID.isEmpty && !password.isEmpty ? .white : .black
                        )
                        .padding()
                        .frame(maxWidth: 150)
                        .background(
                            !studentID.isEmpty && !password.isEmpty ?
                                Color.black : Color.gray.opacity(0.5)
                        )
                        .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(studentID.isEmpty || password.isEmpty)
                    .padding(.top, 20)
                }
                
                Spacer()
            }
            .padding(.horizontal, 30)
        }
    }
}

struct Signup_Previews: PreviewProvider {
    static var previews: some View {
        Signup()
    }
}
