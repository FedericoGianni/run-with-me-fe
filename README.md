# RunWithMe
## Polimi - Design and Implementation of Mobile Applications - 2021
Federico Dei Cas - federico.deicas@mail.polimi.it  
Daniele V. De Vincenti - danielevalentino.devincenti@mail.polimi.it

## Intro
The objective of the app is to provide a platform in which users can find or propose
running events, giving a starting place and time, and the expected distance and time to
complete.

Users can subscribe to other events or create their own, choosing the maximum number
of allowed participants. The backend will calculate a difficulty level between 0-5 for each
proposed run, to suggest event based on the users’ fitness level, which is calculated by
requiring some questions during registration.

Even if a user is not registered, he/she can still browse events. Registration is then
required if he/she wants to subscribe. We made this choice because many application
do not allow to interact without registering first, which can be a deterrent

## Architecture
![Architecture](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/intro_new.png)

The Architecture of the app is a client/server. We decided to implement a self-hosted
backend solution with a separated application server and database server, for versatility
purposes. The client and the application server communicate through REpresentational
State Transfer (REST) Application Programming Interface (API), which is then connected to the database tier, holding our persistent data safely. We decided not to have
persistent local storage for the data (except for Authentication (auth) token and user
settings, like the chosen theme mode). The data requested from the database throught
API are then temporarily stored in non-persistent dart classes.

## Screenshots
![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/Browse.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/Browse_b.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/Browse_map.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/Browse_tab.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/Events.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/New_small.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/New_tab.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/User.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/browse_small_phone.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/date_picker.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/event_detail.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/event_detail_b.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/home.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/home_b.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/home_small.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/home_tab.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/landscape.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/loading.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/login.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/logout_alert.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/map_alert.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/map_detail.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/map_overlay.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/no_gps_error.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/no_internet_error.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/places.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/register.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/register_error.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/search_bottomsheet.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/weather.png)

![](https://github.com/FedericoGianni/run-with-me-fe/blob/master/deliverables/images/search_bottomsheet_error.png)

