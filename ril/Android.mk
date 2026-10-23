# The m1-common parent includes immediate child Android.mk files only.
LOCAL_PATH := $(call my-dir)
include $(call all-makefiles-under,$(LOCAL_PATH))
