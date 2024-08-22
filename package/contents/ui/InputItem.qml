import QtQuick
import QtQuick.Controls

Item {    
    id: inputItem                                                                                                                                                                                                                               
    width: root.width * 0.9                                                                                         
    height: inputTextArea.contentHeight + 8                                                                                                                                                                                                                                                                                                                    
    anchors.horizontalCenter: parent.horizontalCenter 

    property var thisModel

    TextArea {                                                                                                                      
        id: inputTextArea                                                                                                               
        anchors.fill: parent                                                                                                        
        font.pixelSize: 18                                                                                                   
        color: "white" 
        horizontalAlignment: TextArea.AlignHCenter                                                                                  
        verticalAlignment: TextArea.AlignVCenter                                                                                    
        wrapMode: TextArea.Wrap 
        
        background: Rectangle {
            anchors.fill: parent   
            height: parent.height + 30                                           
            radius: 10                                                           
            opacity: 0.3                                                         
            color: "black"                                                        
        }                                                                                                                                                                                                                                                                                                                            

        Keys.onReturnPressed: {  
            var input = {}
            input.text = inputTextArea.text
            input.color = "white"
            input.checked = false
            input.sublist = []
            thisModel.insert(0, input)  
            saveModelToJson("todoListModel", todoListModel)
            inputTextArea.text = ""                                                                                                                                                                         
        }                                                                                                                                                                                                                                                                                                               
    } 
} 