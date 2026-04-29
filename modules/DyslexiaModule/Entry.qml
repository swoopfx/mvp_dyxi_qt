import QtQuick 2.15

/**

  This defines the entry point for the app
  Defines conditions for what page to load
  based on fed requiresments or status references from the backend
  Parameters like age, language etc determins the background and other things

**/
Item {

  required property int age
  required property string language
  property string theme: "theme"


  Component.onCompleted: {
    // calls necesary page
  }

}
