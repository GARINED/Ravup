import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick 2.11
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import ravup.module.login 1.0

/*

// EXAMPLE USAGE:
// add the following piece of code inside your App { } to display the Login Page

// property to store whether user is logged
property bool userLoggedIn: false

// login page is always visible if user is not logged in
loginPage {
  z: 1 // show login above actual app pages
  visible: opacity > 0
  enabled: visible
  opacity: userLoggedIn ? 0 : 1 // hide if user is logged in
  onLoginSucceeded: userLoggedIn = true

  Behavior on opacity { NumberAnimation { duration: 250 } } // page fade in/out
}

*/

Page {
    id: loginPage
    title: "Login"
    signal loginSucceeded


    // login form background
    Rectangle {
        id: loginForm
        anchors.centerIn: parent
        color: "white"
        width: content.width + dp(48)
        height: content.height + dp(16)
        radius: dp(4)
    }

    // login form content
    GridLayout {
        id: content
        anchors.centerIn: loginForm
        columnSpacing: dp(20)
        rowSpacing: dp(10)
        columns: 2

        // headline
        AppText {
            Layout.topMargin: dp(8)
            Layout.bottomMargin: dp(12)
            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignHCenter
            text: "Login"
        }

        // email text and field
        AppText {
            text: qsTr("E-mail")
            font.pixelSize: sp(12)
        }

        AppTextField {
            id: txtUsername
            Layout.preferredWidth: dp(200)
            showClearButton: true
            font.pixelSize: sp(14)
            borderColor: Theme.tintColor
            borderWidth: !Theme.isAndroid ? dp(2) : 0
        }

        // password text and field
        AppText {
            text: qsTr("Password")
            font.pixelSize: sp(12)
        }

        AppTextField {
            id: txtPassword
            Layout.preferredWidth: dp(200)
            showClearButton: true
            font.pixelSize: sp(14)
            borderColor: Theme.tintColor
            borderWidth: !Theme.isAndroid ? dp(2) : 0
            echoMode: TextInput.Password
        }

        // column for buttons, we use column here to avoid additional spacing between buttons
        Column {
            Layout.fillWidth: true
            Layout.columnSpan: 2
            Layout.topMargin: dp(12)

            // buttons
            AppButton {
                text: qsTr("Login")
                flat: false
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    loginPage.forceActiveFocus() // move focus away from text fields

                    // simulate successful login
                    console.debug("logging in ...")
                    loginSucceeded()
                }
            }

            AppButton {
                text: qsTr("No account yet? Register now")
                flat: true
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    loginPage.forceActiveFocus() // move focus away from text fields

                    // call your server code to register here
                    console.debug("registering...")
                }
            }
        }
    }
}
