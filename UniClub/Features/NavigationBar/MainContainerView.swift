import SwiftUI

struct MainContainerView: View {
    @State private var selection: MainTab = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selection {
                case .qna:
                    QnaView()
                case .home:
                    HomeView()
                case .mypage:
                    MyPageView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            NavigationBottomBar(selection: $selection)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    MainContainerView()
}
