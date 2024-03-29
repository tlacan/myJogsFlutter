# My Jogs 

<p align="center">
<img src="https://github.com/tlacan/myJogsFlutter/blob/master/logo.png" alt="logo"><br />
Record your jogs into a flutter application
</p>



## Description
My jog is a test project on which I have tested Flutter.<br />
It covers all the main functionnalities that can be found in a mobile application. <br />
Such as webservices call, session management, cache management, forms...


## How to launch project
My Jogs uses an API, you can run it localy with xCode (10.3). <br />
See the api repository here: [https://github.com/tlacan/MyJogs-vapor](https://github.com/tlacan/MyJogs-vapor) 

Then you can launch the flutter application.<br />
See official documentation if needed:<br />
[https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)<br />
[https://flutter.dev/docs/get-started/editor](https://flutter.dev/docs/get-started/editor)


## Project strucutre
The flutter content is stored in lib folder.

Widgets folder contains the widgets class used to handle the UI layer.<br />
Services folder contains the engine and related services.<br />
A service handle a Model component and manages the related http calls, data caching and, model treatement.<br />
There are some additional helpers class to handle strings, styles, date formating...

## Features
List of features available into the application.


###Onboarding<br />
<p align="center"><img src="https://github.com/tlacan/myJogsFlutter/blob/master/1.gif" alt="1"><br /></p>
Onboarding is displayed on every launched until this one has been closed by tapping
"let's go".

<br />
###Login<br />
<p align="center"><img src="https://github.com/tlacan/myJogsFlutter/blob/master/2.gif" alt="2"><br /></p>
login button is disabled when the fields are empty.

###Signup<br />
<p align="center"><img src="https://github.com/tlacan/myJogsFlutter/blob/master/3.gif" alt="3"><br /></p>
There are some fields control such as valid email address, password length, matching password confirmation. <br /><br />

###Record a new jog<br />
<p align="center"><img src="https://github.com/tlacan/myJogsFlutter/blob/master/4.gif" alt="4"><br /></p>
It asks for the geo location.<br />
This way it has the user speed. <br />
A chrono is displayed.<br />
The background is green or red depending if it fits your settings.

###Settings<br />
<p align="center"><img src="https://github.com/tlacan/myJogsFlutter/blob/master/5.gif" alt="5"><br /></p>
Configure the desired target speed, and the tolerance level for your jogs.
Logout button.

###History<br />
<p align="center"><img src="https://github.com/tlacan/myJogsFlutter/blob/master/6.gif" alt="6"><br /></p>
History show the jogs recorded, you can delete a Jog with left swipte action.



## Known issues
1. The distance do not fit the reality, it is computed with GPS coordinate distance and it is not
really accurate. Using Google Api would be a solution to have a better result.
Due to wrong distance, the speed distance computed with it in History is also wrong.

1. On Android the lottie background is white and do not handle transparency.

