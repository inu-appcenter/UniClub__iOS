//
//  QnaSerachClubViewModel.swift
//  UniClub
//
//  Created by 제욱 on 11/8/25.
//

import Foundation

final class SearchClubViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var clubs: [ClubInfo] = []
    
    private let service: QnaService
    
    init(service: QnaService = .init()) {
        self.service = service
    }
    
    /// 서버에서 동아리 검색
    @MainActor
    func search(keyword: String) {
        Task {
            isLoading = true
            errorMessage = nil
            
            do {
                // 1) 서버에서 DTO 배열 받아오기
                let dtoList = try await service.searchClubs(keyword: keyword)
                
                // 2) 화면에서 쓰기 편한 Domain 모델(ClubInfo)로 매핑
                self.clubs = dtoList.map {
                    ClubInfo(
                        id: $0.clubId,
                        name: $0.clubName,
                        category: $0.categoryType
                    )
                }
            } catch let apiError as APIError {
                self.errorMessage = apiError.errorDescription ?? "동아리 목록을 불러오지 못했습니다."
                print("SearchClubViewModel APIError:", apiError)
            } catch {
                self.errorMessage = "동아리 목록을 불러오지 못했습니다."
                print("SearchClubViewModel Unknown error:", error)
            }
            
            isLoading = false
        }
    }
}
