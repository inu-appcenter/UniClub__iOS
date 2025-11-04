import SwiftUI

struct TermsOfServiceView: View {
    // SignUp 뷰에서 전달받을 데이터
    @State var studentID: String
    @State var password: String
    @State var name: String
    @State var major: String
    
    // 약관 동의 상태
    @State private var isAgreed = false
    
    // 스크롤 가능한 약관 내용
    private let termsOfServiceContent = """
        [서비스 이용약관]

        제1조 (목적)
        이 약관은 UniClub(이하 “회사”)이 제공하는 UniClub 서비스(이하 “서비스”)의 이용과 관련하여 회사와 회원 간의 권리, 의무 및 책임 사항, 기타 필요한 사항을 규정함을 목적으로 합니다.

        제2조 (정의)
        1. “회원”이라 함은 회사의 서비스에 접속하여 이 약관에 따라 회사와 이용계약을 체결하고 회사가 제공하는 서비스를 이용하는 고객을 말합니다.
        2. “서비스”라 함은 구현되는 단말기(PC, 휴대용 단말기 등의 각종 유무선 장치를 포함)와 상관없이 회원이 이용할 수 있는 회사가 제공하는 모든 관련 서비스를 의미합니다.

        제3조 (약관의 효력 및 변경)
        1. 이 약관은 서비스를 이용하고자 하는 모든 회원에 대하여 그 효력을 발생합니다.
        2. 회사는 약관의 규제에 관한 법률 등 관련 법령을 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다.
        ... (실제 약관 내용이 들어갑니다. 스크롤 가능)
        
        ---
        
        [개인정보 수집 및 이용 동의]

        앱(이하 "서비스")는 고객님의 개인정보 보호를 중요하게 생각하며, 관련 법령을 준수하고 있습니다. 서비스 회원가입을 위해 아래와 같이 개인정보 수집 및 이용에 동의해 주시기 바랍니다.

        1. 수집하는 개인정보 항목
            - 필수항목: 이름, 연락처(휴대폰 번호), 이메일, 생년월일, 성별, 서비스 이용 기록
            - 선택항목: 프로필 사진

        2. 개인정보의 수집 및 이용 목적
            - 회원관리: 서비스 이용을 위한 회원 인증 및 본인 확인
            - 마케팅 및 광고: 서비스 이용 통계 분석 및 이벤트 정보 제공 (선택적 동의)

        3. 개인정보 보유 및 이용 기간
            - 서비스 탈퇴 시까지 보유하며, 탈퇴 후 즉시 삭제됩니다. 단, 관련 법령에 따라 일정 기간 보관이 필요할 경우, 해당 기간 동안 저장됩니다.

        4. 동의 거부 권리 및 동의 거부 시 불이익
            - 회원가입을 위한 필수항목에 대한 동의를 거부하실 수 있으나, 이 경우 회원가입 및 서비스 이용이 제한될 수 있습니다.
    """
    
    var body: some View {
        VStack {
            Text("서비스 이용약관")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            ScrollView {
                Text(termsOfServiceContent)
                    .font(.body)
                    .foregroundColor(.black)
                    .padding()
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            HStack {
                Button(action: {
                    isAgreed.toggle()
                }) {
                    Image(systemName: isAgreed ? "checkmark.square.fill" : "square")
                        .foregroundColor(isAgreed ? .blue : .gray)
                }
                Text("이용약관 및 개인정보 수집에 동의합니다.")
                    .font(.subheadline)
            }
            .padding(.top, 20)
            
            Button("회원가입 완료") {
                // 회원가입 완료 버튼 동작
                APIService.shared.register(studentID: studentID, name: password, major: name, password: major) { result in
                    switch result {
                    case .success:
                        print("회원가입 성공!")
                        // 성공 후 다음 화면으로 이동
                    case .failure(let error):
                        print("회원가입 실패: \(error.localizedDescription)")
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isAgreed ? Color.black : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .disabled(!isAgreed) // 동의해야 버튼 활성화
        }
        .padding(.vertical)
        .navigationTitle("약관 동의")
    }
}
