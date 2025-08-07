//
//  WIldCatRepository.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/6/25.
//

import UIKit

protocol WildCatDataSource: CatFactLoader {
    func getCatImage() async -> Result<CatImage?, Error>
    func downloadCatUIImage(from urlString: String) async -> UIImage?
    func domesticate(meowFact: String?, catImage: CatImage?)
}

class WildCatRepository: WildCatDataSource {
    var remoteDataProvider = RemoteMeowProvider()
    var localFactProvider = LocalMeowFactProvider()
    var localImageProvider = LocalCatImageProvider()

    init(
        remoteProvider: RemoteMeowProvider = RemoteMeowProvider(),
        factProvider: LocalMeowFactProvider =  LocalMeowFactProvider(),
        imageProvider: LocalCatImageProvider = LocalCatImageProvider()
    ) {
        self.remoteDataProvider = remoteProvider
        self.localFactProvider = factProvider
        self.localImageProvider = imageProvider
    }

    func getCatFact() async throws -> String {
        let result: Result<MeowFactData, Error> = await remoteDataProvider.getRandomMeowFact()

        switch result {
        case .success(let meowFacts):
            return meowFacts.data.first ?? ""
        case .failure(let error):
            throw error
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

    func downloadCatUIImage(from urlString: String) async -> UIImage? {
        return await remoteDataProvider.downloadCatUIImage(from: urlString)
    }

    func domesticate(meowFact: String?, catImage: CatImage?) {
        if let fact = meowFact {
            self.localFactProvider.save([fact])
        }

        if let image = catImage {
            self.localImageProvider.save([image])
        }
    }
}
