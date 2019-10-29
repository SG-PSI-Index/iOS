//
//  MapInteractorTests.swift
//  PSIMapTests
//
//  Created by Kevin Lo on 29/10/2019.
//  Copyright © 2019 Zuhlke Engineering HK Limited. All rights reserved.
//

import Cuckoo
import Quick
@testable import PSIMap

class MapInteractorSpec: QuickSpec {

    let subject: MapInteractorProtocol = MapInteractor()

    let presenterMock = MockMapPresenterProtocol()

    let apiServiceMock = MockPSIAPIServiceProtocol()

    override func spec() {
        describe("the method `fetchPSIData`") {
            beforeEach {
                self.subject.presenter = self.presenterMock
                self.subject.apiService = self.apiServiceMock

                stub(self.presenterMock) { presenter in
                    when(presenter).presentData(with: any()).thenDoNothing()
                    when(presenter).presentError().thenDoNothing()
                    when(presenter).presentLoadingState(isLoading: any()).thenDoNothing()
                }

                stub(self.apiServiceMock) { apiService in
                    when(apiService).getPSI(completion: any()).thenDoNothing()
                }
            }

            afterEach {
                clearStubs(self.presenterMock)
                clearInvocations(self.presenterMock)
                clearStubs(self.apiServiceMock)
                clearInvocations(self.apiServiceMock)
            }

            it("should start loading in presenter") {
                self.subject.fetchPSIData()
                verify(self.presenterMock).presentLoadingState(isLoading: true)
            }

            context("when getting API error") {
                beforeEach {
                    stub(self.apiServiceMock) { apiService in
                        when(apiService).getPSI(completion: any()).then { completion in
                            completion(.failure)
                        }
                    }
                }

                afterEach {
                    clearStubs(self.apiServiceMock)
                    clearInvocations(self.apiServiceMock)
                }

                it("should return failure") {
                    self.subject.fetchPSIData()
                    verify(self.presenterMock).presentError()
                }

                it ("should stop loading in presenter") {
                    self.subject.fetchPSIData()
                    verify(self.presenterMock).presentLoadingState(isLoading: false)
                }
            }
        }
    }

}
