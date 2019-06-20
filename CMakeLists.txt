cmake_minimum_required(VERSION 3.0)

project(XFeatures)
include(ExternalProject)
include(FetchContent)

#TODO: Convert to individual logic based on saving which revision we explicetely checked out, so as to only skip trying to update when it'd be useless. Also try to make it look at the actual info inside, so that we don't change the timestamps of the source files we check out from git if we stay at the same commit hash. This enables updates that automatically track upstream if we specify a branch isntead of a tag, while still skipping needless recompilation. Normaly we'd have to choose between thoe two, i.e., either check for upstream updates upon re-running cmake, or skip recompilation of dependants when there were no new commits. Maybe we can even get it to partially skip recompilation based on the external project's own makefile infrastructure (fetching from git/checking out, and telling cmake to keep it's cache when no cmake files changed or such (otherwise propagating cmake changes that'd require deleting cmake's cache would be ugly and unlikely to be supported by upstream, as it'd likely require addition of a stub file that gets updated/changed whenever such breaking changes occur)
set(FETCHCONTENT_UPDATES_DISCONNECTED ON)

set(CMAKE_CXX_FLAGS "-std=c++11")

# Set path for cmake finder
set(CMAKE_MODULE_PATH  ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR}/cmake)

#set(GLOG_LIBRARY glog)
if (FALSE)
#################
## find eigen3 ##
#################
add_definitions(-DEIGEN_DONT_ALIGN)
message("-- Check for Eigen3")
find_package(Eigen3 REQUIRED)
if (${EIGEN3_FOUND})
    message(STATUS "Eigen found in " ${EIGEN3_INCLUDE_DIR})
    include_directories(${EIGEN3_INCLUDE_DIR})
else()
    message(FATAL_ERROR "Eigen not found!")
endif()

################
## find Ceres ##
################
message("-- Check for Ceres-Solver")
find_package(Ceres REQUIRED)
if (${CERES_FOUND})
    message(STATUS "Ceres found in " ${CERES_INCLUDE_DIRS})
    include_directories(${CERES_INCLUDE_DIRS})
else()
    message(FATAL_ERROR "Ceres not found")
endif()
endif()
###############
## find glog ##
###############
message("-- Check for Google Log")
find_package(Glog REQUIRED)
if (GLOG_FOUND)
  message("-- Found Google Logging: ${GLOG_INCLUDE_DIRS}")
else (GLOG_FOUND)
  message(FATAL_ERROR "Can't find Google Logging. Please set GLOG_INCLUDE_DIR & "
    "GLOG_LIBRARY")
endif (GLOG_FOUND)

################
## find gflag ##
################
message("-- Check for gflags")
find_package(gflags REQUIRED)
if (GFLAGS_FOUND)
    message("-- Found GFlags: ${GFLAGS_INCLUDE_DIRS}")
else (GFLAGS_FOUND)
    message(FATAL ERROR "Can't find GFlags. Please set GFLAGS_INCLUDE_DIR & GFLAGS_LIBRARY")
endif (GFLAGS_FOUND)

# Suitesparse
find_package(SuiteSparse REQUIRED)
if (SUITESPARSE_FOUND)
  # On Ubuntu the system install of SuiteSparse (v3.4.0) up to at least
  # Ubuntu 13.10 cannot be used to link shared libraries.
  if (BUILD_SHARED_LIBS AND
      SUITESPARSE_IS_BROKEN_SHARED_LINKING_UBUNTU_SYSTEM_VERSION)
    message(FATAL_ERROR "You are attempting to build Theia as a shared "
      "library on Ubuntu using a system package install of SuiteSparse "
      "3.4.0. This package is broken and does not support the "
      "construction of shared libraries (you can still build Theia as "
      "a static library).  If you wish to build a shared version of Theia "
      "you should uninstall the system install of SuiteSparse "
      "(libsuitesparse-dev) and perform a source install of SuiteSparse "
      "(we recommend that you use the latest version), "
      "see http://theia-solver.org/building.html for more information.")
  endif (BUILD_SHARED_LIBS AND
    SUITESPARSE_IS_BROKEN_SHARED_LINKING_UBUNTU_SYSTEM_VERSION)
  message("-- Found SuiteSparse ${SUITESPARSE_VERSION}")
  add_definitions(-DTHEIA_SUITESPARSE_VERSION="${SUITESPARSE_VERSION}")
else (SUITESPARSE_FOUND)
  # Disable use of SuiteSparse if it cannot be found and continue.
  message(FATAL_ERROR "Can't find SuiteSparse. This library is required "
    "for bundle adjustment and for solving convex optimization problems. "
    "Please set SUITESPARSE_INCLUDE_DIR & SUITESPARSE_LIBRARY")
endif (SUITESPARSE_FOUND)

##################################################
## fix bugs when using OpenMVG as 3rd-party lib ##
##################################################
find_package(OpenMP REQUIRED)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
##################
## find openMVG ##
##################
message("--Check for openMVG")
# find_package(OpenMVG REQUIRED)
# if (${OPENMVG_FOUND})
    # message("-- Found OpenMVG: ${OPENMVG_INCLUDE_DIRS}")
    # include_directories(${OPENMVG_INCLUDE_DIRS})
    # add_definitions(-DUSE_OPENMVG)
# else ()
    # message(FATAL_ERROR "Can't find OpenMVG! Please set OPENMVG_INCLUDE_DIRS & OPENMVG_LIBRARIES")
# endif()

if(FALSE)
set(OPENMVG_LIBS_DIR ${CMAKE_BINARY_DIR}/ext/openMVG/Linux-x86_64-Release)
set(OPENMVG_INCLUDE_DIRS ${PROJECT_SOURCE_DIR}/ext/openMVG)
set(OPENMVG_LIBRARIES # domset
                    #   lib_clp
                    #   lib_CoinUtils
                    #   lib_Osi
                    #   lib_OsiClpSolver
                      openMVG_easyexif
                      openMVG_exif
                      openMVG_fast
                      openMVG_features
                      openMVG_geometry
                      openMVG_image
                      openMVG_kvld
                      openMVG_lemon
                      openMVG_linearProgramming
                      openMVG_lInftyComputerVision
                      openMVG_matching_image_collection
                      openMVG_matching
                      openMVG_multiview
                      openMVG_multiview_test_data
                      openMVG_numeric
                      openMVG_robust_estimation
                      openMVG_sfm
                      openMVG_stlplusCeres
                      openMVG_system
                      vlsift
                    $(Ceres_LIBRARIES))
endif()

########################
## Unit Test Enabling ##
########################
set(ENABLE_TESTING TRUE)

if(${ENABLE_TESTING})
    enable_testing()
endif(${ENABLE_TESTING})


# Add include directories
include_directories(${PROJECT_SOURCE_DIR}/src
                    ${PROJECT_SOURCE_DIR}/ext
                    ${PROJECT_SOURCE_DIR}/ext/graclus/metisLib
                    ${PROJECT_SOURCE_DIR}/ext/graclus/multilevelLib
                    ${PROJECT_SOURCE_DIR}/ext/graclus/graclus
                    ${PROJECT_SOURCE_DIR}/ext/yaml-cpp/include
                    ${PROJECT_SOURCE_DIR}/ext/eigen3
                    ${PROJECT_SOURCE_DIR}/ext/ceres-solver/include
                    ${GLOG_INCLUDE_DIRS}
                    ${GLFGS_INCLUDE_DIRS}
                    ${SUITESPARSE_INCLUDE_DIRS})


include(${PROJECT_SOURCE_DIR}/cmake/UseGTest.cmake)

# Add subdirectories
add_subdirectory(${PROJECT_SOURCE_DIR}/ext)
include(${PROJECT_SOURCE_DIR}/cmake/SetOpenMVG_Libraries.cmake)
add_subdirectory(${PROJECT_SOURCE_DIR}/src)
add_subdirectory(${PROJECT_SOURCE_DIR}/app)
# add_subdirectory(${PROJECT_SOURCE_DIR}/example)
