import SwiftUI

struct TermsOfServiceView: View {
    // SignUp 뷰에서 전달받을 데이터
    @State var studentID: String
    @State var password: String
    @State var name: String
    @State var major: String
    
    // 1. SignUp 뷰에서 받을 바인딩 변수 (네비게이션 제어용)
    @Binding var isSignUpLinkActive: Bool
    
    // 2. "다시 입력"을 위한 presentationMode (현재 화면 닫기)
    @Environment(\.presentationMode) var presentationMode
    
    // 약관 동의 상태
    @State private var isPersonalInfoAgreed = false
    @State private var isMarketingAgreed = false
    
    // 3. 하단 모달(이미 가입된 회원 알림) 표시 여부 상태
    @State private var showAlreadyRegisteredAlert = false
    
    // 스크롤 가능한 약관 내용 (줄바꿈 처리를 위해 Text에 그대로 넣습니다)
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
        // 4. ZStack으로 뷰를 감싸서 모달을 띄울 준비를 합니다.
        ZStack {
            // --- 메인 컨텐츠 (VStack) ---
            VStack {
                Text("서비스 이용약관")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                // 약관 내용 스크롤 뷰
                ScrollView {
                    Text(termsOfServiceContent)
                        .font(.body)
                        .foregroundColor(.black)
                        .padding()
                }
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // 체크박스 영역
                VStack(spacing: 0) {
                    AgreementCheckmarkView(
                        text: "(필수) 개인정보 수집 및 이용 동의",
                        isAgreed: $isPersonalInfoAgreed
                    )
                    AgreementCheckmarkView(
                        text: "(선택) 마케팅 정보 수신 동의",
                        isAgreed: $isMarketingAgreed
                    )
                }
                .padding(.top, 20)
                .padding(.horizontal)
                
                Spacer()
                
                // 회원가입 완료 버튼
                Button("회원가입 완료") {
                                    APIService.shared.register(
                                        studentID: studentID,
                                        name: name,
                                        major: major,
                                        password: password,
                                        personalInfoAgreed: isPersonalInfoAgreed,
                                        marketingAgreed: isMarketingAgreed
                                    ) { result in
                                        switch result {
                                        case .success:
                                            print("회원가입 성공!")
                                            self.isSignUpLinkActive = false
                                            
                                        case .failure(let error):
                                            // 에러 처리: AuthError를 스위치로 처리하여 Equatable 요구를 피함
                                            if let apiError = error as? AuthError {
                                                switch apiError {
                                                case .userAlreadyExists:
                                                    self.showAlreadyRegisteredAlert = true
                                                default:
                                                    print("회원가입 실패: \(error.localizedDescription)")
                                                }
                                            } else {
                                                print("회원가입 실패: \(error.localizedDescription)")
                                            }
                                        }
                                    }
                                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(isPersonalInfoAgreed ? Color.black : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .disabled(!isPersonalInfoAgreed) // 필수 항목 동의 전까지 비활성화
            }
            .padding(.vertical)
            .navigationTitle("약관 동의")
            
            // --- 7. 하단 모달 오버레이 (ZStack의 맨 위) ---
            if showAlreadyRegisteredAlert {
                // 반투명 검은 배경
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        // 배경 터치 시 닫고 싶으면 아래 주석 해제
                        // self.showAlreadyRegisteredAlert = false
                    }
                
                // 모달 컨텐츠
                VStack(spacing: 0) {
                    Spacer() // 컨텐츠를 화면 하단으로 밀어냄
                    
                    VStack(alignment: .center, spacing: 20) {
                        Text("이미 가입된 회원입니다.")
                            .font(.system(size: 18, weight: .bold))
                        
                        // 요청하신 문구로 수정됨
                        Text("로그인하거나 학번 또는 비밀번호를\n다시 확인해 주세요.")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .padding(.bottom, 10)
                        
                        // "다시 입력" 버튼 (이전 화면인 SignUp 뷰로 돌아가기)
                        Button(action: {
                            self.showAlreadyRegisteredAlert = false // 모달 닫기
                            self.presentationMode.wrappedValue.dismiss() // TermsOfServiceView 닫기
                        }) {
                            Text("다시 입력")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(10)
                        }
                        
                        // "로그인" 버튼 (초기 화면인 login 뷰로 돌아가기)
                        Button(action: {
                            self.showAlreadyRegisteredAlert = false // 모달 닫기
                            self.isSignUpLinkActive = false // 네비게이션 스택 초기화 (Pop to Root)
                        }) {
                            Text("로그인")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 255/255, green: 102/255, blue: 0/255)) // 주황색
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 30)
                    .padding(.bottom, 40) // Safe Area 고려한 하단 여백
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.2), radius: 10, y: -5)
                    .padding(.horizontal, 10) // 화면 좌우 여백
                }
                .transition(.move(edge: .bottom).combined(with: .opacity)) // 아래에서 올라오는 애니메이션
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showAlreadyRegisteredAlert) // 모달 등장/퇴장 애니메이션
    }
}
