// filepath: /Users/jw/MyDeveloper/iOSProject/UniClub clean/UniClub/UniClub/Features/MyPage/Model/MyPageViewModel.swift
// Generated/updated to integrate with project's HTTPClient and DTOs

import Foundation

// Domain model used by MyPageView
struct MyPageModel: Identifiable, Equatable, Codable {
    var id: String { studentId }

    let nickname: String
    let name: String
    let studentId: String
    let major: String
    let profileImageURL: URL?

    static let sample = MyPageModel(
        nickname: "jw",
        name: "제욱",
        studentId: "20201234",
        major: "Computer Science",
        profileImageURL: URL(string: "https://example.com/profile.jpg")
    )
}


@MainActor
final class MyPageViewModel: ObservableObject {

    @Published private(set) var mypage: MyPageModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let service: MyPageServiceProtocol

    init(service: MyPageServiceProtocol = MyPageService()) {
        self.service = service
    }

    func fetch() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let model = try await service.fetchMyPage()
            self.mypage = model
        } catch {
            self.errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }
}

// MARK: - Networking

protocol MyPageServiceProtocol {
    func fetchMyPage() async throws -> MyPageModel
}

// Implementation that uses the project's HTTPClient and DTOs
struct MyPageService: MyPageServiceProtocol {
    init() {}

    func fetchMyPage() async throws -> MyPageModel {
        // Use shared HTTPClient; it will use AppConfig.baseURL and auth token if configured
        let dto: UserProfileDTO = try await HTTPClient.shared.get(AppConfig.API.User.me, as: UserProfileDTO.self)

        let model = MyPageModel(
            nickname: dto.nickname ?? "",
            name: dto.name,
            studentId: dto.studentId ?? "",
            major: dto.major ?? "",
            profileImageURL: dto.profileURL
        )
        return model
    }
}

// Mock for previews/tests
struct MockMyPageService: MyPageServiceProtocol {
    let model: MyPageModel
    init(model: MyPageModel = .sample) { self.model = model }
    func fetchMyPage() async throws -> MyPageModel { return model }
}
