import Foundation

struct WhatWeEatURL {
    static let baseURL: String = "http://3.39.155.132:8080/"
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
    
    struct ResultSubmissionAPI: Postable {
        var url: URL?
        var method: HttpMethod = .post
        var contentType: String? = "application/json"
        var body: Data? 
        
        init(pinNumber: String?, body: Data?, baseURL: String = baseURL) {
            self.body = body
            
            if let pinNumber = pinNumber {
                // 함께메뉴결정은 response로 nil을 받음 
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
