// Validate the real source-built library without creating a socket or device.
#include <gtest/gtest.h>
#include <stdint.h>
#include <string.h>
#include <sys/socket.h>
#include <linux/netlink.h>
#include <linux/rmnet_data.h>
extern "C" {
#include "librmnetctl.h"
#include "librmnetctl_hndl.h"
}

static rmnetctl_hndl_t handle() {
    rmnetctl_hndl_t value;
    memset(&value, 0, sizeof(value));
    value.netlink_fd = -1;
    value.transaction_id = 123;
    return value;
}

TEST(RmnetUapi, RejectsUnsupportedEgressBitsBeforeTransaction) {
    const uint32_t supported = RMNET_EGRESS_FORMAT__RESERVED__ |
        RMNET_EGRESS_FORMAT_MAP | RMNET_EGRESS_FORMAT_AGGREGATION |
        RMNET_EGRESS_FORMAT_MUXING;
    for (unsigned bit = 0; bit < 32; ++bit) {
        const uint32_t flag = uint32_t(1) << bit;
        if (flag & supported) continue;
        rmnetctl_hndl_t value = handle();
        uint16_t error = 0;
        EXPECT_EQ(RMNETCTL_INVALID_ARG, rmnet_set_link_egress_data_format(
            &value, flag | RMNET_EGRESS_FORMAT_MAP, 0, 0, "rmnet0", &error));
        EXPECT_EQ(123U, value.transaction_id);
    }
}

TEST(RmnetUapi, RejectsUnsupportedIngressBitsBeforeTransaction) {
    const uint32_t supported = RMNET_INGRESS_FIX_ETHERNET |
        RMNET_INGRESS_FORMAT_MAP | RMNET_INGRESS_FORMAT_DEAGGREGATION |
        RMNET_INGRESS_FORMAT_DEMUXING | RMNET_INGRESS_FORMAT_MAP_COMMANDS |
        RMNET_INGRESS_FORMAT_MAP_CKSUMV3;
    for (unsigned bit = 0; bit < 32; ++bit) {
        const uint32_t flag = uint32_t(1) << bit;
        if (flag & supported) continue;
        rmnetctl_hndl_t value = handle();
        uint16_t error = 0;
        EXPECT_EQ(RMNETCTL_INVALID_ARG, rmnet_set_link_ingress_data_format_tailspace(
            &value, flag | RMNET_INGRESS_FORMAT_MAP, 0, "rmnet0", &error));
        EXPECT_EQ(123U, value.transaction_id);
    }
}

TEST(RmnetUapi, SupportedFlagsReachTransportAndReturnSendErrorSafely) {
    for (unsigned iteration = 0; iteration < 16; ++iteration) {
        rmnetctl_hndl_t value = handle();
        uint16_t error = 0;
        EXPECT_EQ(RMNETCTL_LIB_ERR, rmnet_set_link_egress_data_format(
            &value, RMNET_EGRESS_FORMAT_MAP, 0, 0, "rmnet0", &error));
        EXPECT_EQ(RMNETCTL_API_ERR_MESSAGE_SEND, error);
        EXPECT_EQ(124U, value.transaction_id);
        error = 0;
        EXPECT_EQ(RMNETCTL_LIB_ERR, rmnet_set_link_ingress_data_format_tailspace(
            &value, RMNET_INGRESS_FORMAT_MAP_CKSUMV3, 0, "rmnet0", &error));
        EXPECT_EQ(RMNETCTL_API_ERR_MESSAGE_SEND, error);
        EXPECT_EQ(125U, value.transaction_id);
    }
}
