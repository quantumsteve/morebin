# grab gmock and gtest for testing
# We need thread support
find_package(Threads REQUIRED)

include(ExternalProject)

# Download and install GoogleTest
ExternalProject_Add(
    gtest
    URL "http://googletest.googlecode.com/files/gtest-${gtest_version}.zip"
    URL_MD5 "${gtest_md5}"
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/gtest
    # Disable install step
    INSTALL_COMMAND ""
    CMAKE_ARGS
      -DBUILD_SHARED_LIBS:BOOL=ON
#      -Dgtest_force_shared_crt:BOOL=ON
)

# Create a libgtest target to be used as a dependency by test programs
add_library(libgtest IMPORTED SHARED GLOBAL)
add_dependencies(libgtest gtest)
add_library(libgtest_main IMPORTED SHARED GLOBAL)
add_dependencies(libgtest_main gtest)

# Set gtest properties
ExternalProject_Get_Property(gtest source_dir binary_dir)
set_target_properties(libgtest PROPERTIES
    "IMPORTED_LOCATION" "${binary_dir}/${CMAKE_SHARED_LIBRARY_PREFIX}gtest${CMAKE_SHARED_LIBRARY_SUFFIX}"
    "IMPORTED_LINK_INTERFACE_LIBRARIES" "${CMAKE_THREAD_LIBS_INIT}"
#    "INTERFACE_INCLUDE_DIRECTORIES" "${source_dir}/include"
)
set_target_properties(libgtest_main PROPERTIES
    "IMPORTED_LOCATION" "${binary_dir}/${CMAKE_SHARED_LIBRARY_PREFIX}gtest_main${CMAKE_SHARED_LIBRARY_SUFFIX}"
    "IMPORTED_LINK_INTERFACE_LIBRARIES" "${CMAKE_THREAD_LIBS_INIT}"
#    "INTERFACE_INCLUDE_DIRECTORIES" "${source_dir}/include"
)

# I couldn't make it work with INTERFACE_INCLUDE_DIRECTORIES
include_directories("${source_dir}/include")
