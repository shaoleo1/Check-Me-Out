# Check Me Out - A Smart Library Companion

![App logo](https://github.com/shaoleo1/Check-Me-Out/blob/master/Check%20Me%20Out/Assets.xcassets/AppIcon.appiconset/CMO180.jpg?raw=true)


  * [About](#about)
    + [Introduction](#introduction)
    + [App Features](#app-features)
    + [Services Used](#services-used)
    + [Screenshots](#screenshots)
    + [How to use Check Me Out](#how-to-use-check-me-out)
  * [Installation](#installation)
    + [Prerequisites](#prerequisites)
    + [Instructions for Testing](#instructions-for-testing)
    + [Signing Errors](#signing-errors)
    + [Troubleshooting](#troubleshooting)

## About

### Introduction
> We created an iOS application that allows students and teachers to check out, reserve, and obtain information about books at the school library. Built from scratch with the Swift 4 programming language and Xcode 9.2 IDE in the frontend/app-side, and Node.js, Express.js, and MySQL in the backend/API-side, the app allows for barcode scanning of books to allow students to check out by themselves. The app also allows for the searching of books to obtain numerous details (including but not limited to: description, rating, page count, etc.) and the reservation of books for up to 7 days. Due dates and reservation expiration dates are automatically calculated and fines will automatically accumulate for every day late; students/teachers will be notified before their book is due as well as every single day after it's due. The app also offers a detailed map of the school library. A librarian account is also implemented to allow librarians to check in returned books, view logs and details of students and their check-outs, and add and manage books in the library. Code is well written, commented, error free.

### App Features
* Easily log in using student or teacher's school ID.
* Easily view all the books that the student or teacher has checked out and their due dates.
* Seemlessly scan barcodes of books in the library to instantly check them out with a due date automatically calculated.
* Search for books and their numerous details such as quantity, genre, description, etc.
* Reserve books for 7 days as well as withdraw reservations for books.
* Book stock quantity counts are automatically and accurately tracked.
* Refresh bookshelf by pulling down on the screen.
* Fully functional and fast self-made backend API using Node.js, Express.js, and MySQL hosted on Amazon Web Services Elastic Compute Cloud (AWS EC2) instance.
* View a detailed map of the school library.
* View automatically accumulated fines and other account info.
* Librarian account for adding new books to the library, checking in returned books, and viewing student information/logs.
* Simple and self-explanatory user interface and app navigation.
* Ability to navigate to, share, and communicate through social media.
* Bug reporting system.

### Services Used
* Swift 4 (programming language)
* Xcode 9.2 (IDE)
* Cocoapods (Dependency manager, MIT license)
* TextFieldEffects (Library for custom text fields effects, MIT license)
* Kingfisher (Library for downloading and caching images, MIT license)
* Node.js (programming language (backend API))
* Express.js (web app framework for Node.js (backend API), MIT license)
* MySQL (relational database management system/RDBMS using structured query language/SQL (backend API))
* Google Books API (to search and retrieve information about books)
* GitHub (collaboration and source/version control)

### Screenshots
[Download PDF](https://drive.google.com/file/d/1c7EWKLG2vRqebIDJ8KJYLgZ4Y807xTIM/view?usp=sharing)

### How to use Check Me Out
* A test student account (teacher accounts are the same) is already in place. The ID is `311620`.
* A book should already be checked out and overdue, titled `Fast Food Nation`.
* To check out a book, tap on the camera tab in the middle of the bar at the bottom. Simply point your camera at the barcode of any book to scan it. Samples books to test that are in stock at the library are `To Kill a Mockingbird`, `Johnny Tremain`, `Fast Food Nation`, `Fahrenheit 451`, `Animal Farm`, `Between the World and Me`, and `The Good Earth`. Scanned books that are not in stock at the library will not be able to be checked out.
* If you do not have these books, you may scan the ISBN barcodes here:
* To Kill a Mockingbird: ![To Kill a Mockingbird](https://i.imgur.com/VEI3ycZ.png)  Johnny Tremain: ![Johnny Tremain](https://i.imgur.com/Ok4axQq.png)
* All checked out and reserved books will show up on the bookshelf. If it is not there, pull down on the screen to refresh.
* To reserve books, tap on the search tab to search books. Books that are in stock (quantity > 0) such as Fast Food Nation and Johnny Tremain can be reserved.
* To withdraw your reservation, tap on the reservation you wish to withdraw (if it is not there, pull down on the screen to refresh the bookshelf).
* Fines can be found on the settings tab and notifications are sent once every day at 3:10PM ET for overdue books and start the day before the book is due.
* A test librarian account is already in place. The ID is `ehthslibrarian`.
* Librarians may scan returned books from students and teachers, add new books to the library, and manage/view student info/logs.

## Installation
### Prerequisites
* A physical Macintosh (MacBook/iMac)
* [Xcode 9.2](https://itunes.apple.com/us/app/xcode/id497799835) (latest)
* An internet connection
* A physical iPhone running iOS 10.0+ (the camera is unusable on simulators and thus barcode scanning cannot be tested)

### Instructions for Testing
1. If you already have all the project source files, skip to step 4. Otherwise, open Xcode and select Clone an existing project
2. Paste `https://github.com/shaoleo1/Check-Me-Out.git` and select "Clone"
3. Select a location to store the project, select "Download", and wait for the project to download and open
4. Unlock your iPhone and plug it into your Mac
5. Go to the top left corner, select `Check Me Out` as the Scheme; select your attached iPhone to run the app on (should be at the top of the list); and press the run button (play button)
![Select Run](https://i.imgur.com/xZCPY5u.png)
6. If signing errors occur (this is expected), please see the Signing Errors section (⬇️)
7. For an easier install of the app using TestFlight (Apple's App Beta Testing Platform), please email shaoleo1@gmail.com with your email used for your Apple ID to test the app using TestFlight. Download TestFlight from the App Store and follow instructions in the email you will receive.

### Signing Errors
If a signing error occurs while compiling or running an app please do the following:

1. Go to Xcode -> Preferences, and select Accounts. Here, select the + button in the bottom left corner and sign into your Apple Developer Account. If you do not have an Apple Developer Account, follow [these instuctions](https://9to5mac.com/2016/03/27/how-to-create-free-apple-developer-account-sideload-apps/) to make an account (it should work with a normal Apple ID).
In order for push notifications to work, your Apple ID must be enrolled in the Apple Developer Program for $100. If you are not in the Apple Developer Program, you must disable Push Notifications by clicking Check Me Out in the directory, selecting the capabilities tab, and switching off Push Notifications for the app to run. If you still wish to test push notifications, you can also test the app via TestFlight (Apple's App Beta Testing Platform). Please email shaoleo1@gmail.com with your email used for your Apple ID to test the app using TestFlight. Download TestFlight from the App Store and follow instructions in the email you will receive. Push notifications send every day at 3:10 Eastern Time.
2. Select Check Me Out (project file) in the Project Navigator (located on the left)
3. Select the "General" tab 
4. Under Identity: Change the bundle identifier, replacing com.leoshao.checkmeout with any unique domain that you would like to use
![Select Run](https://i.imgur.com/C2baSf6.png)
5. If there are any issues at this point, please follow [these instructions](https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppStoreDistributionTutorial/CreatingYourTeamProvisioningProfile/CreatingYourTeamProvisioningProfile.html)
4. Under Signing: Change the team to the newly created team. 
![Select Team](https://i.imgur.com/SYOBqyi.png)
5. Run the app 
6. If this fails, redo the Instructions for Testing(⬆️) and run the app on a simulator

### Troubleshooting 
| Issue | Solution |
|-------------------------------------------------------------------|--------------------------------------------------------------------------------------------------|
| After Checking Out the repository, Xcode does not load the project| This is an Xcode bug, quit Xcode, navigate to the directory that the Xcode project is stored in, delete the DerivedData folder, and open `Check Me Out.xcworkspace` OR  delete the downloaded folder and restart the Intructions For Testing, this time changing the download directory location|
| When running on a physical device, the developer is not trusted.  | On the iPhone, go to Settings -> General -> Device Management-> And select "Trust" for your developer profile |
| App appears as a black screen | If running on a simulator, the simulator may be booting up, otherwise, try running the app again |
| "The run destination is not valid" | Ensure that the app running on an iOS device or simulator that is iOS 10.0+  |
| I can't see the project navigator  | In Xcode, go to View -> Navigators and select Project Navigator  
| App views overlap | Try running an app on an iPhone 7 or 7 Plus (either actual device or simulator)
