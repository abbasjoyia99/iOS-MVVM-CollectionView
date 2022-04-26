//
//  CoreDataMoviesResponseStorage.swift
//  MovieApp
//
//  Created by Developer on 14/04/2022.
//

import Foundation
import CoreData

final class CoreDataMoviesResponseStorage {

    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }

    // MARK: - Private

    private func fetchRequest(for requestDto: MoviesRequestDTO) -> NSFetchRequest<MoviesRequestEntity> {
        let request: NSFetchRequest = MoviesRequestEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@ AND %K = %d",
                                        #keyPath(MoviesRequestEntity.query), requestDto.query,
                                        #keyPath(MoviesRequestEntity.page), requestDto.page)
        return request
    }

    private func deleteResponse(for requestDto: MoviesRequestDTO, in context: NSManagedObjectContext) {
        let request = fetchRequest(for: requestDto)

        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }
    func updateMovie(movie: Movie) {
        coreDataStorage.performBackgroundTask { context in
            do {
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieResponseEntity")

                fetchRequest.predicate = NSPredicate(format: "title = %@",argumentArray:[movie.self.title!])
                let results = try context.fetch(fetchRequest) as? [NSManagedObject]
                    if results?.count != 0 { // Atleast one was returned

                        // In my case, I only updated the first item in results
                        results![0].setValue(movie.isFavourite, forKey: "isFavourite")
                    }

            } catch {
                // TODO: - Log to Crashlytics
                debugPrint("CoreDataMoviesResponseStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}

extension CoreDataMoviesResponseStorage: MoviesResponseStorage {

    func getResponse(for requestDto: MoviesRequestDTO, completion: @escaping (Result<MoviesResponseDTO?, CoreDataStorageError>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest = self.fetchRequest(for: requestDto)
                let requestEntity = try context.fetch(fetchRequest).first

                completion(.success(requestEntity?.response?.toDTO()))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }
    func save(response responseDto: MoviesResponseDTO, for requestDto: MoviesRequestDTO) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteResponse(for: requestDto, in: context)

                let requestEntity = requestDto.toEntity(in: context)
                requestEntity.response = responseDto.toEntity(in: context)

                try context.save()
            } catch {
                // TODO: - Log to Crashlytics
                debugPrint("CoreDataMoviesResponseStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
    
}
