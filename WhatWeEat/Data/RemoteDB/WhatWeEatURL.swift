import Foundation

//완료- 홈화면의 랜덤메뉴 (GET) : menu/random
//완료- 그룹만들기 (POST) : /group?token=1234
//완료- PIN으로 입장하기 (GET) : /group/1111  // ?group=1111 보다 계층성을 나타냄
//게임 제출 (POST) - 못먹는음식,게임답변,PIN번호,사용자토큰 : group/1111/(나머지는 JSON)
//완료- 현재 제출인원수 (GET) : group/1111/player-count
//HOST가 결과확인 (GET) -> 게임 결과 : group/1111/gameresult
//도중에 게임다시시작 (PATCH/PUT DELETE?) : group/1111?token=1234
//결과 Notification : HTTP 메서드가 아님 (Firebase)

struct WhatWeEatURL {
    static let baseURL: String = "http://3.39.155.132:8080/"  // TODO: 추가
//    static let baseURL: String = "http://localhost:8080/"   // 참고 - 로컬 서버

    struct RandomMenuAPI: Gettable {
        let url: URL?
        let method: HttpMethod = .get
        
        init(baseURL: String = baseURL) {
            self.url = URL(string: "\(baseURL)menu/random")
        }
    }

    struct CreateGroupAPI: Postable {
        let url: URL?
        let method: HttpMethod = .post
        var contentType: String?
        var body: Data?
        
        init(token: String, baseURL: String = baseURL) {
            self.url = URL(string: "\(baseURL)group?token=\(token)")
        }
    }
    
    struct GroupValidationCheckAPI: Gettable {
        var url: URL?
        var method: HttpMethod = .get
        
        init(pinNumber: String, baseURL: String = baseURL) {
            self.url = URL(string: "\(baseURL)group/\(pinNumber)")
        }
    }
    
    // TODO: 못먹는음식,게임답변,PIN번호,사용자토큰 : group/1111 (여기까지가 URL), (나머지는 JSON으로 보낸다)
    struct ResultSubmissionAPI: Postable {
        var url: URL?
        var method: HttpMethod = .post
        var contentType: String? = "application/json"
        var body: Data? 
        
        init(pinNumber: String?, body: Data?, baseURL: String = baseURL) {
            self.body = body
            
            if let pinNumber = pinNumber {
                // 함께메뉴결정은 response로 nil을 받음 ->
                self.url = URL(string: "\(baseURL)group/\(pinNumber)")
            } else {
                // 혼밥메뉴결정은 response로 게임결과 (Data 타입)를 받음
                self.url = URL(string: "\(baseURL)group/solo")
            }
        }
    }

    struct GameResultWaitingAPI: Gettable {
        var url: URL?
        var method: HttpMethod = .get
        
        init(pinNumber: String, token: String, baseURL: String = baseURL) {
            self.url = URL(string: "\(baseURL)group/\(pinNumber)/gameresultwait?token=\(token)")
        }
    }
    
    struct GameResultAPI: Gettable {
        var url: URL?
        var method: HttpMethod = .get
        
        init(pinNumber: String?, baseURL: String = baseURL) {
            if let pinNumber = pinNumber {
                self.url = URL(string: "\(baseURL)group/\(pinNumber)/gameresult")
            } else {
                self.url = URL(string: "\(baseURL)group/solo/gameresult")
            }
        }
    }
    
    struct CancelSubmissionAPI: Puttable {
        var url: URL?
        var method: HttpMethod = .put
        
        init(pinNumber: String, token: String, baseURL: String = baseURL) {
            self.url = URL(string: "\(baseURL)group/\(pinNumber)?token=\(token)")
        }
    }
}
