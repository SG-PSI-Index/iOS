//
//  PSIAPIServiceProtocols.swift
//  PSIMap
//
//  Created by Kevin Lo on 27/10/2019.
//  Copyright © 2019 Zuhlke Engineering HK Limited. All rights reserved.
//

import Foundation

protocol PSIAPIServiceProtocol: class {
    
    func getPSI(completion: @escaping (GetPSIResult) -> Void)
    
}

enum GetPSIResult {

    case success(PSIAPIResponse)

    case failure

}
