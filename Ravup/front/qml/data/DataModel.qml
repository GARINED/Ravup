import QtQuick 2.0
import Felgo 3.0
import "../api"

Item {

    // property to configure target dispatcher / logic
    property alias dispatcher: logicConnection.target
    property var apiData: api

    // whether api is busy (ongoing network requests)
    readonly property bool isBusy: api.busy
    property bool reLogin: false

    // whether a user is logged in
    readonly property bool userLoggedIn: _.userLoggedIn

    readonly property bool wrongConnection: _.wrongConnection
    readonly property bool alreadyExist: _.alreadyExist
    readonly property bool samePassword: _.samePassword
    readonly property int pages: _.pages

    readonly property var localStorage: _.localStorage
    readonly property var dataGet: _.dataGet
    // action error signals
    signal fetchLoginFailed(var error)

    // listen to actions from dispatcher
    Connections {
        id: logicConnection

        // action 1 - clearCache
        onClearCache: {
            cache.clearAll()
        }

        // action 2 - login
        onLogin: {
            var body = {
                "username": username,
                "password": password
            }
            _.wrongConnection = false

            // load from api
            api.login(body,
                      function(data) {
                          cache.setValue("token", data["token"])
                          cache.setValue("user", data["user"])
                          _.userLoggedIn = true
                          _.pages = 2
                          cache.setValue("page", _.pages)
                          reLogin = false
                          console.log(data["token"])
                          console.log(cache.getValue("user").username)
                      },
                      function(error) {
                          _.wrongConnection = true
                      })
        }

        // action 3 - register
        onRegister: {
            if (confirmPassword == password) {
                _.samePassword = true
                var body = {
                    "username": username,
                    "password": password,
                    "email" : email
                }
                _.alreadyExist = false

                // load from api
                api.registered(body,
                          function(data) {
                              _.pages = 0
                          },
                          function(error) {
                              _.alreadyExist = true
                          })
            }
            else {
                _.samePassword = false
            }
        }

        // action 4 - logout
        onLogout: {
            cache.clearAll()
            _.userLoggedIn = false
            _.pages = 0
        }

        // action 5 - changePage
        onChangePage: {
            _.wrongConnection = false
            _.pages = page
        }

        // action 6 - get method
        onGetRequest: {
            _.dataGet = ""
            api.get(url, cache.getValue("token"),
                    function(data) {
                        _.dataGet = JSON.parse(data)
                        console.log(_.dataGet)
                    },
                    function(err) {
                        console.log(err)
                    })
        }
    }

    // you can place getter functions here that do not modify the data
    // pages trigger write operations through logic signals only

    // rest api for data access
    RestApi {
        id: api
    }

    // storage for caching
    Storage {
        id: cache
    }

    // private
    Item {
        id: _

        property var localStorage: cache
        // auth
        property bool userLoggedIn: cache.getValue("token") ? true : false
        property bool wrongConnection: false
        property bool samePassword: true
        property bool alreadyExist: false
        property int pages: cache.getValue("page") ? 2 : 0
        property var dataGet: ["test"]
    }

    // Public function
    function postOneEvent(name, shortDescription, longDescription, type, location, status, ageMin, price, autoAccept, maxParticipate, authorizationDate, coverPicture, listSelectedDate, listUser) {
        var body = {
            "name": name,
            "shortDescription": shortDescription,
            "longDescription": longDescription,
            "type": type,
            "location": location,
            "status": status,
            "ageMin": ageMin ? parseInt(ageMin) : 0,
            "price": price ? parseInt(price) : 0,
            "autoAccept": autoAccept,
            "maxParticipate": maxParticipate ? parseInt(maxParticipate) : 0,
            "authorizationDate": authorizationDate,
            "coverPicture": coverPicture,
            "creator": "/api/users/" + localStorage.getValue("user")["id"]
        }
        dataModel.apiData.post("/api/events", body, dataModel.localStorage.getValue("token"),
                               function(data) {
                                   var eventId = JSON.parse(data)
                                   eventId = eventId["id"]
                                   console.log("count dates = ", listSelectedDate.count)
                                   for (var i = 0; i < listSelectedDate.count; i++) {
                                       console.log(listSelectedDate.get(i)["date"])
                                       var bodyDate = {
                                           "date": listSelectedDate.get(i)["date"],
                                           "duration": 1,
                                           "event": eventId
                                       }
                                       dataModel.apiData.post("/api/dates", bodyDate, dataModel.localStorage.getValue("token"),
                                                              function(data) {
                                                                  console.log("success date")
                                                              },
                                                              function(err) {
                                                                  console.log("error date: ", err)
                                                              })
                                   }
                                   console.log("count userInvited = ", listUser.count)
                                   for (i = 0; i < listUser.count; i++) {
                                       var bodyParticipation = {
                                           "relatedUserId": listUser.get(i)["id"],
                                           "participate": -1,
                                           "eventId": eventId
                                       }
                                       dataModel.apiData.post("/api/participations", bodyParticipation, dataModel.localStorage.getValue("token"),
                                                              function(data) {
                                                                 console.log("success participation")
                                                              },
                                                              function(err) {
                                                                  console.log("error participation: ", err)
                                                              })
                                   }
                                   var bodyMyParticipation = {
                                       "relatedUserId": localStorage.getValue("user")["id"],
                                       "participate": -1,
                                       "eventId": eventId
                                   }
                                   dataModel.apiData.post("/api/participations", bodyMyParticipation, dataModel.localStorage.getValue("token"),
                                                          function(data) {
                                                             console.log("success participation")
                                                          },
                                                          function(err) {
                                                              console.log("error participation: ", err)
                                                          })
                                   console.log("success event = ", data)
                                   logic.changePage(6)
                               },
                               function(err) {
                                   console.log("error event = ", err)
                               })
    }

    function isExist(model, id) {
      for(var i = 0; i < model.count; ++i) {
          if (model.get(i)["id"] === id) {
              return true
          }
      }
      return false
    }
}
