import Felgo 3.0
import QtQuick 2.2
import "logic"
import "pages"
import "data"

App {
    id: app

    Logic {
        id: logic
    }

    // model
    DataModel {
        id: dataModel
        dispatcher: logic // data model handles actions sent by logic

        // global error handling
        onFetchLoginFailed: nativeUtils.displayMessageBox("login failed: ", "password or username is incorrect", 1)
    }

    LoginPage { // Page 0
        visible: opacity > 0
        enabled: visible
        opacity: (!dataModel.userLoggedIn && dataModel.pages == 0) ? 1 : 0 // hide if user is logged in

        Behavior on opacity { NumberAnimation { duration: 250 } } // page fade in/out
    }

    RegisterPage { // Page 1
        visible: opacity > 0
        enabled: visible
        opacity: (!dataModel.userLoggedIn && dataModel.pages == 1) ? 1 : 0 // hide if user is logged in

        Behavior on opacity { NumberAnimation { duration: 250 } } // page fade in/out
    }

    HomePage { // Page 2
        visible: opacity > 0
        enabled: visible
        opacity: (dataModel.userLoggedIn && dataModel.pages == 2) ? 1 : 0 // hide if user is logged out

        Behavior on opacity { NumberAnimation { duration: 350 } } // page fade in/out
    }

    EventPage { // Page 3
        id: eventPage
        visible: opacity > 0
        enabled: visible
        opacity: (dataModel.userLoggedIn && dataModel.pages == 3) ? 1 : 0// hide if user is logged out

        Behavior on opacity { NumberAnimation { duration: 350 } } // page fade in/out
    }

    ProfilePage { // Page 4
        id: profilePage
        visible: opacity > 0
        enabled: visible
        opacity: (dataModel.userLoggedIn && dataModel.pages == 4) ? 1 : 0 // hide if user is logged out

        Behavior on opacity { NumberAnimation { duration: 350 } } // page fade in/out
    }

    FriendPage { // Page 5
        visible: opacity > 0
        enabled: visible
        opacity: (dataModel.userLoggedIn && dataModel.pages == 5) ? 1 : 0 // hide if user is logged out

        Behavior on opacity { NumberAnimation { duration: 350 } } // page fade in/out
    }


    MyEventsPage { // Page 6
        visible: opacity > 0
        enabled: visible
        opacity: (dataModel.userLoggedIn && dataModel.pages == 6) ? 1 : 0 // hide if user is logged out

        Behavior on opacity { NumberAnimation { duration: 350 } } // page fade in/out
    }

    CreateEventPage { // Page 7
        id: createEventPage
        visible: opacity > 0
        enabled: visible
        opacity: (dataModel.userLoggedIn && dataModel.pages == 7) ? 1 : 0 // hide if user is logged out

        Behavior on opacity { NumberAnimation { duration: 350 } } // page fade in/out
    }

    SettingsPage { // Page 8
        id: settingsPage
        visible: opacity > 0
        enabled: visible
        opacity: (dataModel.userLoggedIn && dataModel.pages == 8) ? 1 : 0 // hide if user is logged out

        Behavior on opacity { NumberAnimation { duration: 350 } } // page fade in/out
    }

    // Fonts
    FontLoader {
        id: regularConfortaa
        source: "../assets/Comfortaa-Regular.ttf"
    }

    FontLoader {
        id: boldConfortaa
        source: "../assets/Comfortaa-Bold.ttf"
    }

    FontLoader {
        id: lightConfortaa
        source: "../assets/Comfortaa-Light.ttf"
    }

    FontLoader {
        id: centabel
        source: "../assets/centabel.ttf"
    }

    FontLoader {
        id: azonix
        source: "../assets/Azonix.otf"
    }

    FontLoader {
        id: monospace
        source: "../assets/Elronmonospace.ttf"
    }

    FontLoader {
        id: monospaceNK57
        source: "../assets/nk57-monospace-cd-bk.ttf"
    }

}
