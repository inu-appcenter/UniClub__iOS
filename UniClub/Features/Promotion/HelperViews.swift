import SwiftUI

// 정보 표시 행 (라벨 + 내용)
struct InfoRow: View {
    let label: String
    let content: String

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(width: 80, alignment: .leading)
            Text(content)
                .font(.subheadline)
        }
    }
}

// 정보 수정 행 (라벨 + 텍스트 필드)
struct EditInfoRow: View {
    let label: String
    let placeholder: String
    @State private var text: String = ""

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(width: 80, alignment: .leading)
            TextField(placeholder, text: $text)
        }
    }
}
