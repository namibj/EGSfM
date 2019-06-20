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
                      #openMVG_stlplusCeres
                      openMVG_system
                      vlsift
                  #  $(Ceres_LIBRARIES)
                      ceres
                  )
include_directories(${OPENMVG_INCLUDE_DIRS})
