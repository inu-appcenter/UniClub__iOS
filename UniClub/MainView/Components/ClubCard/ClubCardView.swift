//
//  ClubCardView.swift
//  UniClub
//
//  Created by 제욱 on 8/9/25.
//

import SwiftUI

struct ClubCard: View {
    let club: ClubCardModel
    let onLikeToggle: () -> Void
    
    var body: some View {
        ZStack {
            
            // 이미지 대신 플레이스홀더
            if let url = club.imageURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .empty:
                        Color.gray.opacity(0.25)  // 로딩 중
                    case .failure(_):
                        Color.gray.opacity(0.35)  // 실패 시
                    @unknown default:
                        Color.gray.opacity(0.25)
                    }
                }
                .frame(width: 136, height: 206)
                .clipShape(RoundedRectangle(cornerRadius: 17))
            } else {
                RoundedRectangle(cornerRadius: 17)
                    .fill(Color.white.opacity(0.55))
                    .frame(width: 136, height: 206)
            }
        }
        .overlay(alignment: .topLeading) {
            Text(club.name)
                .font(Font.custom("Noto Sans KR", size: 13).weight(.medium))
                .foregroundColor(.white)
                .frame(width: 72, alignment: .topLeading)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .padding(.top, 12)
                .padding(.leading, 12)
                .shadow(radius: 2) // 밝은 이미지 위 가독성 보조(원치 않으면 제거)
        }
        
        .overlay(alignment: .topTrailing) {
            Button(action: onLikeToggle) {
                Image(systemName: club.isLiked ? "heart.fill" : "heart")
                    .font(.title3)
                    .foregroundColor(club.isLiked ? .red : .white)
                    .shadow(radius: 2) // 밝은 배경 대비
                    .padding(8)
            }
            .buttonStyle(.plain)
            .padding(.top, 6)
            .padding(.trailing, 6)
        }
        .contentShape(RoundedRectangle(cornerRadius: 17))
    }
}


struct ClubCardView: View {
    @StateObject private var vm = ClubCardViewModel()

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(vm.clubs) { item in
                    ClubCard(
                        club: item,
                        onLikeToggle: { vm.toggleLike(for: item.id) }
                    )
                    .onAppear {
                        vm.loadMoreIfNeeded(currentItem: item)
                    }
                }
                
                if vm.isLoadingMore {
                    ProgressView()
                        .frame(width: 120, height: 120)
                    
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}

struct ClubCardView_Previews: PreviewProvider {
    static var previews: some View {
        ClubCardView()
            .previewLayout(.sizeThatFits)
    }
}
