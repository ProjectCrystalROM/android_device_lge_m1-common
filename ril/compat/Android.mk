# Based on the Apache-2.0 H631 liblge build rule; see README.md for provenance.
LOCAL_PATH := $(call my-dir)

# Only the experimental cm_m1_radio board profile enables this module.
# cm_m1 leaves it unselected. Native and runtime qualification remain pending.
ifeq ($(TARGET_DEVICE),m1)
ifeq ($(TARGET_ARCH),arm)
ifeq ($(M1_BUILD_RADIO_COMPAT),true)

include $(CLEAR_VARS)
LOCAL_MODULE := libm1_ril_compat
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := parcel_compat.cpp
LOCAL_CPPFLAGS := -std=gnu++11 -Wall -Wextra -Werror
LOCAL_SHARED_LIBRARIES := libbinder libutils
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := m1_ril_compat_test
LOCAL_MODULE_TAGS := tests
LOCAL_SRC_FILES := parcel_compat_test.cpp
LOCAL_CPPFLAGS := -std=gnu++11 -Wall -Wextra -Werror
LOCAL_SHARED_LIBRARIES := libm1_ril_compat libbinder libutils
include $(BUILD_NATIVE_TEST)

endif
endif
endif
