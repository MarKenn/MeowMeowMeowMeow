//
//  RemoteMeowProvider.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/8/25.
//

import Foundation
import Nuke

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
