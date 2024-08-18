import QtQuick
import QtQuick.Controls

Item {    
    id: inputItem                                                                                                                                                                                                                               
    width: root.width * 0.9                                                                                         
    height: inputTextArea.contentHeight + 8                                                                                                                                                                                                                                                                                                                    
    anchors.horizontalCenter: parent.horizontalCenter 

    property bool details: false  
    property int detailIndex: -1
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
            if (details == false) { 
                for (var i = 0; i < thisModel.count; i++) {     
                    for (var prop in thisModel.get(i)) {                                                         
                        console.log(prop, ":", thisModel.get(i)[prop])                                                                         
                    } 
                }
                input.sublist = []
                thisModel.insert(0, input)  
            }   
            else { 
                thisModel.insert(0, input) 
                var sublist = todoListModel.get(detailIndex).sublist;                                                 
                sublist.clear();                                                                                      
                for (var i = 0; i < thisModel.count; i++) {                                                           
                    sublist.append(thisModel.get(i))                                                               
                }    
                saveModelToJson("todoListModel", todoListModel)
            }

            inputTextArea.text = ""                                                                                                                                                                           
        }                                                                                                                                                                                                                                                                                                               
    } 
} 