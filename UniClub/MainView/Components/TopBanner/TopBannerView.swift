import SwiftUI

struct TopBannerView: View {
    @StateObject private var vm = TopBannerViewModel()
    @State private var index = 0
    @State private var isActive = true

    var body: some View {
        ZStack {
            if vm.items.isEmpty {
                Color.gray.opacity(0.2)
                    .frame(width: 324, height: 249)
                    .cornerRadius(21)
            } else {
                TabView(selection: $index) {
                    ForEach(vm.items.prefix(5)) { item in
                        AsyncImage(url: item.imageURL) { phase in
                            switch phase {
                            case .success(let img): img.resizable().scaledToFill()
                            case .empty: Color.gray.opacity(0.3)
                            case .failure: Color.gray.opacity(0.35)
                            @unknown default: Color.gray.opacity(0.3)
                            }
                        }
                        .frame(width: 324, height: 249)
                        .clipped()
                        .cornerRadius(21)
                        .tag(item.id)
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .automatic))
                .frame(width: 324, height: 249)
            }
        }
        .onAppear { isActive = true }
        .onDisappear { isActive = false }
        .onReceive(Timer.publish(every: 3, on: .main, in: .common).autoconnect()) { _ in
            guard isActive, !vm.items.isEmpty else { return }
            withAnimation(.easeInOut) {
                let ids = Array(vm.items.prefix(5)).map(\.id)
                if let pos = ids.firstIndex(of: index) {
                    index = ids[(pos + 1) % ids.count]
                } else {
                    index = ids.first ?? 0
                }
            }
        }
    }
}

#Preview {
    TopBannerView()
}
