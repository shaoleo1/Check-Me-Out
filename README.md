# Check Me Out
## A Smart Library Companion

![App logo](https://github.com/shaoleo1/Check-Me-Out/blob/master/Check%20Me%20Out/Assets.xcassets/AppIcon.appiconset/180.jpg?raw=true)


- [Check Me Out](#check-me-out)
  * [About](#about)
    + [Introduction](#introduction)
    + [App Features](#app-features)
    + [Services Used](#services-used)
    + [GUI Screenshots](#gui-screenshots)
    + [How to use Check Me Out](#how-to-use-check-me-out)
  * [Installation](#installation)
    + [Prerequisites](#prerequisites)
    + [Instructions for Testing](#instructions-for-testing)
    + [Signing Errors](#signing-errors)
    + [Troubleshooting](#troubleshooting)
    + [FAQ](#faq)

## About

### Introduction
> Create an iOS application that allows students and teachers to check out, reserve, and obtain information about books at the school library. Built from scratch with the Swift 4 programming language and Xcode 9.2 IDE in the frontend/app-side, and Node.js, Express.js, and MySQL in the backend/API-side, the app allows for barcode scanning of books to allow students to check out by themselves. The app also allows for the searching of books to obtain numerous details (including but not limited to: description, rating, page count, etc.) and the reservation of books for up to 7 days. Due dates and reservation expiration dates are automatically calculated and fines will automatically accumulate for every day late; students/teachers will be notified before their book is due as well as every single day after it's due. The app also offers a detailed map of the school library. A librarian account is also implemented to allow librarians to check in returned books, view logs and details of students and their check-outs, and add and manage books in the library. Code is well written, commented, error free.

### App Features
* Easily login using student or teacher's school ID.
* Easily view all the books that the student or teacher has checked out and their due dates.
* Seemlessly scan barcodes of books in the library to instantly check them out with a due date automatically calculated.
* Search for books and their numerous details such as quantity, genre, description, etc.
* Fully functional and fast self-made backend API using Node.js, Express.js, and MySQL hosted on Amazon Web Services Elastic Compute Cloud (AWS EC2) instance.
* View a detailed map of the school library.
* View fines and other account info.
* Self-explanatory user interface and app navigation.
* Ability to navigate to, share, and communicate through social media.

### Services Used
* Swift 4 (programming language)
* Xcode 9.2 (IDE)
* Node.js (programming language (backend API))
* Express.js (web app framework for Node.js (backend API))
* MySQL (relational database management system/RDBMS using structured query language/SQL (backend API))
* GitHub (collaboration and source/version control)

### GUI Screenshots
[Download PDF]()

### How to use Check Me Out
* A test student account is already in place. The ID is `311620`.
* The Global group has been created with sample items, many of which highlight app features
* If you would like to change groups, log out and sign back in
* To purchase an item, reach out to the seller via the "Seller" chat. If you would like to just ask a question, ask the question in the "Item" or global chat
* If you have successfully sold an item, select that item in the browse section (or in the "Selling" section of the profile view) and select "Mark as Sold" This will remove the item from sale
* Tap the center of the screen while on an item (in the browse section) to go to the next item



## Installation
### Prerequisites
* A physical Macintosh (MacBook/iMac)
* [Xcode 9.2](https://itunes.apple.com/us/app/xcode/id497799835) (latest)
* An internet connection
* A physical iPhone running iOS 10.0+ (the camera is unusable on simulators and thus barcode scanning cannot be tested)

### Instructions for Testing
1. Open Xcode and select Source Control -> Checkout
2. Under "Or enter a repository location:", paste `https://github.com/shaoleo1/Check-Me-Out.git` and select "Next"
3. Select a location to store the project, select "Download", and wait for the project to download and open
4. Unlock your iPhone and plug it into your Mac
5. Go to the top left corner, select `Check Me Out` as the Scheme; select your attached iPhone to run the app on (should be at the top of the list); and press the run button (play button)
![Select Run](https://i.imgur.com/xZCPY5u.png)
6. If signing errors occur (this is expected when running on physical iPhone), please see the Signing Errors section (⬇️)

### Signing Errors
If a signing error occurs while compiling or running an app please do the following:

1. Go to Xcode -> Preferences, and select Accounts. Here, select the + button in the bottom left corner and sign into your Apple Developer Account. If you do not have an Apple Developer Account, follow [these instuctions](https://9to5mac.com/2016/03/27/how-to-create-free-apple-developer-account-sideload-apps/) to make an account (It should work with a normal Apple ID)
2.  Select FBLA2017 (project file) in the Project Navigator (located on the left)
3. Select the "General" tab 
4. Under Identity: Change the bundle ID, replacing com.namehere with any unique domain that you would like to use
![Select Run](https://raw.githubusercontent.com/lukejmann/FBLA2017/master/Photoshop/Screen%20Shot%202017-05-13%20at%209.10.51%20AM.png)
5. If there are any issues at this point, please follow [these instructions](https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppStoreDistributionTutorial/CreatingYourTeamProvisioningProfile/CreatingYourTeamProvisioningProfile.html)
4. Under Signing: Change the team to the newly created team. 
![Select Team](https://raw.githubusercontent.com/lukejmann/FBLA2017/master/Photoshop/Screen%20Shot%202017-05-13%20at%209.13.50%20AM.png)
5. Run the app 
6. If this fails, redo the Instructions for Testing(⬆️) and run the app on a simulator

### Troubleshooting 
| Issue | Solution |
|-------------------------------------------------------------------|--------------------------------------------------------------------------------------------------|
|After Checking Out the repository, Xcode does not load the project| This is an Xcode bug, quit Xcode, naviagate to the directory that the Xcode project is stored in, delete the DerivedData folder, and open `FBLA2017.xcworkspace` OR  delete the downloaded folder and restart the Intructions For Testing, this time changing the download directory location|
| When running on a physical device, the developer is not trusted.  | On the iPhone, go to Settings -> General -> Device Management-> And select "Trust" for your developer profile |
| App appears as a black screen | If running on a simulator, the simulator may be booting up, otherwise, try running the app again |
| "The run destination is not valid" | Ensure that the app running on an iOS device or simulator that is iOS 10.2+  |
| I can't see the project navigator  | In Xcode, go to View -> Navigators and select Project Navigator  
| App views overlap | Try running an app on an iPhone 7 or 7 Plus (either actual device or simulator)
| Location does not load in app |  While running the app, you can set the location of the simulator by selecting the location button in the bottom bar ![Select Location](https://raw.githubusercontent.com/lukejmann/FBLA2017/master/Photoshop/FullSizeRender.jpg) |







<!--### Steps
1. 
 If you have [git](https://git-scm.com) : 
 Run  `git clone https://github.com/lukejmann/FBLA2017.git` in the desired installation folder.
 
 OR
 
 If you do not have git, 
  press the download ZIP button (⬆️) and extract the ZIP file to the desired folder.

2. Open `FBLA2017.xcworkspace`
<!---7. Go to the top left corner, select `FBLA2017` as the Scheme, chose a device to run the app on,  and press the run button (play button)
![Select Run](https://raw.githubusercontent.com/lukejmann/FBLA2017/master/Photoshop/Screen%20Shot%202017-05-05%20at%203.38.44%20PM.png)
8.  If the app is being run on a physical device, the app and developer profile must be approved in the settings menu of the device (Settings –> General –> Device Management)-->

### FAQ
