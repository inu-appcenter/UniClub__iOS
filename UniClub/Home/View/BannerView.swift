import SwiftUI

struct BannerView: View {
    @StateObject private var vm = BannerViewModel()
    @State private var selectedID: Int = 0
    @State private var isActive = true
    private let bannerAspect: CGFloat = 324.0/249.0
    private let bannerCorner: CGFloat = 20
    
    var body: some View {
        ZStack {
            if vm.items.isEmpty {
                Image("empty_banner")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity) // 화면 크기에 따라 자동 조정
                    .padding(.horizontal, 18)
            } else {
                TabView(selection: $selectedID) {
                    ForEach(vm.items) { item in
                        AsyncImage(url: item.imageURL) { phase in
                            switch phase {
                            case .success(let img): img.resizable().scaledToFill()
                            case .empty: Color.gray.opacity(0.3)
                            case .failure: Color.gray.opacity(0.35)
                            @unknown default: Color.gray.opacity(0.3)
                            }
                        }
                        .aspectRatio(324 / 249, contentMode: .fit) // 기존 비율 유지
                        .clipShape(RoundedRectangle(cornerRadius: 21))
                        .scaledToFit()
                        .tag(item.id)
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .automatic))
            }
        }
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
