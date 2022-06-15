import Foundation

enum JSONParserError: Error, LocalizedError {
    case decodingFail
    case encodingFail
    
    var errorDescription: String? {
        switch self {
        case .decodingFail:
            return "디코딩에 실패했습니다."
        case .encodingFail:
            return "인코딩에 실패했습니다."
        }
    }
}

struct JSONParser<Item: Codable> {
    func decode(from json: Data?) -> Item? {
        guard let data = json else {
            return nil
        }
        
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(Item.self, from: data) else { 
            return nil
        }
        
        return decodedData
    }
    
    func encode(from item: Item?) -> Data? {
        guard let item = item else {
            return nil
        }
        
        let encoder = JSONEncoder()
        
        guard let encodedData = try? encoder.encode(item) else {
            return nil
        }
        
        return encodedData
    }
    
//    func encode(from item: Item?) -> Result<Data, JSONParserError> {
//        guard let item = item else {
//            return .failure(.encodingFail)
//        }
//
//        let encoder = JSONEncoder()
//
//        guard let encodedData = try? encoder.encode(item) else {
//            return .failure(.encodingFail)
//        }
//
//        return .success(encodedData)
//    }
}
