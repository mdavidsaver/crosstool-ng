do_cexp_get() { :; }
do_cexp_extract() { :; }
do_cexp_for_build() { :; }
do_cexp_for_host() { :; }
do_cexp_for_target() { :; }

if [ "${CT_CEXP}" = "y" ]; then

do_cexp_get() {
    CT_GetGit cexp "${CT_CEXP_VERSION}" \
      https://github.com/epicsdeb/rtems-cexp.git
}

do_cexp_extract() {
    CT_Extract cexp-"${CT_CEXP_VERSION}"
    cp ${CT_TOP_DIR}/scripts/config.sub   "${CT_SRC_DIR}/cexp-${CT_CEXP_VERSION}/"
    cp ${CT_TOP_DIR}/scripts/config.guess "${CT_SRC_DIR}/cexp-${CT_CEXP_VERSION}/"
}

do_cexp_for_target() {

    CT_DoStep INFO "Installing CEXP lib for target"

    CT_mkdir_pushd "${CT_BUILD_DIR}/build-cexp-target-${CT_TARGET}"

    CT_DoLog EXTRA "Configuring CEXP"
    CT_DoExecLog CFG                                                    \
    "${CT_SRC_DIR}/cexp-${CT_CEXP_VERSION}/configure"                   \
        --target=${CT_TARGET}                                           \
        --host=${CT_TARGET}                                             \
        --build=${CT_BUILD}                                             \
        --with-rtems-top="${CT_PREFIX_DIR}"                             \
        --with-hostbindir="${CT_PREFIX_DIR}/bin"                        \
        --enable-rtemsbsp="${CT_RTEMS_BSPS}"                            \
        --enable-std-rtems-installdirs                                  \
        --disable-pmelf64                                               \
        --enable-cexp                                                   \
        --with-man-pages=no

    # FTBFS when elf64 enabled with 2.0b, but would probably be easy to fix

    CT_DoLog EXTRA "Building CEXP"
    CT_DoExecLog ALL ${make} ${JOBSFLAGS}
    CT_DoLog EXTRA "Installing CEXP"
    CT_DoExecLog ALL ${make} install

    CT_Popd
    CT_EndStep
}

fi # "${CT_CEXP}" = "y"
