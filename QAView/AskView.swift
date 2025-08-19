import SwiftUI

struct AskView: View {
    // Environment variable to dismiss the view
    @Environment(\.presentationMode) var presentationMode
    
    @State private var searchText = ""
    @State private var selectedClub = "동아리 선택"
    @State private var questionText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Navigation Bar
            HStack {
                // Custom back button action
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                Spacer()
                Text("질문하기")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                // Placeholder to center the title
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.clear)
                }
            }
            .padding()
            .background(Color.white)
            
            // Separator line
            Divider()
            
            // Main content area
            VStack(alignment: .leading, spacing: 20) {
                
                // Search Bar
                HStack {
                    TextField("질문할 동아리를 검색하세요.", text: $searchText)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                // Club Selection Dropdown
                HStack {
                    Text(selectedClub)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .onTapGesture {
                    // Action for selecting club
                }
                .padding(.horizontal)
                
                // Question Text Editor
                ZStack(alignment: .topLeading) {
                    if questionText.isEmpty {
                        Text("동아리 부원들에게 궁금한 것을 물어보세요.")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 8)
                    }
                    TextEditor(text: $questionText)
                        .frame(minHeight: 150)
                        .opacity(questionText.isEmpty ? 0.25 : 1)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            
            // Bottom Buttons
            HStack {
                Button(action: {}) {
                    Text("익명")
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(12)
                }
                
                Button(action: {}) {
                    Text("등록하기")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .background(Color(.systemGray6))
        .ignoresSafeArea(.keyboard)
        .navigationBarHidden(true) // Hides the default navigation bar
    }
}

struct AskView_Previews: PreviewProvider {
    static var previews: some View {
        AskView()
    }
}
