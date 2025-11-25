import SwiftUI

struct DepartmentSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedMajor: String

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("학과를 선택해주세요.")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    
                    // DepartmentData.colleges 데이터를 사용하여 단과대별 섹션 생성
                    ForEach(DepartmentData.colleges) { college in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(college.name)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 255/255, green: 102/255, blue: 0/255))
                                .padding(.horizontal)
                            
                            // 2열 그리드 레이아웃
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                ForEach(college.departments, id: \.self) { department in
                                    Button(action: {
                                        selectedMajor = department
                                        presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Text(department)
                                            .font(.subheadline)
                                            .foregroundColor(selectedMajor == department ? .white : .black)
                                            .padding(.vertical, 8)
                                            .frame(maxWidth: .infinity)
                                            .background(selectedMajor == department ? Color.black : Color.white)
                                            .cornerRadius(8)
                                            // 테두리 추가 (선택 안된 항목도 깔끔하게 보이도록)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 20)
                    }
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("닫기") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.black)
                }
            }
        }
    }
}

struct DepartmentSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DepartmentSelectionView(selectedMajor: .constant("컴퓨터공학과"))
    }
}
