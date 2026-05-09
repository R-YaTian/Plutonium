cmake_minimum_required(VERSION 3.16)

# Project definition
project(pu VERSION 1.0.0 LANGUAGES C CXX)

include(GNUInstallDirs)

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
	set(CMAKE_INSTALL_PREFIX "${DKP_INSTALL_PREFIX_INIT}" CACHE PATH "" FORCE)
endif()

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

list(GET ${DKP_PREFIX_VAR} 0 PORTLIBS)

# Include directories
include_directories(
    include
    ${PORTLIBS}/include
    ${PORTLIBS}/include/freetype2
    ${PORTLIBS}/include/SDL2
    ${NX_ROOT}/include
)

# Find SDL2
find_package(PkgConfig REQUIRED)
pkg_check_modules(SDL2 REQUIRED sdl2)
pkg_check_modules(FREETYPE REQUIRED freetype2)

# Build custom SDL2_mixer before compiling main library
add_custom_target(build_sdl2_mixer ALL
	COMMAND bash ${CMAKE_CURRENT_SOURCE_DIR}/build-sdl2-mixer.sh
	WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
	COMMENT "Building custom SDL2_mixer library"
)

# Source directories
set(SOURCE_DIRS
    source
    source/pu
    source/pu/audio
    source/pu/ttf
    source/pu/sdl2
    source/pu/ui
    source/pu/ui/elm
    source/pu/ui/extras
    source/pu/ui/render
)

# Collect source files
set(SOURCES)
foreach(dir ${SOURCE_DIRS})
    file(GLOB_RECURSE dir_sources 
        "${dir}/*.c"
        "${dir}/*.cpp"
    )
    list(APPEND SOURCES ${dir_sources})
endforeach()

# Create static library
add_library(pu STATIC ${SOURCES})

# Ensure SDL2_mixer is built before compiling pu
add_dependencies(pu build_sdl2_mixer)

# Set target properties
set_target_properties(pu PROPERTIES
    OUTPUT_NAME "pu"
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/lib"
)

# SDL libraries
set(SDL_IMAGE_LIBS SDL2_image png jpeg)
set(SDL_GFX_LIBS SDL2_gfx)
set(SDL_MIXER_LIBS SDL2_mixer)

# Link libraries
target_link_libraries(pu PUBLIC
    ${SDL_IMAGE_LIBS}
    ${SDL_GFX_LIBS}
    ${SDL_MIXER_LIBS}
    EGL
    GLESv2
    glapi
    ${SDL2_LIBRARIES}
    ${FREETYPE_LIBRARIES}
)

# Create output directory
file(MAKE_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/lib")

# Merge libraries using ar script
add_custom_command(
	TARGET pu POST_BUILD
	COMMAND ar -M < ${CMAKE_CURRENT_SOURCE_DIR}/merge.mri
	WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)

# Install the library
install(
	TARGETS pu
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

# Install headers
install(DIRECTORY include/pu
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
