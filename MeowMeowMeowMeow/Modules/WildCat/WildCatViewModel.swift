//
//  WildCatViewModel.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/6/25.
//

import Foundation

protocol WildCatViewModel {
    var meowFact: String? { get set }
}

extension WildCatView {
    @Observable
    class Model: WildCatViewModel {
        var repository: WildCatDataSource

        var meowFact: String?
        var catImage: CatImage?
        var error: Error?

        init(repository: WildCatDataSource =  WildCatRepository()) {
            self.repository = repository
        }

        func getMeowFact() async {
            let response = await repository.getMeowFact()

            if case .success(let meowFact) = response {
                self.meowFact = meowFact
            } else if case .failure(let error) = response {
                self.error = error
            }
        }

        func getCatImage() async {
            let response = await repository.getCatImage()
            
            if case .success(let catImage) = response {
                self.catImage = catImage
            } else if case .failure(let error) = response {
                self.error = error
            }
        }
    }
}
