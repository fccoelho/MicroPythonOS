# This file is used to build for desktop systems, like Linux and MacOS

MOD_DIR := $(USERMOD_DIR)

ifneq (,$(findstring -Wno-missing-field-initializers, $(CFLAGS_USERMOD)))
    CFLAGS_USERMOD += -Wno-missing-field-initializers
endif

# Check which system this build is being performed on
UNAME_S := $(shell uname -s)
ifneq ($(MPOS_WEB),1)
ifneq ($(UNAME_S),Darwin)
    # Non-macOS settings (e.g., Linux)
    # The fully-static link (-static) needs libv4l2.a, which most distros do
    # not ship; only build the webcam module when it is available.
    V4L2_STATIC_LIB := $(shell ls /usr/lib/x86_64-linux-gnu/libv4l2.a /usr/lib/libv4l2.a 2>/dev/null | head -n 1)
    ifneq ($(V4L2_STATIC_LIB),)
        LDFLAGS += -lv4l2
        SRC_USERMOD_C += $(MOD_DIR)/src/webcam.c
    endif
endif
endif

SRC_USERMOD_C += $(MOD_DIR)/src/quirc_decode.c
SRC_USERMOD_C += $(MOD_DIR)/quirc/lib/identify.c
SRC_USERMOD_C += $(MOD_DIR)/quirc/lib/version_db.c
SRC_USERMOD_C += $(MOD_DIR)/quirc/lib/decode.c
SRC_USERMOD_C += $(MOD_DIR)/quirc/lib/quirc.c

#SRC_USERMOD_C += $(MOD_DIR)/src/font_Noto_Sans_sat_emojis_compressed.c

ifneq ($(MPOS_WEB),1)
CFLAGS+= -I/usr/include
endif

