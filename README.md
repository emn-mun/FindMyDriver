### FindMyDriver is an app similar to Uber that you let you follow in (almost) realtime a driver's location.
This is using RxSwift.


### Find My Driver

**Find My Driver** is a simple application showing a map automatically recentered on the latest known location of a given driver. To follow a driver, the user has to tap on the bottom-right "menu" button and select one of the 4 drivers around.
Once selected, the app shows the map centered on the driver's location and displays a banner with the driver's fullname, it's profile picture and the current postal address of its location.
​
- Once a driver is followed, its location must be refreshed every 5s and the map should automatically recenter itself on the new location ⏳

## Drivers Coordinate
The list of drivers around a location is fetchable using a REST API:

**URL**
```
PUT http://hiring.heetch.com/mobile/coordinates
```

**Headers**
```
Accept: application/json
Content-Type: application/json
```

**Body**
```json
{
    "latitude": 48.858181,
    "longitude": 2.348090
}
```

**Response**
```json
[
    {
        "id": 1,
        "firstname": "Patrick",
        "lastname": "Delapique",
        "image": "/mobile/images/nutty.jpg",
        "coordinates": {
            "latitude": 48.86162,
            "longitude": 2.34490
        }
    }
]
```
