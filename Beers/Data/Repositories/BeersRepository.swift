//
//  BeersRepository.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 06.08.21.
//

import Foundation
import Combine

typealias BeersPublisher = AnyPublisher<[Beer], Error>
typealias BeerPublisher = AnyPublisher<Beer, Error>

enum DBError: Error {
    case empty
}

class BeersRepository {

    private var dataStore: BeersDataStoreProtocol
    private var storage: CoreDataStoring

    init(dataStore: BeersDataStoreProtocol, storage: CoreDataStoring) {
        self.dataStore = dataStore
        self.storage = storage
    }
}

// MARK: - Beers
extension BeersRepository: BeersRepositoryProtocol {
    func getBeers(page: Int, count: Int) -> BeersPublisher {
        Publishers
            .Merge(getBeersFromCache(), getBeersFromServer(page: page, count: count))
            .eraseToAnyPublisher()
    }
    
    func getFavoriteBeers() -> BeersPublisher {
        getBeersFromCache(with: NSPredicate(format: "isFavorite = %d", true))
    }

    private func getBeerEntitiesFromCache(with predicate: NSPredicate? = nil) -> AnyPublisher<[BeerEntity], Error> {
        Future<[BeerEntity], Error> { [storage] promise in
            let response: Result<[BeerEntity], Error> = storage.fetch(predicate: predicate)
            switch response {
            case .failure(let error):
                promise(.failure(error))
            case .success(let items):
                promise(.success(items.isEmpty ? [] : items))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    private func getBeersFromCache(with predicate: NSPredicate? = nil) -> BeersPublisher {
        Future<[Beer], Error> { [storage] promise in
            let response: Result<[BeerEntity], Error> = storage.fetch(predicate: predicate)
            switch response {
            case .failure(let error):
                promise(.failure(error))
            case .success(let items):
                promise(.success(items.isEmpty ? [] : items.map { $0.toDomain()}))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    private func getBeersFromServer(page: Int, count: Int) -> BeersPublisher {
        dataStore.getBeers(page: page, count: count)
            .map { beers in
                beers.map { [weak self] dto in
                    guard let self = self, let beer = self.handleServerResponse(dto) else { return dto.toDomain(isFavorite: false) }
                    return beer
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func handleServerResponse(_ dto: BeerDTO) -> Beer? {
        let cachedResult: Result<[BeerEntity], Error> = self.storage.fetch(predicate: NSPredicate(format: "id == \(dto.id)"))
        
        switch cachedResult {
        case .failure:
            return nil
        case .success(let items):
            if items.isEmpty {
                let entity: BeerEntity = storage.createEntity()
                entity.fillFromDTO(dto)
                storage.saveSync()
                return dto.toDomain(isFavorite: entity.isFavorite)
            } else {
                let entity = items.first
                return entity?.toDomain()
            }
        }
    }
}

// MARK: - BeerDetails
extension BeersRepository {
    func getBeerDetails(id: Int) -> BeerPublisher {
        Publishers
            .Merge(getBeerDetailsFromCache(id: id), getBeerDetailsFromServer(id: id))
            .eraseToAnyPublisher()
    }

    func getBeerDetailsFromServer(id: Int) -> BeerPublisher {
        dataStore.getBeerDetails(id: id)
            .map { [weak self] dto in
                guard let self = self, let beer = self.handleServerResponse(dto) else { return dto.toDomain(isFavorite: false) }
                return beer
            }
            .eraseToAnyPublisher()
    }
    
    func getBeerDetailsFromCache(id: Int) -> BeerPublisher {
        let predicate = NSPredicate(format: "id == \(id)")
        return getBeersFromCache(with: predicate)
            .flatMap { beers -> AnyPublisher<Beer, Error> in
                guard let beer = beers.first else { return Fail(error: DBError.empty).eraseToAnyPublisher() }
                return Just(beer).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Actions
extension BeersRepository {
    func favoriteBeer(id: Int) -> AnyPublisher<Void, Error> {
        actionForBeer(id: id, true)
    }
    
    func unfavoriteBeer(id: Int) -> AnyPublisher<Void, Error> {
        actionForBeer(id: id, false)
    }
    
    private func actionForBeer(id: Int, _ isFavorite: Bool) -> AnyPublisher<Void, Error> {
        getBeerEntitiesFromCache(with: NSPredicate(format: "id == \(id)"))
            .flatMap { [weak self] beers -> AnyPublisher<Void, Error> in
                guard let beer = beers.first else { return Fail(error: DBError.empty).eraseToAnyPublisher() }
                beer.setValue(isFavorite, forKey: "isFavorite")
                self?.storage.saveSync()
                return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
