import SwiftUI

struct AgreementCheckmarkView: View {
    let text: String
    @Binding var isAgreed: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: {
                isAgreed.toggle()
            }) {
                Image(systemName: isAgreed ? "checkmark" : "")
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundColor(.black)
                    .padding(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.gray, lineWidth: 1) // 테두리 색상 유지 또는 조정
                    )
            }
            Text(text)
                .font(.subheadline)
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(Color(.systemGray6)) // ⭐️ 학과 리스트 배경색과 동일하게 변경
        .cornerRadius(10)
    }
}
