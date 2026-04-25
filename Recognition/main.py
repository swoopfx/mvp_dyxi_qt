import sys
import os
from PySide6.QtGui import QGuiApplication, QFont, QFontDatabase
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject, Slot, Signal, Property

class GameEngine(QObject):
    def __init__(self):
        super().__init__()
        self._score = 0
        self._level = 1

    @Property(int)
    def score(self):
        return self._score

    @score.setter
    def score(self, val):
        self._score = val
        self.scoreChanged.emit()

    scoreChanged = Signal()

    @Slot(str)
    def playSound(self, sound_name):
        # In a real environment, we'd use QMediaPlayer
        # For this sandbox, we'll just print and pretend
        sound_path = os.path.join(os.path.dirname(__file__), "assets/sounds", sound_name)
        print(f"Playing sound: {sound_path}")
        # To actually hear it in some environments:
        # subprocess.run(["aplay", sound_path])

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    
    # Load Dyslexia friendly font
    font_path = os.path.join(os.path.dirname(__file__), "assets/OpenDyslexic-Regular.otf")
    font_id = QFontDatabase.addApplicationFont(font_path)
    if font_id != -1:
        font_family = QFontDatabase.applicationFontFamilies(font_id)[0]
        app.setFont(QFont(font_family, 12))
    else:
        print("Failed to load OpenDyslexic font")

    engine = QQmlApplicationEngine()
    
    game_engine = GameEngine()
    engine.rootContext().setContextProperty("gameEngine", game_engine)
    
    qml_file = os.path.join(os.path.dirname(__file__), "main.qml")
    engine.load(qml_file)

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
