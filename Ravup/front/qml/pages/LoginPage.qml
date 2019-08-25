import QtQuick 2.0
import QtQuick.Layouts 1.1
import Felgo 3.0

Page {
    id: loginPage
    useSafeArea: false

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
    }

    Image {
        id: logo
        source: "../../assets/logo.png"
        width: parent.width / 2
        height: parent.height / 3
        anchors.left: parent.left
        anchors.leftMargin: (parent.width - width) / 2
        anchors.top: headBar.bottom
        anchors.topMargin: headBar.height / 2
        anchors.bottomMargin: 0
        fillMode: Image.PreserveAspectFit
    }

    GridLayout {
        id: content
        anchors.top: logo.bottom
        anchors.topMargin: headBar.height / 2
        anchors.left: parent.left
        anchors.leftMargin: (parent.width - width) / 3
        columnSpacing: dp(20)
        rowSpacing: dp(20)
        columns: 2

        // email text and field
        AppText {
            text: qsTr("Username")
            color: "#512e5f"
            font.family: regularConfortaa.name
            font.pixelSize: sp(15)
        }

        AppTextField {
            id: txtUsername
            Layout.preferredWidth: dp(200)
            showClearButton: true
            font.pixelSize: sp(14)
            borderColor: "#512e5f"
            borderWidth: dp(1)
            cursorColor: "#512e5f"
        }

        // password text and field
        AppText {
            text: qsTr("Password")
            color: "#512e5f"
            font.family: regularConfortaa.name
            font.pixelSize: sp(15)
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

        // column for buttons, we use column here to avoid additional spacing between buttons
    }

    Column {
        id: columnLogin
        anchors.top: content.bottom
        anchors.topMargin: content.height / 2
        Layout.fillWidth: true
        Layout.columnSpan: 2
        Layout.topMargin: dp(0)
        width: parent.width

        Text {
            id: textWrong
            visible: dataModel.wrongConnection
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Wrong password or username")
            font.family: regularConfortaa.name
            font.pixelSize: sp(15)
            color: "red"
        }

        // buttons
        AppButton {
            text: qsTr("Login")
            fontFamily: regularConfortaa.name
            flat: false
            textColor: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            backgroundColor: "#512e5f"
            onClicked: {
                loginPage.forceActiveFocus()
                dataModel.reLogin = false
                logic.login(txtUsername.text, txtPassword.text)
                txtUsername.text = ""
                txtPassword.text = ""
            }
            ActivityIndicatorBarItem {
                enabled: dataModel.isBusy
                visible: enabled
                showItem: showItemAlways
            }
        }

        AppButton {
            id: noAccountButton
            text: qsTr("No account yet? Register now")
            fontFamily: regularConfortaa.name
            flat: true
            anchors.horizontalCenter: parent.horizontalCenter
            textColor: "#512e5f"
            onClicked: {
                loginPage.forceActiveFocus()
                // call your logic action to register here
                logic.changePage(1)
                txtUsername.text = ""
                txtPassword.text = ""
            }
        }
    }

    Text {
        id: reLoginText
        anchors.top: columnLogin.bottom
        anchors.left: parent.left
        anchors.leftMargin: (parent.width - width) / 2
        width: loginPage.width / 1.25
        text: qsTr("You have been disconnected. Please log in again")
        visible: dataModel.reLogin
        wrapMode: Text.Wrap
        color: "red"
        horizontalAlignment: Text.AlignHCenter
        font.family: regularConfortaa.name
    }
}
