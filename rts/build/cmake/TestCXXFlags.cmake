# This file is part of the Spring engine (GPL v2 or later), see LICENSE.html

# - Test whether the C++ compiler supports certain flags.
# Once done, this will define the following vars.
# They will be empty if the flag is not supported,
# or contain the flag if it is supported.
#
# VISIBILITY_HIDDEN            -fvisibility=hidden
# VISIBILITY_INLINES_HIDDEN    -fvisibility-inlines-hidden
# SSE_FLAGS                    -msse -mfpmath=sse
# IEEE_FP_FLAG                 -fvisibility-inlines-hidden
# LTO_FLAGS                    -flto -fwhopr
#
# Note: gcc for windows supports these flags, but gives lots of errors when
#       compiling, so use them only for linux builds.

Include(TestCXXAcceptsFlag)


If    (NOT DEFINED VISIBILITY_HIDDEN)
	Set(VISIBILITY_HIDDEN "")
	If    (NOT MINGW AND NOT APPLE)
		CHECK_CXX_ACCEPTS_FLAG(-fvisibility=hidden HAS_VISIBILITY_HIDDEN)
		If    (HAS_VISIBILITY_HIDDEN)
			Set(VISIBILITY_HIDDEN "-fvisibility=hidden")
		EndIf (HAS_VISIBILITY_HIDDEN)
	EndIf (NOT MINGW AND NOT APPLE)
EndIf (NOT DEFINED VISIBILITY_HIDDEN)


If    (NOT DEFINED VISIBILITY_INLINES_HIDDEN)
	Set(VISIBILITY_INLINES_HIDDEN "")
	If    (NOT MINGW)
		CHECK_CXX_ACCEPTS_FLAG(-fvisibility-inlines-hidden HAS_VISIBILITY_INLINES_HIDDEN)
		If    (HAS_VISIBILITY_INLINES_HIDDEN)
			Set(VISIBILITY_INLINES_HIDDEN "-fvisibility-inlines-hidden")
		EndIf (HAS_VISIBILITY_INLINES_HIDDEN)
	EndIf (NOT MINGW)
EndIf (NOT DEFINED VISIBILITY_INLINES_HIDDEN)


If    (NOT DEFINED SSE_FLAGS)
	CHECK_CXX_ACCEPTS_FLAG("-msse -mfpmath=sse" HAS_SSE_FLAGS)
	If    (HAS_SSE_FLAGS)
		Set(SSE_FLAGS "-msse -mfpmath=sse")
	Else  (HAS_SSE_FLAGS)
		Set(SSE_FLAGS "-DDEDICATED_NOSSE")
		Message(WARNING "SSE1 support is missing, online play is highly discouraged with this build")
	EndIf (HAS_SSE_FLAGS)
EndIf (NOT DEFINED SSE_FLAGS)


If    (NOT DEFINED IEEE_FP_FLAG)
	CHECK_CXX_ACCEPTS_FLAG("-mieee-fp" HAS_IEEE_FP_FLAG)
	If    (HAS_IEEE_FP_FLAG)
		Set(IEEE_FP_FLAG "-mieee-fp")
	Else  (HAS_IEEE_FP_FLAG)
		Message(WARNING "IEEE-FP support is missing, online play is highly discouraged with this build")
		Set(IEEE_FP_FLAG "")
	EndIf (HAS_IEEE_FP_FLAG)
EndIf (NOT DEFINED IEEE_FP_FLAG)


If    (NOT DEFINED LTO_FLAGS)
	Set(LTO_FLAGS "")

	Set(LTO       FALSE CACHE BOOL "Link Time Optimizations (LTO)")
	If    (LTO)
		CHECK_CXX_ACCEPTS_FLAG("-flto" HAS_LTO_FLAG)
		If    (HAS_LTO_FLAG)
			Set(LTO_FLAGS "${LTO_FLAGS} -flto")
		Else  (HAS_LTO_FLAG)
			Set(LTO_FLAGS "${LTO_FLAGS} -flto")
		EndIf (HAS_LTO_FLAG)
	EndIf (LTO)

	Set(LTO_WHOPR FALSE CACHE BOOL "Link Time Optimizations (LTO) - Whole program optimizer (WHOPR)")
	If    (LTO_WHOPR)
		CHECK_CXX_ACCEPTS_FLAG("-fwhopr" HAS_LTO_WHOPR_FLAG)
		If    (HAS_LTO_WHOPR_FLAG)
			Set(LTO_FLAGS "${LTO_FLAGS} -fwhopr")
		EndIf (HAS_LTO_WHOPR_FLAG)
	EndIf (LTO_WHOPR)
	
	If (LTO AND LTO_WHOPR)
		Message( FATAL_ERROR "LTO and LTO_WHOPR are mutually exclusive, please enable only one at a time." )
	EndIf (LTO AND LTO_WHOPR)
EndIf (NOT DEFINED LTO_FLAGS)


IF    (NOT DEFINED MARCH)
	Set(MARCH "")

	# 32bit
	CHECK_CXX_ACCEPTS_FLAG("-march=i686" HAS_I686_FLAG_)
	IF    (HAS_I686_FLAG_)
		Set(MARCH "i686")
	EndIf (HAS_I686_FLAG_)

	# 64bit
	if    ((CMAKE_SIZEOF_VOID_P EQUAL 8) AND (NOT MARCH))
		# march=amd64 supports the whole 64bit family (including Intels!)
		# it's similar to the i686 flag and should sync between 32bit & 64bit (other 64bit march's enable SSE3 etc. and won't sync!)
		CHECK_CXX_ACCEPTS_FLAG("-march=amd64" HAS_AMD64_FLAG_)
		IF    (HAS_AMD64_FLAG_)
			Set(MARCH "amd64")
		EndIf (HAS_I686_FLAG_)
	endif ((CMAKE_SIZEOF_VOID_P EQUAL 8) AND (NOT MARCH))

	# no compatible arch found
	if    (NOT MARCH)
		Message(WARNING "Neither i686 nor amd64 are accepted by the compiler! (`march=native` _may_ cause sync errors!)")
	endif (NOT MARCH)
EndIf (NOT DEFINED MARCH)
