import SwiftUI

@main
struct UniClubApp: App {
    init() {
        // 모든 요청에 Authorization 자동 주입
        HTTPClient.shared.authTokenProvider = { MyAuthStore.shared.accessToken }

        // ====== 개발용(디버그) 하드코딩 토큰 ======
        // 출시할 땐 이 줄만 주석 처리하거나 빈 문자열로 두세요.
        #if DEBUG
        MyAuthStore.shared.accessToken = ""  // "Bearer " 없이 순수 JWT
        #endif
        // =======================================
    }

    var body: some Scene {
        WindowGroup {
            ClubDetailView(clubId: 1)
            //MainView()
        }
    }
}
