<<<<<<< HEAD:UniClub/Features/Login/DepartmentData.swift
=======
// DepartmentData.swift

>>>>>>> be26fb7 (promotion view change):login/DepartmentData.swift
import Foundation

struct DepartmentData {
    static let colleges: [College] = [
        College(name: "인문대학", departments: ["국어국문학과", "영어영문학과", "독어독문학과", "불어불문학과", "일어일문학과", "중국학과"]),
        College(name: "자연과학대학", departments: ["수학과", "물리학과", "화학과", "패션산업학과", "해양학과"]),
        College(name: "사회과학대학", departments: ["사회복지학과", "미디어커뮤니케이션학과", "문헌정보학과", "창의인재개발학과"]),
        College(name: "글로벌경영대학", departments: ["행정학과", "정치외교학과", "경제학과", "무역학부", "소비자학과"]),
<<<<<<< HEAD:UniClub/Features/Login/DepartmentData.swift
        College(name: "공과대학", departments: ["기계공학과", "신소재공학과", "메카트로닉스공학과", "산업경영공학과", "전자공학과", "에너지화학공학과", "전기공학과", "안전공학과", "환경공학과", "생명공학과", "나노바이오공학과"]),
        College(name: "정보기술대학", departments: ["컴퓨터공학부", "정보통신공학과", "전자공학과", "임베디드시스템공학과"]),
        College(name: "경영대학", departments: ["경영학부", "회계세무학과", "무역학부", "재무부동산학과", "융합기술경영학과"]),
        College(name: "예술체육대학", departments: ["조형예술학부", "디자인학부", "공연예술학과", "체육학부"]),
        College(name: "사범대학", departments: ["국어교육과", "영어교육과", "일어교육과", "불어교육과", "수학교육과", "물리교육과", "화학교육과", "생물교육과", "체육교육과"]),
        College(name: "도시과학대학", departments: ["도시행정학과", "건설환경공학과", "교통공학과", "건축학과", "도시계획학과"]),
        College(name: "생명과학기술대학", departments: ["생명과학부", "생명공학부", "생체분자과학부", "나노바이오학과"]),
        College(name: "융합자유전공대학", departments: ["자유전공학부", "국제자유전공학부", "융합학부"]),
        College(name: "동북아국제통상대학", departments: ["동북아시아국제통상학부"]),
        College(name: "법학부", departments: ["법학부"]),
        College(name: "IBE전공", departments: ["IBE전공"])
=======
        College(name: "공과대학", departments: ["기계공학과", "신소재공학과", "메카트로닉스공학과", "산업경영공학과", "전자공학과", "에너지화학공학과", "전기공학과", "안전공학과", "환경공학과", "생명공학과", "나노바이오공학과"]), // 예시로 일부 추가
        College(name: "정보기술대학", departments: ["컴퓨터공학부", "정보통신공학과", "전자공학과", "임베디드시스템공학과"]), // 예시로 일부 추가
        College(name: "경영대학", departments: ["경영학부", "회계세무학과", "무역학부", "재무부동산학과", "융합기술경영학과"]), // 예시로 일부 추가
        College(name: "예술체육대학", departments: ["조형예술학부", "디자인학부", "공연예술학과", "체육학부"]), // 예시로 일부 추가
        College(name: "사범대학", departments: ["국어교육과", "영어교육과", "일어교육과", "불어교육과", "수학교육과", "물리교육과", "화학교육과", "생물교육과", "체육교육과"]), // 예시로 일부 추가
        College(name: "도시과학대학", departments: ["도시행정학과", "건설환경공학과", "교통공학과", "건축학과", "도시계획학과"]), // 예시로 일부 추가
        College(name: "생명과학기술대학", departments: ["생명과학부", "생명공학부", "생체분자과학부", "나노바이오학과"]), // 예시로 일부 추가
        College(name: "융합자유전공대학", departments: ["자유전공학부", "국제자유전공학부", "융합학부"]), // 예시로 일부 추가
        College(name: "동북아국제통상대학", departments: ["동북아시아국제통상학부"]), // 예시로 일부 추가
        College(name: "법학부", departments: ["법학부"]),
        College(name: "IBE전공", departments: ["IBE전공"]) // IBE는 단과대학이 아니지만, 편의상 여기에 추가
>>>>>>> be26fb7 (promotion view change):login/DepartmentData.swift
    ]
}

struct College: Identifiable {
    let id = UUID()
    let name: String
    let departments: [String]
}
