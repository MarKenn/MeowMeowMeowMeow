//
//  WIldCatRepository.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/6/25.
//

import Foundation
import CoreData
import Nuke

protocol WildCatDataSource {
    func getMeowFact() async -> Result<String?, Error>
    func getCatImage() async -> Result<CatImage?, Error>
    func downloadCatUIImage(from urlString: String) async -> PlatformImage?
    func domesticate(meowFact: String)
}

class WildCatRepository: WildCatDataSource {
    var remoteDataProvider = RemoteMeowProvider()
    var localDataProvider = LocalMeowProvider()

    func getMeowFact() async -> Result<String?, Error>  {
        let result: Result<MeowFactData, Error> = await remoteDataProvider.getRandomMeowFact()

        switch result {
        case .success(let meowFacts):
            return .success(meowFacts.data.first)
        case .failure(let error):
            return .failure(error)
        }
    }

    func getCatImage() async -> Result<CatImage?, Error>  {
        let result: Result<[CatImage], Error> = await remoteDataProvider.getRandomCatImage()

        switch result {
        case .success(let images):
            return .success(images.first)
        case .failure(let error):
            return .failure(error)
        }
    }

    func downloadCatUIImage(from urlString: String) async -> PlatformImage? {
        return await remoteDataProvider.downloadCatUIImage(from: urlString)
    }

    func domesticate(meowFact: String) {
        self.localDataProvider.save([meowFact])
    }
}

class RemoteMeowProvider: RemoteDataProvider {
    func getRandomMeowFact() async -> Result<MeowFactData, Error> {
        await api.load(MeowFactsEndpoint.getRandomCatFact)
    }

    func getRandomCatImage() async -> Result<[CatImage], Error> {
        await api.load(TheCatAPIEndpoint.getRandomCatImage)
    }

    func downloadCatUIImage(from urlString: String) async -> PlatformImage? {
        guard let url = URL(string: urlString) else { return nil }
        let imageTask = ImagePipeline.shared.imageTask(with: url)

        return try? await imageTask.image
    }
}

class LocalMeowProvider: NSObject, LocalDataProvider {
    @Published
    var objectsPublisher = [MeowFactPersisted]()

    var fetchedResultsController: NSFetchedResultsController<MeowFactPersisted>!

    func fetchRequest() -> NSFetchRequest<MeowFactPersisted> {
        MeowFactPersisted.fetchRequest()
    }
}
