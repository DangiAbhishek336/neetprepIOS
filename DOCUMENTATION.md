# Essential Documentation

This provides basic outilne of the structure of project. Apart there are few comments present in the code itself.

## Table of Contents

- [merge request to merge flutterflow branch to develop/ff-merge branch](#merge-request-to-merge-flutterflow-branch-to-developff-merge-branch)
- [Installation](#installation)
- [Components](#components)
  - [main.dart](#maindart)
  - [login page](#login-page)
  - [practice chapter wise page](#practice-chapter-wise-page)
  - [practice test page](#practice-test-page)
  - [practice question page](#practice-question-page)
  - [notes page](#notes-page)
  - [create and preview test page](#create-and-preview-test-page)
  - [start test page](#start-test-page)
  - [create custom test page](#create-custom-test-page)
  - [test page](#test-page)
  - [result page](#result-page)
  - [view test with answers page](#view-test-with-answers-page)
  - [order page](#order-page)
  - [post transaction page](#post-transaction-page)
- [development notes](#development-notes)

## Merge request to merge flutterflow branch to develop/ff-merge branch

  Use command to merge this pull request from IDE. This will merge the flutterflow branch to develop/ff-merge branch. This branch can be used to test the app on local machine. This branch can be merged to develop branch after testing.

    gh pr checkout 4

   Contains multiple merge conflicts. Resolve them manually.

## Installation

1. Clone the repository
2. Install the dependencies using

        flutter pub get
3. Run the app using

        flutter run

### Notes

    - This project was built using Flutter 3.7.0 and Dart 2.19.0
    - This needs to be bumped up to Dart > 3.0.0
    - If testing on browser use `flutter run -d web-browser` to generate localhost link/(port)
    - Open chrome using command `chrome.exe --user-data-dir="C://Chrome dev session" --disable-web-security`
    - This is done avoid CORS error
    - If there is Firebase error, please make sure to add debug sha key to firebase console.
    - People API to be also enabled in Google Cloud Console

    - Utilise `git flow` to manage branches and releases

## Components

### main.dart

It has firebase implemented on the basis on user email. It also logs user id using key value pair.

Dark mode is disabled from here.

### login page

Simple google based login. If porting to different code files to different app, please do check Gmail config file. It might contain some hardcoded parameters.

### practice chapter wise page

This page has two component search and chapter list.
Search is simply checks where the given keyword exists in the List of names of chapters or not.

The chapter list is stored in App state which is intialised on home page. There is also a persisted app state which stores history or recent searches. ***Currently there is no check for duplicate searches. It can be implemented with same logic as LRU cache.***

Main chapter list page utilises Isolate functions to call apis' paralelly to main thread to prevent UI hang. But not sure how effective it was. This was used because it was advised to not make unneccessary calls when Builder or future builder is been called.

The QuesLimitComponent can handle params like mrp, currPrice and discount percentage. Corresponding UI can be enabled at dart file. ***Currently it is disabled.***

In app Rating is implement using the in-app-review package.

### practice test page

This page shows both subtopics and bookmarks for given chapter.
This is implemented using TabBar widget.

Here, number of click on subtopics is calculated and after 3 times. It will trigger `in app review` package to ask for review. on main page.

There is also bottom modal sheet included which is shown when user tries to access the questions without subscription or enrolling first. This has same component as QuesLimitComponent in practice chapter wise page.

Bookmarks tab shows all the bookmarked ques with thier ans and explanation.

***Currently there is no way to remove bookmark directly from this page, which can be implemented***

Bookmarked components are similar to the one in practice question page.

### practice question page

This page shows all the questions for given subtopic.

It displays question using HTML widget. From here one add or remove bookmarks.

Similarly, show me NCERT button is also implemented using HTML widget.

The explanation component has two parts, one is HTML widget and other is WebView widget. Custom WebView is used only with Youtube and Math-text because it provides poor UI and formatting.

Because the navigation are implemented outside the Page View widget they require a intermediary variable to relay the current page index.

There is also section change banner implemented. We can have index of first question in each section. We then utilise a lower bound function to find the section index. If the current index is equal the index pointed by section number, then we show the banner.

### notes page

Simply displays all notes available for given course. *Currently there is some issue with the URLs of the notes. They work perfectly fine for PG URLs but not with UG ones.*

Instead of using PDF viewer widget, user is redirected to browser to view/download the PDF. ***Should be changed to PDF viewer widget ASAP to prevent unwanted downloading of PDF.***

### create and preview test page

> This page is not accessible from the Essential app. It is implemented in Reflex UG app.

This page has three parts, one is button to create custom test, it has some of the features disabled. Second is to show the custom test created by user. Third is to show the mock test created by admin.

### start test page

> This page is not accessible from the Essential app. It is implemented in Reflex UG app.

Shows all the details of the test. It also has a button to start the test.

### create custom test page

> This page is not accessible from the Essential app. It is implemented in Reflex UG app.

Currently backend only supports few custom parameters. So, although UI can handle more complex parameters, it is not implemented.

### test page

> This page is not accessible from the Essential app. It is implemented in Reflex UG app.

Made similar to practice question page. It has a timer and a submit button. It also has a similar bottom modal sheet to navigate through question.

### result page

> This page is not accessible from the Essential app. It is implemented in Reflex UG app.

Shows the result of the test. It also has a button to view the test with answers.

### view test with answers page

> This page is not accessible from the Essential app. It is implemented in Reflex UG app.

Implemented similar to practice question page. It shows the correct answer and explanation for each question using varoius widget.

### order page

Shows all the courses available for purchase.
**Currently it supports only one course at a time**

It shows course details from course offer array returned by back end.

Backend response has two parts -

    1. It shows a single offer for a course. ***for some course IDs, this details is only available***
    2. It shows a second component which dispay all the courses in the course offer array. In current implementation, this is only used. 

***UI to handle first is present but is commented out.***

***While course IDs with empty course offer array can result in page to crash due to null error***

To provide a visual feedback to user, the border color and border width of the course card is changed when user clicks on it. This is implemented using a selectedSstate variable. If it is equal to the index of the course card, then the border color and width is changed.

For handling case when both course detail and course offer array is display (Both UI parts stated above are enabled), this visual feedback will require small changes for proper operation. Currently code is implemented to check whether the course offer array has been selected by user or only course detail is selected (a boolean check). This can be changed to check whether the course detail is selected or not. This will require small changes in the code.

### post transaction page

Currently this page only has two state for either payment success or payment failure. It can be extended to handle case when payment is successfull but backend does not provide subscription access or details.

## Development notes

- Feature to show a limited amount of question without requiring any subscription is implement on a feature branch can be easily merge devleop and be tested.

- A major improvement can come through the use of Ink and Inkwell widget, to provide a ripple touch effect to the buttons.
Because current implementation uses Inkwell and Container to provide the same effect. There is no ripple effect on the buttons. As both color of inkwell is transparent and it lies below the container. ***This can only be implemented if the container is removed and replaced with Ink widget. Also this cannot be currently\* achieved using FlutterFlow platform.*** This would require manually changingevery occurence in the code.

- SafeArea widget implemented by FlutterFlow is not properly implemented. Some of the widgets cross the safe area. This can be fixed by manually changing the code.

- Custom WebView widget has stock fonts instead of Poppins font, But it was causing some issues with the formatting of the text as stated by a senior. Also WebView has fixed height, this can be looked into.

- The way the app is structured, at some there are unncecessary calls to setState causing whole page to rebuild. Redudant calls can be removed.

- there is slight lag between user input and actual display of the input. This needs to looked upon and fixed. methods like isolate functions, Querycache and utilising App state can be used to fix this.

- Some part of the backend code have few hardcoded values. This can be fixed by using a config file.

- **Dark mode can be implemented on priority**

- Debuging and testing directly from FlutterFlow platform is little cumbersome. It is better to test the app on local machine. But causes flutterflow branch and local branch to diverge. *I was not able to deal with this issue.*

- The way worked is to utilise `git cherry-pick` command to fetch changes from FF branch to my local branch. This causes branches to diverge but is faster in my opinion.

- ***Reset popup which is present on prectice test page to reset the answer is not working. Requires some research***

- ***On test page in reflex app on resuming test it reset the timer to 0, making it possible to cheat. This needs to be fixed.***

- ***bubble question tracker suffers from null check applied on null value error when it is closed using scroll down or close button.***

- When user clicks on pay button there can be bottom modal can be automatically opened to add phone number and other details.

- functions like `safeElement()` can be utilized to prevent null error without adding multiple conditions.

- using map function has known to be slow. It can be replaced with for loop or other type of iteration methods.

- use of column in dynamic widget to be replaced with listview or other dynamic widget.
