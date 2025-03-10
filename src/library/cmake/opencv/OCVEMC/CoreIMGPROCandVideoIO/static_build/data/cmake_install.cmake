# Install script for directory: C:/Users/natha/Desktop/statics/opencv/data

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "C:/Users/natha/Desktop/statics/opencv/static_build/install")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "TRUE")
endif()

# Set path to fallback-tool for dependency-resolution.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "C:/msys64/ucrt64/bin/objdump.exe")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "libs" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/opencv4/haarcascades" TYPE FILE FILES
    "C:/Users/natha/Desktop/statics/opencv/data/haarcascades/haarcascade_eye.xml"
    "C:/Users/natha/Desktop/statics/opencv/data/haarcascades/haarcascade_eye_tree_eyeglasses.xml"
    "C:/Users/natha/Desktop/statics/opencv/data/haarcascades/haarcascade_frontalcatface.xml"
    "C:/Users/natha/Desktop/statics/opencv/data/haarcascades/haarcascade_frontalcatface_extended.xml"
    "C:/Users/natha/Desktop/statics/opencv/data/haarcascades/haarcascade_frontalface_alt.xml"
    "C:/Users/natha/Desktop/statics/opencv/data/haarcascades/haarcascade_frontalface_alt2.xml"
    "C:/Users/natha/Desktop/statics/opencv/data/haarcascades/haarcascade_frontalface_alt_tree.xml"
    "C:/Users/natha/Desktop/statics/opencv/data/haarcascades/haarcascade_frontalface_default.xml"
    "C:/Users/natha/Desktop/statics/opencv/data/haarcascades/haarcascade_fullbody.xml"
    "C:/Users/natha/Desktop/statics/opencv/data/haarcascades/haarcascade_lefteye_2splits.xml"
    "C:/Users/natha/Desktop/statics/opencv/data/haarcascades/haarcascade_license_plate_rus_16stages.xml"
    "C:/Users/natha/Desktop/statics/opencv/data/haarcascades/haarcascade_lowerbody.xml"
    "C:/Users/natha/Desktop/statics/opencv/data/haarcascades/haarcascade_profileface.xml"
    "C:/Users/natha/Desktop/statics/opencv/data/haarcascades/haarcascade_righteye_2splits.xml"
    "C:/Users/natha/Desktop/statics/opencv/data/haarcascades/haarcascade_russian_plate_number.xml"
    "C:/Users/natha/Desktop/statics/opencv/data/haarcascades/haarcascade_smile.xml"
    "C:/Users/natha/Desktop/statics/opencv/data/haarcascades/haarcascade_upperbody.xml"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "libs" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/opencv4/lbpcascades" TYPE FILE FILES
    "C:/Users/natha/Desktop/statics/opencv/data/lbpcascades/lbpcascade_frontalcatface.xml"
    "C:/Users/natha/Desktop/statics/opencv/data/lbpcascades/lbpcascade_frontalface.xml"
    "C:/Users/natha/Desktop/statics/opencv/data/lbpcascades/lbpcascade_frontalface_improved.xml"
    "C:/Users/natha/Desktop/statics/opencv/data/lbpcascades/lbpcascade_profileface.xml"
    "C:/Users/natha/Desktop/statics/opencv/data/lbpcascades/lbpcascade_silverware.xml"
    )
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "C:/Users/natha/Desktop/statics/opencv/static_build/data/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
