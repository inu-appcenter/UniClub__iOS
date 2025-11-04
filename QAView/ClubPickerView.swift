import SwiftUI

// [수정] ClubInfo 모델의 id 타입을 Int로 변경
struct ClubInfo: Identifiable, Equatable {
    let id: Int
    let name: String
    let category: String
}

struct ClubPickerView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // 동아리 선택이 완료되었을 때 호출될 클로저
    var onClubSelected: (ClubInfo) -> Void
    
    @State private var searchText = ""
    @State private var selectedClub: ClubInfo?
    
    // [수정] 예시 동아리 데이터에 Int 타입 id 추가
    let allClubs: [ClubInfo] = [
        ClubInfo(id: 1, name: "하늬울림", category: "문화분과"),
        ClubInfo(id: 2, name: "인형극회", category: "문화분과"),
        ClubInfo(id: 3, name: "INSDIES", category: "문화분과"),
        ClubInfo(id: 4, name: "젊은영상", category: "문화분과"),
        ClubInfo(id: 5, name: "IUDC", category: "문화분과"),
        ClubInfo(id: 6, name: "합성", category: "문화분과"),
        ClubInfo(id: 7, name: "크레퍼스", category: "문화분과"),
        ClubInfo(id: 8, name: "파이오니아", category: "문화분과"),
        ClubInfo(id: 9, name: "포크라인", category: "문화분과"),
        ClubInfo(id: 10, name: "INUO", category: "문화분과"),
        ClubInfo(id: 11, name: "울림", category: "문화분과")
    ]
    
    // 검색 필터링된 동아리 목록
    var filteredClubs: [ClubInfo] {
        if searchText.isEmpty {
            return allClubs
        } else {
            return allClubs.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - 상단 바
            HStack {
                Spacer()
                Text("질문하기")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                Button("취소") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding()
            
            // MARK: - 검색창
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("질문할 동아리를 검색하세요.", text: $searchText)
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                    }
                }
            }
            .foregroundColor(.gray)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)

            // MARK: - 동아리 목록
            ScrollView {
                if let club = selectedClub {
                    ClubPickerRow(club: club, isSelected: true) {
                        self.selectedClub = nil
                    }
                } else {
                    ForEach(filteredClubs) { club in
                        ClubPickerRow(club: club, isSelected: false) {
                            self.selectedClub = club
                        }
                    }
                }
            }
            .padding(.top)
            Spacer()
            
            // MARK: - 선택 버튼
            if let clubToConfirm = selectedClub {
                Button(action: {
                    onClubSelected(clubToConfirm)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("선택")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
    }
}

// MARK: - ClubPickerRow
struct ClubPickerRow: View {
    let club: ClubInfo
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(club.name)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isSelected ? .orange : .black)
                    Text(club.category)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal)
        }
    }
}
