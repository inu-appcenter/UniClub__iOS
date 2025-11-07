import SwiftUI

struct BannerView: View {
    @StateObject private var vm = BannerViewModel()
    @State private var selectedID: Int = 0
    @State private var isActive = true
    private let bannerAspect: CGFloat = 324.0 / 249.0    // 가로/세로 비율 (Figma 기준 324:249)
    private let bannerCorner: CGFloat = 20

    var body: some View {
        // ScrollView 안에 있는 TabView는 높이를 명시해 주는 게 안전함
        let screenWidth = UIScreen.main.bounds.width
        let horizontalPadding: CGFloat = 18
        let bannerWidth = screenWidth - horizontalPadding * 2
        let bannerHeight = bannerWidth / bannerAspect

        ZStack {
            if vm.items.isEmpty {
                Image("empty_banner")
                    .resizable()
                    .scaledToFill()
                    .frame(width: bannerWidth, height: bannerHeight)
                    .clipShape(RoundedRectangle(cornerRadius: bannerCorner, style: .continuous))
                    .padding(.horizontal, horizontalPadding)
            } else {
                TabView(selection: $selectedID) {
                    ForEach(vm.items) { item in
                        AsyncImage(url: item.imageURL) { phase in
                            switch phase {
                            case .success(let img):
                                img.resizable().scaledToFill()
                            case .empty:
                                Color.gray.opacity(0.3)
                            case .failure:
                                Color.gray.opacity(0.35)
                            @unknown default:
                                Color.gray.opacity(0.3)
                            }
                        }
                        .frame(width: bannerWidth, height: bannerHeight)
                        .clipShape(RoundedRectangle(cornerRadius: bannerCorner, style: .continuous))
                        .tag(item.id)
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .automatic))
                .frame(width: bannerWidth, height: bannerHeight)   // ✅ TabView 자체 높이 확실히 지정
                .padding(.horizontal, horizontalPadding)
            }
        }
        // 전체 배너 뷰 높이도 고정해 줌 (ScrollView 안에서 쪼그라드는 것 방지)
        .frame(height: bannerHeight)
        .onAppear { Task { await vm.load() } }
        .onDisappear { isActive = false }
        .onReceive(Timer.publish(every: 3, on: .main, in: .common).autoconnect()) { _ in
            guard isActive, !vm.items.isEmpty else { return }
            withAnimation(.easeInOut) {
                let ids = vm.items.map(\.id)
                if let pos = ids.firstIndex(of: selectedID) {
                    selectedID = ids[(pos + 1) % ids.count]
                } else {
                    selectedID = ids.first ?? 0
                }
            }
        }
    }
}

#Preview {
    BannerView()
        .background(Color.gray)
}
