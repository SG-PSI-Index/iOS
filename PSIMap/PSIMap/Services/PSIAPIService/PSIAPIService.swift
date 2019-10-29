//
//  PSIAPIService.swift
//  PSIMap
//
//  Created by Kevin Lo on 27/10/2019.
//  Copyright © 2019 Zuhlke Engineering HK Limited. All rights reserved.
//

import Foundation

class PSIAPIService: PSIAPIServiceProtocol {

    let psiURL = URL(string: "https://api.data.gov.sg/v1/environment/psi")

    func getPSI(completion: @escaping (GetPSIResult) -> Void) {
        guard let psiURL = psiURL else {
            return
        }
        let task = URLSession.shared.dataTask(with: psiURL) { data, _, _ in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let result = try decoder.decode(PSIAPIResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure)
                }
            } else {
                completion(.failure)
            }
        }
        task.resume()
    }

}
