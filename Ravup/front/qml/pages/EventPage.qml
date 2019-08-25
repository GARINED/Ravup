import QtPositioning 5.5
import QtLocation 5.6
import QtQuick.Window 2.2
import QtQuick.Controls 2.1
import Felgo 3.0
import QtQuick 2.0
import QtGraphicalEffects 1.0

Page {
    id: eventPage
    useSafeArea: false
    property string id: "nothing"
    property int lastPage: 2
    property var objectEvent
    property bool isBusy: false
    property real lon: -0.580036
    property real lat: 44.841225
    property var userPos
    property var userInvitedObject
    property var myParticipation
    property var dataPut

    onVisibleChanged: {
        isBusy = true
        if (visible) {
            dataModel.apiData.get("/api/events/" + id, dataModel.localStorage.getValue("token"),
                    function(data) {
                        objectEvent = JSON.parse(data)
                        userInvitedObject = objectEvent["userParticipations"]
                        listModelUserInvited.clear()
                        for (var i in userInvitedObject) {
                            if (userInvitedObject[i]["relatedUser"]["id"] === dataModel.localStorage.getValue("user")["id"]) {
                                myParticipation = {
                                    id: userInvitedObject[i]["id"],
                                    relatedUser: userInvitedObject[i]["relatedUser"],
                                    participate: userInvitedObject[i]["participate"]
                                }
                            }
                            listModelUserInvited.append({
                                                      id: userInvitedObject[i]["id"],
                                                      relatedUser: userInvitedObject[i]["relatedUser"],
                                                      participate: userInvitedObject[i]["participate"]
                                                  });
                        }
                        isBusy = false
                    },
                    function(err) {
                        console.log("votre session à expiré ", err)
                        dataModel.reLogin = true
                        logic.logout()
                    })
        }
    }

    Rectangle {
        id: activityIndicatorEvents
        width: parent.width
        height: eventPage.height - headBar.height - safeAreaTop.height
        visible: isBusy
        anchors.top: headBar.bottom
        AppActivityIndicator {
            anchors.top: parent.top
            anchors.topMargin: (parent.height - height) / 2
            anchors.left: parent.left
            anchors.leftMargin: (parent.width - width) / 2
            height: parent.height / 2
            width: parent.width / 3
            color: "black"
        }
    }

    Rectangle {
        id: nameEventRectangle
        height: eventPage.height / 10
        width: parent.width
        anchors.top: headBar.bottom
        anchors.left: parent.left
        color: "white"//"#d2b4de"
        visible: isBusy ? false : true

        AppText {
            id: nameEvent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: (parent.width - width) / 2
            anchors.topMargin: height / 1.25
            text: qsTr(objectEvent ? objectEvent["name"] : "")
            font.family: boldConfortaa.name
            font.pixelSize: sp(25)
        }

        Icon {
            id: lockIcon
            icon: IconType.lock
            color: "black"
            anchors.top: parent.top
            anchors.topMargin: (parent.height - height) / 2
            anchors.right: parent.right
            anchors.rightMargin: width
            visible: (objectEvent ? (objectEvent["status"] === "Public" ? false : true) : false)
        }
        Icon {
            id: unlockIcon
            icon: IconType.unlock
            color: "black"
            anchors.top: parent.top
            anchors.topMargin: (parent.height - height) / 2
            anchors.right: parent.right
            anchors.rightMargin: width
            visible: (objectEvent ? (objectEvent["status"] === "Private" ? false : true) : false)
        }
    }

    Rectangle {
        id: basicInfoRectangleStatic
        width: parent.width
        height: eventPage.height / 12
        anchors.top: nameEventRectangle.bottom
        anchors.left: parent.left
        color: "white"//"#d2b4de"
        border.width: 5
        border.color: "black"
        visible: isBusy ? false : (eventFlickable.visibleArea.yPosition / eventFlickable.visibleArea.heightRatio) * 1000 > (nameEventRectangle.y - (nameEventRectangle.height / 9.5)) ? true : false

        Rectangle { // Text minimum Age
            height: parent.height / 1.15
            width: parent.width / 3.25
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 5
            anchors.leftMargin: 5

            AppText {
                id: minAgeStatic
                anchors.top: parent.top
                anchors.topMargin: (parent.height - height) / 2
                anchors.left: parent.left
                anchors.leftMargin: (parent.width - width) / 2.5
                text: qsTr((objectEvent ? (objectEvent["ageMin"] === 0 ? "Open to All" : objectEvent["ageMin"] + "") : ""))
                font.family: lightConfortaa.name
                font.pixelSize: (objectEvent ? (objectEvent["ageMin"] === 0 ? sp(18) : sp(20)) : sp(0))
            }
            AppText {
                anchors.top: parent.top
                anchors.topMargin: (parent.height - height) / 2
                anchors.left: minAgeStatic.right
                anchors.leftMargin: parent.width / 10
                text: qsTr("Min.\nage")
                font.family: lightConfortaa.name
                font.pixelSize: sp(10)
                visible: (objectEvent ? (objectEvent["ageMin"] === 0 ? false : true) : false)
            }
        }

        Rectangle { // first break
            id: firstBreakStatic
            height: parent.height / 2
            width: 6
            anchors.top: parent.top
            anchors.topMargin: (parent.height - height) / 2
            anchors.left: parent.left
            anchors.leftMargin: parent.width / 3
            color: "black"
        }

        Rectangle { // Text Price
            height: parent.height / 1.15
            width: parent.width / 3.25
            anchors.top: parent.top
            anchors.left: firstBreakStatic.right
            anchors.topMargin: 5
            anchors.leftMargin: 5

            AppText {
                id: priceStatic
                anchors.top: parent.top
                anchors.topMargin: (parent.height - height) / 2
                anchors.left: parent.left
                anchors.leftMargin: (parent.width - width) / 2.5
                text: qsTr((objectEvent ? (objectEvent["price"] === 0 ? "Free" : objectEvent["price"] + "") : ""))
                font.family: lightConfortaa.name
                font.pixelSize: sp(20)
            }
            AppText {
                anchors.top: parent.top
                anchors.topMargin: (parent.height - height) / 2
                anchors.left: priceStatic.right
                anchors.leftMargin: parent.width / 10
                text: qsTr("€")
                font.family: lightConfortaa.name
                font.pixelSize: sp(20)
                visible: (objectEvent ? (objectEvent["price"] === 0 ? false : true) : false)
            }
        }

        Rectangle { // second break
            id: secondBreakStatic
            height: parent.height / 2
            width: 6
            anchors.top: parent.top
            anchors.topMargin: (parent.height - height) / 2
            anchors.right: parent.right
            anchors.rightMargin: parent.width / 3
            color: "black"
        }

        Rectangle { // Text Personne Max.
            height: parent.height / 1.15
            width: parent.width / 3.25
            anchors.top: parent.top
            anchors.left: secondBreakStatic.right
            anchors.topMargin: 5
            anchors.leftMargin: 5

            AppText {
                id: maxPeopleStatic
                anchors.top: parent.top
                anchors.topMargin: (parent.height - height) / 4
                anchors.left: parent.left
                anchors.leftMargin: (parent.width - width) / 2
                text: qsTr((objectEvent ? (objectEvent["maxParticipate"] === 0 ? "No limit" : objectEvent["maxParticipate"] + "") : ""))
                font.family: lightConfortaa.name
                font.pixelSize: sp(20)
            }
            AppText {
                anchors.top: maxPeopleStatic.bottom
                anchors.topMargin: height / 4
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 10
                text: qsTr("Max. People")
                font.family: lightConfortaa.name
                font.pixelSize: sp(15)
                visible: (objectEvent ? (objectEvent["maxParticipate"] === 0 ? false : true) : false)
            }
        }
    }

    AppFlickable {
        id: eventFlickable
        width: parent.width
        height: parent.height - headBar.height - nameEventRectangle.height
        anchors.top: (eventFlickable.visibleArea.yPosition / eventFlickable.visibleArea.heightRatio) * 1000 > (nameEventRectangle.y - (nameEventRectangle.height / 9.5)) ? basicInfoRectangleStatic.bottom : nameEventRectangle.bottom
        anchors.left: parent.left
        contentHeight: contentColumn.height
        contentWidth: contentColumn.width
        visible: isBusy ? false : true
        MouseArea {
            anchors.fill: parent
            onClicked: {
                eventPage.forceActiveFocus()
            }
        }

        onFlickingChanged: {
            //console.log("y = ", eventFlickable.visibleArea.yPosition, " and height ratio = ", eventFlickable.visibleArea.heightRatio, " and result = ", (eventFlickable.visibleArea.yPosition / eventFlickable.visibleArea.heightRatio) * 1000)
            //console.log("y name event = ", nameEventRectangle.y)
        }

        Rectangle {
            anchors.fill: parent
            color: "#ebdef0"
        }

        Column {
            id: contentColumn
            width: eventPage.width
            anchors.left: parent.left
            height: eventImageRectangle.height + shortDescrition.height + longDescription.height + txtEventType.height
                    + mapRectangle.height + basicInfoRectangle.height
                    + flickUser.height + participateAndMessage.height + safeAreaTop.height

            Rectangle {
                id: eventImageRectangle
                width: parent.width
                height: eventPage.height / 4
                color: "white"//"#d2b4de"
                Rectangle {
                    id: eventImage
                    width: parent.width / 2
                    height: parent.height / 1.05
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: (parent.width - width) / 2
                    radius: 20
                    Image {
                        width: parent.width
                        height: parent.height
                        source: (objectEvent && objectEvent["coverPicture"] ? "http://10.10.253.39/uploads/" + objectEvent["coverPicture"]["fileId"] : "../../assets/Unknown-person.png")
                        fillMode: Image.PreserveAspectCrop
                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: parent
                        }
                    }
                }
            }

            Rectangle {
                id: basicInfoRectangle
                width: parent.width
                height: eventPage.height / 12
                color: "white"//"#d2b4de"
                border.width: 5
                border.color: "black"
                visible: (eventFlickable.visibleArea.yPosition / eventFlickable.visibleArea.heightRatio) * 1000 > (nameEventRectangle.y - (nameEventRectangle.height / 9.5)) ? false : true
                onVisibleChanged: {
                    if (visible) {
                        eventFlickable.flick(0, -100)
                    }
                    else {
                        eventFlickable.flick(0, -100)
                    }

                }

                Rectangle { // Text minimum Age
                    height: parent.height / 1.15
                    width: parent.width / 3.25
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: 5
                    anchors.leftMargin: 5

                    AppText {
                        id: minAge
                        anchors.top: parent.top
                        anchors.topMargin: (parent.height - height) / 2
                        anchors.left: parent.left
                        anchors.leftMargin: (parent.width - width) / 2.5
                        text: qsTr((objectEvent ? (objectEvent["ageMin"] === 0 ? "Open to All" : objectEvent["ageMin"] + "") : ""))
                        font.family: lightConfortaa.name
                        font.pixelSize: (objectEvent ? (objectEvent["ageMin"] === 0 ? sp(18) : sp(20)) : sp(0))
                    }
                    AppText {
                        anchors.top: parent.top
                        anchors.topMargin: (parent.height - height) / 2
                        anchors.left: minAge.right
                        anchors.leftMargin: parent.width / 10
                        text: qsTr("Min.\nage")
                        font.family: lightConfortaa.name
                        font.pixelSize: sp(10)
                        visible: (objectEvent ? (objectEvent["ageMin"] === 0 ? false : true) : false)
                    }
                }

                Rectangle { // first break
                    id: firstBreak
                    height: parent.height / 2
                    width: 6
                    anchors.top: parent.top
                    anchors.topMargin: (parent.height - height) / 2
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width / 3
                    color: "black"
                }

                Rectangle { // Text Price
                    height: parent.height / 1.15
                    width: parent.width / 3.25
                    anchors.top: parent.top
                    anchors.left: firstBreak.right
                    anchors.topMargin: 5
                    anchors.leftMargin: 5

                    AppText {
                        id: price
                        anchors.top: parent.top
                        anchors.topMargin: (parent.height - height) / 2
                        anchors.left: parent.left
                        anchors.leftMargin: (parent.width - width) / 2.5
                        text: qsTr((objectEvent ? (objectEvent["price"] === 0 ? "Free" : objectEvent["price"] + "") : ""))
                        font.family: lightConfortaa.name
                        font.pixelSize: sp(20)
                    }
                    AppText {
                        anchors.top: parent.top
                        anchors.topMargin: (parent.height - height) / 2
                        anchors.left: price.right
                        anchors.leftMargin: parent.width / 10
                        text: qsTr("€")
                        font.family: lightConfortaa.name
                        font.pixelSize: sp(20)
                        visible: (objectEvent ? (objectEvent["price"] === 0 ? false : true) : false)
                    }
                }

                Rectangle { // second break
                    id: secondBreak
                    height: parent.height / 2
                    width: 6
                    anchors.top: parent.top
                    anchors.topMargin: (parent.height - height) / 2
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width / 3
                    color: "black"
                }

                Rectangle { // Text Personne Max.
                    height: parent.height / 1.15
                    width: parent.width / 3.25
                    anchors.top: parent.top
                    anchors.left: secondBreak.right
                    anchors.topMargin: 5
                    anchors.leftMargin: 5

                    AppText {
                        id: maxPeople
                        anchors.top: parent.top
                        anchors.topMargin: (parent.height - height) / 4
                        anchors.left: parent.left
                        anchors.leftMargin: (parent.width - width) / 2
                        text: qsTr((objectEvent ? (objectEvent["maxParticipate"] === 0 ? "No limit" : objectEvent["maxParticipate"] + "") : ""))
                        font.family: lightConfortaa.name
                        font.pixelSize: sp(20)
                    }
                    AppText {
                        anchors.top: maxPeople.bottom
                        anchors.topMargin: height / 4
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width / 10
                        text: qsTr("Max. People")
                        font.family: lightConfortaa.name
                        font.pixelSize: sp(15)
                        visible: (objectEvent ? (objectEvent["maxParticipate"] === 0 ? false : true) : false)
                    }
                }
            }

            Rectangle { // Short description
                id: shortDescrition
                anchors.left: parent.left
                width: parent.width
                height: textShortDescription.height + sp(50)
                color: "transparent"
                 AppText {
                     id: textShortDescription
                     anchors.top: parent.top
                     anchors.topMargin: (parent.height - height) / 2
                     anchors.left: parent.left
                     anchors.leftMargin: (parent.width - width) / 2
                     width: parent.width - sp(10)
                     text: qsTr(objectEvent ? objectEvent["shortDescription"] : "")
                     font.family: boldConfortaa.name
                     font.pixelSize: sp(20)
                     wrapMode: Text.WordWrap
                     horizontalAlignment: Text.AlignHCenter
                 }
            }

            Rectangle { // Long description
                id: longDescription
                anchors.left: parent.left
                anchors.leftMargin: (parent.width - width) / 2
                width: eventPage.width / 1.15
                height: textLongDescription.height + sp(40)
                radius: 100
                border.width: 5
                border.color: "#512e5f"
                color: "grey"
                 AppText {
                     id: textLongDescription
                     anchors.top: parent.top
                     width: parent.width - sp(20)
                     anchors.left: parent.left
                     anchors.leftMargin: sp(12)
                     anchors.margins: sp(10)
                     text: qsTr(objectEvent ? objectEvent["longDescription"] === "" ? "No Description Available" : objectEvent["longDescription"] : "")
                     font.family: boldConfortaa.name
                     font.pixelSize: sp(15)
                     wrapMode: Text.WordWrap
                 }
            }

            Rectangle { // Event type
                id: txtEventType
                anchors.left: parent.left
                width: parent.width
                height: eventPage.height / 10
                color: "transparent"
                AppText {
                    id: textEventType
                    anchors.top: parent.top
                    anchors.topMargin: (parent.height - height) / 2
                    anchors.left: parent.left
                    anchors.leftMargin: (parent.width - width) / 2.5
                    text: qsTr(objectEvent ? objectEvent["type"] : "")
                    font.family: boldConfortaa.name
                    font.pixelSize: sp(25)
               }

                Icon {
                    id: birthdayIcon
                    icon: IconType.birthdaycake
                    color: "black"
                    anchors.top: parent.top
                    anchors.topMargin: (parent.height - height) / 2
                    anchors.left: textEventType.right
                    anchors.leftMargin: width
                    visible: (objectEvent ? (objectEvent["type"] === "Birthday" ? true : false) : false)
                }
                Icon {
                    id: partyIcon
                    icon: IconType.glass
                    color: "black"
                    anchors.top: parent.top
                    anchors.topMargin: (parent.height - height) / 2
                    anchors.left: textEventType.right
                    anchors.leftMargin: width
                    visible: (objectEvent ? (objectEvent["type"] === "Party" ? true : false) : false)
                }
            }

            Rectangle {
                id: mapRectangle
                width: parent.width / 1.25
                height: eventPage.height / 2.5
                anchors.left: parent.left
                anchors.leftMargin: (parent.width - width) / 2
                radius: 100
                border.width: sp(100)
                border.color: "#512e5f"

                AppMap {
                    id: mapEvent
                     anchors.fill: parent
                     // configure map provider
                     plugin: Plugin {
                       name: "mapbox"
                       // configure your own map_id and access_token here
                       parameters: [  PluginParameter {
                           name: "mapbox.mapping.map_id"
                           value: "mapbox.streets"
                         },
                         PluginParameter {
                           name: "mapbox.access_token"
                           value: "pk.eyJ1IjoiZ3R2cGxheSIsImEiOiJjaWZ0Y2pkM2cwMXZqdWVsenJhcGZ3ZDl5In0.6xMVtyc0CkYNYup76iMVNQ"
                         },
                         PluginParameter {
                           name: "mapbox.mapping.highdpi_tiles"
                           value: true
                         }]
                     }
                     layer.enabled: true
                     layer.effect: OpacityMask {
                         maskSource: parent
                     }

                     // configure the map to try to display the user's position
                     showUserPosition: true
                     enableUserPosition: true
                     zoomLevel: 17

                     // check for user position initially when the component is created
                     onVisibleChanged: {
                         if(userPositionAvailable) {
                            userPos = userPosition.coordinate
                         }
                         if (visible) {
                             dataModel.apiData.getCoordinate((objectEvent ? (objectEvent["location"] ? objectEvent["location"] : "") : ""),
                                                             function(data) {
                                                                 var location = data["results"][0] ? data["results"][0] : null
                                                                 if (location) {
                                                                     lat = data["results"][0]["geometry"]["lat"]
                                                                     lon = data["results"][0]["geometry"]["lng"]
                                                                     center = QtPositioning.coordinate(lat, lon)
                                                                 }
                                                                 else {
                                                                     center = QtPositioning.coordinate(lat, lon) // Bordeaux
                                                                 }
                                                             },
                                                             function(err) {
                                                                 console.log("votre session à expiré ", err)
                                                                 dataModel.reLogin = true
                                                             })
                         }
                         else {
                             center = QtPositioning.coordinate(lat, lon) // Bordeaux
                         }

                     }

                     MapQuickItem {
                        coordinate: QtPositioning.coordinate(lat, lon)
                        anchorPoint: Qt.point(sourceItem.width/2, sourceItem.height/2)
                        sourceItem: Icon {
                            icon: IconType.child
                            color: "red"
                            size: sp(25)
                        }
                    }
                   }
                IconButton {
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.rightMargin: width / 4
                    anchors.bottomMargin: height / 4
                    icon: IconType.crosshairs
                    color: "blue"
                    size: sp(40)
                    onClicked: {
                        mapEvent.center = userPos
                    }
                }
                IconButton {
                    id: myEventIcon
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.leftMargin: width / 4
                    anchors.bottomMargin: height / 4
                    icon: IconType.child
                    color: "red"
                    size: sp(30)
                    onClicked: {
                        mapEvent.center = QtPositioning.coordinate(lat, lon)
                    }
                }
                AppText {
                    anchors.bottom: parent.bottom
                    anchors.left: myEventIcon.right
                    anchors.bottomMargin: height
                    text: qsTr("My event")
                    font.family: boldConfortaa.name
                    font.pixelSize: sp(15)
                }
            }

            Rectangle {
                id: flickUser
                anchors.left: parent.left
                width: eventPage.width
                height: eventPage.height / 4.5
                color: "transparent"
                Flickable {
                    anchors.top: parent.top
                    anchors.topMargin: (parent.height - (eventPage.width / 5)) / 2
                    width: eventPage.width
                    height: eventPage.height / 5
                    contentWidth: userInvitedRow.width
                    contentHeight: userInvitedRow.height
                    flickableDirection: Flickable.HorizontalFlick
                    Row {
                        id: userInvitedRow
                        Component {
                            id: contactDelegate
                            Rectangle {
                                width: eventPage.width / 5
                                height: eventPage.width / 5
                                color: "#512e5f"
                                border.width: 1
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        profilePage.userId = relatedUser["id"]
                                        logic.changePage(4)
                                    }
                                }
                                Image {
                                    id: userPicture
                                    anchors.top: parent.top
                                    width: parent.width
                                    height: parent.height - txtUsername.height
                                    source: (relatedUser["profilPicture"] !== null ? ("http://10.10.253.39/uploads/" + relatedUser["profilPicture"]["fileId"]) : "../../assets/Unknown-person.png")
                                    fillMode: Image.PreserveAspectCrop
                                }
                                Icon {
                                    icon: (participate == 0 ? IconType.close : (participate == 1 ? IconType.check : IconType.question))
                                    anchors.top: parent.top
                                    anchors.left: parent.left
                                    size: sp(15)
                                    color: participate == 0 ? "red" : (participate == 1 ? "green" : "black")
                                }
                                Text {
                                    id: txtUsername
                                    text: (relatedUser["username"])
                                    anchors.top: userPicture.bottom
                                    anchors.left: parent.left
                                    anchors.leftMargin: (parent.width - width) / 2
                                    font.family: lightConfortaa.name
                                    color: "white"
                                }
                            }
                        }
                        Repeater {
                            id: myEventRepeater
                            model: ListModel {
                                id: listModelUserInvited
                            }
                            delegate: contactDelegate
                            focus: true
                        }
                    }
                }
            }

            Rectangle {
                id: participateAndMessage
                height: eventPage.height / 10
                width: eventPage.width
                color: "#512e5f"
                Rectangle {
                    id: firstRec
                    width: parent.width / 3
                    height: parent.height
                    color: "transparent"
                    border.width: 5
                    border.color: "white"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: customDialog.open()
                    }
                    AppText {
                        anchors.top: parent.top
                        anchors.topMargin: (parent.height - height) / 3
                        anchors.left: parent.left
                        anchors.leftMargin: (parent.width - width) / 2
                        text: qsTr("Participation")
                        font.family: boldConfortaa.name
                        font.pixelSize: sp(15)
                        color: "white"
                    }
                    Icon {
                        icon: (myParticipation ? myParticipation["participate"] === 0 ? IconType.close : (myParticipation["participate"] === 1 ? IconType.check : IconType.question) : "")
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: height / 2
                        anchors.left: parent.left
                        anchors.leftMargin: (parent.width - width) / 2
                        size: sp(20)
                        color: myParticipation ? myParticipation["participate"] === 0 ? "red" : (myParticipation["participate"] === 1 ? "green" : "white") : "white"
                    }
                }
                Rectangle {
                    width: (parent.width - firstRec.width)
                    height: parent.height
                    anchors.top: parent.top
                    anchors.left: firstRec.right
                    color: "transparent"
                    AppText {
                        anchors.top: parent.top
                        anchors.topMargin: (parent.height - height) / 2
                        anchors.left: parent.left
                        anchors.leftMargin: (parent.width - width) / 2
                        text: qsTr("Messages")
                        font.family: boldConfortaa.name
                        font.pixelSize: sp(20)
                        color: "white"
                    }
                    Icon {
                        icon: IconType.arrowright
                        anchors.right: parent.right
                        anchors.rightMargin: width / 2
                        anchors.top: parent.top
                        anchors.topMargin: (parent.height - height) / 2
                        color: "white"
                        size: sp(25)
                    }
                }
            }

        }
    }

    Popup {
        id: customDialog
        modal: true
        focus: true
        anchors.centerIn: parent
        height: eventPage.height / 5
        width: eventPage.width / 1.25

        AppButton {
            id: positiveAction
            height: parent.height / 2
            width: parent.width / 2
            anchors.top: parent.top
            anchors.left: parent.left
            text: "Je participe"
            flat: true
            textColor: "black"
            icon: IconType.checkcircle
            onClicked: {
                dataPut = {
                    "participate" : 1
                }
                customDialog.close()
            }
        }
        AppButton {
            id: negativeAction
            height: parent.height / 2
            width: parent.width / 2
            anchors.top: parent.top
            anchors.left: positiveAction.right
            text: "Je ne participe pas"
            flat: true
            textColor: "black"
            icon: IconType.close
            onClicked: {
                dataPut = {
                    "participate" : 0
                }
                customDialog.close()
            }
        }
        AppButton {
            id: ternaireAction
            height: parent.height / 2
            width: parent.width
            anchors.top: positiveAction.bottom
            anchors.left: parent.left
            text: "Je ne sais pas"
            flat: true
            textColor: "black"
            icon: IconType.question
            onClicked: {
                dataPut = {
                    "participate" : -1
                }
                customDialog.close()
            }
        }
        onClosed: {
            dataModel.apiData.put("/api/participations/" + myParticipation["id"], dataPut, dataModel.localStorage.getValue("token"),
                                  function(data) {
                                  },
                                  function(err) {
                                      console.log("votre session à expiré ", err)
                                      dataModel.reLogin = true
                                  })
            eventPage.forceActiveFocus()
            logic.changePage(2)
        }
    }


    Rectangle {
        id: safeAreaTop
        width: parent.width
        height: nativeUtils.safeAreaInsets.top > 0 ? nativeUtils.safeAreaInsets.top : nativeUtils.statusBarHeight()
        color: "#512e5f"
    }

    Rectangle {
        id: safeAreaBottom
        width: parent.width
        height: nativeUtils.safeAreaInsets.bottom > 0 ? nativeUtils.safeAreaInsets.bottom : nativeUtils.statusBarHeight()
        color: "#512e5f"
    }

    Rectangle {
        id: headBar
        width: parent.width
        height: parent.height / 10
        anchors.top: safeAreaTop.bottom
        color: "#512e5f"

        Image {
            id: logo
            source: "../../assets/viking-helmet-white.png"
            width: parent.width / 2
            height: parent.height / 1.5
            anchors.top: parent.top
            anchors.topMargin: (parent.height - height) / 2
            anchors.left: parent.left
            anchors.leftMargin: (parent.width - width) / 2
            fillMode: Image.PreserveAspectFit
        }

        IconButtonBarItem {
            id: backButton
            icon: IconType.arrowleft
            height: parent.height
            anchors.top: parent.top
            anchors.topMargin: (parent.height - height) / 2
            anchors.left: parent.left
            showItem: showItemAlways
            onClicked: {
                logic.changePage(lastPage)
            }
            color: "white"
        }

        IconButtonBarItem {
            id: editButton
            icon: IconType.edit
            height: parent.height
            anchors.top: parent.top
            anchors.topMargin: (parent.height - height) / 2
            anchors.right: parent.right
            showItem: showItemAlways
            color: "white"
        }
    }
}
