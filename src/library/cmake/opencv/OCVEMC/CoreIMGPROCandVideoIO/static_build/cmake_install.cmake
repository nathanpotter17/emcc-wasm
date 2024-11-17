# Install script for directory: C:/Users/natha/Desktop/statics/opencv

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

if(CMAKE_INSTALL_COMPONENT STREQUAL "licenses" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/licenses/opencv4" TYPE FILE RENAME "flatbuffers-LICENSE.txt" FILES "C:/Users/natha/Desktop/statics/opencv/3rdparty/flatbuffers/LICENSE.txt")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "licenses" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/licenses/opencv4" TYPE FILE RENAME "opencl-headers-LICENSE.txt" FILES "C:/Users/natha/Desktop/statics/opencv/3rdparty/include/opencl/LICENSE.txt")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/opencv4/3rdparty" TYPE STATIC_LIBRARY OPTIONAL FILES "C:/Users/natha/Desktop/statics/opencv/static_build/3rdparty/lib/libade.a")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "licenses" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/licenses/opencv4" TYPE FILE RENAME "ade-LICENSE" FILES "C:/Users/natha/Desktop/statics/opencv/static_build/3rdparty/ade/ade-0.1.2e/LICENSE")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv4/opencv2" TYPE FILE FILES "C:/Users/natha/Desktop/statics/opencv/static_build/cvconfig.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv4/opencv2" TYPE FILE FILES "C:/Users/natha/Desktop/statics/opencv/static_build/opencv2/opencv_modules.hpp")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/opencv4/OpenCVModules.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/opencv4/OpenCVModules.cmake"
         "C:/Users/natha/Desktop/statics/opencv/static_build/CMakeFiles/Export/51ea738ee2ea68756d9122094dacc2a4/OpenCVModules.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/opencv4/OpenCVModules-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/opencv4/OpenCVModules.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/opencv4" TYPE FILE FILES "C:/Users/natha/Desktop/statics/opencv/static_build/CMakeFiles/Export/51ea738ee2ea68756d9122094dacc2a4/OpenCVModules.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/opencv4" TYPE FILE FILES "C:/Users/natha/Desktop/statics/opencv/static_build/CMakeFiles/Export/51ea738ee2ea68756d9122094dacc2a4/OpenCVModules-release.cmake")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/opencv4" TYPE FILE FILES
    "C:/Users/natha/Desktop/statics/opencv/static_build/unix-install/OpenCVConfig-version.cmake"
    "C:/Users/natha/Desktop/statics/opencv/static_build/unix-install/OpenCVConfig.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "scripts" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE FILE PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE FILES "C:/Users/natha/Desktop/statics/opencv/static_build/CMakeFiles/install/setup_vars_opencv4.sh")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/opencv4" TYPE FILE FILES
    "C:/Users/natha/Desktop/statics/opencv/platforms/scripts/valgrind.supp"
    "C:/Users/natha/Desktop/statics/opencv/platforms/scripts/valgrind_3rdparty.supp"
    )
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("C:/Users/natha/Desktop/statics/opencv/static_build/3rdparty/zlib/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/3rdparty/libjpeg-turbo/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/3rdparty/libtiff/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/3rdparty/libwebp/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/3rdparty/openjpeg/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/3rdparty/libpng/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/3rdparty/protobuf/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/include/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/modules/.firstpass/calib3d/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/modules/.firstpass/core/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/modules/.firstpass/dnn/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/modules/.firstpass/features2d/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/modules/.firstpass/flann/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/modules/.firstpass/gapi/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/modules/.firstpass/highgui/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/modules/.firstpass/imgcodecs/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/modules/.firstpass/imgproc/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/modules/.firstpass/java/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/modules/.firstpass/js/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/modules/.firstpass/ml/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/modules/.firstpass/objc/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/modules/.firstpass/objdetect/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/modules/.firstpass/photo/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/modules/.firstpass/python/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/modules/.firstpass/stitching/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/modules/.firstpass/ts/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/modules/.firstpass/video/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/modules/.firstpass/videoio/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/modules/.firstpass/world/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/modules/core/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/modules/imgproc/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/modules/imgcodecs/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/modules/videoio/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/doc/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/data/cmake_install.cmake")
  include("C:/Users/natha/Desktop/statics/opencv/static_build/apps/cmake_install.cmake")

endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "C:/Users/natha/Desktop/statics/opencv/static_build/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
if(CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_COMPONENT MATCHES "^[a-zA-Z0-9_.+-]+$")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
  else()
    string(MD5 CMAKE_INST_COMP_HASH "${CMAKE_INSTALL_COMPONENT}")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INST_COMP_HASH}.txt")
    unset(CMAKE_INST_COMP_HASH)
  endif()
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "C:/Users/natha/Desktop/statics/opencv/static_build/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
