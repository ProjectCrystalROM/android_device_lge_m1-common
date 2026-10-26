LOCAL_PATH := $(call my-dir)
ifeq ($(TARGET_DEVICE),m1)
include $(CLEAR_VARS)
LOCAL_MODULE := k7_microg_libc_test
LOCAL_MODULE_TAGS := tests
LOCAL_MODULE_PATH := $(TARGET_OUT_DATA)/nativetest/k7_microg_libc_test
LOCAL_SRC_FILES := microg_libc_test.cpp
LOCAL_CFLAGS := -Wall -Wextra -Werror
LOCAL_SHARED_LIBRARIES := libdl
include $(BUILD_EXECUTABLE)
endif
