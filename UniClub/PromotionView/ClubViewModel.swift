import Foundation
import SwiftUI

class ClubViewModel: ObservableObject {
    @Published var clubName: String = "크레퍼스(CREPERS)"
    @Published var recruitmentStatus: String = "모집 중"
    @Published var clubRoom: String = "17호관 414호"
    @Published var president: String = "이석준"
    @Published var contact: String = "010.1234.5678"
    @Published var recruitmentPeriod: String = "7월 16일 ~ 24일 오후 6시"
    @Published var notice: String = "25일 동아리실 출입금지"
    @Published var introduction: String = "이 글은 동아리 소개 게시글입니다. 저희 동아리는 전공과 학년을 넘어 다양한 사람들이 모여 공동의 관심사를 나누고, 함께 경험을 쌓아가는 공간입니다. 활동 하나하나에 진심을 담고, 소소한 일상도 특별하게 만드는 우리! 처음이라도 괜찮아요. 언제든 환영합니다. 당신의 자리를 만들어드릴게요."
}
