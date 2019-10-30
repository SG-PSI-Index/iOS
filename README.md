# PSI Map (iOS)

## Project setup
1. Install [CocoaPods](https://cocoapods.org/) 
2. Open terminal and navigate the root directory of the repository
3. Execute `pushd ./PSIMap && pod install && popd`
4. Try running the app or tests with simulator

## Architecture
This is only a single screen application. The only screen is implemented with [Clean Swift](https://clean-swift.com/handbook/) with VIP cycle.

## Tech notes
- Unit tests cover the interactor, presenter and service layer.
- Unit tests are implemented with both `Quick` and ordinary `XCTest`, with `Cuckoo` as quick `Mockito` alternative for stubbing dependencies. 
- CI is set up and checks should pass before merging pull request (although there is only one developer).
- UI is implemented programmatically (no interface builder) to demostrate the ability to code with auto-layout and every UI feature, and it is easier to review.

## TODO
Due to time constraint, we did not implement everything.
- Error handling
- Integration (UI) test (a single screen application can hardly have a "journey" to test.)
- Local cache
- Refactoring
- Accessibility
- And more...
