#include <stdlib.h>

#include <android-base/file.h>
#include <android-base/logging.h>
#include <android-base/properties.h>
#include <android-base/strings.h>

#include "vendor_init.h"

#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>

using android::base::GetProperty;
using android::base::ReadFileToString;
using android::base::Trim;

#define MODEL_NAME_LEN 5
#define SERIAL_NUMBER_FILE "/efs/FactoryApp/serial_no"

// copied from build/tools/releasetools/ota_from_target_files.py
// but with "." at the end and empty entry
std::vector<std::string> ro_product_props_default_source_order = {
    "",
    "product.",
    "product_services.",
    "odm.",
    "vendor.",
    "system.",
    "system_ext.",
};

void property_override(char const prop[], char const value[], bool add = true)
{
    auto pi = (prop_info *) __system_property_find(prop);

    if (pi != nullptr) {
        __system_property_update(pi, value, strlen(value));
    } else if (add) {
        __system_property_add(prop, strlen(prop), value, strlen(value));
    }
}

void vendor_load_properties()
{
    const std::string bootloader = GetProperty("ro.bootloader", "");
    const std::string model = bootloader.substr(0, MODEL_NAME_LEN);

    char const *serial_number_file = SERIAL_NUMBER_FILE;
    std::string serial_number;

    if (ReadFileToString(serial_number_file, &serial_number)) {
        serial_number = Trim(serial_number);
        property_override("ro.serialno", serial_number.c_str());
    }

    const auto set_ro_product_prop = [](const std::string &source,
            const std::string &prop, const std::string &value) {
        auto prop_name = "ro.product." + source + prop;
        property_override(prop_name.c_str(), value.c_str(), false);
    };

    if (model == "I257M") {
        /* serranoltebmc */
        for (const auto &source : ro_product_props_default_source_order) {
            set_ro_product_prop(source, "fingerprint", "samsung/serranoltebmc/serranoltebmc:4.4.2/KOT49H/I257MVLUBNE6:user/release-keys");
            set_ro_product_prop(source, "device", "serranoltebmc");
            set_ro_product_prop(source, "model", "SGH-I257M");
            set_ro_product_prop(source, "name", "serranoltebmc");
        }
        property_override("ro.build.description", "serranoltebmc-user 4.4.2 KOT49H I257MVLUBNE6 release-keys");
        property_override("ro.build.product", "serranoltebmc");
    } else if (model == "I9195") {
        /* serranoltexx */
        for (const auto &source : ro_product_props_default_source_order) {
            set_ro_product_prop(source, "fingerprint", "samsung/serranoltexx/serranolte:4.4.2/KOT49H/I9195XXUCQL2:user/release-keys");
            set_ro_product_prop(source, "device", "serranolte");
            set_ro_product_prop(source, "model", "GT-I9195");
            set_ro_product_prop(source, "name", "serranoltexx");
        }
        property_override("ro.build.description", "serranoltexx-user 4.4.2 KOT49H I9195XXUCQL2 release-keys");
        property_override("ro.build.product", "serranolte");
    } else if (model == "E370K") {
        /* serranoltektt */
        for (const auto &source : ro_product_props_default_source_order) {
            set_ro_product_prop(source, "fingerprint", "samsung/serranoltektt/serranoltektt:4.4.4/KTU84P/E370KKTU2BNK5:user/release-keys");
            set_ro_product_prop(source, "device", "serranoltektt");
            set_ro_product_prop(source, "model", "SHV-E370K");
            set_ro_product_prop(source, "name", "serranoltektt");
        }
        property_override("ro.build.description", "serranoltektt-user 4.4.4 KTU84P E370KKTU2BNK5 release-keys");
        property_override("ro.build.product", "serranoltektt");
    }

    const std::string device = GetProperty("ro.product.vendor.device", "");
    LOG(INFO) << "Found bootloader " << bootloader << ". " << "Setting build properties for " << device << ".\n";
}
