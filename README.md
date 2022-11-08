# NasaApp
# Dear Reviewer, Thank you for taking time to review my code.

Listing out the details of the code as below:
Design Pattern: MVVM
Deployment target: 16.1
Device support: iPhone/iPad
Coding language: SwiftUI/Swift

Details:

* App is a searched based app which fetched data based on user query from "https://images-
api.nasa.gov"
* Media type used for search is always "image"
* A dropdown displays when user tap on the list, user can select from list or can key-in new input
* After submitting the result, UI displays list of items
* Pagination is implemented and maximum limit is 100 pages per search
* On selection of any item in the list, it opens a detai page corresponding to selected item
* Includes testcase for ViewModel

Implementation Details:

# API
* NasaApi, Contains API initialization, Session URL, JSON data decode, search(query, mediaType, page), fetchData response status code function, generateSearchURL(query, mediaType, page), generateError for NASA Api. Future implementation to seperate API service in seperate module

# CacheAsyncImage
* As AsyncImage doesnot cache images, implements caching to avoid network traffic for already loaded images

# View
* SearchView to search for the query and display API results
* ImageListView for list of items, Displays ImageRowView and navigated to ImageDetailView on tap of each row
* ImageRowView, Displays Image and title for the image
* ImageDetailView, Displays title in navigation bar, Displays Image, description and date created in body
* EmptyPlaceholderView, Implements empty placeholder

# ViewModel
* SearchViewModel, Contains the initial default search value function, search history (dummy), and the image search result function based on the input string

# Model
* NasaDataModel
