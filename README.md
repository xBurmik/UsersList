# ReqRes UsersList App - iOS Test Task

An iOS application for working with the ReqRes API with the ability to store favorite users.

## Features
### Implemented Features
* Display a list of users from the ReqRes API
* Pagination with "infinite" scrolling
* User detail page
* Add/remove users to/from favorites
* Local storage of favorites using Realm
* Pull-to-refresh for updating the user list
* Error handling with message display
* Loading indicators

## Architecture & Technologies
* SwiftUI for the user interface
* MVVM architecture
* URLSession + async/await for network requests
* Realm for local data storage
* Error handling and alert display
* Supports iOS 16+

## Project Setup
### Requirements
* Xcode 14.0+
* iOS 16.0+
* Swift 5.7+

### Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/xBurmik/UsersList.git
   ```
2. Install dependencies via Swift Package Manager:
   * Open the project in Xcode
   * Wait for Xcode to load dependencies (Realm)
3. Run the project on a simulator or a real device

## Implementation Notes
* The app works offline only for favorite users
* Infinite scrolling is implemented using the approach of checking the current list item index
* User data is stored in Realm only if added to favorites

