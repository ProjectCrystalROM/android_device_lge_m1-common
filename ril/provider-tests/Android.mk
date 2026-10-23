LOCAL_PATH := $(call my-dir)
ifeq ($(TARGET_DEVICE),m1)
ifeq ($(TARGET_ARCH),arm)
ifeq ($(M1_BUILD_RADIO_COMPAT),true)
include $(CLEAR_VARS)
LOCAL_MODULE := m1_rmnet_uapi_test
LOCAL_MODULE_TAGS := tests
LOCAL_SRC_FILES := rmnet_uapi_test.cpp
LOCAL_CPPFLAGS := -std=gnu++11 -Wall -Wextra -Werror
LOCAL_C_INCLUDES := vendor/qcom/opensource/dataservices/rmnetctl/inc $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
LOCAL_ADDITIONAL_DEPENDENCIES := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr
LOCAL_SHARED_LIBRARIES := librmnetctl
include $(BUILD_NATIVE_TEST)
endif
endif
endif
