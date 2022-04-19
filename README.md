
# **Run With Me**

### **Design and Implementations of Mobile Applications**
Course project for academic year 2021-2022

Developed by **Federico Dei Cas** and **Daniele Valentino De Vincenti**

## **App Description:**
**Run With Me** is a mobile application developed in [Flutter](https://flutter.dev/) for Android devices such as smartphones and tablets. 
This app helps runners all over the world to join other runners and create groups. 

With the app it will be possible to view, create and register to running events near the user. In fact, once a user sign up, it can create new running events with a precise starting point, a duration, a lenght and many other stats. The creator of an events will also be the leader of the event that will lead the group throughout the run.
Other users can then search for event nearby or everywhere in the world with a user friendly map interface and can join whatever event they want. 

## **App Pages:**
### **Home** 
The home page of the application.
Upon opening the app, the user is greeted with: 

 - some imformations about itself
 - few of the next booked Events
 - weather forecasts for the user current location in the next days
 - the user current location informations
 - weekly stats computed from the past booked events
 - some past booked events

### **Browse**
Here the user can search and view events, filtering by date, by distance from itself or from any location in the world.
The user can also choose to view all events or to filter out the ones that are full.

Searched results can then be sorted by distance, date, difficulty, lenght or duration. Finally, searched events can be viewed in a grid, list or map style.

### **New**
In the New page the user can create a new event giving it a name, starting time, location and other parameters such as distance, duration and the max number of participants.

### **Events**
The events page is used to show the user all its booked events, separated in past and future events.
As in the Search page, a user can sort by distance, date, difficulty, lenght or duration. Also, booked events can be viewed in a grid or list style. 

### **User**
The user page gives the user all the informations about itself. 
At the bottom of the page one can find the app settings such as the theme mode and the logout button, along with some general informations about the app.

### **Event**
In an event page all the event informations are shown, such as:
 - location 
 - name 
 - date 
 - distance from the user 
 - duration
 - average pace
 - difficulty level
 - current amount of participants with respect to the max

The user is also given the option to subscribe to such event, or to unsubscrive in case it is already subscribed to it.


## **General Infos:**
### **Backend** 

- Most of the informations displayed on the app screens is requested to a set of custom developed APIs that are hosted as a Python backend. Such backend is responsible for storing all user data and all running events data. It is also responsible for users authentication and in order to achieve a secure communication, a JWT based authentication token is shared between  

### **External Services**
- [Google maps APIs](https://developers.google.com/maps) have been used extensively throughout the app to view events location, to let the user set a starting location for a new event and to vew the location of each event in the event page.

- [Google places APIs](https://developers.google.com/maps/documentation/places/web-service/overview) have also been used to let the user search locations in a text based manner while still getting all the place informations needed by the app and the backend.

- [OpenWeatherMap APIs](https://openweathermap.org/) have been used to provide the user with location based weather forecasts in the home page.



