//
//  CoreDataStore.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 08.08.21.
//

import CoreData

extension NSManagedObject {
    class var entityName: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}

protocol EntityCreating {
    var viewContext: NSManagedObjectContext { get }
    func createEntity<T: NSManagedObject>() -> T
}

extension EntityCreating {
    func createEntity<T: NSManagedObject>() -> T {
        T(context: viewContext)
    }
}

protocol EntitySaving {
    var viewContext: NSManagedObjectContext { get }
    func saveSync()
}

extension EntitySaving {
    func saveSync() {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = viewContext
        privateContext.perform {
            do {
                try privateContext.save()
                viewContext.performAndWait {
                    do  {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        print("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                }
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

protocol EntityFetching {
    var viewContext: NSManagedObjectContext { get }
    func fetch<T: NSManagedObject>(predicate: NSPredicate?) -> Result<[T], Error>
}

extension EntityFetching {
    func fetch<T: NSManagedObject>(predicate: NSPredicate? = nil) -> Result<[T], Error> {
        let request = NSFetchRequest<T>(entityName: T.entityName)
        request.predicate = predicate
        do {
            let items = try viewContext.fetch(request)
            return .success(items)
        } catch {
            return .failure(error)
        }
    }
}


protocol CoreDataStoring: EntityCreating, EntitySaving, EntityFetching {
    var viewContext: NSManagedObjectContext { get }
}


class CoreDataStore: CoreDataStoring {
    
    private let container: NSPersistentContainer
    
    static var shared = CoreDataStore(name: "Beers")
    
    var viewContext: NSManagedObjectContext {
        self.container.viewContext
    }
    
    private init(name: String) {
        container = NSPersistentContainer(name: name)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
