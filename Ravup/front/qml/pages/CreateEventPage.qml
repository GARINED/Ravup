import QtQuick.Controls 2.1
import QtQuick 2.11
import QtQuick 2.6
import Felgo 3.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import QtQuick.Controls 2.0 as Quick2

Page {
    id: createEventPage
    useSafeArea: false
    property int lastPage: 6
    property string srcImg: ""
    property var media
    property string mediaId: ""
    property bool errorForm: false
    property string selectionnedDate

    onVisibleChanged: {
        fct.getUserToInvite("")
    }

    AppFlickable {
        id: createEventFlickable
        width: parent.width
        height: parent.height - headBar.height
        anchors.top: headBar.bottom             // The AppFlickable fills the whole page
        anchors.left: parent.left
        contentWidth: contentColumn.width   // You need to define the size of your content item
        contentHeight: contentColumn.height
        MouseArea {
            anchors.fill: parent
            onClicked: {
                createEventPage.forceActiveFocus()
            }
        }

        Column {
            id: contentColumn
            width: createEventPage.width // We only need to set the width of a column
            height: eventImage.height + contentLayout.height + longDescriptionRectangle.height
                    + rowPublicAndAge.height + rowAcceptAndPrice.height
                    + rowAcceptAutoAndNbParticipate.height + rowLocationAndType.height
                    + buttonCreateEvent.height + (createEventPage.height / 20)
                    + calendarRectangle.height + listDate.height + invitePeople.height
                    + listUserRectangle.height
            anchors.left: parent.left
            anchors.top: parent.top

            Rectangle {
                id: eventImage
                width: parent.width
                height: createEventPage.height / 3.75
                anchors.left: parent.left
                Image {
                    width: parent.width
                    height: parent.height / 1.1
                    source: (srcImg == "") ? "../../assets/Unknown-person.png" : srcImg
                    fillMode: Image.PreserveAspectCrop
                }
                AppButton {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.topMargin: (parent.height - height) / 2
                    anchors.leftMargin: (parent.width - width) / 2
                    radius: 40
                    backgroundColor: "#6c3483"
                    text: "Select an image"
                    flat: false
                    textColor: "white"
                    borderColor: "#6c3483"
                    textSize: sp(12)
                    onClicked: {
                        nativeUtils.displayImagePicker(qsTr("Choose Image"))
                        //nativeUtils.displayAlertSheet("", ["Choose Photo", "Reset Photo"], true)
                    }
                }
            }

            GridLayout {
                id: contentLayout
                anchors.left: parent.left
                anchors.leftMargin: (parent.width) / 22
                columnSpacing: dp(parent.width / 25)
                rowSpacing: dp(15)
                columns: 2

                AppText {
                    id: eventName
                    text: qsTr("Event Name")
                    font.pixelSize: sp(16)
                    font.family: boldConfortaa.name
                }

                AppText {
                    id: shortDescription
                    text: qsTr("Short Description")
                    font.pixelSize: sp(16)
                    font.family: boldConfortaa.name
                }

                AppTextField {
                    id: txtEventName
                    Layout.preferredWidth: createEventPage.width / 3
                    showClearButton: true
                    font.pixelSize: sp(12)
                    borderColor: "#512e5f"
                    borderWidth: dp(1)
                    cursorColor: "#512e5f"
                    radius: 25
                }

                FocusScope {
                    id: rootShortDescription
                    height: createEventPage.width / 5
                    width: createEventPage.width / 2.4
                    Layout.preferredWidth: createEventPage.width / 2.4
                    Layout.preferredHeight: createEventPage.height / 7

                    Rectangle {
                        color: "grey"
                        anchors.fill: parent
                        Component.onCompleted: {
                            color.a = 0.7
                        }
                        radius: 25
                    }

                    TextInput {
                        id: textEditShortDescription
                        anchors.fill: parent
                        anchors.margins: 10
                        maximumLength: 80
                        font.pixelSize: sp(12)
                        font.family: monospaceNK57.name
                        wrapMode: TextInput.Wrap
                     }
                }
            }

            Rectangle {
                id: longDescriptionRectangle
                width: createEventPage.width
                height: createEventPage.height / 2.25
                AppText {
                    id: longDescription
                    text: qsTr("Long Description")
                    anchors.left: parent.left
                    anchors.leftMargin: (parent.width - width) / 2
                    anchors.top: parent.top
                    anchors.topMargin: parent.height / 15
                    font.pixelSize: sp(16)
                    font.family: boldConfortaa.name
                }

                FocusScope {
                    id: rootLongDescription
                    width: parent.width / 1.25
                    height: parent.height / 1.25
                    anchors.top: longDescription.bottom
                    anchors.topMargin: longDescription.height / 2
                    anchors.left: parent.left
                    anchors.leftMargin: (parent.width - width) / 2

                    Rectangle {
                        color: "grey"
                        anchors.fill: parent
                        Component.onCompleted: {
                            color.a = 0.7
                        }
                        radius: 25
                    }

                    TextInput {
                        id: textEditLongDescription
                        anchors.fill: parent
                        anchors.margins: 10
                        maximumLength: 500
                        font.pixelSize: sp(10)
                        font.family: monospaceNK57.name
                        wrapMode: TextInput.Wrap
                     }
                }
            }

            Row {
                id: rowPublicAndAge
                width: createEventPage.width
                height: createEventPage.height / 10

                Column {
                    width: parent.width / 2
                    height: parent.height
                    Rectangle {
                        height: parent.height / 2
                        width: parent.width
                        AppSwitch {
                            id: switchStatus
                            anchors.top: parent.top
                            anchors.topMargin: (parent.height - height) / 2
                            anchors.left: parent.left
                            anchors.leftMargin: (parent.width - width) / 2
                            width: parent.width / 2
                            height: parent.height / 1.25
                            checked: true
                            backgroundColorOn: "#8e44ad"
                            knobColorOn: "#512e5f"
                        }
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: (parent.width - width) / 2
                        text: qsTr("Public")
                        font.pixelSize: sp(20)
                        font.family: boldConfortaa.name
                    }
                }

                Column {
                    width: parent.width / 2
                    height: parent.height
                    Rectangle {
                        height: parent.height / 2
                        width: parent.width
                        Text {
                            anchors.top: parent.top
                            anchors.topMargin: (parent.height - height) / 2
                            anchors.left: parent.left
                            anchors.leftMargin: (parent.width - width) / 2
                            text: qsTr("Minimum Age:")
                            font.pixelSize: sp(17)
                            font.family: boldConfortaa.name
                        }
                    }

                    Rectangle {
                        height: parent.height / 2
                        width: parent.width
                        AppTextField {
                            id: ageInput
                            anchors.top: parent.top
                            anchors.topMargin: (parent.height - height) / 2
                            anchors.left: parent.left
                            anchors.leftMargin: (parent.width - width) / 2
                            width: parent.width / 4
                            height: parent.height / 1.2
                            font.pixelSize: sp(14)
                            borderColor: "#512e5f"
                            borderWidth: dp(1)
                            cursorColor: "#512e5f"
                            radius: 25
                            placeholderText: "age"
                            anchors.margins: 3
                        }
                    }
                }
            }

            Row {
                id: rowAcceptAndPrice
                width: createEventPage.width
                height: createEventPage.height / 10
                Column {
                    width: parent.width / 2
                    height: parent.height
                    Rectangle {
                        height: parent.height / 2
                        width: parent.width
                        AppSwitch {
                            id: switchAcceptAutoInvit
                            anchors.top: parent.top
                            anchors.topMargin: (parent.height - height) / 2
                            anchors.left: parent.left
                            anchors.leftMargin: (parent.width - width) / 2
                            width: parent.width / 2
                            height: parent.height / 1.25
                            checked: true
                            backgroundColorOn: "#8e44ad"
                            knobColorOn: "#512e5f"
                        }
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: (parent.width - width) / 2
                        text: qsTr("Acceptation Auto")
                        font.pixelSize: sp(18)
                        font.family: boldConfortaa.name
                    }
                }

                Column {
                    width: parent.width / 2
                    height: parent.height
                    Rectangle {
                        height: parent.height / 2
                        width: parent.width
                        Text {
                            anchors.top: parent.top
                            anchors.topMargin: (parent.height - height) / 2
                            anchors.left: parent.left
                            anchors.leftMargin: (parent.width - width) / 2
                            text: qsTr("Price:")
                            font.pixelSize: sp(17)
                            font.family: boldConfortaa.name
                        }
                    }

                    Rectangle {
                        height: parent.height / 2
                        width: parent.width
                        AppTextField {
                            id: priceInput
                            anchors.top: parent.top
                            anchors.topMargin: (parent.height - height) / 2
                            anchors.left: parent.left
                            anchors.leftMargin: (parent.width - width) / 2
                            width: parent.width / 4
                            height: parent.height / 1.2
                            font.pixelSize: sp(14)
                            borderColor: "#512e5f"
                            borderWidth: dp(1)
                            cursorColor: "#512e5f"
                            radius: 25
                            placeholderText: "price"
                            anchors.margins: 3
                        }
                    }
                }
            }

            Row {
                id: rowAcceptAutoAndNbParticipate
                width: createEventPage.width
                height: createEventPage.height / 10
                Column {
                    width: parent.width / 2
                    height: parent.height
                    Rectangle {
                        height: parent.height / 2
                        width: parent.width
                        AppSwitch {
                            id: switchAcceptCustoDate
                            anchors.top: parent.top
                            anchors.topMargin: (parent.height - height) / 2
                            anchors.left: parent.left
                            anchors.leftMargin: (parent.width - width) / 2
                            width: parent.width / 2
                            height: parent.height / 1.25
                            checked: true
                            backgroundColorOn: "#8e44ad"
                            knobColorOn: "#512e5f"
                        }
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: (parent.width - width) / 2
                        text: qsTr("Customizable Date")
                        font.pixelSize: sp(18)
                        font.family: boldConfortaa.name
                    }
                }

                Column {
                    width: parent.width / 2
                    height: parent.height
                    Rectangle {
                        height: parent.height / 2
                        width: parent.width
                        Text {
                            anchors.top: parent.top
                            anchors.topMargin: (parent.height - height) / 2
                            anchors.left: parent.left
                            anchors.leftMargin: (parent.width - width) / 2
                            text: qsTr("Personnes Max.:")
                            font.pixelSize: sp(17)
                            font.family: boldConfortaa.name
                        }
                    }

                    Rectangle {
                        height: parent.height / 2
                        width: parent.width
                        AppTextField {
                            id: nbPeopleInput
                            anchors.top: parent.top
                            anchors.topMargin: (parent.height - height) / 2
                            anchors.left: parent.left
                            anchors.leftMargin: (parent.width - width) / 2
                            width: parent.width / 4
                            height: parent.height / 1.2
                            font.pixelSize: sp(14)
                            borderColor: "#512e5f"
                            borderWidth: dp(1)
                            cursorColor: "#512e5f"
                            radius: 25
                            placeholderText: "Max."
                            anchors.margins: 3
                        }
                    }
                }
            }

            Row {
                id: rowLocationAndType
                width: createEventPage.width
                height: createEventPage.height / 8
                spacing: 10

                Rectangle {
                    height: parent.height
                    width: parent.width / 2
                    AppTextField {
                        id: locationInput
                        height: parent.height / 2
                        anchors.top: parent.top
                        anchors.topMargin: (parent.height - height) / 2
                        anchors.left: parent.left
                        anchors.leftMargin: (parent.width - width) / 2
                        width: parent.width / 1.25
                        font.pixelSize: sp(14)
                        borderColor: "#512e5f"
                        borderWidth: dp(1)
                        cursorColor: "#512e5f"
                        radius: 25
                        placeholderText: "Location"
                        placeholderColor: "#512e5f"
                        anchors.margins: 3
                        backgroundColor: "grey"
                    }
                }

                Rectangle {
                    height: parent.height
                    width: parent.width / 2
                    Quick2.ComboBox {
                      id: comboBox
                      implicitHeight: parent.height / 2
                      implicitWidth: parent.width / 1.25
                      anchors.top: parent.top
                      anchors.topMargin: (parent.height - height) / 2
                      anchors.left: parent.left
                      anchors.leftMargin: (parent.width - width) / 2
                      padding: dp(12)
                      background: Rectangle {
                          anchors.fill: parent
                          radius: 25
                          color: "grey"
                          border.width: dp(1)
                          border.color: "#512e5f"
                      }

                      model: [qsTr("Select type"), qsTr("Party"), qsTr("Birthday"), qsTr("Wedding"), qsTr("Seminary"), qsTr("Other")]

                      delegate: Quick2.ItemDelegate {
                        width: comboBox.implicitWidth
                        height: comboBox.implicitHeight
                        padding: dp(12)
                        background: Rectangle {
                            anchors.fill: parent
                            color: "grey"
                        }

                        contentItem: AppText {
                          text: modelData
                          color: highlighted ? "#512e5f" : "black"
                          wrapMode: Text.NoWrap
                        }
                        highlighted: comboBox.highlightedIndex == index
                      }

                      contentItem: AppText {
                        width: comboBox.width - comboBox.indicator.width - comboBox.spacing
                        text: comboBox.displayText
                        color: "#512e5f"
                        wrapMode: Text.NoWrap
                      }
                    }
                }
            }

            Rectangle {
                id: calendarRectangle
                width: parent.width
                height: createEventPage.height / 2.2
                Calendar {
                    id: calendar
                    width: parent.width / 1.25
                    height: parent.height / 1.1
                    anchors.left: parent.left
                    anchors.leftMargin: (parent.width - width) / 2
                    weekNumbersVisible: false
                    minimumDate: new Date(2019, 0, 1)

                    onClicked: {
                        selectionnedDate = date
                        listSelectedDate.append({
                                                    date: selectionnedDate
                                                })
                    }
                }
            }


            Column {
                id: listDate
                width: createEventPage.width
                height: ((createEventPage.height / 13) * (selectedDateRepeater.count)) + textSelectDate.height
                        + (selectedDateRepeater.count == 0 ? textNoDate.height : 0)
                AppText {
                    id: textSelectDate
                    text: qsTr("Selected Date :")
                    font.pixelSize: sp(20)
                    font.family: boldConfortaa.name
                    anchors.left: parent.left
                    anchors.leftMargin: (parent.width - width) / 2
                }
                AppText {
                    id: textNoDate
                    text: qsTr("Please select at least one date")
                    font.pixelSize: sp(18)
                    font.family: lightConfortaa.name
                    anchors.left: parent.left
                    anchors.leftMargin: (parent.width - width) / 2
                    visible: (selectedDateRepeater.count == 0) ? true : false
                }

                Component {
                    id: dateDelegate
                    Rectangle {
                        height: createEventPage.height / 13
                        width: parent.width
                        color: (index % 2 == 0) ? "#ebdef0" : "#f4ecf7"
                        AppText {
                            id: dateText
                            text: qsTr(date.substr(0, 10))
                            font.pixelSize: sp(17)
                            font.family: lightConfortaa.name
                            anchors.left: parent.left
                            anchors.leftMargin: parent.width / 9
                            anchors.top: parent.top
                            anchors.topMargin: (parent.height - height) / 2
                        }
                        IconButton {
                            id: backButton
                            icon: IconType.close
                            height: parent.height
                            anchors.top: parent.top
                            anchors.topMargin: (parent.height - height) / 2
                            anchors.left: parent.left
                            anchors.leftMargin: parent.width / 1.20
                            onClicked: {
                                listSelectedDate.remove(listSelectedDate.get(index))
                            }
                            color: "#512e5f"
                        }
                    }
                }

                Repeater {
                    id: selectedDateRepeater
                    model: ListModel {
                        id: listSelectedDate
                    }
                    delegate: dateDelegate
                    focus: true
                }
            }

            Rectangle {
                id: invitePeople
                width: createEventPage.width
                height: createEventPage.height / 4.5

                AppText {
                    id: textInvite
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: parent.height / 4
                    anchors.leftMargin: (parent.width - width) / 2
                    text: qsTr("Invite people :")
                    font.family: lightConfortaa.name
                    font.pixelSize: sp(20)
                }

                Quick2.ComboBox {
                  id: comboBoxUser
                  implicitHeight: parent.height / 3
                  implicitWidth: parent.width / 1.25
                  anchors.top: textInvite.bottom
                  anchors.topMargin: textInvite.height / 2
                  anchors.left: parent.left
                  anchors.leftMargin: (parent.width - width) / 2
                  padding: dp(12)
                  editable: true
                  flat: false
                  background: Rectangle {
                      anchors.fill: parent
                      radius: 25
                      color: "grey"
                      border.width: dp(1)
                      border.color: "#512e5f"
                  }

                  popup: Popup {
                          y: comboBoxUser.height - 1
                          width: comboBoxUser.width - indicatorRec.width
                          implicitHeight: listModelUser.count > 10 ? createEventPage.height / 3 : (listModelUser.count * (comboBoxUser.implicitHeight / 2))
                          padding: 1

                          contentItem: ListView {
                              clip: true
                              implicitHeight: contentHeight
                              model: comboBoxUser.popup.visible ? comboBoxUser.delegateModel : null
                              currentIndex: comboBoxUser.highlightedIndex
                          }

                          background: Rectangle {
                              border.color: "grey"
                          }
                      }

                  model: ListModel {
                      id: listModelUser
                  }

                  delegate: Quick2.ItemDelegate {
                    width: comboBoxUser.implicitWidth - indicatorRec.width
                    height: comboBoxUser.implicitHeight / 2
                    padding: dp(12)
                    background: Rectangle {
                        anchors.fill: parent
                        color: "grey"
                    }

                    contentItem: AppText {
                      text: username
                      color: highlighted ? "#512e5f" : "black"
                      wrapMode: Text.NoWrap
                    }
                    highlighted: comboBoxUser.highlightedIndex == index
                    onClicked: {
                        if (!dataModel.isExist(listUser, listModelUser.get(index)["id"])) {
                            listUser.append(listModelUser.get(index))
                        }
                    }
                  }
                  indicator: Rectangle {
                      id: indicatorRec
                      anchors.top: comboBoxUser.top
                      anchors.right: comboBoxUser.right
                      width: comboBoxUser.width / 10
                      height: comboBoxUser.height
                      color: "transparent"

                      Icon {
                          icon: comboBoxUser.popup.opened ? IconType.angledoubleup : IconType.angledoubledown
                          anchors.top: parent.top
                          anchors.left: parent.left
                          anchors.topMargin: (parent.height - height) / 2
                          anchors.leftMargin: (parent.width - width) / 2
                      }
                  }

                  contentItem: Rectangle {
                      anchors.top: comboBoxUser.top
                      anchors.topMargin: (comboBoxUser.height - height) / 2
                      anchors.left: comboBoxUser.left
                      anchors.leftMargin: (parent.width - width) / 10
                      width: comboBoxUser.width - indicatorRec.width
                      height: comboBoxUser.height
                      color: "transparent"

                      AppTextField {
                          id: inputUser
                          text: ""
                          anchors.fill: parent
                          backgroundColor: "transparent"
                          placeholderText: "Invite Users"
                          onTextChanged: {
                              fct.getUserToInvite(inputUser.text)
                          }
                          onFocusChanged: {
                              comboBoxUser.popup.open()
                          }
                      }
                  }
                }
            }

            Rectangle {
                id: listUserRectangle
                width: createEventPage.width
                height: listUser.count > 0 ? createEventPage.height / 3.5 : createEventPage.height / 13
                implicitHeight: createEventPage.height / 3.5

                AppText {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: (parent.height - height) / 2
                    anchors.leftMargin: (parent.width - width) / 2
                    text: "No user selected"
                    font.family: lightConfortaa.name
                    font.pixelSize: sp(20)
                    visible: listUser.count > 0 ? false : true
                }

                AppFlickable {
                    width: createEventPage.width
                    height: parent.height
                    contentHeight: contentColumnUser.height
                    contentWidth: width
                    flickableDirection: Flickable.VerticalFlick
                    visible: listUser.count > 0 ? true : false
                    Column {
                        id: contentColumnUser
                        width: parent.width
                        height: listUser.count * (listUserRectangle.height / 5)

                        Component {
                            id: contactDelegate
                            Rectangle {
                                width: parent.width
                                height: listUserRectangle.height / 5
                                color: (index % 2 == 0) ? "#ebdef0" : "#f4ecf7"

                                AppText {
                                    anchors.top: parent.top
                                    anchors.left: parent.left
                                    anchors.topMargin: (parent.height - height) / 2
                                    anchors.leftMargin: (parent.width - width) / 2
                                    text: username
                                    font.family: lightConfortaa.name
                                    font.pixelSize: sp(20)
                                }

                                IconButton {
                                    anchors.top: parent.top
                                    anchors.right: parent.right
                                    anchors.rightMargin: parent.width / 15
                                    anchors.topMargin: (parent.height - height) / 2
                                    icon: IconType.close
                                    color: "black"
                                    onClicked: {
                                        listUser.remove(listUser.get(index))
                                    }
                                }
                            }
                        }

                        AppListView {
                            model: listUser
                            delegate: contactDelegate
                        }
                    }
                }

                ListModel {
                    id: listUser
                }
            }

            Text {
                id: textError
                anchors.left: parent.left
                anchors.leftMargin: (parent.width - width) / 2
                text: qsTr("There is an error with form")
                color: "red"
                visible: errorForm
            }

            AppButton {
                id: buttonCreateEvent
                height: createEventPage.height / 10
                width: createEventPage.width
                anchors.left: parent.left
                anchors.leftMargin: (parent.width - width) / 2
                text: "Create My Event"
                flat: false
                textColor: "white"
                backgroundColor: "#512e5f"
                fontFamily: boldConfortaa.name
                onClicked: {
                    if (!txtEventName.text || !textEditShortDescription.text || (comboBox.displayText == "Select type")
                            || !locationInput || !selectionnedDate || srcImg == "") {
                        errorForm = true
                    }
                    else {
                        errorForm = false
                    }
                    if (!errorForm) {
                        var postData = dataModel.localStorage.getValue("user")["id"]
                        dataModel.apiData.postMedia("/api/media?coverEvent=true", postData, srcImg, "file", dataModel.localStorage.getValue("token"),
                                                    function(data) {
                                                        media = JSON.parse(data)
                                                        mediaId = media["id"]
                                                        console.log("count = ", listSelectedDate.count)
                                                        dataModel.postOneEvent(txtEventName.text, textEditShortDescription.text, textEditLongDescription.text,
                                                                               comboBox.displayText, locationInput.text, (switchStatus.checked ? "Public" : "Private"),
                                                                               ageInput.text, priceInput.text, switchAcceptAutoInvit.checked,
                                                                               nbPeopleInput.text, switchAcceptCustoDate.checked, ("/api/media/" + mediaId), listSelectedDate, listUser)
                                                        txtEventName.text = ""
                                                        textEditShortDescription.text = ""
                                                        textEditLongDescription.text = ""
                                                        comboBox.displayText = comboBox.textAt(0)
                                                        locationInput.text = ""
                                                        switchStatus.checked = true
                                                        ageInput.text = ""
                                                        priceInput.text = ""
                                                        switchAcceptAutoInvit.checked = true
                                                        nbPeopleInput.text = ""
                                                        switchAcceptCustoDate.checked = true
                                                        srcImg = ""
                                                        createEventPage.forceActiveFocus()
                                                        inputUser.text = ""
                                                    },
                                                    function(err) {
                                                        console.log("erreur = ", err)
                                                        console.log("votre session à expiré")
                                                        dataModel.reLogin = true
                                                        logic.logout()
                                                    }
                                                        )
                    }
                }
            }
        }
    }

    Connections {
        target: nativeUtils
        onAlertSheetFinished: {
            if (index == 0)
                nativeUtils.displayImagePicker(qsTr("Choose Image"))
            else if (index == 1)
                srcImg = ""
        }

        onImagePickerFinished: {
            if(accepted) {
                srcImg = path;
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
                mediaId = ""
                logic.changePage(lastPage)
            }
            color: "white"
        }
    }

    Item {
        id: fct
        function getUserToInvite(usernameText) {
            dataModel.apiData.get("/api/users" + (usernameText === "" ? "" : ("?username=" + usernameText.toLowerCase())), dataModel.localStorage.getValue("token"),
                    function(data) {
                        var user = JSON.parse(data)
                        user = user["hydra:member"]
                        listModelUser.clear();
                        for (var i in user) {
                            if (user[i]["id"] !== dataModel.localStorage.getValue("user")["id"]) {
                                listModelUser.append({
                                                         id: user[i]["id"],
                                                         username: user[i]["username"],
                                                         roles: user[i]["roles"]
                                                      });
                            }
                        }
                    },
                    function(err) {
                        console.log("votre session à expiré ", err)
                        dataModel.reLogin = true
                        logic.logout()
                    })
        }
    }
}
