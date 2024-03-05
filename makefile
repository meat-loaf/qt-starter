.SUFFIXES:

include make/colors.mk

QT_VER          ?= 5

CXX             ?= g++
MOC             ?= moc-qt${QT_VER}
DEBUG           ?= 0
GDB             ?= gdb
GDB_ARGS        :=
BIN_NAME        = test

CXXFLAGS        += -std=c++17 -fPIC -Werror -Wall -Wimplicit-fallthrough=2 -Wshadow=local -Wold-style-cast
CXXFLAGS        += -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB

LDLIBS_RAW      = Qt${QT_VER}Widgets Qt${QT_VER}Gui Qt${QT_VER}Core
ILIBS_RAW       = qt${QT_VER} qt${QT_VER}/QtWidgets qt${QT_VER}/QtGui qt${QT_VER}/QtCore

NO_DEP_TGTS     = clean
DEBUG_TGTS      = debug debugbuild rundebug

BUILD_DIR_NDBG := .build
BUILD_DIR_DBG  := .debug

ifneq (0, $(words $(filter ${DEBUG_TGTS},${MAKECMDGOALS})))
	DEBUG = 1
endif

ifeq ($(DEBUG), 0)
	CXXFLAGS += -O2
	BUILD_DIR = ${BUILD_DIR_NDBG}
else
	BUILD_DIR = ${BUILD_DIR_DBG}
	CXXFLAGS += -g -Og -Wno-unused-variable
endif

ifeq (${VERBOSE}, 1)
	V=
else
	V=@
endif

INCL_DIR = include
SRC_DIR = src
DEPS_DIR = deps
B_OBJ_DIR = obj
B_SRC_DIR = ${BUILD_DIR}/${B_OBJ_DIR}
B_DEPS_DIR = ${BUILD_DIR}/${DEPS_DIR}
UTIL_DIR_RAW = util
UI_DIR_RAW = ui
UI_H_DIR = ${INCL_DIR}/${UI_DIR_RAW}

BUILD_SUBDIRS = ${UI_DIR_RAW}\
	${UTIL_DIR_RAW}

BUILDDIRS_RAW = ${SRC_DIR} $(addprefix ${SRC_DIR}/,${BUILD_SUBDIRS})

DEPDIRS = $(subst ${SRC_DIR},${DEPS_DIR},${BUILDDIRS_RAW})

ALL_BUILDDIRS_RAW = ${BUILDDIRS_RAW} ${DEPDIRS}

CXXFLAGS += -iquote ${INCL_DIR}

UI_SOURCE_BASE_RAW = ui/main_window

UI_HEADERS_RAW = $(addsuffix .h,${UI_SOURCE_BASE_RAW})
UI_SOURCES_RAW = $(addsuffix .cpp,${UI_SOURCE_BASE_RAW})

SOURCES_RAW = main.cpp \
	${UTIL_DIR_RAW}/stuff.cpp \
	${UI_SOURCES_RAW}

UI_HEADERS = $(addprefix ${INCL_DIR}/, ${UI_HEADERS_RAW})

DIRS            = $(subst ${SRC_DIR},${B_OBJ_DIR},$(addprefix ${BUILD_DIR}/,${ALL_BUILDDIRS_RAW}))
LDLIBS          = $(addprefix -l,${LDLIBS_RAW})
ILIBS           = $(addprefix -I/usr/include/, ${ILIBS_RAW})

SOURCES         = $(addprefix ${SRC_DIR}/,${SOURCES_RAW})
OBJS_CPP        = $(patsubst ${SRC_DIR}/%.cpp,${B_SRC_DIR}/%.o,${SOURCES})
DEPS            = $(addprefix ${B_DEPS_DIR}/, $(addsuffix .d,${SOURCES_RAW}))

MOC_GENS        = $(patsubst ${UI_H_DIR}/%.h,${B_SRC_DIR}/${UI_DIR_RAW}/%.moc.cpp,${UI_HEADERS})
OBJS_MOC        = $(patsubst ${B_SRC_DIR}/${UI_DIR_RAW}/%.moc.cpp,${B_SRC_DIR}/${UI_DIR_RAW}/%.moc.o,${MOC_GENS})

OBJS            = ${OBJS_CPP} ${OBJS_MOC}

.PHONY: ${BIN_NAME} clean run build debug runbuild rundebug debugbuild
.SECONDARY: ${MOC_GENS}

define do_compile =
	$(call print,Compiling:,$<,$@)
	${V}${CXX} ${CXXFLAGS} ${LDLIBS} ${ILIBS} -c $< -o $@
endef

${BIN_NAME}: ${BUILD_DIR}/${BIN_NAME}

ifeq (0, $(words $(findstring ${MAKECMDGOALS}, clean)))
-include ${DEPS}
endif

run rundebug: ${BIN_NAME}
	${V}${BUILD_DIR}/${BIN_NAME}

debugbuild: ${BIN_NAME}

debug: debugbuild
	${V}${GDB} ${GDB_ARGS} ${BUILD_DIR}/${BIN_NAME}

${BUILD_DIR}/${BIN_NAME}: ${DEPS} ${OBJS} | ${DIRS}
	$(call print,Linking:,${OBJS},$@)
	${V}${CXX} ${CXXFLAGS} ${LDLIBS} ${ILIBS} ${OBJS} -o $@

${B_DEPS_DIR}/%.cpp.d: ${SRC_DIR}/%.cpp | ${DIRS}
	$(call print,Generate dependencies:,$<,$@)
	${V}${CXX} ${CXXFLAGS} -MT $(patsubst ${SRC_DIR}/%.cpp,${B_SRC_DIR}/%.o,$<) -MM $< -MF $@

${B_SRC_DIR}/%.o: ${SRC_DIR}/%.cpp | ${DIRS}
	$(do_compile)

${B_SRC_DIR}/${UI_DIR_RAW}/%.moc.o: ${B_SRC_DIR}/${UI_DIR_RAW}/%.moc.cpp
	$(do_compile)

${B_SRC_DIR}/${UI_DIR_RAW}/%.moc.cpp: ${UI_H_DIR}/%.h
	$(call print,Generate MOC source:,$<,$@)
	${V}${MOC} $< -o $@

${DIRS}:
	${V}mkdir -p $@

clean:
	${V}rm -rf ${BUILD_DIR_DBG} ${BUILD_DIR_NDBG}
