//
//  WIldCatRepository.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/6/25.
//

protocol WildCatDataSource {
    func getMeowFact() async -> Result<String?, Error>
    func getCatImage() async -> Result<CatImage?, Error>
}

class WildCatRepository: WildCatDataSource {
    var remoteDataProvider = RemoteMeowProvider()

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
}

class RemoteMeowProvider: RemoteDataProvider {
    func getRandomMeowFact() async -> Result<MeowFactData, Error> {
        await api.load(MeowFactsEndpoint.getRandomCatFact)
    }

    func getRandomCatImage() async -> Result<[CatImage], Error> {
        await api.load(TheCatAPIEndpoint.getRandomCatImage)
    }
}
