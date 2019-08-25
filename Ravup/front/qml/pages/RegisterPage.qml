import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.1

Page {
    id: registerPage
    useSafeArea: false

    property bool buttonIsPressed: false

    Rectangle {
        id: safeAreaTop
        width: parent.width
        height: nativeUtils.safeAreaInsets.top > 0 ? nativeUtils.safeAreaInsets.top : nativeUtils.statusBarHeight()
        color: "#512e5f"
    }

    Rectangle {
        id: headBar
        width: parent.width
        height: parent.height / 12
        anchors.top: safeAreaTop.bottom
        color: "#512e5f"
        Image {
            id: logo
            source: "../../assets/logo.png"
            width: parent.width / 2
            height: parent.height
            anchors.top: parent.top
            anchors.topMargin: (parent.height - height) / 2
            anchors.left: parent.left
            anchors.leftMargin: (parent.width - width) / 2
            fillMode: Image.PreserveAspectFit
        }
    }

    NavigationBarRow {
        anchors.top: headBar.top
        anchors.topMargin: (headBar.height - height) / 2
        anchors.left: headBar.left
        IconButtonBarItem {
            icon: IconType.arrowleft
            color: "white"
            showItem: showItemAlways
            onClicked: {
                buttonIsPressed = false
                registerPage.forceActiveFocus()
                logic.changePage(0)
            }
        }
    }

    Text {
        id: textAccount
        text: "Create Account"
        anchors.left: parent.left
        anchors.leftMargin: (parent.width - width) / 2
        anchors.top: headBar.bottom
        anchors.topMargin: parent.height / 15
        font.bold: true
        font.pixelSize: sp(25)
        font.family: regularConfortaa.name
    }

    GridLayout {
        id: content
        anchors.top: textAccount.bottom
        anchors.topMargin: parent.height / 12
        anchors.left: parent.left
        anchors.leftMargin: (parent.width - width) / 2
        columnSpacing: dp(0)
        rowSpacing: dp(30)
        columns: 2

        // email text and field
        AppText {
            text: qsTr("Username")
            color: "#512e5f"
            font.pixelSize: sp(12)
            font.family: regularConfortaa.name
        }

        AppTextField {
            id: txtUsername
            Layout.preferredWidth: dp(200)
            showClearButton: true
            font.pixelSize: sp(14)
            borderColor: "#512e5f"
            borderWidth: dp(1)
        }

        AppText {
            text: qsTr("E-mail")
            color: "#512e5f"
            font.pixelSize: sp(12)
            font.family: regularConfortaa.name
        }

        AppTextField {
            id: txtEmail
            Layout.preferredWidth: dp(200)
            showClearButton: true
            font.pixelSize: sp(14)
            borderColor: "#512e5f"
            borderWidth: dp(1)
        }

        // password text and field
        AppText {
            text: qsTr("Password")
            color: "#512e5f"
            font.pixelSize: sp(12)
            font.family: regularConfortaa.name
        }

        AppTextField {
            id: txtPassword
            Layout.preferredWidth: dp(200)
            showClearButton: true
            font.pixelSize: sp(14)
            borderColor: "#512e5f"
            borderWidth: dp(1)
            echoMode: TextInput.Password
        }

        AppText {
            text: qsTr("Confirm\nPassword")
            color: "#512e5f"
            font.pixelSize: sp(12)
            font.family: regularConfortaa.name
        }

        AppTextField {
            id: txtConfirmPassword
            Layout.preferredWidth: dp(200)
            showClearButton: true
            font.pixelSize: sp(14)
            borderColor: "#512e5f"
            borderWidth: dp(1)
            echoMode: TextInput.Password
        }

        // column for buttons, we use column here to avoid additional spacing between buttons
        Column {
            Layout.fillWidth: true
            Layout.columnSpan: 2
            Layout.topMargin: dp(15)

            Text {
                id: textWrongField
                visible: (txtUsername.text == "" && txtEmail.text == "" && txtPassword.text == "" && txtConfirmPassword.text == "" && buttonIsPressed) ? true : false
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Invalid Field")
                font.pixelSize: sp(12)
                font.family: regularConfortaa.name
                color: "red"
            }

            Text {
                id: textWrong
                visible: (dataModel.alreadyExist && !textWrongField.visible) ? true : false
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("User already exist")
                font.pixelSize: sp(12)
                font.family: regularConfortaa.name
                color: "red"
            }

            Text {
                id: textWrongPassword
                visible: (!dataModel.samePassword && !textWrong.visible) ? true : false
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Invalid password")
                font.pixelSize: sp(12)
                font.family: regularConfortaa.name
                color: "red"
            }

            // buttons
            AppButton {
                id: signUpButton
                text: qsTr("Sign up")
                flat: false
                backgroundColor: "#512e5f"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    buttonIsPressed = true
                    registerPage.forceActiveFocus()
                    if (!textWrongField.visible) {
                        buttonIsPressed = false

                        // call login action
                        logic.register(txtUsername.text, txtEmail.text, txtPassword.text, txtConfirmPassword.text)
                        txtUsername.text = ""
                        txtEmail.text = ""
                        txtPassword.text = ""
                        txtConfirmPassword.text = ""
                    }
                }
                ActivityIndicatorBarItem {
                    enabled: dataModel.isBusy
                    visible: enabled
                    showItem: showItemAlways // do not collapse into sub-menu on Android
                }
            }
        }
    }
}
