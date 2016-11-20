# This file declares functions for bare metal kernel (IE. none)
# Copyright 2016 Michael Davidsaver
# Licensed under the GPL v2. See COPYING in the root of this package

CT_DoKernelTupleValues() {
    CT_TARGET_KERNEL=${CT_RTEMS_TOOLCHAIN_NAME}
    CT_TARGET_SYS=

    # The RTEMS kernel build depends on specific ARCH names
    # when selecting compatable BSPs
    # Supported target archs for 4.10.2:
    #     arm avr bfin h8300 i386 lm32 m32c m32r m68k mips powerpc sh sparc
    # do any mapping
    case "${CT_ARCH}:${CT_ARCH_BITNESS}" in
    x86:32) CT_TARGET_ARCH=i386 ;;
    *)      CT_TARGET_ARCH="${CT_ARCH}" ;;
    esac

    # don't pass target name through config.sub
    # RTEMS toolchains with a vendor break some packages (CEXP)
    # which assume <arch>-rtems<version>
    # :(
    CT_TARGET_SKIP_CONFIG_SUB=y
    CT_TARGET_VENDOR=
}

do_kernel_get() {
    :
}

do_kernel_extract() {
    :
}

do_kernel_headers() {
    # RTEMS headers aren't needed to build gcc+newlib
    :
}
