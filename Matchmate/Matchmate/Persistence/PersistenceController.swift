import CoreData

final class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    var viewContext: NSManagedObjectContext { container.viewContext }

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Matchmate")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error {
                assertionFailure("Failed to load Core Data: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    // MARK: - Reads

    func loadCachedUsers() -> [MatchUser] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "CDMatchUser")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            let objects = try viewContext.fetch(request)
            return objects.map(toDomain)
        } catch {
            assertionFailure("Fetch failed: \(error)")
            return []
        }
    }

    // MARK: - Writes

    func saveUsers(_ users: [MatchUser]) {
        let existing = fetchByIDs(users.map(\.id))
        var existingByID = Dictionary(uniqueKeysWithValues: existing.map { ($0.value(forKey: "id") as! String, $0) })

        for user in users {
            let object = existingByID[user.id] ?? makeObject()
            object.setValue(user.id, forKey: "id")
            object.setValue(user.name, forKey: "name")
            object.setValue(Int32(user.age), forKey: "age")
            object.setValue(user.city, forKey: "city")
            object.setValue(user.country, forKey: "country")
            object.setValue(user.imageURL, forKey: "imageURL")
            if object.value(forKey: "status") == nil {
                object.setValue(user.status.rawValue, forKey: "status")
            }
            existingByID[user.id] = object
        }
        save()
    }

    func updateStatus(for id: String, to status: MatchStatus) {
        guard let object = fetchByIDs([id]).first else { return }
        object.setValue(status.rawValue, forKey: "status")
        save()
    }

    // MARK: - Helpers

    private func makeObject() -> NSManagedObject {
        let entity = NSEntityDescription.entity(forEntityName: "CDMatchUser", in: viewContext)!
        return NSManagedObject(entity: entity, insertInto: viewContext)
    }

    private func fetchByIDs(_ ids: [String]) -> [NSManagedObject] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "CDMatchUser")
        request.predicate = NSPredicate(format: "id IN %@", ids)
        return (try? viewContext.fetch(request)) ?? []
    }

    private func save() {
        guard viewContext.hasChanges else { return }
        do {
            try viewContext.save()
        } catch {
            assertionFailure("Save failed: \(error)")
        }
    }

    private func toDomain(_ object: NSManagedObject) -> MatchUser {
        let statusRaw = object.value(forKey: "status") as? String ?? MatchStatus.pending.rawValue
        return MatchUser(
            id: object.value(forKey: "id") as? String ?? "",
            name: object.value(forKey: "name") as? String ?? "",
            age: Int(object.value(forKey: "age") as? Int32 ?? 0),
            city: object.value(forKey: "city") as? String ?? "",
            country: object.value(forKey: "country") as? String ?? "",
            imageURL: object.value(forKey: "imageURL") as? String ?? "",
            status: MatchStatus(rawValue: statusRaw) ?? .pending
        )
    }
}
