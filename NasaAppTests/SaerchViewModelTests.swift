//
//  NasaAppTests.swift
//  NasaAppTests
//
//  Created by Anju Malhotra on 11/5/22.
//

import XCTest
@testable import NasaApp

@MainActor
final class SaerchViewModelTests: XCTestCase {
    var searchViewModel: SearchViewModel!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        searchViewModel = SearchViewModel(api: ApiServiceMock())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        searchViewModel = nil
    }

    func test_SearchWithAndWithoutNoSearchQuery() async throws {
        await getCollectionObject()
        XCTAssertEqual(searchViewModel.collection.count, 0)
        
        searchViewModel.searchQuery = "Test"
        await getCollectionObject()
        XCTAssertEqual(searchViewModel.collection.count, 1)
    }
    
    func test_ReachedEnd() async throws {
        searchViewModel.searchQuery = "Test"
        await getCollectionObject()
        let result = searchViewModel.reachedEnd(of: searchViewModel.collection.first!)
        XCTAssertEqual(result, true)
    }
    
    func test_FetchNextSetOfData() async throws {
        searchViewModel.searchQuery = "Test"
        await getCollectionObject()
        
        await searchViewModel.fetchNextSetOfData()
        XCTAssertEqual(searchViewModel.collection.count, 2)
    }
    
    private func getCollectionObject() async {
       await searchViewModel.search()
    }
    
    private class ApiServiceMock: APIServiceProtocol {
        func getJsonData() -> Data {
            let jsonString = """
            {
              "collection": {
                "href": "http://images-api.nasa.gov/search?q=&media_type=image",
                "items": [
                  {
                    "data": [
                      {
                        "title": "Heating Martian Sand Grains",
                        "date_created": "2012-12-03T17:00:06Z",
                        "description": "This plot of data from NASA Mars rover Curiosity shows the variety of gases that were released from sand grains upon heating in the Sample Analysis at Mars instrument, or SAM."
                      }
                    ],
                    "links": [
                      {
                        "href": "https://images-assets.nasa.gov/image/PIA16573/PIA16573~thumb.jpg"
                      }
                    ]
                  }
                ],
                "links": [
                  {
                    "rel": "prev",
                    "prompt": "Previous",
                    "href": "http://images-api.nasa.gov/search?media_type=image"
                  }
                ]
              }
            }
            """
            return jsonString.data(using: .utf8)!
        }
        
        func search(from query: String, for mediaType: String, page: Int) async throws -> NasaAPIResponse {
            let data = getJsonData()
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return try decoder.decode(NasaAPIResponse.self, from: data)
            } catch {
                throw error
            }            
        }
    }
}
