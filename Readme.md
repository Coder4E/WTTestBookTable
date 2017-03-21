/**
Readme file

Author: Fabio Rossato 
Date: 20-03-2017
*/

For this project I've used OHHTTPStubs library to stub the network requests during unit tests.

I installed it using Cocoapod, a library dependency manager for Xcode projects.

-———————— IMPORTANT ——————————————————————————————————————————————————————-

Cocoapod uses a workspace to make the libraries available to the project, so please open the WTTest.xcworkspace
instead of WTTest.xcodeproj otherwise the project will not compile.

Project built with XCode 8.2.1, swift 3.0

————————————————————————-————————————————————————-————————————————————————-

The app shows the weather every three hours for the next five days for a selected city; 
Every row represents a day (indicated with a label), and every item within a row represents a 3 hours timeslot.
The app works in both portrait and landscape mode.

The code has been written thinking about scalability and testability;

The classes are coded to allow dependency injection through the constructors to make easier writing unit tests and mocking objects.

The project is structured to keep the source files grouped by functionalities, so that it's easy to find them; All of the classes and files are using a prefix (WT: Weather test), that is a recommended practice, especially when working with other frameworks.

I developed the app following the TDD principles.
Unit tests and integration tests are included.
The UI tests are testing the basic views of the app.
The app has a good code coverage (around 90%).

I used the following design patterns:
- MVC: explanation below
- Factory: to create the network Request objects
- Delegate: to deliver the responses from the network
- Decorator: to extend functionalities of the Double struct, and to keep some structs clearer (Model objects)
- Facade: to organise the api calls in one single interface (WTRequestEndpoints)
- Chain of responsibilities: implicitly used to deliver the user actions from the view to the controller (IBActions)

I was able to keep the MVC model in place by using different controllers for the main view and the sub-collectionViews:
once the data is received, I separate the weather items by days in different arrays, each of them represents a dataSource for one collectionView.
The CollectionViewControllers are held by the MainViewController, which instantiate them when a new row of the tableView is needed.
When the row is not displayed anymore, I delete the associated CollectionViewController to save memory: in this way if the same MainController is used with a lot of rows, I will not need to worry about the memory usage for the sub-collectionViewControllers; furthermore it follows the idea of reusable cells used by iOS.

There are 2 schemas, one to run both UI and UT tests, and one only for UITest.

A limitation of the app is the lack of any check about the city that the user types in: in fact the user could misspell the city name, and the API would return the weather for an unexpected city.

I mitigated this problem displaying the city returned from the api to the user (so they can check if it is the one they were looking for) and allowing the user to type only alphabet letters into the search bar.

If I had got more time I would have implemented a default location using GPS coordinates (now set to London);
I would have imported the bulk file with all the cities (city.list.json, that can be found on the open weather website) in the database in order to show suggestions to the user while typing the city in the search bar.

I added a pull to refresh on the MainViewController so it's possible to get fresh weather data for the last selected city.
