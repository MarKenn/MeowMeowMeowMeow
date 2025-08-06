//
//  CatFactLoader.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 8/6/25.
//

protocol CatFactLoader {
    func getCatFact() async -> Result<String, Error>
}
