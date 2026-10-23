/* Copyright (C) 2015 The CyanogenMod Project
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy at http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software is
 * distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND.
 * See the License for the specific language governing permissions and limitations.
 */

#include "parcel_compat.h"
#include <gtest/gtest.h>
#include <cstdlib>
#include <cstring>

using android::NO_ERROR;
using android::Parcel;

// CM13 Parcel destruction unconditionally initializes ProcessState and requires
// /dev/binder. An explicit serialization-only runner can retain these few test
// objects until process exit; default Android runs still exercise destruction.
// No Binder provider, library behavior or bridge implementation is replaced.
class ParcelForTest {
public:
    ParcelForTest() : parcel_(new Parcel()) {}
    ~ParcelForTest() {
        const char* mode = std::getenv("M1_PARCEL_TEST_SERIALIZATION_ONLY");
        if (mode == nullptr || std::strcmp(mode, "1") != 0) {
            delete parcel_;
        }
    }
    Parcel& get() { return *parcel_; }
private:
    ParcelForTest(const ParcelForTest&) = delete;
    ParcelForTest& operator=(const ParcelForTest&) = delete;
    Parcel* parcel_;
};

TEST(M1RilParcelCompat, PreservesUtf16LengthEmbeddedNullAndObject) {
    const uint16_t text[] = {0x0041, 0x0000, 0x03a9, 0xd83d, 0xde00};
    ParcelForTest parcel_owner;
    Parcel& parcel = parcel_owner.get();
    ParcelForTest untouched_owner;
    Parcel& untouched = untouched_owner.get();
    ASSERT_EQ(NO_ERROR, untouched.writeInt32(123));
    ASSERT_EQ(NO_ERROR, m1_ril_write_string16(&parcel, text, 5));
    parcel.setDataPosition(0);
    size_t length = 0;
    const char16_t* decoded = parcel.readString16Inplace(&length);
    ASSERT_NE(nullptr, decoded);
    ASSERT_EQ(5u, length);
    for (size_t i = 0; i < length; ++i) {
        EXPECT_EQ(text[i], static_cast<uint16_t>(decoded[i]));
    }
    untouched.setDataPosition(0);
    EXPECT_EQ(123, untouched.readInt32());
}

TEST(M1RilParcelCompat, PreservesNullStringMarker) {
    ParcelForTest parcel_owner;
    Parcel& parcel = parcel_owner.get();
    ASSERT_EQ(NO_ERROR, m1_ril_write_string16(&parcel, nullptr, 0));
    parcel.setDataPosition(0);
    EXPECT_EQ(-1, parcel.readInt32());
}

TEST(M1RilParcelCompat, PreservesFullUint64OutputAndPosition) {
    ParcelForTest parcel_owner;
    Parcel& parcel = parcel_owner.get();
    const uint64_t first = UINT64_C(0xfedcba9876543210);
    const uint64_t second = UINT64_C(0x0123456789abcdef);
    ASSERT_EQ(NO_ERROR, parcel.writeUint64(first));
    ASSERT_EQ(NO_ERROR, parcel.writeUint64(second));
    parcel.setDataPosition(0);
    uint64_t value = 0;
    ASSERT_EQ(NO_ERROR, m1_ril_read_uint64(&parcel, &value));
    EXPECT_EQ(first, value);
    ASSERT_EQ(NO_ERROR, m1_ril_read_uint64(&parcel, &value));
    EXPECT_EQ(second, value);
    EXPECT_EQ(parcel.dataSize(), parcel.dataPosition());
}

TEST(M1RilParcelCompat, PropagatesReadFailure) {
    ParcelForTest direct_owner;
    Parcel& direct = direct_owner.get();
    ParcelForTest bridged_owner;
    Parcel& bridged = bridged_owner.get();
    uint64_t expected = 7;
    uint64_t actual = 7;
    const android::status_t status = direct.readUint64(&expected);
    ASSERT_NE(NO_ERROR, status);
    EXPECT_EQ(status, m1_ril_read_uint64(&bridged, &actual));
    EXPECT_EQ(expected, actual);
    EXPECT_EQ(direct.dataPosition(), bridged.dataPosition());
}
