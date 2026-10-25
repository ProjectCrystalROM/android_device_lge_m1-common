/* K7 stock GPS adapter for the CM13 XTRA callback ABI. */
#include <hardware/gps.h>
#include <dlfcn.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <log/log.h>

static void *stock_handle;
static struct gps_device_t *stock_device;
static const GpsInterface *stock_interface;
static GpsInterface interface;
static const GpsXtraInterface *stock_xtra;
static GpsXtraInterface xtra;
/* LG's loc_eng_xtra_init reads a third pointer beyond CM13's two callbacks.
 * Keep the expanded object alive and make its optional server callback NULL.
 * Otherwise the adjacent framework AGPS callback is called with a URL string.
 */
static struct {
    gps_xtra_download_request download_request_cb;
    gps_create_thread create_thread_cb;
    void (*report_xtra_server_cb)(const char *, const char *, const char *);
} xtra_callbacks;

static int xtra_init(GpsXtraCallbacks *callbacks) {
    if (!callbacks) return -EINVAL;
    xtra_callbacks.download_request_cb = callbacks->download_request_cb;
    xtra_callbacks.create_thread_cb = callbacks->create_thread_cb;
    xtra_callbacks.report_xtra_server_cb = NULL;
    ALOGI("K7 GPS: adapting two CM13 XTRA callbacks to LG's three-pointer ABI");
    return stock_xtra->init((GpsXtraCallbacks *)&xtra_callbacks);
}

static const void *get_extension(const char *name) {
    const void *extension = stock_interface->get_extension(name);
    if (extension && !strcmp(name, GPS_XTRA_INTERFACE)) {
        stock_xtra = extension;
        if (stock_xtra->size < sizeof(xtra) || !stock_xtra->init) return NULL;
        xtra = *stock_xtra;
        xtra.init = xtra_init;
        return &xtra;
    }
    return extension;
}

static const GpsInterface *get_interface(struct gps_device_t *device) {
    (void)device;
    return &interface;
}

static int close_device(struct hw_device_t *device) {
    free(device);
    /* Stock pointers and callback objects remain valid for process lifetime. */
    return 0;
}

static int open_device(const struct hw_module_t *module, const char *name,
                       struct hw_device_t **device) {
    if (!stock_interface) {
        stock_handle = dlopen("/system/lib/hw/gps.k7-stock.so", RTLD_NOW | RTLD_LOCAL);
        if (!stock_handle) { ALOGE("K7 GPS: %s", dlerror()); return -ENODEV; }
        const struct hw_module_t *stock_module = dlsym(stock_handle, HAL_MODULE_INFO_SYM_AS_STR);
        if (!stock_module || !stock_module->methods || !stock_module->methods->open) return -ENODEV;
        int result = stock_module->methods->open(stock_module, name, (struct hw_device_t **)&stock_device);
        if (result) return result;
        if (!stock_device || !stock_device->get_gps_interface) return -ENODEV;
        const GpsInterface *original = stock_device->get_gps_interface(stock_device);
        if (!original || original->size < sizeof(interface) || !original->get_extension) return -ENODEV;
        interface = *original;
        stock_interface = original;
        interface.get_extension = get_extension;
    }
    struct gps_device_t *wrapper = calloc(1, sizeof(*wrapper));
    if (!wrapper) return -ENOMEM;
    wrapper->common.tag = HARDWARE_DEVICE_TAG;
    wrapper->common.module = (struct hw_module_t *)module;
    wrapper->common.close = close_device;
    wrapper->get_gps_interface = get_interface;
    *device = &wrapper->common;
    return 0;
}
static struct hw_module_methods_t methods = { .open = open_device };
struct hw_module_t HAL_MODULE_INFO_SYM = {
    .tag = HARDWARE_MODULE_TAG,
    .module_api_version = 1,
    .id = GPS_HARDWARE_MODULE_ID,
    .name = "K7 stock GPS with CM13 XTRA callback adapter",
    .author = "LG / K7 bring-up",
    .methods = &methods,
};
