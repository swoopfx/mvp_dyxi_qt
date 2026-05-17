# find_package(Qt6 REQUIRED COMPONENTS Quick Gui Multimedia QuickControls2  Network Core TextToSpeech )#This provides
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
add_library(coreLib STATIC

  # CoreSettings.hpp
  # neworkaccessmanager.h
  # neworkaccessmanager.cpp
  # usersession.h
  # usersession.cpp

)
# qt_add_executable(coreLib
  # General/CoreSettings.hpp
  # General/neworkaccessmanager.h General/neworkaccessmanager.cpp
  # General/usersession.h General/usersession.cpp
# )

# qt_add_qml_module(coreLib
#   URI coreLib
#   # SOURCES CoreSettings.hpp
#   # SOURCES neworkaccessmanager.h neworkaccessmanager.cpp
#   # SOURCES usersession.h usersession.cpp
#   SOURCES General/CoreSettings.hpp
#   SOURCES General/neworkaccessmanager.h General/neworkaccessmanager.cpp
#   SOURCES General/usersession.h General/usersession.cpp
# )

target_link_libraries(coreLib
  PRIVATE
  Qt6::Core
  Qt6::Qml
  Qt6::Network
)
# set(CMAKE_AUTOMOC ON)

add_subdirectory(General)

