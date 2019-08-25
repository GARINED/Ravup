import Felgo 3.0
import QtQuick 2.0

Page {
    id: homePage
    useSafeArea: false

    property int index: 0
    property var myEvents
    property var objectEvents
    property bool isBusyEvents: false
    property bool isBusyMyEvents: false
    property int nbNotifs: 0

    onVisibleChanged: {
        if (dataModel.pages != 2) {
            return
        }
        isBusyEvents = true
        isBusyMyEvents = true
        dataModel.apiData.get("/api/events?status=Public", dataModel.localStorage.getValue("token"),
                function(data) {
                    objectEvents = JSON.parse(data)
                    objectEvents = objectEvents["hydra:member"]
                    listModelEvent.clear();
                    for (var i in objectEvents) {
                        listModelEvent.append({
                                                  id: objectEvents[i]["id"],
                                                  name: objectEvents[i]["name"],
                                                  type: objectEvents[i]["type"],
                                                  location: objectEvents[i]["location"],
                                                  creator: "nothing",
                                                  status: objectEvents[i]["status"],
                                                  price: (objectEvents[i]["price"]) ? "" + (objectEvents[i]["price"]): "0",
                                                  shortDescription: objectEvents[i]["shortDescription"],
                                                  date: objectEvents[i]["dateList"],
                                                  statusEvent: "public event",
                                                  picture: (objectEvents[i]["coverPicture"]) ? objectEvents[i]["coverPicture"]["fileId"] : "null"
                                              });
                    }
                    isBusyEvents = false
                },
                function(err) {
                    console.log("votre session à expiré ", err)
                    dataModel.reLogin = true
                    logic.logout()
                })
        dataModel.apiData.get("/api/users/" + (dataModel.localStorage.getValue("user") ? dataModel.localStorage.getValue("user")["id"] : ""), dataModel.localStorage.getValue("token"),
                function(data) {
                    var user = JSON.parse(data)
                    dataModel.localStorage.setValue("user", user)
                    myEvents = user["createdEvents"]
                    listModelMyEvent.clear();
                    for (var i in myEvents) {
                        if (i < 3) {
                            listModelMyEvent.append({
                                                      id: myEvents[i]["id"],
                                                      name: myEvents[i]["name"],
                                                      type: myEvents[i]["type"],
                                                      location: myEvents[i]["location"],
                                                      creator: "nothing",
                                                      status: myEvents[i]["status"],
                                                      price: (myEvents[i]["price"]) ? "" + (myEvents[i]["price"]): "0",
                                                      shortDescription: myEvents[i]["shortDescription"],
                                                      date: myEvents[i]["dateList"],
                                                      statusEvent: "my event",
                                                      picture: (myEvents[i]["coverPicture"]) ? myEvents[i]["coverPicture"]["fileId"] : "null"
                                                  });
                        }
                    }
                    isBusyMyEvents = false
                    var notifications = user["notifications"]
                    nbNotifs = 0
                    listModelNotifs.clear()
                    for (var index in notifications) {
                        if (notifications[index]["enabled"] === true) {
                            nbNotifs++
                        }
                        listModelNotifs.append({
                                                   id: notifications[index]["id"],
                                                   message: notifications[index]["message"],
                                                   enabledNotif: notifications[index]["enabled"],
                                                   type: notifications[index]["type"],
                                                   info: notifications[index]["info"],
                                               });
                    }
                },
                function(err) {
                    console.log("votre session à expiré ", err)
                    dataModel.reLogin = true
                    logic.logout()
                })
    }

    Component.onCompleted: {
        isBusyEvents = true
        isBusyMyEvents = true
        dataModel.apiData.get("/api/events?status=Public", dataModel.localStorage.getValue("token"),
                function(data) {
                    objectEvents = JSON.parse(data)
                    objectEvents = objectEvents["hydra:member"]
                    listModelEvent.clear();
                    for (var i in objectEvents) {
                        listModelEvent.append({
                                                  id: objectEvents[i]["id"],
                                                  name: objectEvents[i]["name"],
                                                  type: objectEvents[i]["type"],
                                                  location: objectEvents[i]["location"],
                                                  creator: "nothing",
                                                  status: objectEvents[i]["status"],
                                                  price: (objectEvents[i]["price"]) ? "" + (objectEvents[i]["price"]): "0",
                                                  shortDescription: objectEvents[i]["shortDescription"],
                                                  date: objectEvents[i]["dateList"],
                                                  statusEvent: "public event",
                                                  picture: (objectEvents[i]["coverPicture"]) ? objectEvents[i]["coverPicture"]["fileId"] : "null"
                                              });
                    }
                    isBusyEvents = false
                },
                function(err) {
                    console.log("votre session à expiré ", err)
                    dataModel.reLogin = true
                    logic.logout()
                })
        dataModel.apiData.get("/api/users/" + (dataModel.localStorage.getValue("user") ? dataModel.localStorage.getValue("user")["id"] : ""), dataModel.localStorage.getValue("token"),
                function(data) {
                    var user = JSON.parse(data)
                    myEvents = user["createdEvents"]
                    dataModel.localStorage.setValue("user", user)
                    listModelMyEvent.clear();
                    for (var i in myEvents) {
                        if (i < 3) {
                            listModelMyEvent.append({
                                                      id: myEvents[i]["id"],
                                                      name: myEvents[i]["name"],
                                                      type: myEvents[i]["type"],
                                                      location: myEvents[i]["location"],
                                                      creator: "nothing",
                                                      status: myEvents[i]["status"],
                                                      price: (myEvents[i]["price"]) ? "" + (myEvents[i]["price"]): "0",
                                                      shortDescription: myEvents[i]["shortDescription"],
                                                      date: myEvents[i]["dateList"],
                                                      statusEvent: "my event",
                                                      picture: (myEvents[i]["coverPicture"]) ? myEvents[i]["coverPicture"]["fileId"] : "null"
                                                  });
                        }
                    }
                    isBusyMyEvents = false
                    var notifications = user["notifications"]
                    nbNotifs = 0
                    listModelNotifs.clear()
                    for (var index in notifications) {
                        if (notifications[index]["enabled"] === true) {
                            nbNotifs++
                        }
                        listModelNotifs.append({
                                                   id: notifications[index]["id"],
                                                   message: notifications[index]["message"],
                                                   enabledNotif: notifications[index]["enabled"],
                                                   type: notifications[index]["type"],
                                                   info: notifications[index]["info"],
                                               });
                    }
                },
                function(err) {
                    console.log("votre session à expiré ", err)
                    dataModel.reLogin = true
                    logic.logout()
                })
    }

    AppFlickable {
        id: userFlickable
        width: parent.width
        height: parent.height - headBar.height - safeAreaBottom.height
        anchors.top: headBar.bottom             // The AppFlickable fills the whole page
        anchors.left: parent.left
        contentWidth: contentColumn.width   // You need to define the size of your content item
        contentHeight: contentColumn.height

      // Using a Column as content item is very convenient
      // The height of the column is set automatically depending on the child items
      Column {
        id: contentColumn
        width: homePage.width // We only need to set the width of a column
        height: myEventText.height + eventText.height + (isBusyMyEvents ? activityIndicatorMyEvents.height : ((homePage.height / 6) * eventRepeater.count)) + (isBusyEvents ? activityIndicatorEvents.height : ((homePage.height / 5) * myEventRepeater.count))
        anchors.left: parent.left
        anchors.top: parent.top
        Component {
            id: contactDelegate
            Rectangle {
                id: eventElement
                anchors.left: parent.left
                width: parent.width
                height: statusEvent == "public event" ? homePage.height / 6 : homePage.height / 5
                visible: (statusEvent == "public event" ? (isBusyEvents ? false : true) : (isBusyMyEvents ? false : true))
                color: (index % 2 == 0) ? "#ebdef0" : "#f4ecf7"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        eventPage.id = id
                        eventPage.lastPage = 2
                        logic.changePage(3)
                    }
                    ColorAnimation {
                        from: "white"
                        to: "black"
                        duration: 200
                    }
                }

                Image {
                    id: eventPicture
                    anchors.top: eventElement.top
                    anchors.left: parent.left
                    width: parent.width / 3
                    height: parent.height + 2
                    fillMode: Image.PreserveAspectCrop
                    source: (picture != "null") ? "http://10.10.253.39/uploads/" + picture : "../../assets/Unknown-person.png"
                }
                Rectangle {
                    id: eventName
                    anchors.top: parent.top
                    anchors.left:  eventPicture.right
                    width: parent.width - eventPicture.width
                    color: "transparent"
                    Text {
                        id: eventNameText
                        anchors.left: parent.left
                        anchors.leftMargin: (parent.width - width > 0) ? (parent.width - width) / 2 : 0
                        text: '<b>' + name + '</b>'
                        font.pixelSize: sp(15)
                        font.family: lightConfortaa.name
                        color: "#4a235a"
                        elide: Text.ElideRight
                    }
                    height: childrenRect.height
                    radius: 50
                }
                Rectangle {
                    id: eventInfo
                    anchors.left: eventPicture.left
                    anchors.leftMargin: eventPicture.width + 5
                    anchors.top: eventName.bottom
                    width: parent.width - eventPicture.width
                    height: parent.height - eventName.height
                    color: "transparent"
                    Text {
                        id: myEventshortDescription
                        width: eventElement.width - eventPicture.width
                        height: eventElement.height / 4
                        color: "grey"
                        text: '<i>' + shortDescription + '</i>'
                        font.family: lightConfortaa.name
                        wrapMode: Text.WordWrap
                        anchors.leftMargin: eventPicture.width + 10
                        anchors.top: parent.top
                        font.pixelSize: sp(12)
                        elide: Text.ElideRight
                    }
                    Text {
                        id: eventLocation
                        anchors.top: eventInfo.top
                        anchors.topMargin: (eventInfo.height - height) / 2
                        anchors.leftMargin: eventPicture.width + 10
                        font.family: lightConfortaa.name
                        font.pixelSize: sp(13)
                        text: qsTr('Le\t<b>') + "undefined" + '</b>' + qsTr(' à\t<b>') + location + '</b>'
                        width: eventElement.width - eventPicture.width
                        height: Text.height
                        elide: Text.ElideRight
                    }
                    Rectangle {
                        id: eventIcon
                        width: eventInfo.width
                        height: birthdayIcon.height
                        anchors.top: eventInfo.top
                        anchors.topMargin: (eventInfo.height - height) / 1.1
                        anchors.leftMargin: eventPicture.width + 10
                        color: "transparent"
                        Icon {
                            id: moneyIcon
                            icon: IconType.money
                            color: "black"
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.leftMargin: width
                            visible: (price != "0") ? true : false
                        }
                        Icon {
                            id: birthdayIcon
                            icon: IconType.birthdaycake
                            color: "black"
                            anchors.top: parent.top
                            anchors.left: moneyIcon.left
                            anchors.leftMargin: moneyIcon.width + width
                            visible: (type == "Birthday") ? true : false
                        }
                        Icon {
                            id: partyIcon
                            icon: IconType.glass
                            color: "black"
                            anchors.top: parent.top
                            anchors.left: birthdayIcon.left
                            anchors.leftMargin: birthdayIcon.width + width
                            visible: (type == "Party") ? true : false
                        }
                        Icon {
                            id: lockIcon
                            icon: IconType.lock
                            color: "black"
                            anchors.top: parent.top
                            anchors.left: partyIcon.left
                            anchors.leftMargin: partyIcon.width + width
                            visible: (status == "Private" && statusEvent == "my event") ? true : false
                        }
                        Icon {
                            id: unlockIcon
                            icon: IconType.unlock
                            color: "black"
                            anchors.top: parent.top
                            anchors.left: lockIcon.left
                            anchors.leftMargin: lockIcon.width + width
                            visible: (status == "Public" && statusEvent == "my event") ? true : false
                        }
                    }
                }
            }
        }

        Rectangle {
            id: myEventText
            height: homePage.height / 10
            width: parent.width
            color: "#c2bbbb"
            Text {
                text: qsTr("My Events")
                anchors.top: parent.top
                anchors.topMargin: (parent.height - height) / 2
                anchors.left: parent.left
                anchors.leftMargin: (parent.width - width) / 2
                font.pixelSize: sp(18)
                font.family: lightConfortaa.name
            }
        }

        Rectangle {
            id: activityIndicatorMyEvents
            width: parent.width
            height: homePage.height / 5
            visible: isBusyMyEvents
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

        Repeater {
            id: myEventRepeater
            model: ListModel {
                id: listModelMyEvent
            }
            delegate: contactDelegate
            focus: true
        }

        Rectangle {
            id: eventText
            visible: (listModelEvent.count > 0) ? true : false
            height: homePage.height / 10
            width: parent.width
            color: "#76448a"
            Text {
                text: qsTr("Public Events")
                anchors.top: parent.top
                anchors.topMargin: (parent.height - height) / 2
                anchors.left: parent.left
                anchors.leftMargin: (parent.width - width) / 2
                font.pixelSize: sp(18)
            }
        }

        Rectangle {
            id: activityIndicatorEvents
            width: parent.width
            height: homePage.height / 5
            visible: isBusyEvents
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

        Repeater {
            id: eventRepeater
            model: ListModel {
                id: listModelEvent
            }
            delegate: contactDelegate
        }
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
            id: listButton
            icon: IconType.list
            height: parent.height
            anchors.top: parent.top
            anchors.topMargin: (parent.height - height) / 2
            anchors.left: parent.left
            showItem: showItemAlways
            onClicked: {
                drawer.isOpen ? drawer.close() : drawer.open()
            }
            color: "white"
        }

        IconButton {
            id: searchButton
            icon: IconType.globe
            size: parent.height / 2
            anchors.top: parent.top
            anchors.topMargin: (parent.height - height) / 2
            anchors.right: parent.right
            anchors.rightMargin: width / 3
            color: "white"
            AppText {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: -((parent.height - height) / 2) / 3
                anchors.rightMargin: -((parent.width - width) / 2) / 3
                text: nbNotifs > 9 ? "9+" : nbNotifs
                color: "red"
                font.family: boldConfortaa.name
                font.pixelSize: sp(16)
            }
            onClicked: {
                drawerNotifs.isOpen ? drawerNotifs.close() : drawerNotifs.open()
            }
        }
    }

    AppDrawer {
        id: drawerNotifs
        anchors.top: headBar.bottom
        width: parent.width / 1.75
        height: parent.height - headBar.height
        z: 1 //put drawer on top of other content
        drawerPosition: drawerPositionRight

        Rectangle { //background for drawer
          anchors.fill: parent
          color: "#f5eef8"
        }

        AppFlickable {
            id: notifFlickable
            width: parent.width
            height: parent.height
            anchors.top: parent.top             // The AppFlickable fills the whole page
            anchors.left: parent.left
            contentWidth: contentColumnNotif.width   // You need to define the size of your content item
            contentHeight: contentColumnNotif.height

          // Using a Column as content item is very convenient
          // The height of the column is set automatically depending on the child items
          Column {
            id: contentColumnNotif
            width: drawerNotifs.width // We only need to set the width of a column
            height: notificationsRepeater.count * sp(300)
            anchors.left: parent.left
            anchors.top: parent.top
            Component {
                id: contactDelegateNotifs
                Rectangle {
                    id: notificationRectangle
                    width: parent.width
                    height: messageTxt.height * 2
                    color: enabledNotif ? "#808b96" : "#d5d8dc"
                    AppText {
                        id: messageTxt
                        text: qsTr(message)
                        width: parent.width - sp(5)
                        anchors.top: parent.top
                        anchors.topMargin: (parent.height - height) / 2
                        wrapMode: Text.Wrap
                        color: "#512e5f"
                        font.family: lightConfortaa.name
                        font.pixelSize: sp(17)
                        horizontalAlignment: Text.AlignHCenter
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            var body = {
                                enabled: false
                            }
                            dataModel.apiData.put("/api/notifications/" + id, body, dataModel.localStorage.getValue("token"),
                                                  function(data) {
                                                        enabledNotif = false
                                                  },
                                                  function(err) {
                                                      console.log("votre session à expiré ", err)
                                                      dataModel.reLogin = true
                                                      logic.logout()
                                                  })
                            if (type === "event") {
                                eventPage.id = info
                                logic.changePage(3)
                                drawerNotifs.close()
                            }
                        }
                    }
                }
            }

            Repeater {
                id: notificationsRepeater
                model: ListModel {
                    id: listModelNotifs
                }
                delegate: contactDelegateNotifs
            }
          }
        }
    }

    AppDrawer {
         id: drawer
         anchors.top: headBar.bottom
         width: parent.width / 1.75
         height: parent.height - headBar.height
         z: 1 //put drawer on top of other content

         Rectangle { //background for drawer
           anchors.fill: parent
           color: "#f5eef8"
         }

         SimpleButton {
             id: myProfile
             anchors.top: parent.top
             width: parent.width
             height: parent.height / 8
             color: "white"
             onClicked: {
                 drawer.close()
                 profilePage.userId = dataModel.localStorage.getValue("user")["id"]
                 logic.changePage(4)
             }

             Icon {
                 id: userIcon
                 icon: IconType.user
                 color: "black"
                 anchors.top: parent.top
                 anchors.topMargin: (parent.height - height) / 2
                 anchors.left: parent.left
                 anchors.leftMargin: width
             }

             Text {
                 text: qsTr("My Profile")
                 color: "black"
                 font.family: lightConfortaa.name
                 anchors.top: parent.top
                 anchors.topMargin: (parent.height - height) / 2
                 anchors.left: parent.left
                 anchors.leftMargin: (parent.width - width) / 2
             }
         }

         SimpleButton {
             id: myEvent
             anchors.top: myProfile.bottom
             width: parent.width
             height: parent.height / 8
             color: "white"
             onClicked: {
                 drawer.close()
                 logic.changePage(6)
             }

             Icon {
                 id: glassIcon
                 icon: IconType.glass
                 color: "black"
                 anchors.top: parent.top
                 anchors.topMargin: (parent.height - height) / 2
                 anchors.left: parent.left
                 anchors.leftMargin: userIcon.width
             }

             Text {
                 text: qsTr("My Events")
                 color: "black"
                 font.family: lightConfortaa.name
                 anchors.top: parent.top
                 anchors.topMargin: (parent.height - height) / 2
                 anchors.left: parent.left
                 anchors.leftMargin: (parent.width - width) / 2
             }
         }

         SimpleButton {
             id: myFriend
             anchors.top: myEvent.bottom
             width: parent.width
             height: parent.height / 8
             color: "white"
             onClicked: {
                 drawer.close()
                 logic.changePage(5)
             }

             Icon {
                 id: friendIcon
                 icon: IconType.group
                 color: "black"
                 anchors.top: parent.top
                 anchors.topMargin: (parent.height - height) / 2
                 anchors.left: parent.left
                 anchors.leftMargin: userIcon.width
             }

             Text {
                 text: qsTr("My Friends")
                 color: "black"
                 font.family: lightConfortaa.name
                 anchors.top: parent.top
                 anchors.topMargin: (parent.height - height) / 2
                 anchors.left: parent.left
                 anchors.leftMargin: (parent.width - width) / 2
             }
         }

         SimpleButton {
             id: settings
             anchors.top: myFriend.bottom
             width: parent.width
             height: parent.height / 8
             color: "white"

             Icon {
                 id: settingIcon
                 icon: IconType.gear
                 color: "black"
                 anchors.top: parent.top
                 anchors.topMargin: (parent.height - height) / 2
                 anchors.left: parent.left
                 anchors.leftMargin: userIcon.width
             }

             Text {
                 text: qsTr("Settings")
                 color: "black"
                 font.family: lightConfortaa.name
                 anchors.top: parent.top
                 anchors.topMargin: (parent.height - height) / 2
                 anchors.left: parent.left
                 anchors.leftMargin: (parent.width - width) / 2
             }
             onClicked: {
                 drawer.close()
                 logic.changePage(8)
             }
         }

         SimpleButton {
             id: logout
             anchors.bottom: parent.bottom
             anchors.left: parent.left
             width: parent.width
             height: parent.height / 8
             color: "#512e5f"

             Icon {
                 id: logoutIcon
                 icon: IconType.signin
                 color: "white"
                 anchors.top: parent.top
                 anchors.topMargin: (parent.height - height) / 2
                 anchors.left: parent.left
                 anchors.leftMargin: width
             }

             Text {
                 text: qsTr("Logout")
                 font.family: lightConfortaa.name
                 anchors.top: parent.top
                 anchors.topMargin: (parent.height - height) / 2
                 anchors.left: parent.left
                 anchors.leftMargin: (parent.width - width) / 2
                 color: "white"
             }
             onClicked: {
                 drawer.close()
                 logic.logout()
             }
         }
    }
}
