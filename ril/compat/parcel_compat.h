/*
 * Copyright (C) 2015 The CyanogenMod Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef M1_RIL_PARCEL_COMPAT_H
#define M1_RIL_PARCEL_COMPAT_H

#include <binder/Parcel.h>
#include <stddef.h>
#include <stdint.h>

// C entry points use the old ARM32 mangled names, with every method argument
// declared explicitly, including the implicit C++ object pointer.
extern "C" android::status_t m1_ril_write_string16(
        android::Parcel* self, const uint16_t* text, size_t length)
        __asm__("_ZN7android6Parcel13writeString16EPKtj");
extern "C" android::status_t m1_ril_read_uint64(
        const android::Parcel* self, uint64_t* value)
        __asm__("_ZNK7android6Parcel10readuInt64EPy");

#endif
