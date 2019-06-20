#add_library(glog)
externalproject_add(Eigen3
    PREFIX          Eigen3
    URL             https://bitbucket.org/eigen/eigen/get/3.3.2.tar.gz
    URL_MD5         36b5731ab7d7e0c10843ac93bd9fd270
    SOURCE_DIR      ${CMAKE_SOURCE_DIR}/ext/eigen3
    CONFIGURE_COMMAND ""
    BUILD_COMMAND   ""
    INSTALL_COMMAND ""
)
add_subdirectory(eigen3)
set(EIGEN_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/ext/eigen3)
set(EIGEN_INCLUDE_DIRS ${EIGEN_INCLUDE_DIR})
set(BUILD_TESTING OFF)
set(BUILD_EXAMPLES OFF)
set(EXPORT_BUILD_DIR ON)
#set ( -DEIGEN_INCLUDE_DIR=${EIGEN_INCLUDE_DIR}
#externalproject_add(Ceres
FetchContent_Declare(Ceres
    #PREFIX          Ceres
    GIT_REPOSITORY  https://github.com/ceres-solver/ceres-solver.git
    GIT_TAG         1.14.x
    #UPDATE_COMMAND  ""
    SOURCE_DIR      ${CMAKE_SOURCE_DIR}/ext/ceres-solver
  #  CMAKE_ARGS      -DBUILD_TESTING=OFF -DBUILD_EXAMPLES=OFF -DEIGEN_INCLUDE_DIR=${EIGEN_INCLUDE_DIR}
#    INSTALL_COMMAND ""
  #  DEPENDS         Eigen3
)
FetchContent_MakeAvailable(Ceres)
add_subdirectory(easyexif)
# add_subdirectory(glog)
# add_subdirectory(googletest)
add_subdirectory(graclus)
add_subdirectory(libvot)
add_subdirectory(openMVG)
add_subdirectory(stlplus3)
add_subdirectory(vlfeat)
add_subdirectory(yaml-cpp)
