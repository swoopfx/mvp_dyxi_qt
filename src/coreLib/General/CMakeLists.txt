# find_package(Qt6 REQUIRED COMPONENTS Quick Gui Multimedia QuickControls2  Network Core TextToSpeech )#This provides
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
add_library(General STATIC

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

qt_add_qml_module(General
  URI General
  # SOURCES CoreSettings.hpp
  # SOURCES neworkaccessmanager.h neworkaccessmanager.cpp
  # SOURCES usersession.h usersession.cpp
  SOURCES CoreSettings.hpp
  SOURCES neworkaccessmanager.h neworkaccessmanager.cpp
  SOURCES usersession.h usersession.cpp
  SOURCES networkaccessitemlist.h networkaccessitemlist.cpp
  SOURCES
  SOURCES abstracterrorprocessing.h abstracterrorprocessing.cpp
  # SOURCES poststudentactivity.h poststudentactivity.cpp
  # SOURCES postactivity.h postactivity.cpp
  SOURCES networkaccesspresets.h networkaccesspresets.cpp
  SOURCES postact.h postact.cpp
  SOURCES comparestrings.h comparestrings.cpp
  SOURCES audiomanipulator.h audiomanipulator.cpp
)

target_link_libraries(General
  PRIVATE
  Qt6::Core
  Qt6::Qml
  Qt6::Network
)
# set(CMAKE_AUTOMOC ON)

