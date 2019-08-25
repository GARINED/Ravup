import Felgo 3.0
import QtQuick 2.0
import QtQuick.Controls 2.0 as Quick2

Page {
    id: settingsPage
    useSafeArea: false

    AppText {
        id: languageText
        anchors.top: headBar.bottom
        anchors.left: parent.left
        anchors.leftMargin: (parent.width - width) / 2
        anchors.topMargin: height
        font.family: boldConfortaa.name
        font.pixelSize: sp(20)
        text: qsTr("Language") + translation.language
    }

    Quick2.ComboBox {
      id: comboBox
      implicitHeight: parent.height / 10
      implicitWidth: parent.width / 1.5
      anchors.top: languageText.bottom
      anchors.topMargin: languageText.height
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

      model: [qsTr("English"), qsTr("French")]

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
        onClicked: {
            if (index == 0) {
                settings.language = "en_EN";
            }
            else {
                settings.language = "fr_FR";
                console.log("je change en fr")
            }
        }
      }

      contentItem: AppText {
        width: comboBox.width - comboBox.indicator.width - comboBox.spacing
        text: comboBox.displayText
        color: "#512e5f"
        wrapMode: Text.NoWrap
      }
    }

    AppText {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: height
        anchors.leftMargin: (parent.width - width) / 2
        font.family: azonix.name
        font.pixelSize: sp(25)
        text: "Ravup Company"
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
