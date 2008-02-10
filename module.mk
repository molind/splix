#
#	module.mk			(C) 2007-2008, Aurélien Croc (AP²C)
#
#  Compilation file for SpliX
#
# Options: DISABLE_JBIG
# 	   DISABLE_THREADS
#          DISABLE_BLACKOPTIM

MODE			:= debug

SUBDIRS 		+= src
TARGETS			:= rastertoqpdl pstoqpdl
PRE_GENERIC_TARGETS	:= optionList


# Default options
THREADS			?= 2
CACHESIZE		?= 30
DISABLE_JBIG		?= 0
DISABLE_THREADS		?= 0
DISABLE_BLACKOPTIM	?= 0


# Flags
CXXFLAGS		+= `cups-config --cflags` -Iinclude -Wall
DEBUG_CXXFLAGS		+= -DDEBUG  -DDUMP_CACHE
OPTIMIZED_CXXFLAGS 	+= -g
OPTIMIZED_CXXFLAGS 	+= -g 
rastertoqpdl_LDFLAGS	:= `cups-config --ldflags`
rastertoqpdl_LIBS	:= `cups-config --libs` -lcupsimage
pstoqpdl_LDFLAGS	:= `cups-config --ldflags`
pstoqpdl_LIBS		:= `cups-config --libs` -lcupsimage


# Update compilation flags with defined options
ifneq ($(DISABLE_THREADS),0)
CXXFLAGS		+= -DDISABLE_THREADS
else
CXXFLAGS		+= -DTHREADS=$(THREADS) -DCACHESIZE=$(CACHESIZE)
endif
ifneq ($(DISABLE_JBIG),0)
CXXFLAGS		+= -DDISABLE_JBIG
else
rastertoqpdl_LIBS	+= -ljbig
endif
ifneq ($(DISABLE_BLACKOPTIM),0)
CXXFLAGS		+= -DDISABLE_BLACKOPTIM
endif


# Get some information
CMSBASE			:= `cups-config --datadir`/model/samsung/cms
CUPSFILTER		:= `cups-config --serverbin`/filter
ifeq ($(ARCHI),Darwin)
PSTORASTER		:= pstocupsraster
else
PSTORASTER		:= pstoraster
endif


# Specific information needed by pstoqpdl
src_pstoqpdl_cpp_FLAGS	:= -DRASTERDIR=\"$(CUPSFILTER)\"
src_pstoqpdl_cpp_FLAGS	+= -DRASTERTOQPDL=\"rastertoqpdl\"
src_pstoqpdl_cpp_FLAGS	+= -DPSTORASTER=\"$(PSTORASTER)\"
src_pstoqpdl_cpp_FLAGS	+= -DCMSBASE=\"$(CMSBASE)\"
