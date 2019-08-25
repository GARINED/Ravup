import Felgo 3.0
import QtQuick 2.0

Page {
    id: myEventsPage
    useSafeArea: false
    property var myEvents
    property int i: 1
    property bool isBusy: false

    onVisibleChanged: {
        isBusy = true
        dataModel.apiData.get("/api/users/" + (dataModel.localStorage.getValue("user") ? dataModel.localStorage.getValue("user")["id"] : ""), dataModel.localStorage.getValue("token"),
                function(data) {
                    myEvents = JSON.parse(data)
                    myEvents = myEvents["createdEvents"]
                    listModelMyEvents.clear();
                    for (var i in myEvents) {
                        listModelMyEvents.append({
                                                  id: myEvents[i]["id"],
                                                  name: myEvents[i]["name"],
                                                  type: myEvents[i]["type"],
                                                  location: myEvents[i]["location"],
                                                  creator: "nothing",
                                                  status: myEvents[i]["status"],
                                                  price: (myEvents[i]["price"]) ? "" + (myEvents[i]["price"]): "0",
                                                  shortDescription: myEvents[i]["shortDescription"],
                                                  date: myEvents[i]["dateList"],
                                                  picture: (myEvents[i]["coverPicture"]) ? myEvents[i]["coverPicture"]["fileId"] : "null"
                                              });
                    }
                    isBusy = false
                },
                function(err) {
                    console.log("votre session à expiré")
                    dataModel.reLogin = true
                    logic.logout()
                })
    }

    AppFlickable {
        id: userFlickable
        width: parent.width
        height: parent.height - headBar.height
        anchors.top: headBar.bottom             // The AppFlickable fills the whole page
        anchors.left: parent.left
        contentWidth: contentColumn.width   // You need to define the size of your content item
        contentHeight: contentColumn.height
        visible: isBusy ? false : true

        // Using a Column as content item is very convenient
        // The height of the column is set automatically depending on the child items
        Grid {
            id: contentColumn
            columns: 2
            height: ((myEventsPage.height / 5) * (myEventsRepeater.count / 2)) + safeAreaTop.height + createEvent.height
            anchors.left: parent.left
            anchors.top: parent.top

            Component {
                id: componentDelegate
                Rectangle {
                    id: eventElement
                    width: (myEventsPage.width / 2)
                    height: myEventsPage.height / 5
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            eventPage.id = id
                            eventPage.lastPage = 6
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
                        source: (picture != "null") ? "http://10.10.253.39/uploads/" + picture : "../../assets/Unknown-person.png"
                        height: parent.height
                        width: parent.width
                        fillMode: Image.PreserveAspectCrop
                    }
                    Rectangle {
                        width: parent.width
                        height: parent.height / 5
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.topMargin: (parent.height - height)
                        anchors.leftMargin: (parent.width - width) / 2
                        color: (index % 2 == 0) ? "#d2b4de" : "#bb8fce"
                        Component.onCompleted: {color.a = 0.8}
                        Text {
                            text: qsTr(name)
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: (parent.height - height) / 2
                            anchors.leftMargin: (parent.width - width) / 2
                            font.pixelSize: sp(12)
                            font.family: lightConfortaa.name
                            color: "#4a235a"
                        }
                    }
                }
            }

            Repeater {
                id: myEventsRepeater
                model: ListModel {
                    id: listModelMyEvents
                }
                delegate: componentDelegate
                focus: true
            }
        }
    }

    Rectangle {
        id: createEvent
        width: parent.width
        height: parent.height / 11
        anchors.bottom: parent.bottom
        color: "#512e5f"
        Component.onCompleted: {color.a = 0.8}
        visible: isBusy ? false : true
        MouseArea {
            anchors.fill: parent
            onClicked: {
                createEventPage.lastPage = 6
                logic.changePage(7)
            }
            ColorAnimation {
                from: "white"
                to: "black"
                duration: 200
            }
        }

        Rectangle {
            height: parent.height / 30
            width: parent.width / 3.5
            anchors.top: parent.top
            anchors.topMargin: ((parent.height - height) / 2)
            anchors.left: parent.left
            anchors.leftMargin: parent.width / 35
            color: "black"
        }
        Text {
            id: textCreateEvent
            text: qsTr("Create Event")
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: (parent.height - height) / 2
            anchors.leftMargin: (parent.width - width) / 2
            font.pixelSize: sp(17)
            font.family: lightConfortaa.name
            color: "white"
        }
        Rectangle {
            height: parent.height / 30
            width: parent.width / 3.5
            anchors.top: parent.top
            anchors.topMargin: ((parent.height - height) / 2)
            anchors.left: textCreateEvent.right
            anchors.leftMargin: parent.width / 35
            color: "black"
        }
    }

    Rectangle {
        id: activityIndicatorEvents
        width: parent.width
        height: myEventsPage.height - headBar.height - safeAreaTop.height
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
        id: safeAreaTop
        width: parent.width
        height: nativeUtils.safeAreaInsets.top > 0 ? nativeUtils.safeAreaInsets.top : nativeUtils.statusBarHeight()
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
                logic.changePage(2)
            }
            color: "white"
        }
    }

}
