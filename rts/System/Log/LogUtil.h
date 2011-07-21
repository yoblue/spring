/* This file is part of the Spring engine (GPL v2 or later), see LICENSE.html */

#ifndef _LOG_UTIL_H
#define _LOG_UTIL_H

#ifdef __cplusplus
extern "C" {
#endif

const char* log_util_levelToString(int level);

char log_util_levelToChar(int level);

/**
 * Ensure we have a non-NULL section.
 */
const char* log_util_prepareSection(const char* section);

#ifdef __cplusplus
} // extern "C"
#endif

#endif // _LOG_UTIL_H

