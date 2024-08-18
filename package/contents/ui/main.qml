import QtQuick            
import QtQuick.Layouts                                             
import org.kde.plasma.plasmoid                                         
import QtQuick.Controls                                           
import QtQuick.LocalStorage
import org.kde.plasma.core
import org.kde.kirigami as Kirigami

PlasmoidItem {     
    id: root                                                           
    width: 300                                                       
    height: 400 
    Layout.minimumWidth: 300                                                 
    Layout.minimumHeight: 400     

    Item {
        id: mainViewWrapper
        anchors.fill: parent
        visible: true

        TodoList {
            id: mainTodoList
            width: parent.width                                      
            height: parent.height * 0.9 
            anchors.top: mainInputItem.bottom                         
            model: todoListModel 
            thisModel: todoListModel
        }

        InputItem {
            id: mainInputItem
            anchors.top: parent.top
            thisModel: todoListModel
        }
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
    } 

   ListModel {
        id: detailModel
    }                                                                                                                                
    ListModel {                                                        
        id: todoListModel   

        onCountChanged: {
            saveModelToJson("todoListModel", todoListModel)
        }

        Component.onCompleted: {
            loadModelFromJson("todoListModel", todoListModel)
        }                                        
    } 

    function saveModelToJson(fileName, listModel) {
        let jsonArray = []
        for (let i = 0; i < listModel.count; i++) {
            jsonArray.push(listModel.get(i))
        }
        let jsonString = JSON.stringify(jsonArray)
        let file = LocalStorage.openDatabaseSync("qtodo", "1.0", "StorageDatabase", 5000000)
        file.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS ListData (id TEXT UNIQUE, data TEXT)')
            tx.executeSql('INSERT OR REPLACE INTO ListData VALUES(?, ?)', [fileName, jsonString])
        })
    }

    function loadModelFromJson(fileName, listModel) {
        let file = LocalStorage.openDatabaseSync("qtodo", "1.0", "StorageDatabase", 5000000)
        let jsonString = ""
        file.transaction(function(tx) {
            let rs = tx.executeSql('SELECT data FROM ListData WHERE id=?', [fileName])
            if (rs.rows.length > 0) {
                jsonString = rs.rows.item(0).data
            }
        })

        if (jsonString !== "") {
            let jsonArray = JSON.parse(jsonString)
            listModel.clear()
            for (let i = 0; i < jsonArray.length; i++) {
                listModel.append(jsonArray[i])
            }
        }
    }  

    Item {
        id: detailsWrapper
        anchors.fill: parent
        visible: false 

        property var detailTitle  

        TodoList {
            id: detailTodoList
            width: parent.width                                      
            height: parent.height * 0.75
            anchors.top: detailInputItem.bottom      
            model: detailModel     
            thisModel: detailModel  
            details: true          
            detailIndex: -1
        }

        InputItem {
            id: detailInputItem
            anchors.topMargin: 10
            anchors.top: topBarRectangle.bottom
            details: true
            detailIndex: -1
            thisModel: detailModel 
        }

        Rectangle {
            id: topBarRectangle
            width: parent.width
            height: Math.max(title.contentHeight + 10, 40)
            radius: 10
            anchors.top: parent.top
            color: "black"
            opacity: 0.3
        }
        Text {    
            id: title 
            width: parent.width * 0.75                                                     
            text: detailsWrapper.detailTitle                                                                                                   
            font.pixelSize: 18                                                                                                      
            color: "white"                                                                           
            anchors.verticalCenter: topBarRectangle.verticalCenter  
            anchors.left: detailBackButton.right
            anchors.leftMargin: 15                                                                                                         
            wrapMode: Text.Wrap                                                                                                                                                                                               
        }  
        Button {
            id: detailBackButton
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.verticalCenter: topBarRectangle.verticalCenter
            onClicked: {
                detailsWrapper.visible = false
                mainViewWrapper.visible = true
            }
            background: Kirigami.Icon {
                id: backIcon
                source: "draw-arrow-back"
                width: Kirigami.Units.iconSizes.medium
                height: width 
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                HoverHandler {
                    id: backButtonHoverHandler
                    acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                    cursorShape: Qt.PointingHandCursor
                }                                                                                
                states: [                                                                                     
                    State {                                                                                                                                                   
                        when: backButtonHoverHandler.hovered                                                                  
                        PropertyChanges {                                                                     
                            target: backIcon                                                                 
                            opacity: 0.4                                                               
                        }                                                                                     
                    }                                                                                      
                ] 
            }
        }


    }                                               
}       