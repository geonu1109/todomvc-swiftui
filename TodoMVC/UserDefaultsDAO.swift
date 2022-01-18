import Foundation

struct UserDefaultsDAO {
    typealias EntityType = Codable & Identifiable & Hashable
    
    private let userDefaults: UserDefaults
    private let jsonEncoder: JSONEncoder = .init()
    private let jsonDecoder: JSONDecoder = .init()
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func findAll<Entity: EntityType>(for key: String = .init(describing: Entity.self)) throws -> Set<Entity> {
        guard let data: Data = self.userDefaults.data(forKey: key) else {
            return []
        }
        let entities: Set<Entity> = try self.jsonDecoder.decode(Set<Entity>.self, from: data)
        return entities
    }
    
    func save<Entity: EntityType>(_ entity: Entity, for key: String = .init(describing: Entity.self)) throws {
        var entities: Set<Entity> = try self.findAll(for: key)
        if let entity = entities.first(where: { $0.id == entity.id }) {
            entities.remove(entity)
        }
        entities.insert(entity)
        let data: Data = try self.jsonEncoder.encode(entities)
        self.userDefaults.set(data, forKey: key)
    }
    
    func saveAll<Entities: Sequence>(_ newEntities: Entities, for key: String = .init(describing: Entities.Element.self)) throws where Entities.Element: EntityType {
        var entities: Set<Entities.Element> = try self.findAll(for: key)
        newEntities.forEach { (entity) in
            if let entity = entities.first(where: { $0.id == entity.id }) {
                entities.remove(entity)
            }
            entities.insert(entity)
        }
        let data: Data = try self.jsonEncoder.encode(entities)
        self.userDefaults.set(data, forKey: key)
    }
    
    @discardableResult
    func delete<Entity: EntityType>(_ entity: Entity, for key: String = .init(describing: Entity.self)) throws -> Bool {
        var entities: Set<Entity> = try self.findAll(for: key)
        guard let index = entities.firstIndex(of: entity) else {
            return false
        }
        entities.remove(at: index)
        let data: Data = try self.jsonEncoder.encode(entities)
        self.userDefaults.set(data, forKey: key)
        return true
    }
    
    func deleteAll<Entities: Sequence>(_ targetEntities: Entities, for key: String = .init(describing: Entities.Element.self)) throws where Entities.Element: EntityType {
        var entities: Set<Entities.Element> = try self.findAll(for: key)
        targetEntities.forEach { (entity) in
            guard let index = entities.firstIndex(of: entity) else {
                return
            }
            entities.remove(at: index)
        }
        let data: Data = try self.jsonEncoder.encode(entities)
        self.userDefaults.set(data, forKey: key)
    }
}
