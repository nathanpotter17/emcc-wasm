#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "zlib" for configuration "Release"
set_property(TARGET zlib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(zlib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/opencv4/3rdparty/libzlib.a"
  )

list(APPEND _cmake_import_check_targets zlib )
list(APPEND _cmake_import_check_files_for_zlib "${_IMPORT_PREFIX}/lib/opencv4/3rdparty/libzlib.a" )

# Import target "libjpeg-turbo" for configuration "Release"
set_property(TARGET libjpeg-turbo APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(libjpeg-turbo PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/opencv4/3rdparty/liblibjpeg-turbo.a"
  )

list(APPEND _cmake_import_check_targets libjpeg-turbo )
list(APPEND _cmake_import_check_files_for_libjpeg-turbo "${_IMPORT_PREFIX}/lib/opencv4/3rdparty/liblibjpeg-turbo.a" )

# Import target "libtiff" for configuration "Release"
set_property(TARGET libtiff APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(libtiff PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C;CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/opencv4/3rdparty/liblibtiff.a"
  )

list(APPEND _cmake_import_check_targets libtiff )
list(APPEND _cmake_import_check_files_for_libtiff "${_IMPORT_PREFIX}/lib/opencv4/3rdparty/liblibtiff.a" )

# Import target "libwebp" for configuration "Release"
set_property(TARGET libwebp APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(libwebp PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/opencv4/3rdparty/liblibwebp.a"
  )

list(APPEND _cmake_import_check_targets libwebp )
list(APPEND _cmake_import_check_files_for_libwebp "${_IMPORT_PREFIX}/lib/opencv4/3rdparty/liblibwebp.a" )

# Import target "libopenjp2" for configuration "Release"
set_property(TARGET libopenjp2 APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(libopenjp2 PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/opencv4/3rdparty/liblibopenjp2.a"
  )

list(APPEND _cmake_import_check_targets libopenjp2 )
list(APPEND _cmake_import_check_files_for_libopenjp2 "${_IMPORT_PREFIX}/lib/opencv4/3rdparty/liblibopenjp2.a" )

# Import target "libpng" for configuration "Release"
set_property(TARGET libpng APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(libpng PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/opencv4/3rdparty/liblibpng.a"
  )

list(APPEND _cmake_import_check_targets libpng )
list(APPEND _cmake_import_check_files_for_libpng "${_IMPORT_PREFIX}/lib/opencv4/3rdparty/liblibpng.a" )

# Import target "libprotobuf" for configuration "Release"
set_property(TARGET libprotobuf APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(libprotobuf PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/opencv4/3rdparty/liblibprotobuf.a"
  )

list(APPEND _cmake_import_check_targets libprotobuf )
list(APPEND _cmake_import_check_files_for_libprotobuf "${_IMPORT_PREFIX}/lib/opencv4/3rdparty/liblibprotobuf.a" )

# Import target "ade" for configuration "Release"
set_property(TARGET ade APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(ade PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/opencv4/3rdparty/libade.a"
  )

list(APPEND _cmake_import_check_targets ade )
list(APPEND _cmake_import_check_files_for_ade "${_IMPORT_PREFIX}/lib/opencv4/3rdparty/libade.a" )

# Import target "opencv_core" for configuration "Release"
set_property(TARGET opencv_core APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(opencv_core PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libopencv_core.a"
  )

list(APPEND _cmake_import_check_targets opencv_core )
list(APPEND _cmake_import_check_files_for_opencv_core "${_IMPORT_PREFIX}/lib/libopencv_core.a" )

# Import target "opencv_imgproc" for configuration "Release"
set_property(TARGET opencv_imgproc APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(opencv_imgproc PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libopencv_imgproc.a"
  )

list(APPEND _cmake_import_check_targets opencv_imgproc )
list(APPEND _cmake_import_check_files_for_opencv_imgproc "${_IMPORT_PREFIX}/lib/libopencv_imgproc.a" )

# Import target "opencv_imgcodecs" for configuration "Release"
set_property(TARGET opencv_imgcodecs APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(opencv_imgcodecs PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libopencv_imgcodecs.a"
  )

list(APPEND _cmake_import_check_targets opencv_imgcodecs )
list(APPEND _cmake_import_check_files_for_opencv_imgcodecs "${_IMPORT_PREFIX}/lib/libopencv_imgcodecs.a" )

# Import target "opencv_videoio" for configuration "Release"
set_property(TARGET opencv_videoio APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(opencv_videoio PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libopencv_videoio.a"
  )

list(APPEND _cmake_import_check_targets opencv_videoio )
list(APPEND _cmake_import_check_files_for_opencv_videoio "${_IMPORT_PREFIX}/lib/libopencv_videoio.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
