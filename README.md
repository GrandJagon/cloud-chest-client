# Cloud chest

Cloud chest is a picture backing application. Connected to the backend (also available on my repositories) it allows one to upload pictures to the server.
Albums can also be created and shared with the other user on the same server. Each album owner can manage the different rights of the album (read, post and delete).
There is also a download feature to download an album content (or just chosen pictures) directly into the user's photo gallery.

This project is an educational project, even though the app is working for android and I will not deploy it in the shop for public use but I intend to use it myself and share it in a private way. My back-end hardware for the backend is a raspberry pie connected to an hard drive.

Feel free to use the code as much as you want ! Any feedback is appreciated :)

## Technical features

Cloud chest is completely written using the Flutter framework for the Dart language.
The communication with the server is made through a REST Api (implemented using Node.Js in the repisitory cloud-chest-server). All data exchange is fully encrypted using SSL and authentication is made possible with JWT token (all details are avalaible in the server repo).
The token is required for any request to the server and verified each time.

An SQLite database has been implemented that would store in the devices the path for each picture and in case the user wants to download it (or uploads it from the gallery) the local path would be replacing the network one. The goal of this feature was to check before querying pictures from the server if it was already in device storage in order to alleviate the server's bandwith.
Unfortunately I could not fin any Flutter package that was able to download a picture to the photo gallery and returns the picture path at the same time. My idea was to develop the method channels myself but I sadly will not have time enough for it.

