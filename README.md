# Quoteslection 🖊 

### Video Demo 📺

(coming soon)

### Description 📄

##### Abstract

Quoteslection, short for quotes-collection, is a website for looking at and sharing quotes. Quotes and information related to them, i.e. Quotee (the one who said the quote), submitter of the quote, and number of favourites can be seen without  signing in. However to use all the features on the site - including features of submitting quotes; liking quotes; and viewing submitted and liked quotes - signing in is required.

##### Folder Structure:

* image/README: contains images for the project readme file
* static: contains static files for the app.
  * static/scripts: JavaScript file(s)
  * static/styles: CSS file(s)
* templates: countains HTML templates for the frontend.
* app.py: The main file, written in python, that runs the application. It contains the backend logic of the application.
* helpers.py: Contains some helper functions that are used by app.py
* requirements.txt: Contains required python dependencies that must be installed to run the application.
* schema.sql: Contains SQL queries for database creation and insertion of some data.

##### Code Details

The application is made using Python's Flask framework, which is a backend web framework. Using flask, python functions for all views or routes are written. A view or a route is something that a user can see / visit. For example one route is called "/" which is the homepage. Another one is "/signup" which can be visited to sign up for a new account. These python functions "listen" for HTTP requests from the front end and respond in different ways. The functions for routes of this application are written in [app.py](app.py), which is explained below:

**app.py**

At the start, required libraries/functions/modules are imported. Next Flask is configured and the database is connected, followed by functions for routes.

**index** ("/" route)

The default route, for home page. It fetches quotes and details for them from the database and returns the index.html template.

**signup** ("/signup" route)

First this function checks if a user is already signed in, in which case it redirects to the default route. It then checks whether the route was visited via GET parameter in which case it returns the signup.html page. If the page is visited via POST request, that is after submitting signup form, the function first gets the signup details and performs some validation on them. If validation checks aren't passed then  the signup page with an error message is returned. If validation checks are passed then the user is added to the `user` table in the database, signed in via `signin_user` function (present in helpers.py, explained later), and redirected to the default route.

**signin** ("/signin" route)
This works similarly to the signup route. If a user is logged in then a redirect to default route is returned whereas if GET request is recieved then `signin.html` is rendered. If a POST request is recieved (through submitting signin form) then username and password are recieved from the request, and checked if any of them are empty then the `signin.html` page is rendered with an error message. Next the credentials are verified. If they are invalid then the `signin.html` page is rendered with an error message. Otherwise user is signed in via `signin_user` function(present in helpers.py, explained later) and redirected to the default route.

#### Screenshots

###### Home page (when not signed in)

![](image/README/1633578544698.png)

###### Home page (when signed in)

![](image/README/1633578481586.png)

###### Sorting filter on home page

![](image/README/1633578668506.png)

###### Favourites

![](image/README/1633578589199.png)

###### My Submissions page

![](image/README/1633578809370.png)

###### Delete Quote page (accessed by clicking on delete icon for a quote on My Submissions page

![](image/README/1633578715466.png)

###### Sign Up page

![](image/README/1633579080423.png)

###### Sign In page

![](image/README/1633579047720.png)

### How to run on your computer 💻

###### Prerequisites

* Install Python (Version 3.8 or above)

  * [Python downloads website](httpshttps://www.python.org/downloads/)
* Following python libraries (which can be installed by running `pip install -r requirements.txt` in a terminal while inside the root directory of the  project):

  * mysql-connector-python
  * Flask
  * Flask-Session
* MySQL server (any version should be fine)

  * [MySQL installer download website](https://dev.mysql.com/downloads/mysql/)
* Run the [schema.sql file](schema.sql) (present in root directory of the project) to get the database. Optionally uncomment the insert statements present at the bottom to get some initial data.

###### Run the web app

In a terminal (while in the root of the project), execute `Flask run`. It should give a URL, which you can visit using any browser to view and start using the website.
