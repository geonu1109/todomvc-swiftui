import Foundation

struct UserDefaultsDAO {
    typealias ObjectType = Codable & Identifiable & Hashable
    
    private let userDefaults: UserDefaults
    private let jsonEncoder: JSONEncoder = .init()
    private let jsonDecoder: JSONDecoder = .init()
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func findAll<Object: ObjectType>(for key: String = .init(describing: Object.self)) throws -> Set<Object> {
        guard let data: Data = self.userDefaults.data(forKey: key) else {
            return []
        }
        let objects: Set<Object> = try self.jsonDecoder.decode(Set<Object>.self, from: data)
        return objects
    }
    
    func save<Object: ObjectType>(_ object: Object, for key: String = .init(describing: Object.self)) throws {
        var objects: Set<Object> = try self.findAll(for: key)
        if let object = objects.first(where: { $0.id == object.id }) {
            objects.remove(object)
        }
        objects.insert(object)
        let data: Data = try self.jsonEncoder.encode(objects)
        self.userDefaults.set(data, forKey: key)
    }
}
