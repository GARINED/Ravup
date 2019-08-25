import Felgo 3.0
import QtGraphicalEffects 1.0
import QtQuick 2.11
import QtQuick.Layouts 1.1

Page {
    id: profilePage
    useSafeArea: false
    property bool isFriend: false
    property string userId: "nothing"
    property var userObject
    property var lastEvents
    property bool isMyProfile: false
    property bool editingProfile: false
    property bool isBusy: false
    property string srcImgProfile: ""
    property var mediaId

    MouseArea {
        anchors.fill: parent
        onClicked: {
            profilePage.forceActiveFocus()
        }
    }

    onVisibleChanged: {
        isBusy = true
        if (userId !== (dataModel.localStorage.getValue("user") ? dataModel.localStorage.getValue("user")["id"] : "")) {
            isMyProfile = false
        }
        else {
            isMyProfile = true
        }

        dataModel.apiData.get("/api/users/" + (userId != "nothing" ? userId : ""), dataModel.localStorage.getValue("token"),
                function(data) {
                    userObject = JSON.parse(data)
                    lastEvents = userObject["createdEvents"]
                    listModelMyEvent.clear();
                    for (var i in lastEvents) {
                        listModelMyEvent.append({
                                                  id: lastEvents[i]["id"],
                                                  name: lastEvents[i]["name"],
                                                  type: lastEvents[i]["type"],
                                                  location: lastEvents[i]["location"],
                                                  creator: "nothing",
                                                  status: lastEvents[i]["status"],
                                                  price: (lastEvents[i]["price"]) ? "" + (lastEvents[i]["price"]): "0",
                                                  shortDescription: lastEvents[i]["shortDescription"],
                                                  date: lastEvents[i]["dateList"],
                                                  statusEvent: "my event",
                                                  eventPicture: (lastEvents[i]["coverPicture"] ? lastEvents[i]["coverPicture"]["fileId"] : "null"),
                                                  eventTitle: (lastEvents[i]["name"] ? lastEvents[i]["name"] : "null")
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

    Rectangle {
        id: activityIndicatorEvents
        width: parent.width
        height: profilePage.height - headBar.height - safeAreaTop.height
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

    AppFlickable {
        id: userFlickable
        width: parent.width
        height: parent.height - headBar.height - safeAreaBottom.height
        anchors.top: headBar.bottom             // The AppFlickable fills the whole page
        anchors.left: parent.left
        contentWidth: contentColumn.width   // You need to define the size of your content item
        contentHeight: contentColumn.height
        visible: isBusy ? false : true

      // Using a Column as content item is very convenient
      // The height of the column is set automatically depending on the child items
      Column {
        id: contentColumn
        width: profilePage.width // We only need to set the width of a column
        //height: backgroundImage.height + profileImage.height / 3 + fullNameUser.height +
          //      ((isFriend) ? (shortDescriptionUser.height + ageUser.height + cityUser.height + (profilePage.height / 4) + lastEventUser.height) : 0)
        anchors.left: parent.left
        Rectangle {
            width: profilePage.width
            height: width / 2
            Rectangle {
                    id: backgroundImage
                    width: parent.width
                    height: width / 3
                    anchors.left: parent.left
                    Image {
                        width: parent.width
                        height: parent.height
                        source: "https://undesigns.net/wp-content/uploads/2018/02/blue-violet-motion-background-free-download-undesigns.jpg"
                        fillMode: Image.PreserveAspectCrop
                    }
                }
                Rectangle {
                    id: addFriendButton
                    width: parent.width / 8
                    height: width
                    radius: width * 0.5
                    anchors.left: parent.left
                    anchors.top: backgroundImage.bottom
                    anchors.leftMargin: (parent.width - width) / 1.1
                    anchors.topMargin: -height / 2
                    visible: !isMyProfile
                    SimpleButton {
                        width: parent.width
                        height: parent.height
                        onClicked: {
                            isFriend = (isFriend) ? false : true
                        }
                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: parent
                        }
                        color: "#512e5f"
                        Icon {
                            icon: (isFriend) ? IconType.usertimes : IconType.userplus
                            anchors.fill: parent
                            color: "white"
                        }
                    }
                }
                Rectangle {
                    id: editMyProfileButton
                    width: parent.width / 8
                    height: width
                    radius: width * 0.5
                    anchors.left: parent.left
                    anchors.top: backgroundImage.bottom
                    anchors.leftMargin: (parent.width - width) / 1.1
                    anchors.topMargin: -height / 2
                    visible: isMyProfile && !editingProfile
                    SimpleButton {
                        width: parent.width
                        height: parent.height
                        onClicked: {
                            editingProfile = true
                        }

                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: parent
                        }
                        color: "#512e5f"
                        Icon {
                            icon: IconType.edit
                            anchors.fill: parent
                            color: "white"
                        }
                    }
                }

                Rectangle {
                    id: profileImageRect
                    width: parent.width / 3
                    height: width
                    anchors.left: parent.left
                    anchors.top: backgroundImage.bottom
                    anchors.leftMargin: (parent.width - width) / 2
                    anchors.topMargin: -height / 1.5
                    radius: width * 0.5
                    visible: !editingProfile
                    Image {
                        id: profileImage
                        width: parent.width
                        height: parent.height
                        source: (userObject && userObject["profilPicture"] ? "http://10.10.253.39/uploads/" + userObject["profilPicture"]["fileId"] : "../../assets/Unknown-person.png")
                        fillMode: Image.PreserveAspectCrop
                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: parent
                        }
                    }
                }
                Rectangle {
                    id: profileImageEditRect
                    width: parent.width / 3
                    height: width
                    anchors.left: parent.left
                    anchors.top: backgroundImage.bottom
                    anchors.leftMargin: (parent.width - width) / 2
                    anchors.topMargin: -height / 1.5
                    radius: width * 0.5
                    visible: editingProfile
                    Image {
                        id: profileImageEdit
                        width: parent.width
                        height: parent.height
                        source: (userObject && userObject["profilPicture"] ? "http://10.10.253.39/uploads/" + userObject["profilPicture"]["fileId"] : "../../assets/Unknown-person.png")
                        fillMode: Image.PreserveAspectCrop
                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: parent
                        }
                    }
                    Rectangle {
                        width: parent.width / 3
                        height: parent.height / 3
                        radius: width * 0.5
                        anchors.left: parent.left
                        anchors.leftMargin: (parent.width - width) / 2
                        anchors.top: parent.top
                        anchors.topMargin: (parent.height - height) / 2
                        IconButton {
                            id: changeProfileImageButton
                            width: parent.width
                            height: parent.height
                            icon: IconType.photo
                            size: parent.width / 2
                            color: "#512e5f"
                            selectedColor: "black"
                            onClicked: {
                                nativeUtils.displayImagePicker(qsTr("Choose Image"))
                            }
                        }
                    }
                }
            }
        Rectangle {
            width: parent.width
            height: width / 6
                Text {
                    id: fullNameUser
                    text: (userObject && userObject["fullname"] ? userObject["fullname"] : "")
                    font.family: lightConfortaa.name
                    anchors.left: parent.left
                    anchors.leftMargin: (parent.width - width) / 2
                    anchors.topMargin: height / 1.5
                    font.pixelSize: parent.width / 20
                    font.bold: true
                    visible: !editingProfile
                }
                FocusScope {
                    width: fullNameUserEditRect.width
                    height: fullNameUserEditRect.height
                    visible: editingProfile
                    anchors.left: parent.left
                    anchors.leftMargin: (parent.width - width) / 2
                    Layout.preferredWidth: width
                    Layout.preferredHeight: height
                    Rectangle {
                        id: fullNameUserEditRect
                        width: fullNameUserEdit.width + sp(10)
                        height: fullNameUserEdit.height
                        color: "#f5eef8"
                        border.color: "#512e5f"
                        radius: width * 0.5
                    }
                    TextInput {
                        id: fullNameUserEdit
                        text: fullNameUser.text
                        width: text == "" ? sp(50) : sizeFullNameUserEdit.width
                        anchors.left: fullNameUserEditRect.left
                        anchors.leftMargin: (fullNameUserEditRect.width - width) / 2
                        font.family: lightConfortaa.name
                        font.pixelSize: fullNameUser.font.pixelSize
                        font.bold: true
                        font.italic: true
                        visible: editingProfile
                        Text {
                            id: sizeFullNameUserEdit
                            text: parent.text
                            font.family: lightConfortaa.name
                            font.pixelSize: parent.font.pixelSize
                            font.bold: true
                            font.italic: true
                            visible: false
                        }
                    }
                }
                Text {
                    id: pseudoUser
                    text: (userObject && userObject["username"] ? userObject["username"] : "")
                    font.family: lightConfortaa.name
                    anchors.left: fullNameUser.left
                    anchors.top: scoreUser.bottom
                    anchors.leftMargin: (fullNameUser.width - width) / 2
                    font.pixelSize: parent.width / 30
                    font.italic: true
                    color: "grey"
                }
                Text {
                    id: scoreUser
                    text: (userObject && userObject["score"] ? userObject["score"] : "0")
                    font.family: lightConfortaa.name
                    anchors.left: fullNameUser.left
                    anchors.top: fullNameUser.bottom
                    anchors.leftMargin: (fullNameUser.width - (width + iconScoreUser.width)) / 2
                    font.pixelSize: parent.width / 30
                    font.italic: true
                    Icon {
                        id: iconScoreUser
                        height: scoreUser.height
                        icon: IconType.star
                        color: "#512e5f"
                        anchors.left: parent.right
                        anchors.top: parent.top
                        anchors.topMargin: -height / 8
                    }
                }
            }
            Rectangle {
                id: shortDescriptionUser
                width: parent.width / 1.05
                height: biographyText.height + sp(10)
                anchors.left: parent.left
                anchors.leftMargin: (parent.width - width) / 2
                color: "#f5eef8"
                border.color: "#e8daef"
                radius: width * 0.05
                visible: !editingProfile && (isMyProfile || isFriend) && (userObject && userObject["biography"])
                Text {
                    id: biographyText
                    width: parent.width - parent.radius
                    wrapMode: Text.WordWrap
                    font.family: lightConfortaa.name
                    anchors.left: parent.left
                    anchors.leftMargin: (parent.width - width) / 2
                    anchors.top: parent.top
                    anchors.topMargin: (parent.height - height) / 2
                    font.italic: true
                    color: "gray"
                    text: (userObject && userObject["biography"] ? userObject["biography"] : "")
                }
            }
            FocusScope {
                width: shortDescriptionEditRect.width
                height: shortDescriptionEditRect.height
                visible: editingProfile
                anchors.left: parent.left
                anchors.leftMargin: (parent.width - width) / 2
                Layout.preferredWidth: width
                Layout.preferredHeight: height
                Rectangle {
                    id: shortDescriptionEditRect
                    width: profilePage.width / 1.05
                    height: biographyTextEdit.height + sp(10)
                    color: "#f5eef8"
                    border.color: "#512e5f"
                    radius: width * 0.05
                }
                TextInput {
                    id: biographyTextEdit
                    text: biographyText.text
                    width: shortDescriptionEditRect.width - shortDescriptionEditRect.radius
                    wrapMode: Text.WordWrap
                    anchors.left: shortDescriptionEditRect.left
                    anchors.leftMargin: shortDescriptionEditRect.width / 40
                    anchors.top: shortDescriptionEditRect.top
                    anchors.topMargin: (shortDescriptionEditRect.height - height) / 2
                    font.family: lightConfortaa.name
                    font.italic: true
                    color: "grey"
                    visible: editingProfile
                }
            }
            Rectangle {
                width: parent.width
                height: width / 6
                Text {
                    id: ageLabel
                    text: "Age: "
                    font.family: lightConfortaa.name
                    font.pixelSize: parent.width / 35
                    anchors.top: parent.top
                    anchors.topMargin: parent.height / 4
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width / 10
                    visible: (isMyProfile || isFriend) && (userObject && userObject["age"])
                }
                Text {
                    id: ageUser
                    text: ((userObject && userObject["age"]) ? "<b>" + userObject["age"] + qsTr(" ans</b>") : "")
                    font.family: lightConfortaa.name
                    font.pixelSize: parent.width / 30
                    anchors.left: ageLabel.right
                    anchors.top: ageLabel.top
                    anchors.leftMargin:  parent.width / 4
                    visible: (isMyProfile || isFriend) && (userObject && userObject["age"])
                }
                Text {
                    id: locationLabel
                    text: "Location: "
                    font.family: lightConfortaa.name
                    font.pixelSize: parent.width / 35
                    anchors.left: ageLabel.left
                    anchors.top: ageLabel.bottom
                    anchors.topMargin: height
                    visible: (isMyProfile || isFriend) && (userObject && userObject["country"])
                }
                Text {
                    id: cityUser
                    text: userObject && userObject["city"] ? userObject["city"] : ""
                    font.family: lightConfortaa.name
                    font.pixelSize: parent.width / 30
                    font.bold: true
                    anchors.left: ageUser.left
                    anchors.top: locationLabel.top
                    visible: !editingProfile && (isMyProfile || isFriend) && (userObject && userObject["city"])
                }
                Text {
                    id: countryUser
                    text: userObject && userObject["country"] ? userObject["country"] : ""
                    font.family: lightConfortaa.name
                    font.pixelSize: cityUser.font.pixelSize
                    font.bold: true
                    anchors.left: cityUser.right
                    anchors.leftMargin: sp(10)
                    anchors.top: cityUser.top
                    visible: !editingProfile && (isMyProfile || isFriend) && (userObject && userObject["country"])
                }
                Rectangle {
                    id: cityUserEditRect
                    width: cityUserEdit.width + sp(10)
                    height: cityUserEdit.height
                    color: "#f5eef8"
                    border.color: "#512e5f"
                    radius: width * 0.5
                    anchors.left: ageUser.left
                    anchors.leftMargin: (cityUserEdit.width - cityUserEditRect.width) / 2
                    anchors.top: locationLabel.top
                    visible: editingProfile
                    TextInput {
                        id: cityUserEdit
                        width: text == "" ? sp(30) : sizeCityUserEdit.width
                        text: cityUser.text
                        font.family: lightConfortaa.name
                        font.pixelSize: cityUser.font.pixelSize
                        anchors.left: cityUserEditRect.left
                        anchors.leftMargin: (cityUserEditRect.width - width) / 2
                        Text {
                            id: sizeCityUserEdit
                            text: parent.text
                            font.family: lightConfortaa.name
                            font.pixelSize: parent.font.pixelSize
                            visible: false
                        }
                    }
                }
                Rectangle {
                    id: countryUserEditRect
                    width: countryUserEdit.width + sp(10)
                    height: countryUserEdit.height
                    color: "#f5eef8"
                    border.color: "#512e5f"
                    radius: width * 0.5
                    anchors.left: cityUserEditRect.right
                    anchors.leftMargin: sp(10) + (countryUserEdit.width - width) / 2
                    anchors.top: countryUser.top
                    visible: editingProfile
                    TextInput {
                        id: countryUserEdit
                        width: text == "" ? sp(30) : sizeCountryUserEdit.width
                        text: countryUser.text
                        font.family: lightConfortaa.name
                        font.pixelSize: countryUser.font.pixelSize
                        anchors.left: parent.left
                        anchors.leftMargin: (parent.width - width) / 2
                        Text {
                            id: sizeCountryUserEdit
                            text: parent.text
                            font.family: lightConfortaa.name
                            font.pixelSize: parent.font.pixelSize
                            visible: false
                        }
                    }
                }
            }
            Text {
                text: qsTr("Recent events")
                font.family: lightConfortaa.name
                font.bold: true
                anchors.left: parent.left
                anchors.leftMargin: profilePage.width / 60
            }
            Flickable {
                width: profilePage.width
                height: profilePage.height / 3
                contentWidth: lastEventUser.width
                contentHeight: lastEventUser.height
                flickableDirection: Flickable.HorizontalFlick
                visible: (isMyProfile || isFriend)
                Row {
                    id: lastEventUser
                    Component {
                        id: contactDelegate
                        Rectangle {
                            width: profilePage.width / 2
                            height: width
                            color: "#512e5f"
                            border.width: 1
                            Rectangle {
                                id: lastEventUserPictureRect
                                width: parent.width - 2
                                height: width - width / 10
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.leftMargin: (parent.width - width) / 2
                                border.width: 1
                                color: lastEventUserPicture.source == "" ? "white" : "black"
                                Image {
                                    id: lastEventUserPicture
                                    width: parent.width
                                    height: parent.height - sp(2)
                                    anchors.top: parent.top
                                    anchors.topMargin: (parent.height - height) / 2
                                    source: (eventPicture != "null" ? "http://10.10.253.39/uploads/" + eventPicture : "")
                                    fillMode: Image.PreserveAspectCrop
                                }
                            }
                            Text {
                                text: (eventTitle != "null" ? eventTitle : "")
                                anchors.top: lastEventUserPictureRect.bottom
                                anchors.topMargin: sp(3)
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
                            id: listModelMyEvent
                        }
                        delegate: contactDelegate
                        focus: true
                    }
                }
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
            id: backButton
            icon: IconType.arrowleft
            height: parent.height
            anchors.top: parent.top
            anchors.topMargin: (parent.height - height) / 2
            anchors.left: parent.left
            showItem: showItemAlways
            visible: !editingProfile
            onClicked: {
                editingProfile = false
                srcImgProfile = ""
                logic.changePage(2)
            }
            color: "white"
        }
        IconButtonBarItem {
            id: cancelEditButton
            icon: IconType.close
            height: parent.height
            anchors.top: parent.top
            anchors.topMargin: (parent.height - height) / 2
            anchors.left: parent.left
            showItem: showItemAlways
            visible: editingProfile
            onClicked: {
                editingProfile = false
                fullNameUserEdit.text = fullNameUser.text
                biographyTextEdit.text = biographyText.text
                cityUserEdit.text = cityUser.text
                countryUserEdit.text = countryUser.text
                profileImageEdit.source = profileImage.source
                profilePage.forceActiveFocus()
            }
            color: "white"
        }
        IconButtonBarItem {

            id: validEditButton
            icon: IconType.check
            height: parent.height
            anchors.top: parent.top
            anchors.topMargin: (parent.height - height) / 2
            anchors.right: parent.right
            showItem: showItemAlways
            visible: editingProfile
            onClicked: {
                editingProfile = false
                fullNameUser.text = fullNameUserEdit.text
                biographyText.text = biographyTextEdit.text
                cityUser.text = cityUserEdit.text
                countryUser.text = countryUserEdit.text
                if (srcImgProfile != "") {
                    var postData = dataModel.localStorage.getValue("user")["id"]
                    dataModel.apiData.postMedia("/api/media?profile=true", postData, profileImageEdit.source, "file", dataModel.localStorage.getValue("token"),
                                                function(data) {
                                                    mediaId = JSON.parse(data)
                                                    mediaId = mediaId["id"]
                                                    console.log(mediaId)
                                                    var body = {
                                                        "fullname": fullNameUser.text,
                                                        "biography": biographyText.text,
                                                        "city": cityUser.text,
                                                        "country": countryUser.text,
                                                        "profilPicture": "/api/media/" + mediaId
                                                    }
                                                    dataModel.apiData.put("/api/users/" + userId, body, dataModel.localStorage.getValue("token"),
                                                                          function(data) {
                                                                          },
                                                                          function(err) {
                                                                              console.log(err)
                                                                              console.log("votre session à expiré")
                                                                              dataModel.reLogin = true
                                                                              logic.logout()
                                                                          }
                                                                              )
                                                },
                                                function(err) {
                                                    console.log(err)
                                                    console.log("votre session à expiré")
                                                    dataModel.reLogin = true
                                                    logic.logout()
                                                }
                                                    )
                }
                else {
                    var body = {
                        "fullname": fullNameUser.text,
                        "biography": biographyText.text,
                        "city": cityUser.text,
                        "country": countryUser.text,
                    }
                    dataModel.apiData.put("/api/users/" + userId, body, dataModel.localStorage.getValue("token"),
                                          function(data) {
                                          },
                                          function(err) {
                                              console.log(err)
                                              console.log("votre session à expiré")
                                              dataModel.reLogin = true
                                              logic.logout()
                                          }
                                              )
                }
                profileImage.source = profileImageEdit.source
                profilePage.forceActiveFocus()
                mediaId = ""
                srcImgProfile = ""
            }
            color: "white"
        }
    }
    Connections {
        target: nativeUtils
        onImagePickerFinished: {
            if(accepted) {
                srcImgProfile = path;
                profileImageEdit.source = srcImgProfile
            }
        }
    }
}
