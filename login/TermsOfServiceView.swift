import SwiftUI

struct TermsOfServiceView: View {
    @State private var isPrivacyPolicyAgreed: Bool = false
    @State private var isMarketingAgreed: Bool = false
    @State private var isLoading = false
    @State private var alertMessage: String?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // var로 선언하여 값을 변경할 수 있도록 수정
    @State var signupRequest: SignupRequest
    
    private var isNextButtonEnabled: Bool {
        return isPrivacyPolicyAgreed && isMarketingAgreed
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    .padding(.leading, 10)
                    
                    Spacer()
                    Text("와이파이 배터리등 표시공간")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.top, 10)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("UniClub").font(.largeTitle).fontWeight(.bold)
                    Text("이용약관").font(.title).fontWeight(.bold)
                }
                .padding(.horizontal)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("회원가입 시 개인정보 수집 및 이용 동의").fontWeight(.bold)
                        Text("개인정보 수집 및 이용 동의서").fontWeight(.bold)
                        Text("앱(이하 “서비스”)는 고객님의 개인정보 보호를 중요하게 생각하며, 관련 법령을 준수하고 있습니다. 서비스 회원가입을 위해 아래와 같이 개인정보 수집 및 이용에 동의해 주시기 바랍니다.").font(.footnote).foregroundColor(.gray)
                        Text("1. 수집하는 개인정보 항목").fontWeight(.bold).padding(.top, 10)
                        Text("- 필수항목: 이름, 연락처(휴대폰 번호), 이메일, 생년월일, 성별, 서비스 이용 기록\n- 선택항목: 프로필 사진").font(.footnote).foregroundColor(.gray)
                        Text("2. 개인정보의 수집 및 이용 목적").fontWeight(.bold).padding(.top, 10)
                        Text("- 회원관리: 서비스 이용을 위한 회원 인증 및 본인 확인\n- 마케팅 및 광고: 서비스 이용 통계 분석 및 이벤트 정보 제공 (선택적 동의)").font(.footnote).foregroundColor(.gray)
                        Text("3. 개인정보 보유 및 이용 기간").fontWeight(.bold).padding(.top, 10)
                        Text("- 서비스 탈퇴 시까지 보유하며, 탈퇴 후 즉시 삭제됩니다. 단, 관련 법령에 따라 일정 기간 보관이 필요할 경우, 해당 기간 동안 저장됩니다.").font(.footnote).foregroundColor(.gray)
                        Text("4. 동의의 거부 권리 및 동의의 거부 시 불이익").fontWeight(.bold).padding(.top, 10)
                        Text("- 회원가입을 위한 필수항목에 대한 동의를 거부하실 수 있으나, 이 경우 회원가입 및 서비스 이용이 제한될 수 있습니다.").font(.footnote).foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("이용약관에 동의해 주세요.").font(.headline).fontWeight(.bold)
                    
                    AgreementCheckmarkView(text: "(필수) 개인정보 수집 및 이용에 동의합니다.", isAgreed: $isPrivacyPolicyAgreed)
                    
                    AgreementCheckmarkView(text: "(선택) 마케팅 및 광고 활용에 동의합니다.", isAgreed: $isMarketingAgreed)
                }
                .padding(.horizontal)
                
                Button(action: {
                    Task {
                        await performSignup()
                    }
                }) {
                    Text("다음")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isNextButtonEnabled ? Color.black : Color.gray)
                        .cornerRadius(10)
                }
                .disabled(!isNextButtonEnabled || isLoading)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
            .alert(isPresented: .constant(alertMessage != nil)) {
                Alert(title: Text("알림"), message: Text(alertMessage ?? "알 수 없는 오류"), dismissButton: .default(Text("확인")) {
                    alertMessage = nil
                })
            }
            
            if isLoading {
                ProgressView()
                    .frame(width: 100, height: 100)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(10)
            }
        }
    }
    
    private func performSignup() async {
        isLoading = true
        defer { isLoading = false }
        
        var finalRequest = signupRequest
        finalRequest.personalInfoCollectionAgreement = isPrivacyPolicyAgreed
        finalRequest.marketingAdvertisement = isMarketingAgreed
        
        do {
            try await APIService.shared.register(request: finalRequest)
            DispatchQueue.main.async {
                self.alertMessage = "회원가입에 성공했습니다!"
            }
        } catch {
            DispatchQueue.main.async {
                self.alertMessage = error.localizedDescription
            }
        }
    }
}
