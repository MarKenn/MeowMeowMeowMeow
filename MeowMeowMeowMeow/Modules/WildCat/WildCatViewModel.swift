//
//  WildCatViewModel.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 1/6/25.
//

import UIKit

extension WildCatView {
    @Observable
    class Model {
        var repository: WildCatDataSource

        var meowFact: String?
        var catImage: CatImage?
        var catUIImage: UIImage?
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
                await downloadCatUIImage()
            } else if case .failure(let error) = response {
                self.error = error
            }
        }

        func downloadCatUIImage() async {
            guard let catImageURL = catImage?.url else { return }

            let response = await repository.downloadCatUIImage(from: catImageURL)
            self.catUIImage = response
        }

        func domesticate() {
            repository.domesticate(meowFact: meowFact, catImage: catImage)
        }
    }
}
