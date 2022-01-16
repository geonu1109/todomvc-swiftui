import Foundation

struct UserDefaultsDAO {
    typealias ObjectType = Codable & Identifiable
    
    private let userDefaults: UserDefaults
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    
    init(userDefaults: UserDefaults, jsonEncoder: JSONEncoder, jsonDecoder: JSONDecoder) {
        self.userDefaults = userDefaults
        self.jsonEncoder = jsonEncoder
        self.jsonDecoder = jsonDecoder
    }
    
    func findAll<Object: ObjectType>(for key: String = .init(describing: Object.self)) throws -> [Object] {
        guard let data: Data = self.userDefaults.data(forKey: key) else {
            return []
        }
        let objects: [Object] = try self.jsonDecoder.decode([Object].self, from: data)
        return objects
    }
    
    func save<Object: ObjectType>(_ object: Object, for key: String = .init(describing: Object.self)) throws {
        var objects: [Object] = try self.findAll(for: key)
        if let index: Int = objects.firstIndex(where: { $0.id == object.id }) {
            objects[index] = object
        } else {
            objects.append(object)
        }
        let data: Data = try self.jsonEncoder.encode(objects)
        self.userDefaults.set(data, forKey: key)
    }
}
