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

#include "parcel_compat.h"

// The two compatibility names were identified in the H631 liblge shim. These
// wrappers preserve the object, buffers, lengths, output and status explicitly.
// This module intentionally supplies no socket-registration or ACK stubs.
static_assert(sizeof(void*) == 4 && sizeof(size_t) == 4,
              "The proprietary m1 radio interface is ARM32");
static_assert(sizeof(uint16_t) == sizeof(char16_t), "UTF-16 units must match");

extern "C" android::status_t m1_ril_write_string16(
        android::Parcel* self, const uint16_t* text, size_t length) {
    return self->writeString16(reinterpret_cast<const char16_t*>(text), length);
}

extern "C" android::status_t m1_ril_read_uint64(
        const android::Parcel* self, uint64_t* value) {
    return self->readUint64(value);
}
