FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install -y \
      gcc \
      g++ \
      make \
      wget \
      cmake \
      python \
      patch \
      xz-utils \
      bzip2 \
      zlib1g-dev \
      automake \
      autoconf \
      autogen \
      autopoint \
      libtool \
      pkg-config \
      bison \
      flex \
      texinfo \
      libncurses5-dev \
      libreadline6-dev \
      libltdl-dev \
      libgmp-dev \
      libunistring-dev \
      libgc-dev \
      libffi-dev

# variables needed for cross-compiler
RUN mkdir -p /src/vars && \
    echo "2.27" > /src/vars/BINUTILS_VER && \
    echo "6.3.0" > /src/vars/GCC_VER && \
    echo "6.1.1" > /src/vars/GMP_VER && \
    echo "1.0.3" > /src/vars/MPC_VER && \
    echo "3.1.4" > /src/vars/MPFR_VER && \
    echo "1.1.16" > /src/vars/MUSL_VER && \
    echo "4.4.10" > /src/vars/LINUX_VER && \
    echo "x86_64-pc-linux-musl" > /src/vars/TARGET

RUN mkdir -p /opt/gcc-tmp && \
    mkdir -p /opt/stage0/usr/bin && \
    mkdir -p /opt/stage0/usr/lib && \
    mkdir -p /opt/stage0/usr/libexec && \
    mkdir -p /opt/stage0/usr/share && \
    mkdir -p /opt/stage0/usr/sbin && \
    mkdir -p /opt/stage0/dev && \
    mkdir -p /opt/stage0/etc/ca-certificates && \
    mkdir -p /opt/stage0/proc && \
    mkdir -p /opt/stage0/sys && \
    mkdir -p /opt/stage0/tmp && \
    ln -s usr/bin /opt/stage0/bin && \
    ln -s usr/sbin /opt/stage0/sbin && \
    ln -s usr/lib /opt/stage0/lib && \
    mkdir -p /opt/stage1/usr/bin && \
    mkdir -p /opt/stage1/usr/lib && \
    mkdir -p /opt/stage1/usr/libexec && \
    mkdir -p /opt/stage1/usr/share && \
    mkdir -p /opt/stage1/usr/sbin && \
    mkdir -p /opt/stage1/dev && \
    mkdir -p /opt/stage1/etc/ca-certificates && \
    mkdir -p /opt/stage1/proc && \
    mkdir -p /opt/stage1/sys && \
    mkdir -p /opt/stage1/tmp && \
    ln -s usr/bin /opt/stage1/bin && \
    ln -s usr/sbin /opt/stage1/sbin && \
    ln -s usr/lib /opt/stage1/lib && \
    mkdir -p /opt/stage2/usr/bin && \
    mkdir -p /opt/stage2/usr/lib && \
    mkdir -p /opt/stage2/usr/libexec && \
    mkdir -p /opt/stage2/usr/share && \
    mkdir -p /opt/stage2/usr/sbin && \
    mkdir -p /opt/stage2/dev && \
    mkdir -p /opt/stage2/etc/ca-certificates && \
    mkdir -p /opt/stage2/proc && \
    mkdir -p /opt/stage2/sys && \
    mkdir -p /opt/stage2/tmp && \
    ln -s usr/bin /opt/stage2/bin && \
    ln -s usr/sbin /opt/stage2/sbin && \
    ln -s usr/lib /opt/stage2/lib && \
    mkdir -p /opt/stage3/usr/bin && \
    mkdir -p /opt/stage3/usr/lib && \
    mkdir -p /opt/stage3/usr/libexec && \
    mkdir -p /opt/stage3/usr/share && \
    mkdir -p /opt/stage3/usr/sbin && \
    mkdir -p /opt/stage3/dev && \
    mkdir -p /opt/stage3/etc/ca-certificates && \
    mkdir -p /opt/stage3/proc && \
    mkdir -p /opt/stage3/sys && \
    mkdir -p /opt/stage3/tmp && \
    ln -s usr/bin /opt/stage3/bin && \
    ln -s usr/sbin /opt/stage3/sbin && \
    ln -s usr/lib /opt/stage3/lib && \
    cd /src && \
    wget -O musl-cross-make-master.tar.gz https://github.com/richfelker/musl-cross-make/archive/master.tar.gz && \
    tar xf musl-cross-make-master.tar.gz && \
    cd musl-cross-make-master && \
    printf 'TARGET = %s\n' "$(cat /src/vars/TARGET)" > config.mak && \
    printf 'COMMON_CONFIG += --disable-nls\n' >> config.mak && \
    printf 'GCC_CONFIG += --enable-languages=c,c++\n' >> config.mak && \
    printf 'GCC_CONFIG += --disable-libquadmath --disable-decimal-float\n' >> config.mak && \
    printf 'GCC_CONFIG += --disable-multilib\n' >> config.mak && \
    printf 'BINUTILS_VER = %s\n' "$(cat /src/vars/BINUTILS_VER)" >> config.mak && \
    printf 'GCC_VER = %s\n' "$(cat /src/vars/GCC_VER)" >> config.mak && \
    printf 'MUSL_VER = %s\n' "$(cat /src/vars/MUSL_VER)" >> config.mak && \
    printf 'GMP_VER = %s\n' "$(cat /src/vars/GMP_VER)" >> config.mak && \
    printf 'MPC_VER = %s\n' "$(cat /src/vars/MPC_VER)" >> config.mak && \
    printf 'MPFR_VER = %s\n' "$(cat /src/vars/MPFR_VER)" >> config.mak && \
    printf 'LINUX_VER = %s\n' "$(cat /src/vars/LINUX_VER)" >> config.mak && \
    make binutils-$(cat /src/vars/BINUTILS_VER) >/dev/null 2>&1  && \
    make musl-$(cat /src/vars/MUSL_VER) >/dev/null 2>&1  && \
    make gmp-$(cat /src/vars/GMP_VER) >/dev/null 2>&1  && \
    make mpc-$(cat /src/vars/MPC_VER) >/dev/null 2>&1  && \
    make mpfr-$(cat /src/vars/MPFR_VER) >/dev/null 2>&1  && \
    make linux-$(cat /src/vars/LINUX_VER) >/dev/null 2>&1  && \
    make gcc-$(cat /src/vars/GCC_VER) >/dev/null 2>&1  && \
    make && \
    make OUTPUT=/opt/gcc-tmp install && \
    make clean && \
    cd /src && \
    tar xf musl-cross-make-master/sources/binutils-$(cat /src/vars/BINUTILS_VER).tar.bz2  && \
    tar xf musl-cross-make-master/sources/gcc-$(cat /src/vars/GCC_VER).tar.bz2  && \
    tar xf musl-cross-make-master/sources/gmp-$(cat /src/vars/GMP_VER).tar.bz2 && \
    tar xf musl-cross-make-master/sources/mpc-$(cat /src/vars/MPC_VER).tar.gz && \
    tar xf musl-cross-make-master/sources/mpfr-$(cat /src/vars/MPFR_VER).tar.bz2 && \
    tar xf musl-cross-make-master/sources/musl-$(cat /src/vars/MUSL_VER).tar.gz && \
    tar xf musl-cross-make-master/sources/linux-$(cat /src/vars/LINUX_VER).tar.xz && \
    mv binutils-$(cat /src/vars/BINUTILS_VER) binutils && \
    mv gcc-$(cat /src/vars/GCC_VER) gcc && \
    mv gmp-$(cat /src/vars/GMP_VER) gcc/gmp && \
    mv mpc-$(cat /src/vars/MPC_VER) gcc/mpc && \
    mv mpfr-$(cat /src/vars/MPFR_VER) gcc/mpfr && \
    mv musl-$(cat /src/vars/MUSL_VER) musl && \
    mv linux-$(cat /src/vars/LINUX_VER) linux && \
    cd gcc && \
    for p in /src/musl-cross-make-master/patches/gcc-$(cat /src/vars/GCC_VER)/*.diff; do \
        patch -p1 -i "${p}" ; \
    done && \
    rm -rf musl-cross-make-master musl-cross-make-master.tar.gz

COPY llvm-patches /src/llvm-patches
COPY python-patches /src/python-patches
COPY coreutils-patches /src/coreutils-patches

# variables needed for stage0-stage2
RUN echo "4.0.0" > /src/vars/LLVM_VER && \
    echo "0.2.1" > /src/vars/CURSES_VER && \
    echo "20170329-3.1" > /src/vars/LIBEDIT_VER && \
    echo "3.3.1" > /src/vars/LIBARCHIVE_VER && \
    echo "1.2.11" > /src/vars/ZLIB_VER && \
    echo "2.3.4" > /src/vars/PIGZ_VER && \
    echo "1.0.6" > /src/vars/BZIP2_VER && \
    echo "5.2.3" > /src/vars/XZ_VER && \
    echo "0.5.9.1" > /src/vars/DASH_VER && \
    echo "4.2.1" > /src/vars/MAKE_VER && \
    echo "20170510" > /src/vars/BMAKE_VER && \
    echo "487" > /src/vars/LESS_VER && \
    echo "2.7.13" > /src/vars/PYTHON2_VER && \
    echo "3.6.1" > /src/vars/PYTHON3_VER && \
    echo "3.8.1" > /src/vars/CMAKE_VER && \
    echo "3.0" > /src/vars/GREP_VER && \
    echo "4.4" > /src/vars/SED_VER && \
    echo "3.5" > /src/vars/DIFFUTILS_VER && \
    echo "8.27" > /src/vars/COREUTILS_VER && \
    echo "2.7.5" > /src/vars/PATCH_VER && \
    echo "5.31" > /src/vars/FILE_VER && \
    echo "5.24.1" > /src/vars/PERL_VER && \
    echo "1.1.4" > /src/vars/PERL_CROSS_VER && \
    echo "3.2.1" > /src/vars/LIBFFI_VER && \
    echo "1.3.6" > /src/vars/PKGCONF_VER && \
    echo "20170430" > /src/vars/BYACC_VER && \
    echo "2.21" > /src/vars/WHICH_VER && \
    echo "2.4.2" > /src/vars/MBEDTLS_VER && \
    echo "7.54.0" > /src/vars/CURL_VER && \
    echo "1.14.1" > /src/vars/MDOCML_VER && \
    echo "3.0.12" > /src/vars/SWIG_VER && \
    echo "8.40" > /src/vars/PCRE_VER && \
    echo "8.0" > /src/vars/VIM_VER

RUN set -x && cd /src && \
    wget http://ftp.barfooze.de/pub/sabotage/tarballs/netbsd-curses-$(cat /src/vars/CURSES_VER).tar.xz && \
    wget http://thrysoee.dk/editline/libedit-$(cat /src/vars/LIBEDIT_VER).tar.gz && \
    wget http://zlib.net/zlib-$(cat /src/vars/ZLIB_VER).tar.gz && \
    wget http://zlib.net/pigz/pigz-$(cat /src/vars/PIGZ_VER).tar.gz && \
    wget http://www.bzip.org/$(cat /src/vars/BZIP2_VER)/bzip2-$(cat /src/vars/BZIP2_VER).tar.gz && \
    wget https://tukaani.org/xz/xz-$(cat /src/vars/XZ_VER).tar.gz && \
    wget http://www.libarchive.org/downloads/libarchive-$(cat /src/vars/LIBARCHIVE_VER).tar.gz && \
    wget http://git.suckless.org/sbase/snapshot/sbase-master.tar.gz && \
    wget https://git.kernel.org/pub/scm/utils/dash/dash.git/snapshot/dash-$(cat /src/vars/DASH_VER).tar.gz && \
    wget http://releases.llvm.org/$(cat /src/vars/LLVM_VER)/llvm-$(cat /src/vars/LLVM_VER).src.tar.xz && \
    wget http://releases.llvm.org/$(cat /src/vars/LLVM_VER)/cfe-$(cat /src/vars/LLVM_VER).src.tar.xz && \
    wget http://releases.llvm.org/$(cat /src/vars/LLVM_VER)/compiler-rt-$(cat /src/vars/LLVM_VER).src.tar.xz && \
    wget http://releases.llvm.org/$(cat /src/vars/LLVM_VER)/libcxx-$(cat /src/vars/LLVM_VER).src.tar.xz && \
    wget http://releases.llvm.org/$(cat /src/vars/LLVM_VER)/libcxxabi-$(cat /src/vars/LLVM_VER).src.tar.xz && \
    wget http://releases.llvm.org/$(cat /src/vars/LLVM_VER)/libunwind-$(cat /src/vars/LLVM_VER).src.tar.xz && \
    wget http://releases.llvm.org/$(cat /src/vars/LLVM_VER)/lld-$(cat /src/vars/LLVM_VER).src.tar.xz && \
    wget http://releases.llvm.org/$(cat /src/vars/LLVM_VER)/clang-tools-extra-$(cat /src/vars/LLVM_VER).src.tar.xz && \
    wget http://releases.llvm.org/$(cat /src/vars/LLVM_VER)/lldb-$(cat /src/vars/LLVM_VER).src.tar.xz && \
    wget https://ftp.gnu.org/gnu/make/make-$(cat /src/vars/MAKE_VER).tar.bz2 && \
    wget http://www.crufty.net/ftp/pub/sjg/bmake-$(cat /src/vars/BMAKE_VER).tar.gz && \
    wget http://www.greenwoodsoftware.com/less/less-$(cat /src/vars/LESS_VER).tar.gz && \
    wget https://www.python.org/ftp/python/$(cat /src/vars/PYTHON2_VER)/Python-$(cat /src/vars/PYTHON2_VER).tar.xz && \
    wget https://www.python.org/ftp/python/$(cat /src/vars/PYTHON3_VER)/Python-$(cat /src/vars/PYTHON3_VER).tar.xz && \
    wget https://cmake.org/files/v3.8/cmake-$(cat /src/vars/CMAKE_VER).tar.gz && \
    wget http://www.cs.princeton.edu/~bwk/btl.mirror/awk.tar.gz && \
    wget https://ftp.gnu.org/gnu/grep/grep-$(cat /src/vars/GREP_VER).tar.xz && \
    wget https://ftp.gnu.org/gnu/coreutils/coreutils-$(cat /src/vars/COREUTILS_VER).tar.xz && \
    wget https://ftp.gnu.org/gnu/diffutils/diffutils-$(cat /src/vars/DIFFUTILS_VER).tar.xz && \
    wget https://ftp.gnu.org/gnu/patch/patch-$(cat /src/vars/PATCH_VER).tar.xz && \
    wget ftp://ftp.astron.com/pub/file/file-$(cat /src/vars/FILE_VER).tar.gz && \
    wget https://ftp.gnu.org/gnu/sed/sed-$(cat /src/vars/SED_VER).tar.xz && \
    wget http://www.cpan.org/src/5.0/perl-$(cat /src/vars/PERL_VER).tar.gz && \
    wget https://github.com/arsv/perl-cross/releases/download/$(cat /src/vars/PERL_CROSS_VER)/perl-cross-$(cat /src/vars/PERL_CROSS_VER).tar.gz && \
    wget ftp://sourceware.org/pub/libffi/libffi-$(cat /src/vars/LIBFFI_VER).tar.gz && \
    wget https://ftp.gnu.org/gnu/which/which-$(cat /src/vars/WHICH_VER).tar.gz && \
    wget https://distfiles.dereferenced.org/pkgconf/pkgconf-$(cat /src/vars/PKGCONF_VER).tar.xz && \
    wget -O clang-suite-master.tar.gz https://github.com/pathscale/clang-suite/archive/master.tar.gz && \
    wget ftp://invisible-island.net/byacc/byacc-$(cat /src/vars/BYACC_VER).tgz && \
    wget https://tls.mbed.org/download/mbedtls-$(cat /src/vars/MBEDTLS_VER)-apache.tgz && \
    wget https://curl.haxx.se/download/curl-$(cat /src/vars/CURL_VER).tar.gz && \
    wget http://mdocml.bsd.lv/snapshots/mdocml-$(cat /src/vars/MDOCML_VER).tar.gz && \
    wget http://downloads.sourceforge.net/swig/swig-$(cat /src/vars/SWIG_VER).tar.gz && \
    wget https://ftp.pcre.org/pub/pcre/pcre-$(cat /src/vars/PCRE_VER).tar.bz2 && \
    wget ftp://ftp.vim.org/pub/vim/unix/vim-$(cat /src/vars/VIM_VER).tar.bz2 && \
    wget https://curl.haxx.se/ca/cacert.pem && \
    tar xf netbsd-curses-$(cat /src/vars/CURSES_VER).tar.xz && \
    mv netbsd-curses-$(cat /src/vars/CURSES_VER) netbsd-curses && \
    tar xf libedit-$(cat /src/vars/LIBEDIT_VER).tar.gz && \
    mv libedit-$(cat /src/vars/LIBEDIT_VER) libedit && \
    tar xf zlib-$(cat /src/vars/ZLIB_VER).tar.gz && \
    mv zlib-$(cat /src/vars/ZLIB_VER) zlib && \
    tar xf pigz-$(cat /src/vars/PIGZ_VER).tar.gz && \
    mv pigz-$(cat /src/vars/PIGZ_VER) pigz && \
    tar xf bzip2-$(cat /src/vars/BZIP2_VER).tar.gz && \
    mv bzip2-$(cat /src/vars/BZIP2_VER) bzip2 && \
    tar xf xz-$(cat /src/vars/XZ_VER).tar.gz && \
    mv xz-$(cat /src/vars/XZ_VER) xz && \
    cd xz && \
    ./autogen.sh && \
    autoreconf -i -v -f && \
    cd /src && \
    tar xf libarchive-$(cat /src/vars/LIBARCHIVE_VER).tar.gz && \
    mv libarchive-$(cat /src/vars/LIBARCHIVE_VER) libarchive && \
    tar xf dash-$(cat /src/vars/DASH_VER).tar.gz && \
    mv dash-$(cat /src/vars/DASH_VER) dash && \
    cd dash && \
    ./autogen.sh && \
    autoreconf -i -v -f && \
    cd /src && \
    tar xf make-$(cat /src/vars/MAKE_VER).tar.bz2 && \
    mv make-$(cat /src/vars/MAKE_VER) make && \
    tar xf bmake-$(cat /src/vars/BMAKE_VER).tar.gz && \
    tar xf less-$(cat /src/vars/LESS_VER).tar.gz && \
    mv less-$(cat /src/vars/LESS_VER) less && \
    tar xf Python-$(cat /src/vars/PYTHON2_VER).tar.xz && \
    mv Python-$(cat /src/vars/PYTHON2_VER) Python2 && \
    tar xf Python-$(cat /src/vars/PYTHON3_VER).tar.xz && \
    mv Python-$(cat /src/vars/PYTHON3_VER) Python3 && \
    tar xf cmake-$(cat /src/vars/CMAKE_VER).tar.gz && \
    mv cmake-$(cat /src/vars/CMAKE_VER) cmake && \
    tar xf grep-$(cat /src/vars/GREP_VER).tar.xz && \
    mv grep-$(cat /src/vars/GREP_VER) grep && \
    tar xf coreutils-$(cat /src/vars/COREUTILS_VER).tar.xz && \
    mv coreutils-$(cat /src/vars/COREUTILS_VER) coreutils && \
    cd coreutils && \
    for p in /src/coreutils-patches/*.patch; do \
        patch -p1 -i "${p}" ; \
    done && \
    cd /src && \
    tar xf diffutils-$(cat /src/vars/DIFFUTILS_VER).tar.xz && \
    mv diffutils-$(cat /src/vars/DIFFUTILS_VER) diffutils && \
    tar xf patch-$(cat /src/vars/PATCH_VER).tar.xz && \
    mv patch-$(cat /src/vars/PATCH_VER) patch && \
    tar xf file-$(cat /src/vars/FILE_VER).tar.gz && \
    mv file-$(cat /src/vars/FILE_VER) file && \
    tar xf sed-$(cat /src/vars/SED_VER).tar.xz && \
    mv sed-$(cat /src/vars/SED_VER) sed && \
    tar xf mbedtls-$(cat /src/vars/MBEDTLS_VER)-apache.tgz && \
    mv mbedtls-$(cat /src/vars/MBEDTLS_VER) mbedtls && \
    tar xf curl-$(cat /src/vars/CURL_VER).tar.gz && \
    mv curl-$(cat /src/vars/CURL_VER) curl && \
    tar xf perl-$(cat /src/vars/PERL_VER).tar.gz && \
    mv perl-$(cat /src/vars/PERL_VER) perl && \
    tar xf perl-cross-$(cat /src/vars/PERL_CROSS_VER).tar.gz -C perl --strip-components=1 && \
    tar xf which-$(cat /src/vars/WHICH_VER).tar.gz && \
    mv which-$(cat /src/vars/WHICH_VER) which && \
    tar xf libffi-$(cat /src/vars/LIBFFI_VER).tar.gz && \
    mv libffi-$(cat /src/vars/LIBFFI_VER) libffi && \
    tar xf pkgconf-$(cat /src/vars/PKGCONF_VER).tar.xz && \
    mv pkgconf-$(cat /src/vars/PKGCONF_VER) pkgconf && \
    tar xf clang-suite-master.tar.gz && \
    tar xf sbase-master.tar.gz && \
    mkdir awk && \
    tar xf awk.tar.gz -C awk && \
    tar xf byacc-$(cat /src/vars/BYACC_VER).tgz && \
    mv byacc-$(cat /src/vars/BYACC_VER) byacc && \
    tar xf mdocml-$(cat /src/vars/MDOCML_VER).tar.gz && \
    mv mdocml-$(cat /src/vars/MDOCML_VER) mdocml && \
    tar xf swig-$(cat /src/vars/SWIG_VER).tar.gz && \
    mv swig-$(cat /src/vars/SWIG_VER) swig && \
    tar xf pcre-$(cat /src/vars/PCRE_VER).tar.bz2 && \
    mv pcre-$(cat /src/vars/PCRE_VER) pcre && \
    tar xf llvm-$(cat /src/vars/LLVM_VER).src.tar.xz && \
    mv llvm-$(cat /src/vars/LLVM_VER).src llvm && \
    tar xf compiler-rt-$(cat /src/vars/LLVM_VER).src.tar.xz -C llvm/projects && \
    mv llvm/projects/compiler-rt-$(cat /src/vars/LLVM_VER).src llvm/projects/compiler-rt && \
    tar xf libcxx-$(cat /src/vars/LLVM_VER).src.tar.xz -C llvm/projects && \
    mv llvm/projects/libcxx-$(cat /src/vars/LLVM_VER).src llvm/projects/libcxx && \
    tar xf libcxxabi-$(cat /src/vars/LLVM_VER).src.tar.xz -C llvm/projects && \
    mv llvm/projects/libcxxabi-$(cat /src/vars/LLVM_VER).src llvm/projects/libcxxabi && \
    tar xf libunwind-$(cat /src/vars/LLVM_VER).src.tar.xz -C llvm/projects && \
    mv llvm/projects/libunwind-$(cat /src/vars/LLVM_VER).src llvm/projects/libunwind && \
    tar xf lld-$(cat /src/vars/LLVM_VER).src.tar.xz -C llvm/tools && \
    mv llvm/tools/lld-$(cat /src/vars/LLVM_VER).src llvm/tools/lld && \
    tar xf lldb-$(cat /src/vars/LLVM_VER).src.tar.xz -C llvm/tools && \
    mv llvm/tools/lldb-$(cat /src/vars/LLVM_VER).src llvm/tools/lldb && \
    tar xf cfe-$(cat /src/vars/LLVM_VER).src.tar.xz -C llvm/tools && \
    mv llvm/tools/cfe-$(cat /src/vars/LLVM_VER).src llvm/tools/clang && \
    tar xf clang-tools-extra-$(cat /src/vars/LLVM_VER).src.tar.xz -C llvm/tools/clang/tools && \
    mv llvm/tools/clang/tools/clang-tools-extra-$(cat /src/vars/LLVM_VER).src llvm/tools/clang/tools/extra && \
    cd llvm && \
    for p in /src/llvm-patches/*.patch ; do \
        patch -p1 -i "${p}" ; \
    done && \
    cd /src && \
    cd Python2 && \
    for p in /src/python-patches/*.patch ; do \
        patch -p1 -i "${p}" ; \
    done && \
    cd /src && \
    tar xf vim-$(cat /src/vars/VIM_VER).tar.bz2 && \
    mv vim80 vim && \
    rm -f llvm-$(cat /src/vars/LLVM_VER).src.tar.xz && \
    rm -f compiler-rt-$(cat /src/vars/LLVM_VER).src.tar.xz && \
    rm -f libcxx-$(cat /src/vars/LLVM_VER).src.tar.xz && \
    rm -f libcxxabi-$(cat /src/vars/LLVM_VER).src.tar.xz && \
    rm -f libunwind-$(cat /src/vars/LLVM_VER).src.tar.xz && \
    rm -f lld-$(cat /src/vars/LLVM_VER).src.tar.xz && \
    rm -f lldb-$(cat /src/vars/LLVM_VER).src.tar.xz && \
    rm -f cfe-$(cat /src/vars/LLVM_VER).src.tar.xz && \
    rm -f clang-tools-extra-$(cat /src/vars/LLVM_VER).src.tar.xz && \
    rm -f netbsd-curses-$(cat /src/vars/CURSES_VER).tar.xz && \
    rm -f libedit-$(cat /src/vars/LIBEDIT_VER).tar.gz && \
    rm -f zlib-$(cat /src/vars/ZLIB_VER).tar.gz && \
    rm -f pigz-$(cat /src/vars/PIGZ_VER).tar.gz && \
    rm -f bzip2-$(cat /src/vars/BZIP2_VER).tar.gz && \
    rm -f libarchive-$(cat /src/vars/LIBARCHIVE_VER).tar.gz && \
    rm -f sbase-master.tar.gz && \
    rm -f dash-$(cat /src/vars/DASH_VER).tar.gz && \
    rm -f make-$(cat /src/vars/MAKE_VER).tar.bz2 && \
    rm -f bmake-$(cat /src/vars/BMAKE_VER).tar.gz && \
    rm -f less-$(cat /src/vars/LESS_VER).tar.gz && \
    rm -f Python-$(cat /src/vars/PYTHON2_VER).tar.xz && \
    rm -f Python-$(cat /src/vars/PYTHON3_VER).tar.xz && \
    rm -f cmake-$(cat /src/vars/CMAKE_VER).tar.gz && \
    rm -f perl-$(cat /src/vars/PERL_VER).tar.gz && \
    rm -f libffi-$(cat /src/vars/LIBFFI_VER).tar.gz && \
    rm -f pkgconf-$(cat /src/vars/PKGCONF_VER).tar.xz && \
    rm -f awk.tar.gz && \
    rm -f grep-$(cat /src/vars/GREP_VER).tar.xz && \
    rm -f coreutils-$(cat /src/vars/COREUTILS_VER).tar.xz && \
    rm -f diffutils-$(cat /src/vars/DIFFUTILS_VER).tar.xz && \
    rm -f patch-$(cat /src/vars/PATCH_VER).tar.xz && \
    rm -f file-$(cat /src/vars/FILE_VER).tar.gz && \
    rm -f sed-$(cat /src/vars/SED_VER).tar.xz && \
    rm -f perl-cross-$(cat /src/vars/PERL_CROSS_VER).tar.gz && \
    rm -f byacc-$(cat /src/vars/BYACC_VER).tgz && \
    rm -f which-$(cat /src/vars/WHICH_VER).tar.gz && \
    rm -f curl-$(cat /src/vars/CURL_VER).tar.gz && \
    rm -f mdocml-$(cat /src/vars/MDOCML_VER).tar.gz && \
    rm -f mbedtls-$(cat /src/vars/MBEDTLS_VER)-apache.tgz && \
    rm -f swig-$(cat /src/vars/SWIG_VER).tar.gz && \
    rm -f pcre-$(cat /src/vars/PCRE_VER).tar.bz2 && \
    rm -f vim-$(cat /src/vars/VIM_VER).tar.bz2 && \
    mkdir -p /build && \
    cp -a /src/cacert.pem /opt/stage0/etc/ca-certificates/cacert.pem && \
    cp -a /src/cacert.pem /opt/stage1/etc/ca-certificates/cacert.pem && \
    cp -a /src/cacert.pem /opt/stage2/etc/ca-certificates/cacert.pem && \
    cp -a /src/cacert.pem /opt/stage3/etc/ca-certificates/cacert.pem

#cross-netbsd-curses
RUN cp -a /src/netbsd-curses /build/netbsd-curses-cross && \
    cd /build/netbsd-curses-cross && \
    make \
    CC="$(cat /src/vars/TARGET)-gcc" \
    HOSTCC="gcc" \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    PREFIX="" \
    DESTDIR="/opt/gcc-tmp/$(cat /src/vars/TARGET)" \
    install && \
    cd / && \
    rm -rf /build-netbsd-curses-cross

#cross-libedit
RUN mkdir -p /build/libedit-cross && \
    cd /build/libedit-cross && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/libedit/configure \
      --host="$(cat /src/vars/TARGET)" \
      --prefix= && \
    PATH="/opt/gcc-tmp/bin:$PATH" make && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/gcc-tmp/$(cat /src/vars/TARGET)" install && \
    ln -s libedit.pc /opt/gcc-tmp/$(cat /src/vars/TARGET)/lib/pkgconfig/readline.pc && \
    ln -s libedit.a /opt/gcc-tmp/$(cat /src/vars/TARGET)/lib/libreadline.a && \
    ln -s libedit.so /opt/gcc-tmp/$(cat /src/vars/TARGET)/lib/libreadline.so && \
    mkdir -p /opt/gcc-tmp/$(cat /src/vars/TARGET)/include/readline && \
    ln -sf ../editline/readline.h /opt/gcc-tmp/$(cat /src/vars/TARGET)/include/readline/readline.h && \
    touch /opt/gcc-tmp/$(cat /src/vars/TARGET)/include/readline/history.h && \
    touch /opt/gcc-tmp/$(cat /src/vars/TARGET)/include/readline/tilde.h && \
    cd / && \
    rm -rf /build/libedit-cross

# cross-zlib
RUN mkdir -p /build && \
    cp -a /src/zlib /build/zlib-cross && \
    cd /build/zlib-cross && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CC="$(cat /src/vars/TARGET)-gcc" \
    AR="$(cat /src/vars/TARGET)-ar" \
    RANLIB="$(cat /src/vars/TARGET)-ranlib" \
    LDFLAGS="-s" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    ./configure --shared --prefix= && \
    PATH="/opt/gcc-tmp/bin:$PATH" make && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/gcc-tmp/$(cat /src/vars/TARGET)" install && \
    cd / && \
    rm -rf /build/zlib-cross

#cross-xz
RUN mkdir -p /build/xz-cross && \
    cd /build/xz-cross && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/xz/configure \
      --disable-nls \
      --disable-rpath \
      --disable-scripts \
      --prefix= \
      --target="$(cat /src/vars/TARGET)" \
      --host="$(cat /src/vars/TARGET)" && \
    PATH="/opt/gcc-tmp/bin:$PATH" make && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/gcc-tmp/$(cat /src/vars/TARGET)" install && \
    cd / && \
    rm -rf /build/xz-cross

#cross-libffi
RUN mkdir -p /build/libffi-cross && \
    cd /build/libffi-cross && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/libffi/configure \
      --prefix= \
      --target="$(cat /src/vars/TARGET)" \
      --host="$(cat /src/vars/TARGET)" && \
    PATH="/opt/gcc-tmp/bin:$PATH" make && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/gcc-tmp/$(cat /src/vars/TARGET)" install && \
    cd / && \
    rm -rf /build/libffi-cross

#host-file
RUN mkdir -p /build/file-host && \
    cd /build/file-host && \
    /src/file/configure \
      --prefix=/opt/file-${FILE_VER} && \
    make && \
    make install && \
    cd / && \
    rm -rf /build/file-host

#stage0-dash
RUN mkdir -p /build/dash-stage0 && \
    cd /build/dash-stage0 && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    /src/dash/configure \
      --enable-static \
      --host="$(cat /src/vars/TARGET)" \
      --prefix=/usr && \
    PATH="/opt/gcc-tmp/bin:$PATH" make && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage0" install && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage1" install && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage2" install && \
    ln -s dash /opt/stage0/usr/bin/sh && \
    ln -s dash /opt/stage1/usr/bin/sh && \
    ln -s dash /opt/stage2/usr/bin/sh && \
    cd / && \
    rm -rf /build/dash-stage0

#stage0-coreutils
RUN mkdir -p /build/coreutils-stage0 && \
    cd /build/coreutils-stage0 && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/coreutils/configure \
      --host="$(cat /src/vars/TARGET)" \
      --prefix=/usr \
      --enable-install-program=hostname \
      --disable-nls \
      --disable-acl \
      --disable-rpath \
      --disable-libsmack \
      --disable-xattr \
      --disable-libcap \
      --without-openssl \
      --without-selinux && \
    PATH="/opt/gcc-tmp/bin:$PATH" make && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage0" install && \
    cd / && \
    rm -rf /build/coreutils-stage0

#stage0-sbase
RUN cp -a /src/sbase-master /build/sbase-stage0 && \
    cd /build/sbase-stage0 && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    make \
    CC="$(cat /src/vars/TARGET)-gcc" \
    CFLAGS="-g0 -Os -static" \
    LDFLAGS="-static -s" && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    make \
    CC="$(cat /src/vars/TARGET)-gcc" \
    CFLAGS="-g0 -Os -static" \
    LDFLAGS="-static -s" \
    sbase-box && \
    cp sbase-box /opt/stage0/usr/bin/sbase-box && \
    ln -s sbase-box /opt/stage0/usr/bin/find && \
    ln -s sbase-box /opt/stage0/usr/bin/xargs && \
    cd / && \
    rm -rf /build/sbase-stage0

#stage0-grep
RUN mkdir -p /build/grep-stage0 && \
    cd /build/grep-stage0 && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/grep/configure \
      --host="$(cat /src/vars/TARGET)" \
      --prefix=/usr && \
    PATH="/opt/gcc-tmp/bin:$PATH" make && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage0" install && \
    cd / && \
    rm -rf /build/grep-stage0

#stage0-sed
RUN mkdir -p /build/sed-stage0 && \
    cd /build/sed-stage0 && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/sed/configure \
      --host="$(cat /src/vars/TARGET)" \
      --prefix=/usr && \
    PATH="/opt/gcc-tmp/bin:$PATH" make && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage0" install && \
    cd / && \
    rm -rf /build/sed-stage0

#stage0-file
RUN mkdir -p /build/file-stage0 && \
    cd /build/file-stage0 && \
    PATH="/opt/file-${FILE_VER}/bin:/opt/gcc-tmp/bin:$PATH" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/file/configure \
      --host="$(cat /src/vars/TARGET)" \
      --prefix=/usr && \
    PATH="/opt/file-${FILE_VER}/bin:/opt/gcc-tmp/bin:$PATH" make && \
    PATH="/opt/file-${FILE_VER}/bin:/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage0" install && \
    cd / && \
    rm -rf /build/file-stage0

#stage0-diff
RUN mkdir -p /build/diffutils-stage0 && \
    cd /build/diffutils-stage0 && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/diffutils/configure \
      --host="$(cat /src/vars/TARGET)" \
      --prefix=/usr && \
    PATH="/opt/gcc-tmp/bin:$PATH" make && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage0" install && \
    cd / && \
    rm -rf /build/diffutils-stage0

#stage0-patch
RUN mkdir -p /build/patch-stage0 && \
    cd /build/patch-stage0 && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/patch/configure \
      --host="$(cat /src/vars/TARGET)" \
      --prefix=/usr && \
    PATH="/opt/gcc-tmp/bin:$PATH" make && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage0" install && \
    cd / && \
    rm -rf /build/patch-stage0

#stage0-which
RUN mkdir -p /build/which-stage0 && \
    cd /build/which-stage0 && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    /src/which/configure \
      --target="$(cat /src/vars/TARGET)" \
      --host="$(cat /src/vars/TARGET)" \
      --prefix=/usr && \
    PATH="/opt/gcc-tmp/bin:$PATH" make V=1 && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage0" install && \
    cd / && \
    rm -rf /build/which-stage0

#stage0-pkgconf
RUN mkdir -p /build/pkgconf-stage0 && \
    cd /build/pkgconf-stage0 && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/pkgconf/configure \
      --host="$(cat /src/vars/TARGET)" \
      --prefix=/usr && \
    PATH="/opt/gcc-tmp/bin:$PATH" make && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage0" install && \
    ln -s pkgconf /opt/stage0/usr/bin/pkg-config && \
    cd / && \
    rm -rf /build/pkgconf-stage0

#stage0-make
RUN mkdir -p /build/make-stage0 && \
    cd /build/make-stage0 && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/make/configure \
      --host="$(cat /src/vars/TARGET)" \
      --prefix=/usr \
      --disable-rpath \
      --without-guile \
      --without-dmalloc && \
    PATH="/opt/gcc-tmp/bin:$PATH" make && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage0" install && \
    cd / && \
    rm -rf /build/make-stage0

#stage0-byacc
RUN mkdir -p /build/byacc-stage0 && \
    cd /build/byacc-stage0 && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/byacc/configure \
      --target="$(cat /src/vars/TARGET)" \
      --host="$(cat /src/vars/TARGET)" \
      --prefix=/usr && \
    PATH="/opt/gcc-tmp/bin:$PATH" make && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage0" install && \
    cp yacc /opt/stage0/usr/bin/yacc && \
    cd / && \
    rm -rf /build/byacc-stage0

#stage0-awk
RUN cp -a /src/awk /build/awk-stage0 && \
    cd /build/awk-stage0 && \
    sed -i '/YACC = yacc -d -S/ s|^|#|' makefile && \
    bison -d -y awkgram.y && \
    mv y.tab.c ytab.c && \
    mv y.tab.h ytab.h && \
    make proctab.c && \
    rm -f *.o && \
    PATH="/opt/gcc-tmp/bin:$PATH" $(cat /src/vars/TARGET)-gcc -g0 -Os -fPIC -Wall -pedantic -fno-strict-aliasing  -c ytab.c && \
    PATH="/opt/gcc-tmp/bin:$PATH" $(cat /src/vars/TARGET)-gcc -g0 -Os -fPIC -Wall -pedantic -fno-strict-aliasing    -c -o b.o b.c && \
    PATH="/opt/gcc-tmp/bin:$PATH" $(cat /src/vars/TARGET)-gcc -g0 -Os -fPIC -Wall -pedantic -fno-strict-aliasing    -c -o main.o main.c && \
    PATH="/opt/gcc-tmp/bin:$PATH" $(cat /src/vars/TARGET)-gcc -g0 -Os -fPIC -Wall -pedantic -fno-strict-aliasing    -c -o parse.o parse.c && \
    PATH="/opt/gcc-tmp/bin:$PATH" $(cat /src/vars/TARGET)-gcc -g0 -Os -fPIC -Wall -pedantic -fno-strict-aliasing    -c -o proctab.o proctab.c && \
    PATH="/opt/gcc-tmp/bin:$PATH" $(cat /src/vars/TARGET)-gcc -g0 -Os -fPIC -Wall -pedantic -fno-strict-aliasing    -c -o tran.o tran.c && \
    PATH="/opt/gcc-tmp/bin:$PATH" $(cat /src/vars/TARGET)-gcc -g0 -Os -fPIC -Wall -pedantic -fno-strict-aliasing    -c -o lib.o lib.c && \
    PATH="/opt/gcc-tmp/bin:$PATH" $(cat /src/vars/TARGET)-gcc -g0 -Os -fPIC -Wall -pedantic -fno-strict-aliasing    -c -o run.o run.c && \
    PATH="/opt/gcc-tmp/bin:$PATH" $(cat /src/vars/TARGET)-gcc -g0 -Os -fPIC -Wall -pedantic -fno-strict-aliasing    -c -o lex.o lex.c && \
    PATH="/opt/gcc-tmp/bin:$PATH" $(cat /src/vars/TARGET)-gcc -s -Wall ytab.o b.o main.o parse.o proctab.o tran.o lib.o run.o lex.o   -lm && \
    cp a.out /opt/stage0/usr/bin/awk && \
    cd / && \
    rm -rf /build/awk-stage0

#stage0-netbsd-curses
RUN cp -a /src/netbsd-curses /build/netbsd-curses-stage0 && \
    cd /build/netbsd-curses-stage0 && \
    make \
    CC="$(cat /src/vars/TARGET)-gcc" \
    HOSTCC="gcc" \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    PREFIX="/usr" \
    DESTDIR="/opt/stage0" \
    install && \
    make \
    CC="$(cat /src/vars/TARGET)-gcc" \
    HOSTCC="gcc" \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    PREFIX="/usr" \
    DESTDIR="/opt/stage1" \
    install && \
    make \
    CC="$(cat /src/vars/TARGET)-gcc" \
    HOSTCC="gcc" \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    PREFIX="/usr" \
    DESTDIR="/opt/stage2" \
    install && \
    cd / && \
    rm -rf /build-netbsd-curses-stage0


#stage0-libedit
RUN mkdir -p /build/libedit-stage0 && \
    cd /build/libedit-stage0 && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/libedit/configure \
      --host="$(cat /src/vars/TARGET)" \
      --prefix=/usr && \
    PATH="/opt/gcc-tmp/bin:$PATH" make && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage0" install && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage1" install && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage2" install && \
    ln -s libedit.pc /opt/stage0/usr/lib/pkgconfig/readline.pc && \
    ln -s libedit.pc /opt/stage1/usr/lib/pkgconfig/readline.pc && \
    ln -s libedit.pc /opt/stage2/usr/lib/pkgconfig/readline.pc && \
    ln -s libedit.a /opt/stage0/usr/lib/libreadline.a && \
    ln -s libedit.a /opt/stage1/usr/lib/libreadline.a && \
    ln -s libedit.a /opt/stage2/usr/lib/libreadline.a && \
    ln -s libedit.so /opt/stage0/usr/lib/libreadline.so && \
    ln -s libedit.so /opt/stage1/usr/lib/libreadline.so && \
    ln -s libedit.so /opt/stage2/usr/lib/libreadline.so && \
    mkdir -p /opt/stage0/usr/include/readline && \
    mkdir -p /opt/stage1/usr/include/readline && \
    mkdir -p /opt/stage2/usr/include/readline && \
    ln -sf ../editline/readline.h /opt/stage0/usr/include/readline/readline.h && \
    ln -sf ../editline/readline.h /opt/stage1/usr/include/readline/readline.h && \
    ln -sf ../editline/readline.h /opt/stage2/usr/include/readline/readline.h && \
    touch /opt/stage0/usr/include/readline/history.h && \
    touch /opt/stage1/usr/include/readline/history.h && \
    touch /opt/stage2/usr/include/readline/history.h && \
    touch /opt/stage0/usr/include/readline/tilde.h && \
    touch /opt/stage1/usr/include/readline/tilde.h && \
    touch /opt/stage2/usr/include/readline/tilde.h && \
    cd / && \
    rm -rf /build/libedit-stage0

#stage0-zlib
RUN cp -a /src/zlib /build/zlib-stage0 && \
    cd /build/zlib-stage0 && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CC="$(cat /src/vars/TARGET)-gcc" \
    AR="$(cat /src/vars/TARGET)-ar" \
    RANLIB="$(cat /src/vars/TARGET)-ranlib" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    ./configure --shared --prefix=/usr && \
    PATH="/opt/gcc-tmp/bin:$PATH" make && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage0" install && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage1" install && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage2" install && \
    cd / && \
    rm -rf /build/zlib-stage0

#stage0-pigz
RUN cp -a /src/pigz /build/pigz-stage0 && \
    cd /build/pigz-stage0 && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    make \
    CC="$(cat /src/vars/TARGET)-gcc" \
    AR="$(cat /src/vars/TARGET)-ar" \
    RANLIB="$(cat /src/vars/TARGET)-ranlib" \
    LDFLAGS="-s" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" && \
    cp pigz /opt/stage0/usr/bin/pigz && \
    cp pigz /opt/stage1/usr/bin/pigz && \
    cp pigz /opt/stage2/usr/bin/pigz && \
    ln -s pigz /opt/stage0/usr/bin/unpigz && \
    ln -s pigz /opt/stage0/usr/bin/gzip && \
    ln -s pigz /opt/stage0/usr/bin/gunzip && \
    ln -s pigz /opt/stage0/usr/bin/zcat && \
    ln -s pigz /opt/stage0/usr/bin/gzcat && \
    ln -s pigz /opt/stage1/usr/bin/unpigz && \
    ln -s pigz /opt/stage1/usr/bin/gzip && \
    ln -s pigz /opt/stage1/usr/bin/gunzip && \
    ln -s pigz /opt/stage1/usr/bin/zcat && \
    ln -s pigz /opt/stage1/usr/bin/gzcat && \
    ln -s pigz /opt/stage2/usr/bin/unpigz && \
    ln -s pigz /opt/stage2/usr/bin/gzip && \
    ln -s pigz /opt/stage2/usr/bin/gunzip && \
    ln -s pigz /opt/stage2/usr/bin/zcat && \
    ln -s pigz /opt/stage2/usr/bin/gzcat && \
    cd / && \
    rm -rf /build/pigz-stage0

#stage0-xz
RUN mkdir -p /build/xz-stage0 && \
    cd /build/xz-stage0 && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/xz/configure \
      --disable-nls \
      --disable-rpath \
      --disable-scripts \
      --prefix=/usr \
      --target="$(cat /src/vars/TARGET)" \
      --host="$(cat /src/vars/TARGET)" && \
    PATH="/opt/gcc-tmp/bin:$PATH" make && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage0" install && \
    cd / && \
    rm -rf /build/xz-stage0

#stage0-libffi
RUN mkdir -p /build/libffi-stage0 && \
    cd /build/libffi-stage0 && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/libffi/configure \
      --prefix=/usr \
      --target="$(cat /src/vars/TARGET)" \
      --host="$(cat /src/vars/TARGET)" && \
    PATH="/opt/gcc-tmp/bin:$PATH" make && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage0" install && \
    cd / && \
    rm -rf /build/libffi-stage0

#stage0-perl
RUN cp -a /src/perl /build/perl-stage0 && \
    cd /build/perl-stage0 && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    ./configure \
      --target="$(cat /src/vars/TARGET)" \
      --prefix=/usr && \
    PATH="/opt/gcc-tmp/bin:$PATH" make && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage0" install && \
    cd / && \
    rm -rf /build/perl-stage0

#stage0-python
RUN cp -a /src/Python2 /build/Python2-stage0 && \
    cd /build/Python2-stage0 && \
    echo "ac_cv_file__dev_ptmx=yes" > config.site && \
    echo "ac_cv_file__dev_ptc=no" >> config.site && \
    CONFIG_SITE=config.site \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    ./configure \
      --prefix=/usr \
      --enable-ipv6 \
      --build=$(gcc -dumpmachine) \
      --host="$(cat /src/vars/TARGET)" && \
    PATH="/opt/gcc-tmp/bin:$PATH" make && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage0" install && \
    cd / && \
    rm -rf /build/Python2-stage0

# stage0-csu
RUN cp -a /src/clang-suite-master/csu /build/csu-stage0 && \
    cd /build/csu-stage0 && \
    PATH="/opt/gcc-tmp/bin:$PATH" $(cat /src/vars/TARGET)-gcc -g0 -Os -o crtbegin.o -c crtbegin.c && \
    PATH="/opt/gcc-tmp/bin:$PATH" $(cat /src/vars/TARGET)-gcc -g0 -Os -o crtbeginT.o -static -c crtbegin.c && \
    PATH="/opt/gcc-tmp/bin:$PATH" $(cat /src/vars/TARGET)-gcc -g0 -Os -o crtbeginS.o -fPIC -c crtbegin.c && \
    PATH="/opt/gcc-tmp/bin:$PATH" $(cat /src/vars/TARGET)-gcc -g0 -Os -o crtend.o -c crtend.c && \
    PATH="/opt/gcc-tmp/bin:$PATH" $(cat /src/vars/TARGET)-gcc -g0 -Os -o crtendS.o -c -fPIC crtend.c && \
    cp crtbegin.o  /opt/stage0/usr/lib/crtbegin.o && \
    cp crtbeginS.o /opt/stage0/usr/lib/crtbeginS.o && \
    cp crtbeginT.o /opt/stage0/usr/lib/crtbeginT.o && \
    cp crtend.o    /opt/stage0/usr/lib/crtend.o && \
    cp crtendS.o   /opt/stage0/usr/lib/crtendS.o && \
    cd / && \
    rm -rf /build/csu-stage0


#stage0-linux-headers
RUN cp -a /src/linux /build/linux-stage0 && \
    cd /build/linux-stage0 && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CC="$(cat /src/vars/TARGET)-gcc" \
    make \
    ARCH=x86_64 \
    INSTALL_HDR_PATH="/opt/stage0/usr" headers_install && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CC="$(cat /src/vars/TARGET)-gcc" \
    make \
    ARCH=x86_64 \
    INSTALL_HDR_PATH="/opt/stage1/usr" headers_install && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CC="$(cat /src/vars/TARGET)-gcc" \
    make \
    ARCH=x86_64 \
    INSTALL_HDR_PATH="/opt/stage2/usr" headers_install && \
    cd / && \
    rm -rf /build/linux-stage0

# stage0-musl
RUN mkdir -p /build/musl-stage0 && \
    cd /build/musl-stage0 && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CFLAGS="-g0 -Os -fPIC -fpic" \
    LDFLAGS="-s" \
    CROSS_COMPILE="$(cat /src/vars/TARGET)-" \
    /src/musl/configure \
      --prefix=/usr \
      --disable-wrapper && \
    PATH="/opt/gcc-tmp/bin:$PATH" make && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage0" install && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage1" install && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage2" install && \
    cd / && \
    rm -rf /build/musl-stage0

# stage0-binutils
# going to cheat a bit and copy binutils + gcc
# to later stages to save some time
RUN mkdir -p /build/binutils-stage0 && \
    cd /build/binutils-stage0 && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/binutils/configure \
      --prefix=/usr \
      --target="$(cat /src/vars/TARGET)" \
      --host="$(cat /src/vars/TARGET)" \
      --disable-nls \
      --disable-multilib && \
    PATH="/opt/gcc-tmp/bin:$PATH" make && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage0" install && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage1" install && \
    cd / && \
    rm -rf /build/binutils-stage0

# stage0-gcc
RUN mkdir -p /build/gcc-stage0 && \
    cd /build/gcc-stage0 && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/gcc/configure \
      --prefix=/usr \
      --target="$(cat /src/vars/TARGET)" \
      --host="$(cat /src/vars/TARGET)" \
      --disable-nls \
      --disable-multilib \
      --disable-libquadmath \
      --disable-decimal-float \
      --disable-werror \
      --libdir=/usr/lib \
      --enable-tls \
      --disable-libmudflap \
      --disable-libsanitizer \
      --disable-gnu-indirect-function \
      --disable-libmpx \
      --enable-libstdcxx-time \
      --enable-languages=c,c++ && \
    PATH="/opt/gcc-tmp/bin:$PATH" make && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage0" install && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage1" install && \
    cd / && \
    rm -rf /build/gcc-stage0

RUN find /opt/stage0 -name '*.la' -exec rm {} \; ; \
    find /opt/stage1 -name '*.la' -exec rm {} \; ; \
    find /opt/stage2 -name '*.la' -exec rm {} \; ; \
    mv /opt/stage0/usr/lib64/* /opt/stage0/usr/lib || true

FROM scratch
COPY --from=0 /opt/stage0 /
COPY --from=0 /opt/stage1 /opt/stage1
COPY --from=0 /opt/stage2 /opt/stage2
COPY --from=0 /opt/stage3 /opt/stage3
COPY --from=0 /src /src

RUN mkdir -p /build

#stage0-libbz2
RUN cp -a /src/bzip2 /build/bzip2-stage0 && \
    cd /build/bzip2-stage0 && \
    make CFLAGS="-g0 -Os -fPIC" LDFLAGS="-s" -f Makefile-libbz2_so && \
    make CFLAGS="-g0 -Os -fPIC" LDFLAGS="-s" && \
    cp libbz2.so.$(cat /src/vars/BZIP2_VER) /usr/lib/ && \
    cp libbz2.a /usr/lib/ && \
    cp bzip2-shared /usr/bin/bzip2 && \
    ln -s bzip2 /usr/bin/bunzip2 && \
    ln -s bzip2 /usr/bin/bzcat && \
    ln -s libbz2.so.$(cat /src/vars/BZIP2_VER) /usr/lib/libbz2.so && \
    ln -s libbz2.so.$(cat /src/vars/BZIP2_VER) /usr/lib/libbz2.so.1 && \
    ln -s libbz2.so.$(cat /src/vars/BZIP2_VER) /usr/lib/libbz2.so.1.0 && \
    cp bzlib.h /usr/include/bzlib.h && \
    cp bzip2.1 /usr/share/man/man1/bzip2.1 && \
    ln -s bzip2.1 /usr/share/man/man1/bunzip2.1 && \
    ln -s bzip2.1 /usr/share/man/man1/bzcat.1 && \
    cd / && \
    rm -rf /build/bzip2-stage0

#stage0-python (part 2)
RUN cp -a /src/Python2 /build/Python2-stage0 && \
    cd /build/Python2-stage0 && \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    ./configure \
      --prefix=/usr && \
    make -j$(nproc) && \
    make install && \
    cd / && \
    rm -rf /build/Python2-stage0

#stage0-pcre
RUN mkdir -p /build/pcre-stage0 && \
    cd /build/pcre-stage0 && \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/pcre/configure \
      --prefix=/usr && \
    make -j$(nproc) && \
    make install && \
    cd / && \
    rm -rf /build/pcre-stage0

#stage0-swig
RUN mkdir -p /build/swig-stage0 && \
    cd /build/swig-stage0 && \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/swig/configure \
      --prefix=/usr && \
    make -j$(nproc) && \
    make install && \
    cd / && \
    rm -rf /build/swig-stage0

#stage0-cmake
RUN cp -a /src/cmake /build/cmake-stage0 && \
    cd /build/cmake-stage0 && \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    ./bootstrap --prefix=/usr && \
    make -j$(nproc) && \
    make install && \
    cd / && \
    rm -rf /build/cmake-stage0


#stage0-libarchive
RUN mkdir -p /build/libarchive-stage0 && \
    cd /build/libarchive-stage0 && \
    cmake \
      -DCMAKE_INSTALL_PREFIX="/usr" \
      -DCMAKE_C_FLAGS="-g0 -Os -fPIC" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -fPIC" \
      -DCMAKE_EXE_LINKER_FLAGS="-s" \
      -DCMAKE_SHARED_LINKER_FLAGS="-s" \
      -DCMAKE_SKIP_RPATH=ON \
      /src/libarchive && \
    make -j$(nproc) && \
    make install && \
    ln -s bsdtar /usr/bin/tar && \
    ln -s bsdcpio /usr/bin/cpio && \
    cd / && \
    rm -rf /build/libarchive-stage0

#stage0-mbedtls
RUN mkdir -p /build/mbedtls-stage0 && \
    cd /build/mbedtls-stage0 && \
    cmake \
      -DCMAKE_INSTALL_PREFIX="/usr" \
      -DCMAKE_RELEASE_TYPE="Release" \
      -DUSE_SHARED_MBEDTLS_LIBRARY=ON \
      -DCMAKE_C_FLAGS="-g0 -Os -fPIC" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -fPIC" \
      -DCMAKE_EXE_LINKER_FLAGS="-s" \
      -DCMAKE_SHARED_LINKER_FLAGS="-s" \
      -DCMAKE_SKIP_RPATH=ON \
      /src/mbedtls && \
    make -j$(nproc) && \
    make install && \
    cd / && \
    rm -rf /build/mbedtls-stage0

#stage0-curl
RUN mkdir -p /build/curl-stage0 && \
    cd /build/curl-stage0 && \
    /src/curl/configure \
      --with-mbedtls \
      --prefix=/usr && \
    make && \
    make install && \
    cd / && \
    rm -rf /build/curl-stage0

#stage0-llvm
RUN mkdir -p /build/llvm-stage0 && \
    cd /build/llvm-stage0 && \
    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_C_COMPILER=gcc \
      -DCMAKE_CXX_COMPILER=g++ \
      -DCMAKE_SKIP_RPATH=ON \
      -DLLVM_TOOL_LIBCXXABI_BUILD=OFF \
      -DLLVM_TOOL_LIBCXX_BUILD=OFF \
      -DLLVM_TOOL_LIBUNWIND_BUILD=OFF \
      -DLLVM_TOOL_COMPILER_RT_BUILD=OFF \
      -DLLVM_TOOL_LLDB_BUILD=OFF \
      -DLLVM_ENABLE_ASSERTIONS=ON \
      -DLLVM_ENABLE_LLD=OFF \
      -DLLVM_ENABLE_CXX1Y=ON \
      -DLLVM_ENABLE_FFI=OFF \
      -DLLVM_ENABLE_LIBCXX=OFF \
      -DLLVM_ENABLE_PIC=ON \
      -DLLVM_ENABLE_RTTI=ON \
      -DLLVM_ENABLE_SPHINX=OFF \
      -DLLVM_ENABLE_TERMINFO=OFF \
      -DLLVM_ENABLE_ZLIB=ON \
      -DLLVM_TARGET_ARCH="X86" \
      -DLLVM_TARGETS_TO_BUILD="X86" \
      -DLLVM_DEFAULT_TARGET_TRIPLE="$(cat /src/vars/TARGET)" \
      -DGCC_INSTALL_PREFIX="/usr" \
      -DLLVM_BUILD_LLVM_DYLIB=ON \
      -DLLVM_LINK_LLVM_DYLIB=ON \
      -DCLANG_TOOL_EXTRA_BUILD=OFF \
      -DLLVM_TOOL_CLANG_TOOLS_EXTRA_BUILD=OFF \
      -DCLANG_TOOLS_EXTRA_INCLUDE_DOCS=OFF \
      -DCLANG_HAVE_LIBXML=OFF \
      /src/llvm && \
    make -j$(nproc) && \
    make install && \
    cd / && \
    rm -rf /build/llvm-stage0

#stage0-libunwind
RUN mkdir -p /build/libunwind-stage0 && \
    cd /build/libunwind-stage0 && \
    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_C_FLAGS="-g0 -Os -include stdc-predef.h" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -include stdc-predef.h" \
      -DCMAKE_SKIP_RPATH=ON \
      -DLIBUNWIND_ENABLE_SHARED=OFF \
      -DLLVM_PATH=/src/llvm \
      /src/llvm/projects/libunwind && \
    make -j$(nproc) && \
    make install && \
    cd / && \
    rm -rf /build/libunwind-stage0

#stage0-libcxxabi
RUN mkdir -p /build/libcxxabi-stage0 && \
    cd /build/libcxxabi-stage0 && \
    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_C_FLAGS="-g0 -Os -include stdc-predef.h" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -include stdc-predef.h" \
      -DCMAKE_SKIP_RPATH=ON \
      -DCMAKE_SHARED_LINKER_FLAGS="-Wl,--whole-archive -lunwind -Wl,--no-whole-archive" \
      -DLIBCXXABI_USE_LLVM_UNWINDER=ON \
      -DLIBCXXABI_LIBCXX_INCLUDES=/src/llvm/projects/libcxx/include \
      -DLIBCXXABI_HAS_CXA_THREAD_ATEXIT_IMPL=OFF \
      -DLLVM_PATH=/src/llvm \
      /src/llvm/projects/libcxxabi && \
    make -j$(nproc) VERBOSE=1 && \
    make install && \
    cd / && \
    rm -rf /build/libcxxabi-stage0

#stage0-libcxx
RUN mkdir -p /build/libcxx-stage0 && \
    cd /build/libcxx-stage0 && \
    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_C_FLAGS="-g0 -Os -include stdc-predef.h" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -include stdc-predef.h" \
      -DCMAKE_SKIP_RPATH=ON \
      -DLIBCXX_HAS_MUSL_LIBC=ON \
      -DLIBCXX_HAS_GCC_S_LIB=OFF \
      -DLIBCXX_CXX_ABI=libcxxabi \
      -DLIBCXX_CXX_ABI_INCLUDE_PATHS="/src/llvm/projects/libcxxabi/include" \
      -DLLVM_PATH=/src/llvm \
      /src/llvm/projects/libcxx && \
    make -j$(nproc) && \
    make install && \
    cd / && \
    rm -rf /build/libcxx-stage0

#stage0-compiler-rt
RUN mkdir -p /build/compiler-rt-stage0 && \
    cd /build/compiler-rt-stage0 && \
    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_C_FLAGS="-g0 -Os -include stdc-predef.h" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -include stdc-predef.h" \
      -DCMAKE_SKIP_RPATH=ON \
      -DCOMPILER_RT_INSTALL_PATH="/usr/lib/clang/$(cat /src/vars/LLVM_VER)" \
      -DCOMPILER_RT_BUILD_SANITIZERS=OFF \
      -DCOMPILER_RT_BUILD_XRAY=OFF \
      -DLLVM_PATH=/src/llvm \
      /src/llvm/projects/compiler-rt && \
    make -j$(nproc) && \
    make install && \
    cd / && \
    rm -rf /build/compiler-rt-stage0

RUN find / -name '*.la' -exec rm {} \; ; \
    mv /usr/lib64/* /usr/lib || true
#stage0-end


#stage1-coreutils
RUN mkdir -p /build/coreutils-stage1 && \
    cd /build/coreutils-stage1 && \
    FORCE_UNSAFE_CONFIGURE=1 \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    /src/coreutils/configure \
      --host="$(cat /src/vars/TARGET)" \
      --prefix=/usr \
      --disable-nls \
      --disable-acl \
      --disable-rpath \
      --disable-libsmack \
      --disable-xattr \
      --disable-libcap \
      --without-openssl \
      --without-selinux && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage1" install && \
    cd / && \
    rm -rf /build/coreutils-stage1

#stage1-sbase
RUN cp -a /src/sbase-master /build/sbase-stage1 && \
    cd /build/sbase-stage1 && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    make -j$(nproc) \
    CC="clang" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h -static" \
    LDFLAGS="-static -s" && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    make \
    CC="clang" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h -static" \
    CFLAGS="-static" \
    LDFLAGS="-static -s" \
    sbase-box && \
    cp sbase-box /opt/stage1/usr/bin/sbase-box && \
    ln -s sbase-box /opt/stage1/usr/bin/find && \
    ln -s sbase-box /opt/stage1/usr/bin/xargs && \
    cd / && \
    rm -rf /build/sbase-stage1

#stage1-grep
RUN mkdir -p /build/grep-stage1 && \
    cd /build/grep-stage1 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    /src/grep/configure \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage1" install && \
    cd / && \
    rm -rf /build/grep-stage1

#stage1-sed
RUN mkdir -p /build/sed-stage1 && \
    cd /build/sed-stage1 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    /src/sed/configure \
      --host="$(cat /src/vars/TARGET)" \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage1" install && \
    cd / && \
    rm -rf /build/sed-stage1

#stage1-file
RUN mkdir -p /build/file-stage1 && \
    cd /build/file-stage1 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    /src/file/configure \
      --host="$(cat /src/vars/TARGET)" \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage1" install && \
    cd / && \
    rm -rf /build/file-stage1

#stage1-diff
RUN mkdir -p /build/diffutils-stage1 && \
    cd /build/diffutils-stage1 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    /src/diffutils/configure \
      --host="$(cat /src/vars/TARGET)" \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage1" install && \
    cd / && \
    rm -rf /build/diffutils-stage1

#stage1-patch
RUN mkdir -p /build/patch-stage1 && \
    cd /build/patch-stage1 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    /src/patch/configure \
      --host="$(cat /src/vars/TARGET)" \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage1" install && \
    cd / && \
    rm -rf /build/patch-stage1

#stage1-which
RUN mkdir -p /build/which-stage1 && \
    cd /build/which-stage1 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    /src/which/configure \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage1" install && \
    cd / && \
    rm -rf /build/which-stage1

#stage1-pkgconf
RUN mkdir -p /build/pkgconf-stage1 && \
    cd /build/pkgconf-stage1 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    /src/pkgconf/configure \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage1" install && \
    ln -s pkgconf /opt/stage1/usr/bin/pkg-config && \
    cd / && \
    rm -rf /build/pkgconf-stage1

#stage1-make
RUN mkdir -p /build/make-stage1 && \
    cd /build/make-stage1 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    /src/make/configure \
      --prefix=/usr \
      --without-guile \
      --without-dmalloc && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage1" install && \
    cd / && \
    rm -rf /build/make-stage1

#stage1-byacc
RUN ls -lh /usr/bin
RUN mkdir -p /build/byacc-stage1 && \
    cd /build/byacc-stage1 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/byacc/configure \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage1" install && \
    cd / && \
    rm -rf /build/byacc-stage1

#stage1-awk
RUN cp -a /src/awk /build/awk-stage1 && \
    cd /build/awk-stage1 && \
    make YACC="yacc -d" CC="clang" LDFLAGS="-s" CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" && \
    cp a.out /opt/stage1/usr/bin/awk && \
    cd / && \
    rm -rf /build/awk-stage1

#stage1-libbz2
RUN cp -a /src/bzip2 /build/bzip2-stage1 && \
    cd /build/bzip2-stage1 && \
    make -j$(nproc) CC="clang" LDFLAGS="-s" CFLAGS="-fPIC -g0 -Os -include stdc-predef.h" -f Makefile-libbz2_so && \
    make -j$(nproc) CC="clang" LDFLAGS="-s" CFLAGS="-fPIC -g0 -Os -include stdc-predef.h" && \
    cp libbz2.so.$(cat /src/vars/BZIP2_VER) /opt/stage1/usr/lib/ && \
    cp libbz2.a     /opt/stage1/usr/lib/ && \
    cp bzip2-shared /opt/stage1/usr/bin/bzip2 && \
    ln -s bzip2     /opt/stage1/usr/bin/bunzip2 && \
    ln -s bzip2     /opt/stage1/usr/bin/bzcat && \
    ln -s libbz2.so.$(cat /src/vars/BZIP2_VER) /opt/stage1/usr/lib/libbz2.so && \
    ln -s libbz2.so.$(cat /src/vars/BZIP2_VER) /opt/stage1/usr/lib/libbz2.so.1 && \
    ln -s libbz2.so.$(cat /src/vars/BZIP2_VER) /opt/stage1/usr/lib/libbz2.so.1.0 && \
    cp bzlib.h /opt/stage1/usr/include/bzlib.h && \
    cp bzip2.1 /opt/stage1/usr/share/man/man1/bzip2.1 && \
    ln -s bzip2.1 /opt/stage1/usr/share/man/man1/bunzip2.1 && \
    ln -s bzip2.1 /opt/stage1/usr/share/man/man1/bzcat.1 && \
    cd / && \
    rm -rf /build/bzip2-stage1

#stage1-xz
RUN mkdir -p /build/xz-stage1 && \
    cd /build/xz-stage1 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/xz/configure \
      --disable-nls \
      --disable-rpath \
      --disable-scripts \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage1" install && \
    cd / && \
    rm -rf /build/xz-stage1

#stage1-mbedtls
RUN mkdir -p /build/mbedtls-stage1 && \
    cd /build/mbedtls-stage1 && \
    cmake \
      -DCMAKE_INSTALL_PREFIX="/usr" \
      -DCMAKE_RELEASE_TYPE="Release" \
      -DCMAKE_C_COMPILER="clang" \
      -DCMAKE_CXX_COMPILER="clang++" \
      -DUSE_SHARED_MBEDTLS_LIBRARY=ON \
      -DCMAKE_C_FLAGS="-g0 -Os -fPIC" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -fPIC" \
      -DCMAKE_EXE_LINKER_FLAGS="-s" \
      -DCMAKE_SHARED_LINKER_FLAGS="-s" \
      -DCMAKE_SKIP_RPATH=ON \
      /src/mbedtls && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage1" install && \
    cd / && \
    rm -rf /build/mbedtls-stage1

#stage1-curl
RUN mkdir -p /build/curl-stage1 && \
    cd /build/curl-stage1 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/curl/configure \
      --with-mbedtls \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage1" install && \
    cd / && \
    rm -rf /build/curl-stage1

# stage1-libarchive
RUN mkdir -p /build/libarchive-stage1 && \
    cd /build/libarchive-stage1 && \
    cmake \
      -DCMAKE_INSTALL_PREFIX="/usr" \
      -DCMAKE_C_COMPILER="clang" \
      -DCMAKE_CXX_COMPILER="clang++" \
      -DCMAKE_SKIP_RPATH=ON \
      -DCMAKE_C_FLAGS="-g0 -Os -fPIC" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -fPIC" \
      -DCMAKE_EXE_LINKER_FLAGS="-s" \
      -DCMAKE_SHARED_LINKER_FLAGS="-s" \
      /src/libarchive && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage1" install && \
    ln -s bsdtar "/opt/stage1/usr/bin/tar" && \
    ln -s bsdcpio "/opt/stage1/usr/bin/cpio" && \
    cd / && \
    rm -rf /build/libarchive-stage1


#stage1-libffi
RUN mkdir -p /build/libffi-stage1 && \
    cd /build/libffi-stage1 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/libffi/configure \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage1" install && \
    cd / && \
    rm -rf /build/libffi-stage1

#stage1-pcre
RUN mkdir -p /build/pcre-stage1 && \
    cd /build/pcre-stage1 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/pcre/configure \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage1" install && \
    cd / && \
    rm -rf /build/pcre-stage1

#stage1-swig
RUN mkdir -p /build/swig-stage1 && \
    cd /build/swig-stage1 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/swig/configure \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage1" install && \
    cd / && \
    rm -rf /build/swig-stage1

#stage1-perl
RUN cp -r /src/perl /build/perl-stage1 && \
    cd /build/perl-stage1 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    ./configure \
      --prefix=/usr && \
    make && \
    make DESTDIR="/opt/stage1" install && \
    cd / && \
    rm -rf /build/perl-stage1

#stage1-python
RUN cp -a /src/Python2 /build/Python2-stage1 && \
    cd /build/Python2-stage1 && \
    CC="clang" \
    CXX="clang++" \
    ./configure --prefix=/usr --enable-ipv6 && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage1" install && \
    cd / && \
    rm -rf /build/Python2-stage1

#stage1-cmake
RUN cp -a /src/cmake /build/cmake-stage1 && \
    cd /build/cmake-stage1 && \
    cmake \
      -DCMAKE_INSTALL_PREFIX="/usr" \
      -DCMAKE_C_COMPILER="clang" \
      -DCMAKE_CXX_COMPILER="clang++" \
      -DCMAKE_SKIP_RPATH=ON \
      -DCMAKE_C_FLAGS="-g0 -Os -fPIC" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -fPIC" \
      -DCMAKE_EXE_LINKER_FLAGS="-s" \
      -DCMAKE_SHARED_LINKER_FLAGS="-s" \
    . && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage1" install && \
    cd / && \
    rm -rf /build/cmake-stage1

# stage1-csu
RUN cp -a /src/clang-suite-master/csu /build/csu-stage1 && \
    cd /build/csu-stage1 && \
    clang -o crtbegin.o -c crtbegin.c && \
    clang -o crtbeginT.o -static -c crtbegin.c && \
    clang -o crtbeginS.o -fPIC -c crtbegin.c && \
    clang -o crtend.o -c crtend.c && \
    clang -o crtendS.o -c -fPIC crtend.c && \
    cp crtbegin.o  /opt/stage1/usr/lib/crtbegin.o && \
    cp crtbeginS.o /opt/stage1/usr/lib/crtbeginS.o && \
    cp crtbeginT.o /opt/stage1/usr/lib/crtbeginT.o && \
    cp crtend.o    /opt/stage1/usr/lib/crtend.o && \
    cp crtendS.o   /opt/stage1/usr/lib/crtendS.o && \
    cd / && \
    rm -rf /build/csu-stage1

#stage1-libunwind
RUN mkdir -p /build/libunwind-stage1 && \
    cd /build/libunwind-stage1 && \
    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_C_FLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
      -DCMAKE_SKIP_RPATH=ON \
      -DLIBUNWIND_ENABLE_SHARED=OFF \
      -DLLVM_PATH=/src/llvm \
      /src/llvm/projects/libunwind && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage1" install && \
    cd / && \
    rm -rf /build/libunwind-stage1

#stage1-libcxxabi
RUN mkdir -p /build/libcxxabi-stage1 && \
    cd /build/libcxxabi-stage1 && \
    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_C_FLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
      -DCMAKE_SHARED_LINKER_FLAGS="-Wl,--whole-archive -lunwind -Wl,--no-whole-archive" \
      -DCMAKE_SKIP_RPATH=ON \
      -DLIBCXXABI_USE_LLVM_UNWINDER=ON \
      -DLIBCXXABI_LIBCXX_INCLUDES=/src/llvm/projects/libcxx/include \
      -DLIBCXXABI_HAS_CXA_THREAD_ATEXIT_IMPL=OFF \
      -DLLVM_PATH=/src/llvm \
      /src/llvm/projects/libcxxabi && \
    make -j$(nproc) VERBOSE=1 && \
    make DESTDIR="/opt/stage1" install && \
    cd / && \
    rm -rf /build/libcxxabi-stage1

#stage1-libcxx
RUN mkdir -p /build/libcxx-stage1 && \
    cd /build/libcxx-stage1 && \
    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_C_FLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
      -DCMAKE_SKIP_RPATH=ON \
      -DLIBCXX_HAS_MUSL_LIBC=ON \
      -DLIBCXX_HAS_GCC_S_LIB=OFF \
      -DLIBCXX_CXX_ABI=libcxxabi \
      -DLIBCXX_CXX_ABI_INCLUDE_PATHS="/src/llvm/projects/libcxxabi/include" \
      -DLLVM_PATH=/src/llvm \
      /src/llvm/projects/libcxx && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage1" install && \
    cd / && \
    rm -rf /build/libcxx-stage1

#stage1-compiler-rt
RUN mkdir -p /build/compiler-rt-stage1 && \
    cd /build/compiler-rt-stage1 && \
    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_C_FLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
      -DCMAKE_SKIP_RPATH=ON \
      -DCOMPILER_RT_INSTALL_PATH="/usr/lib/clang/$(cat /src/vars/LLVM_VER)" \
      -DCOMPILER_RT_BUILD_SANITIZERS=OFF \
      -DCOMPILER_RT_BUILD_XRAY=OFF \
      -DLLVM_PATH=/src/llvm \
      /src/llvm/projects/compiler-rt && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage1" install && \
    cd / && \
    rm -rf /build/compiler-rt-stage1

#stage1-llvm
RUN mkdir -p /build/llvm-stage1 && \
    cd /build/llvm-stage1 && \
    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_C_FLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
      -DCMAKE_SKIP_RPATH=ON \
      -DLLVM_TOOL_LIBCXXABI_BUILD=OFF \
      -DLLVM_TOOL_LIBCXX_BUILD=OFF \
      -DLLVM_TOOL_LIBUNWIND_BUILD=OFF \
      -DLLVM_TOOL_COMPILER_RT_BUILD=OFF \
      -DLLVM_TOOL_LLDB_BUILD=OFF \
      -DLLVM_ENABLE_ASSERTIONS=ON \
      -DLLVM_ENABLE_LLD=OFF \
      -DLLVM_ENABLE_CXX1Y=ON \
      -DLLVM_ENABLE_FFI=ON \
      -DLLVM_ENABLE_LIBCXX=OFF \
      -DLLVM_ENABLE_PIC=ON \
      -DLLVM_ENABLE_RTTI=ON \
      -DLLVM_ENABLE_SPHINX=OFF \
      -DLLVM_ENABLE_TERMINFO=OFF \
      -DLLVM_ENABLE_ZLIB=ON \
      -DLLVM_TARGET_ARCH="X86" \
      -DLLVM_TARGETS_TO_BUILD="X86" \
      -DLLVM_DEFAULT_TARGET_TRIPLE="$(cat /src/vars/TARGET)" \
      -DGCC_INSTALL_PREFIX="/usr" \
      -DLLVM_BUILD_LLVM_DYLIB=ON \
      -DLLVM_LINK_LLVM_DYLIB=ON \
      -DCLANG_DEFAULT_CXX_STDLIB=libc++ \
      -DCLANG_DEFAULT_RTLIB=compiler-rt \
      -DCLANG_TOOL_EXTRA_BUILD=OFF \
      -DLLVM_TOOL_CLANG_TOOLS_EXTRA_BUILD=OFF \
      -DCLANG_TOOLS_EXTRA_INCLUDE_DOCS=OFF \
      -DCLANG_HAVE_LIBXML=OFF \
      -DFFI_INCLUDE_DIR="/usr/lib/libffi-$(cat /src/vars/LIBFFI_VER)/include/" \
      /src/llvm && \
    make -j$(nproc) && \
    make DESTDIR=/opt/stage1 install && \
    cd / && \
    rm -rf /build/llvm-stage1

RUN find /opt/stage1 -name '*.la' -exec rm {} \; ; \
    mv /opt/stage1/usr/lib64/* /opt/stage1/usr/lib || true

#stage1-end

FROM scratch
COPY --from=1 /opt/stage1 /
COPY --from=1 /opt/stage2 /opt/stage2
COPY --from=1 /opt/stage3 /opt/stage3
COPY --from=1 /src /src

RUN mkdir -p /build

#stage2-coreutils
RUN mkdir -p /build/coreutils-stage2 && \
    cd /build/coreutils-stage2 && \
    FORCE_UNSAFE_CONFIGURE=1 \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/coreutils/configure \
      --host="$(cat /src/vars/TARGET)" \
      --prefix=/usr \
      --disable-nls \
      --disable-acl \
      --disable-rpath \
      --disable-libsmack \
      --disable-xattr \
      --disable-libcap \
      --without-openssl \
      --without-selinux && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage2" install && \
    cd / && \
    rm -rf /build/coreutils-stage2

#stage2-sbase
RUN cp -a /src/sbase-master /build/sbase-stage2 && \
    cd /build/sbase-stage2 && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    make -j$(nproc) \
    CC="clang" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h -static" \
    LDFLAGS="-static -s" && \
    PATH="/opt/gcc-tmp/bin:$PATH" \
    make \
    CC="clang" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h -static" \
    LDFLAGS="-static -s" \
    sbase-box && \
    cp sbase-box /opt/stage2/usr/bin/sbase-box && \
    ln -s sbase-box /opt/stage2/usr/bin/find && \
    ln -s sbase-box /opt/stage2/usr/bin/xargs && \
    cd / && \
    rm -rf /build/sbase-stage2

#stage2-grep
RUN mkdir -p /build/grep-stage2 && \
    cd /build/grep-stage2 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/grep/configure \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage2" install && \
    cd / && \
    rm -rf /build/grep-stage2

#stage2-sed
RUN mkdir -p /build/sed-stage2 && \
    cd /build/sed-stage2 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/sed/configure \
      --host="$(cat /src/vars/TARGET)" \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage2" install && \
    cd / && \
    rm -rf /build/sed-stage2

#stage2-file
RUN mkdir -p /build/file-stage2 && \
    cd /build/file-stage2 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/file/configure \
      --host="$(cat /src/vars/TARGET)" \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage2" install && \
    cd / && \
    rm -rf /build/file-stage2

#stage2-diff
RUN mkdir -p /build/diffutils-stage2 && \
    cd /build/diffutils-stage2 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/diffutils/configure \
      --host="$(cat /src/vars/TARGET)" \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage2" install && \
    cd / && \
    rm -rf /build/diffutils-stage2

#stage2-patch
RUN mkdir -p /build/patch-stage2 && \
    cd /build/patch-stage2 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/patch/configure \
      --host="$(cat /src/vars/TARGET)" \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage2" install && \
    cd / && \
    rm -rf /build/patch-stage2

#stage2-which
RUN mkdir -p /build/which-stage2 && \
    cd /build/which-stage2 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/which/configure \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage2" install && \
    cd / && \
    rm -rf /build/which-stage2

#stage2-pkgconf
RUN mkdir -p /build/pkgconf-stage2 && \
    cd /build/pkgconf-stage2 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/pkgconf/configure \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage2" install && \
    ln -s pkgconf /opt/stage2/usr/bin/pkg-config && \
    cd / && \
    rm -rf /build/pkgconf-stage2

#stage2-mdocml
RUN cp -r /src/mdocml /build/mdocml-stage2 && \
    cd /build/mdocml-stage2 && \
    echo "PREFIX=/usr" > configure.local && \
    echo "MANDIR=/usr/share/man" > configure.local && \
    echo "CC=clang" >> configure.local && \
    echo "CFLAGS=\"-g0 -Os -fPIC\"" >> configure.local && \
    echo "LDFLAGS=\"-s\"" >> configure.local && \
    ./configure && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage2" install && \
    cd / && \
    rm -rf /build/mdocml-stage2

#stage2-make
RUN mkdir -p /build/make-stage2 && \
    cd /build/make-stage2 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/make/configure \
      --prefix=/usr \
      --without-guile \
      --without-dmalloc && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage2" install && \
    cd / && \
    rm -rf /build/make-stage2

#stage2-byacc
RUN mkdir -p /build/byacc-stage2 && \
    cd /build/byacc-stage2 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/byacc/configure \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage2" install && \
    cd / && \
    rm -rf /build/byacc-stage2

#stage2-awk
RUN cp -a /src/awk /build/awk-stage2 && \
    cd /build/awk-stage2 && \
    make YACC="yacc -d" CC="clang" CFLAGS="-g0 -Os" LDFLAGS="-s" && \
    cp a.out /opt/stage2/usr/bin/awk && \
    cd / && \
    rm -rf /build/awk-stage2

#stage2-libbz2
RUN cp -a /src/bzip2 /build/bzip2-stage2 && \
    cd /build/bzip2-stage2 && \
    make -j$(nproc) CC="clang" CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" LDFLAGS="-s" -f Makefile-libbz2_so && \
    make -j$(nproc) CC="clang" CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" LDFLAGS="-s" && \
    cp libbz2.so.$(cat /src/vars/BZIP2_VER) /opt/stage2/usr/lib/ && \
    cp libbz2.a     /opt/stage2/usr/lib/ && \
    cp bzip2-shared /opt/stage2/usr/bin/bzip2 && \
    ln -s bzip2     /opt/stage2/usr/bin/bunzip2 && \
    ln -s bzip2     /opt/stage2/usr/bin/bzcat && \
    ln -s libbz2.so.$(cat /src/vars/BZIP2_VER) /opt/stage2/usr/lib/libbz2.so && \
    ln -s libbz2.so.$(cat /src/vars/BZIP2_VER) /opt/stage2/usr/lib/libbz2.so.1 && \
    ln -s libbz2.so.$(cat /src/vars/BZIP2_VER) /opt/stage2/usr/lib/libbz2.so.1.0 && \
    cp bzlib.h /opt/stage2/usr/include/bzlib.h && \
    cp bzip2.1 /opt/stage2/usr/share/man/man1/bzip2.1 && \
    ln -s bzip2.1 /opt/stage2/usr/share/man/man1/bunzip2.1 && \
    ln -s bzip2.1 /opt/stage2/usr/share/man/man1/bzcat.1 && \
    cd / && \
    rm -rf /build/bzip2-stage2

#stage2-xz
RUN mkdir -p /build/xz-stage2 && \
    cd /build/xz-stage2 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/xz/configure \
      --disable-nls \
      --disable-rpath \
      --disable-scripts \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage2" install && \
    cd / && \
    rm -rf /build/xz-stage2

#stage2-mbedtls
RUN mkdir -p /build/mbedtls-stage2 && \
    cd /build/mbedtls-stage2 && \
    cmake \
      -DCMAKE_INSTALL_PREFIX="/usr" \
      -DCMAKE_RELEASE_TYPE="Release" \
      -DCMAKE_C_COMPILER="clang" \
      -DCMAKE_CXX_COMPILER="clang++" \
      -DUSE_SHARED_MBEDTLS_LIBRARY=ON \
      -DCMAKE_C_FLAGS="-g0 -Os -fPIC" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -fPIC" \
      -DCMAKE_EXE_LINKER_FLAGS="-s" \
      -DCMAKE_SHARED_LINKER_FLAGS="-s" \
      -DCMAKE_SKIP_RPATH=ON \
      /src/mbedtls && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage2" install && \
    cd / && \
    rm -rf /build/mbedtls-stage2

#stage2-curl
RUN mkdir -p /build/curl-stage2 && \
    cd /build/curl-stage2 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/curl/configure \
      --with-mbedtls \
      --with-ca-bundle=/etc/ca-certificates/cacert.pem \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage2" install && \
    cd / && \
    rm -rf /build/curl-stage2

#stage2-libarchive
RUN mkdir -p /build/libarchive-stage2 && \
    cd /build/libarchive-stage2 && \
    cmake \
      -DCMAKE_INSTALL_PREFIX="/usr" \
      -DCMAKE_C_COMPILER="clang" \
      -DCMAKE_CXX_COMPILER="clang++" \
      -DCMAKE_SKIP_RPATH=ON \
      -DCMAKE_C_FLAGS="-g0 -Os -fPIC" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -fPIC" \
      -DCMAKE_EXE_LINKER_FLAGS="-s" \
      -DCMAKE_SHARED_LINKER_FLAGS="-s" \
      /src/libarchive && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage2" install && \
    ln -s bsdtar "/opt/stage2/usr/bin/tar" && \
    ln -s bsdcpio "/opt/stage2/usr/bin/cpio" && \
    cd / && \
    rm -rf /build/libarchive-stage2

#stage2-libffi
RUN mkdir -p /build/libffi-stage2 && \
    cd /build/libffi-stage2 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/libffi/configure \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage2" install && \
    cd / && \
    rm -rf /build/libffi-stage2

#stage2-pcre
RUN mkdir -p /build/pcre-stage2 && \
    cd /build/pcre-stage2 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/pcre/configure \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage2" install && \
    cd / && \
    rm -rf /build/pcre-stage2

#stage2-swig
RUN mkdir -p /build/swig-stage2 && \
    cd /build/swig-stage2 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/swig/configure \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage2" install && \
    cd / && \
    rm -rf /build/swig-stage2

#stage2-perl
RUN cp -r /src/perl /build/perl-stage2 && \
    cd /build/perl-stage2 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    ./configure \
      --prefix=/usr && \
    make && \
    make DESTDIR="/opt/stage2" install && \
    cd / && \
    rm -rf /build/perl-stage2

#stage2-python
RUN cp -a /src/Python2 /build/Python2-stage2 && \
    cd /build/Python2-stage2 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    ./configure --prefix=/usr --enable-ipv6 && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage2" install && \
    cd / && \
    rm -rf /build/Python2-stage2

#stage2-cmake
RUN cp -a /src/cmake /build/cmake-stage2 && \
    cd /build/cmake-stage2 && \
    cmake \
      -DCMAKE_INSTALL_PREFIX="/usr" \
      -DCMAKE_C_COMPILER="clang" \
      -DCMAKE_CXX_COMPILER="clang++" \
      -DCMAKE_C_FLAGS="-g0 -Os -fPIC" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -fPIC" \
      -DCMAKE_EXE_LINKER_FLAGS="-s" \
      -DCMAKE_SHARED_LINKER_FLAGS="-s" \
      -DCMAKE_SKIP_RPATH=ON \
    . && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage2" install && \
    cd / && \
    rm -rf /build/cmake-stage2

# stage2-csu
RUN cp -a /src/clang-suite-master/csu /build/csu-stage2 && \
    cd /build/csu-stage2 && \
    clang -g0 -Os -o crtbegin.o -c crtbegin.c && \
    clang -g0 -Os -o crtbeginT.o -static -c crtbegin.c && \
    clang -g0 -Os -o crtbeginS.o -fPIC -c crtbegin.c && \
    clang -g0 -Os -o crtend.o -c crtend.c && \
    clang -g0 -Os -o crtendS.o -c -fPIC crtend.c && \
    cp crtbegin.o  /opt/stage2/usr/lib/crtbegin.o && \
    cp crtbeginS.o /opt/stage2/usr/lib/crtbeginS.o && \
    cp crtbeginT.o /opt/stage2/usr/lib/crtbeginT.o && \
    cp crtend.o    /opt/stage2/usr/lib/crtend.o && \
    cp crtendS.o   /opt/stage2/usr/lib/crtendS.o && \
    cd / && \
    rm -rf /build/csu-stage2

#stage2-libunwind
RUN mkdir -p /build/libunwind-stage2 && \
    cd /build/libunwind-stage2 && \
    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_C_FLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
      -DCMAKE_SKIP_RPATH=ON \
      -DLIBUNWIND_ENABLE_SHARED=OFF \
      -DLLVM_PATH=/src/llvm \
      /src/llvm/projects/libunwind && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage2" install && \
    cd / && \
    rm -rf /build/libunwind-stage2

#stage2-libcxxabi
RUN mkdir -p /build/libcxxabi-stage2 && \
    cd /build/libcxxabi-stage2 && \
    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_C_FLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
      -DCMAKE_SHARED_LINKER_FLAGS="-Wl,--whole-archive -lunwind -Wl,--no-whole-archive" \
      -DCMAKE_SKIP_RPATH=ON \
      -DLIBCXXABI_USE_LLVM_UNWINDER=ON \
      -DLIBCXXABI_LIBCXX_INCLUDES=/src/llvm/projects/libcxx/include \
      -DLIBCXXABI_HAS_CXA_THREAD_ATEXIT_IMPL=OFF \
      -DLLVM_PATH=/src/llvm \
      /src/llvm/projects/libcxxabi && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage2" install && \
    cd / && \
    rm -rf /build/libcxxabi-stage2

#stage2-libcxx
RUN mkdir -p /build/libcxx-stage2 && \
    cd /build/libcxx-stage2 && \
    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_C_FLAGS="-g0 -Os -include stdc-predef.h" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -include stdc-predef.h" \
      -DCMAKE_SKIP_RPATH=ON \
      -DLIBCXX_HAS_MUSL_LIBC=ON \
      -DLIBCXX_HAS_GCC_S_LIB=OFF \
      -DLIBCXX_CXX_ABI=libcxxabi \
      -DLIBCXX_CXX_ABI_INCLUDE_PATHS="/src/llvm/projects/libcxxabi/include" \
      -DLLVM_PATH=/src/llvm \
      /src/llvm/projects/libcxx && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage2" install && \
    cd / && \
    rm -rf /build/libcxx-stage2

#stage2-compiler-rt
RUN mkdir -p /build/compiler-rt-stage2 && \
    cd /build/compiler-rt-stage2 && \
    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_C_FLAGS="-g0 -Os -include stdc-predef.h" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -include stdc-predef.h" \
      -DCMAKE_SKIP_RPATH=ON \
      -DCOMPILER_RT_INSTALL_PATH="/usr/lib/clang/$(cat /src/vars/LLVM_VER)" \
      -DCOMPILER_RT_BUILD_SANITIZERS=OFF \
      -DCOMPILER_RT_BUILD_XRAY=OFF \
      -DLLVM_PATH=/src/llvm \
      /src/llvm/projects/compiler-rt && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage2" install && \
    cd / && \
    rm -rf /build/compiler-rt-stage2

#stage2-llvm
RUN mkdir -p /build/llvm-stage2 && \
    cd /build/llvm-stage2 && \
    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_C_FLAGS="-g0 -Os -include stdc-predef.h" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -include stdc-predef.h" \
      -DCMAKE_SKIP_RPATH=ON \
      -DLLVM_TOOL_LIBCXXABI_BUILD=OFF \
      -DLLVM_TOOL_LIBCXX_BUILD=OFF \
      -DLLVM_TOOL_LIBUNWIND_BUILD=OFF \
      -DLLVM_TOOL_COMPILER_RT_BUILD=OFF \
      -DLLVM_TOOL_LLDB_BUILD=OFF \
      -DLLVM_ENABLE_ASSERTIONS=ON \
      -DLLVM_ENABLE_LLD=OFF \
      -DLLVM_ENABLE_CXX1Y=ON \
      -DLLVM_ENABLE_FFI=ON \
      -DLLVM_ENABLE_LIBCXX=ON \
      -DLLVM_ENABLE_PIC=ON \
      -DLLVM_ENABLE_RTTI=ON \
      -DLLVM_ENABLE_SPHINX=OFF \
      -DLLVM_ENABLE_TERMINFO=OFF \
      -DLLVM_ENABLE_ZLIB=ON \
      -DLLVM_TARGET_ARCH="X86" \
      -DLLVM_TARGETS_TO_BUILD="X86" \
      -DLLVM_DEFAULT_TARGET_TRIPLE="$(cat /src/vars/TARGET)" \
      -DLLVM_BUILD_LLVM_DYLIB=ON \
      -DLLVM_LINK_LLVM_DYLIB=ON \
      -DCLANG_DEFAULT_CXX_STDLIB=libc++ \
      -DCLANG_DEFAULT_RTLIB=compiler-rt \
      -DCLANG_TOOL_EXTRA_BUILD=OFF \
      -DLLVM_TOOL_CLANG_TOOLS_EXTRA_BUILD=OFF \
      -DCLANG_TOOLS_EXTRA_INCLUDE_DOCS=OFF \
      -DCLANG_HAVE_LIBXML=OFF \
      -DFFI_INCLUDE_DIR="/usr/lib/libffi-$(cat /src/vars/LIBFFI_VER)/include/" \
      /src/llvm && \
    make -j$(nproc) && \
    make DESTDIR=/opt/stage2 install && \
    cd / && \
    rm -rf /build/llvm-stage2

RUN rm -f /opt/stage2/usr/bin/cc  && \
    rm -f /opt/stage2/usr/bin/gcc && \
    rm -f /opt/stage2/usr/bin/c++ && \
    rm -f /opt/stage2/usr/bin/g++ && \
    rm -f /opt/stage2/usr/bin/ld  && \
    rm -f /opt/stage2/usr/bin/ar  && \
    rm -f /opt/stage2/usr/bin/nm  && \
    rm -f /opt/stage2/usr/bin/ranlib  && \
    rm -f /opt/stage2/usr/bin/strings  && \
    rm -f /opt/stage2/usr/bin/c++filt  && \
    rm -f /opt/stage2/usr/bin/objdump  && \
    rm -f /opt/stage2/usr/bin/size && \
    ln -s clang        /opt/stage2/usr/bin/cc  && \
    ln -s clang        /opt/stage2/usr/bin/gcc && \
    ln -s clang++      /opt/stage2/usr/bin/c++ && \
    ln -s clang++      /opt/stage2/usr/bin/g++ && \
    ln -s lld          /opt/stage2/usr/bin/ld  && \
    ln -s llvm-ar      /opt/stage2/usr/bin/ar  && \
    ln -s llvm-nm      /opt/stage2/usr/bin/nm  && \
    ln -s llvm-ranlib  /opt/stage2/usr/bin/ranlib  && \
    ln -s llvm-strings /opt/stage2/usr/bin/strings  && \
    ln -s llvm-cxxfilt /opt/stage2/usr/bin/c++filt  && \
    ln -s llvm-objdump /opt/stage2/usr/bin/objdump  && \
    ln -s llvm-size    /opt/stage2/usr/bin/size

RUN find /opt/stage2 -name '*.la' -exec rm {} \; ; \
    mv /opt/stage2/usr/lib64/* /opt/stage2/usr/lib || true

#stage2-end

FROM scratch
COPY --from=2 /opt/stage2 /
COPY --from=2 /opt/stage3 /opt/stage3
COPY --from=2 /src /src

#stage3-libunwind
RUN mkdir -p /build/libunwind-stage3 && \
    cd /build/libunwind-stage3 && \
    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_C_FLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
      -DLIBUNWIND_ENABLE_SHARED=OFF \
      -DLLVM_PATH=/src/llvm \
      /src/llvm/projects/libunwind && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage3" install && \
    cd / && \
    rm -rf /build/libunwind-stage3

#stage3-libcxxabi
RUN mkdir -p /build/libcxxabi-stage3 && \
    cd /build/libcxxabi-stage3 && \
    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_SKIP_RPATH=ON \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_C_FLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
      -DCMAKE_SHARED_LINKER_FLAGS="-Wl,--whole-archive -lunwind -Wl,--no-whole-archive" \
      -DLIBCXXABI_USE_LLVM_UNWINDER=ON \
      -DLIBCXXABI_LIBCXX_INCLUDES=/src/llvm/projects/libcxx/include \
      -DLIBCXXABI_HAS_CXA_THREAD_ATEXIT_IMPL=OFF \
      -DLLVM_PATH=/src/llvm \
      /src/llvm/projects/libcxxabi && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage3" install && \
    cd / && \
    rm -rf /build/libcxxabi-stage3

#stage3-libcxx
RUN mkdir -p /build/libcxx-stage3 && \
    cd /build/libcxx-stage3 && \
    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_SKIP_RPATH=ON \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_C_FLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
      -DCMAKE_EXE_LINKER_FLAGS="-s" \
      -DLIBCXX_HAS_MUSL_LIBC=ON \
      -DLIBCXX_HAS_GCC_S_LIB=OFF \
      -DLIBCXX_CXX_ABI=libcxxabi \
      -DLIBCXX_CXX_ABI_INCLUDE_PATHS="/src/llvm/projects/libcxxabi/include" \
      -DLLVM_PATH=/src/llvm \
      /src/llvm/projects/libcxx && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage3" install && \
    cd / && \
    rm -rf /build/libcxx-stage3

#stage3-compiler-rt
RUN mkdir -p /build/compiler-rt-stage3 && \
    cd /build/compiler-rt-stage3 && \
    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_SKIP_RPATH=ON \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_C_FLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
      -DCMAKE_EXE_LINKER_FLAGS="-s" \
      -DCOMPILER_RT_BUILD_SANITIZERS=OFF \
      -DCOMPILER_RT_BUILD_XRAY=OFF \
      -DCOMPILER_RT_INSTALL_PATH="/usr/lib/clang/$(cat /src/vars/LLVM_VER)" \
      -DLLVM_PATH=/src/llvm \
      /src/llvm/projects/compiler-rt && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage3" install && \
    cd / && \
    rm -rf /build/compiler-rt-stage3

#stage3-llvm
RUN mkdir -p /build/llvm-stage3 && \
    cd /build/llvm-stage3 && \
    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_SKIP_RPATH=ON \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_C_FLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
      -DCMAKE_EXE_LINKER_FLAGS="-s" \
      -DLLVM_TOOL_LIBCXXABI_BUILD=OFF \
      -DLLVM_TOOL_LIBCXX_BUILD=OFF \
      -DLLVM_TOOL_LIBUNWIND_BUILD=OFF \
      -DLLVM_TOOL_COMPILER_RT_BUILD=OFF \
      -DLLVM_TOOL_LLDB_BUILD=ON \
      -DLLVM_ENABLE_ASSERTIONS=ON \
      -DLLVM_ENABLE_LLD=ON \
      -DLLVM_ENABLE_CXX1Y=ON \
      -DLLVM_ENABLE_FFI=ON \
      -DLLVM_ENABLE_LIBCXX=ON \
      -DLLVM_ENABLE_PIC=ON \
      -DLLVM_ENABLE_RTTI=ON \
      -DLLVM_ENABLE_SPHINX=OFF \
      -DLLVM_ENABLE_TERMINFO=OFF \
      -DLLVM_ENABLE_ZLIB=ON \
      -DLLVM_BUILD_LLVM_DYLIB=ON \
      -DLLVM_LINK_LLVM_DYLIB=ON \
      -DCLANG_DEFAULT_CXX_STDLIB=libc++ \
      -DCLANG_DEFAULT_RTLIB=compiler-rt \
      -DLLVM_DEFAULT_TARGET_TRIPLE="$(cat /src/vars/TARGET)" \
      -DCLANG_TOOL_EXTRA_BUILD=ON \
      -DLLVM_TOOL_CLANG_TOOLS_EXTRA_BUILD=ON \
      -DCLANG_TOOLS_EXTRA_INCLUDE_DOCS=OFF \
      -DCLANG_HAVE_LIBXML=OFF \
      -DFFI_INCLUDE_DIR="/usr/lib/libffi-$(cat /src/vars/LIBFFI_VER)/include/" \
      /src/llvm && \
    make -j$(nproc) && \
    make DESTDIR=/opt/stage3 install && \
    cd / && \
    rm -rf /build/llvm-stage3

#stage3-netbsd-curses
RUN cp -a /src/netbsd-curses /build/netbsd-curses-stage3 && \
    cd /build/netbsd-curses-stage3 && \
    make \
    CC="clang" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    PREFIX="/usr" \
    install && \
    make \
    CC="clang" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    PREFIX="/usr" \
    DESTDIR="/opt/stage3" \
    LDFLAGS="-s" \
    install && \
    cd / && \
    rm -rf /build-netbsd-curses-stage3

#stage3-libedit
RUN mkdir -p /build/libedit-stage3 && \
    cd /build/libedit-stage3 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/libedit/configure \
      --prefix=/usr && \
    PATH="/opt/gcc-tmp/bin:$PATH" make && \
    PATH="/opt/gcc-tmp/bin:$PATH" make DESTDIR="/opt/stage3" install && \
    ln -s libedit.pc /opt/stage3/usr/lib/pkgconfig/readline.pc && \
    ln -s libedit.a /opt/stage3/usr/lib/libreadline.a && \
    ln -s libedit.so /opt/stage3/usr/lib/libreadline.so && \
    mkdir -p /opt/stage3/usr/include/readline && \
    ln -sf ../editline/readline.h /opt/stage3/usr/include/readline/readline.h && \
    touch /opt/stage3/usr/include/readline/history.h && \
    touch /opt/stage3/usr/include/readline/tilde.h && \
    cd / && \
    rm -rf /build/libedit-stage3

#stage3-zlib
RUN cp -a /src/zlib /build/zlib-stage3 && \
    cd /build/zlib-stage3 && \
    CC="clang" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    ./configure --shared --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage3" install && \
    cd / && \
    rm -rf /build/zlib-stage3

#stage3-pigz
RUN cp -a /src/pigz /build/pigz-stage3 && \
    cd /build/pigz-stage3 && \
    make -j$(nproc) \
    CC="clang" \
    AR="llvm-ar" \
    RANLIB="llvm-ranlib" \
    LDFLAGS="-s" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" && \
    cp pigz /opt/stage3/usr/bin/pigz && \
    ln -s pigz /opt/stage3/usr/bin/unpigz && \
    ln -s pigz /opt/stage3/usr/bin/gzip && \
    ln -s pigz /opt/stage3/usr/bin/gunzip && \
    ln -s pigz /opt/stage3/usr/bin/zcat && \
    ln -s pigz /opt/stage3/usr/bin/gzcat && \
    cd / && \
    rm -rf /build/pigz-stage3

#stage3-libbz2
RUN cp -a /src/bzip2 /build/bzip2-stage3 && \
    cd /build/bzip2-stage3 && \
    make -j$(nproc) CC="clang" CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" LDFLAGS="-s" -f Makefile-libbz2_so && \
    make -j$(nproc) CC="clang" CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" LDFLAGS="-s" && \
    cp libbz2.so.$(cat /src/vars/BZIP2_VER) /opt/stage3/usr/lib/ && \
    cp libbz2.a     /opt/stage3/usr/lib/ && \
    cp bzip2-shared /opt/stage3/usr/bin/bzip2 && \
    ln -s bzip2     /opt/stage3/usr/bin/bunzip2 && \
    ln -s bzip2     /opt/stage3/usr/bin/bzcat && \
    ln -s libbz2.so.$(cat /src/vars/BZIP2_VER) /opt/stage3/usr/lib/libbz2.so && \
    ln -s libbz2.so.$(cat /src/vars/BZIP2_VER) /opt/stage3/usr/lib/libbz2.so.1 && \
    ln -s libbz2.so.$(cat /src/vars/BZIP2_VER) /opt/stage3/usr/lib/libbz2.so.1.0 && \
    cp bzlib.h /opt/stage3/usr/include/bzlib.h && \
    mkdir -p /opt/stage3/usr/share/man/man1 && \
    cp bzip2.1 /opt/stage3/usr/share/man/man1/bzip2.1 && \
    ln -s bzip2.1 /opt/stage3/usr/share/man/man1/bunzip2.1 && \
    ln -s bzip2.1 /opt/stage3/usr/share/man/man1/bzcat.1 && \
    cd / && \
    rm -rf /build/bzip2-stage3

#stage3-xz
RUN mkdir -p /build/xz-stage3 && \
    cd /build/xz-stage3 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/xz/configure \
      --disable-nls \
      --disable-rpath \
      --disable-scripts \
      --prefix=/usr && \
    make && \
    make DESTDIR="/opt/stage3" install && \
    cd / && \
    rm -rf /build/xz-stage3

#stage3-mbedtls
RUN mkdir -p /build/mbedtls-stage3 && \
    cd /build/mbedtls-stage3 && \
    cmake \
      -DCMAKE_INSTALL_PREFIX="/usr" \
      -DCMAKE_RELEASE_TYPE="Release" \
      -DCMAKE_C_COMPILER="clang" \
      -DCMAKE_CXX_COMPILER="clang++" \
      -DCMAKE_C_FLAGS="-g0 -Os -fPIC" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -fPIC" \
      -DCMAKE_EXE_LINKER_FLAGS="-s" \
      -DCMAKE_SHARED_LINKER_FLAGS="-s" \
      -DUSE_SHARED_MBEDTLS_LIBRARY=ON \
      /src/mbedtls && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage3" install && \
    cd / && \
    rm -rf /build/mbedtls-stage3

#stage3-curl
RUN mkdir -p /build/curl-stage3 && \
    cd /build/curl-stage3 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/curl/configure \
      --with-mbedtls \
      --with-gnu-ld \
      --with-ca-bundle=/etc/ca-certificates/cacert.pem \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage3" install && \
    cd / && \
    rm -rf /build/curl-stage3

#stage3-libffi
RUN mkdir -p /build/libffi-stage3 && \
    cd /build/libffi-stage3 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/libffi/configure \
      --with-gnu-ld \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage3" install && \
    cd / && \
    rm -rf /build/libffi-stage3

#stage3-sbase
RUN cp -a /src/sbase-master /build/sbase-stage3 && \
    cd /build/sbase-stage3 && \
    make \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    CC="clang" \
    PREFIX="/usr" -j$(nproc) && \
    make \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CC="clang" \
    PREFIX="/usr" \
    DESTDIR="/opt/stage3" \
    LDFLAGS="-s" \
    install && \
    cd / && \
    rm -rf /build/sbase-stage3

#stage3-dash
RUN mkdir -p /build/dash-stage3 && \
    cd /build/dash-stage3 && \
    CC="clang -fPIC" \
    CXX="clang++ -fPIC" \
    CFLAGS="-g0 -Os -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/dash/configure \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage3" install && \
    ln -s dash /opt/stage3/usr/bin/sh && \
    cd / && \
    rm -rf /build/dash-stage3

#stage3-libarchive
RUN mkdir -p /build/libarchive-stage3 && \
    cd /build/libarchive-stage3 && \
    cmake \
      -DCMAKE_INSTALL_PREFIX="/usr" \
      -DCMAKE_C_COMPILER="clang" \
      -DCMAKE_CXX_COMPILER="clang++" \
      -DCMAKE_C_FLAGS="-g0 -Os -fPIC" \
      -DCMAKE_CXX_FLAGS="-g0 -Os -fPIC" \
      -DCMAKE_EXE_LINKER_FLAGS="-s" \
      -DCMAKE_SHARED_LINKER_FLAGS="-s" \
      /src/libarchive && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage3" install && \
    rm -f /opt/stage3/usr/bin/tar && \
    rm -rf /opt/stage3/usr/bin/cpio && \
    ln -s bsdtar /opt/stage3/usr/bin/tar && \
    ln -s bsdcpio /opt/stage3/usr/bin/cpio && \
    cd / && \
    rm -rf /build/libarchive-stage3

#stage3-csu
RUN cp -a /src/clang-suite-master/csu /build/csu-stage3 && \
    cd /build/csu-stage3 && \
    clang -g0 -Os -o crtbegin.o -c crtbegin.c && \
    clang -g0 -Os -o crtbeginT.o -static -c crtbegin.c && \
    clang -g0 -Os -o crtbeginS.o -fPIC -c crtbegin.c && \
    clang -g0 -Os -o crtend.o -c crtend.c && \
    clang -g0 -Os -o crtendS.o -c -fPIC crtend.c && \
    cp crtbegin.o  /opt/stage3/usr/lib/crtbegin.o && \
    cp crtbeginS.o /opt/stage3/usr/lib/crtbeginS.o && \
    cp crtbeginT.o /opt/stage3/usr/lib/crtbeginT.o && \
    cp crtend.o    /opt/stage3/usr/lib/crtend.o && \
    cp crtendS.o   /opt/stage3/usr/lib/crtendS.o && \
    cd / && \
    rm -rf /build/csu-stage3

#stage3-linux-headers
RUN cp -a /src/linux /build/linux-stage3 && \
    cd /build/linux-stage3 && \
    make \
    CC="clang -fPIC" \
    HOSTCC="clang -fPIC" \
    ARCH=x86_64 \
    INSTALL_HDR_PATH="/opt/stage3/usr" headers_install && \
    cd / && \
    rm -rf /build/linux-stage3

#stage3-musl
RUN cp /usr/lib/clang/4.0.0/lib/linux/libclang_rt.builtins-x86_64.a /usr/lib/libcompiler_rt.a && \
    mkdir -p /build/musl-stage3 && \
    cd /build/musl-stage3 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-fPIC -g0 -Os" \
    LDFLAGS="-s" \
    /src/musl/configure \
      --prefix=/usr \
      --disable-wrapper && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage3" install && \
    cd / && \
    rm -rf /build/musl-stage3

#stage3-file
RUN mkdir -p /build/file-stage3 && \
    cd /build/file-stage3 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/file/configure \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage3" install && \
    cd / && \
    rm -rf /build/file-stage3

#stage3-bmake
RUN cp -a /src/bmake /build/bmake-stage3 && \
    cd /build/bmake-stage3 && \
    echo "root:x:0:0:root:/root:/bin/sh" > /etc/passwd && \
    echo "root:x:0:root" > /etc/group && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    ./configure \
      --prefix=/usr && \
    make prefix=/usr || \
    cp unit-tests/dotwait.exp unit-tests/dotwait.out && \
    echo 0 > unit-tests/dotwait.status && \
    make prefix=/usr STRIP_FLAG="" INSTALL=/usr/bin/install DESTDIR=/opt/stage3 install && \
    ln -s bmake /opt/stage3/usr/bin/make && \
    cd / && \
    rm -rf /build/bmake-stage3 && \
    rm /etc/passwd && \
    rm /etc/group

#stage3-byacc
RUN mkdir -p /build/byacc-stage3 && \
    cd /build/byacc-stage3 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/byacc/configure \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage3" install && \
    cd / && \
    rm -rf /build/byacc-stage3

#stage3-awk
RUN cp -a /src/awk /build/awk-stage3 && \
    cd /build/awk-stage3 && \
    make YACC="yacc -d" CC="clang" CFLAGS="-g0 -Os -fPIC" LDFLAGS="-s" && \
    cp -a a.out /opt/stage3/usr/bin/nawk && \
    ln -s nawk /opt/stage3/usr/bin/awk && \
    cd / && \
    rm -rf /build/awk-stage3

#stage3-python2
RUN cp -a /src/Python2 /build/Python2-stage3 && \
    cd /build/Python2-stage3 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC" \
    CXXFLAGS="-g0 -Os -fPIC" \
    LDFLAGS="-s" \
    ./configure --prefix=/usr --enable-ipv6 && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage3" install && \
    cd / && \
    rm -rf /build/Python2-stage3

#stage3-pkgconf
RUN mkdir -p /build/pkgconf-stage3 && \
    cd /build/pkgconf-stage3 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/pkgconf/configure \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage3" install && \
    ln -s pkgconf /opt/stage3/usr/bin/pkg-config && \
    cd / && \
    rm -rf /build/pkgconf-stage3

#stage3-mdocml
RUN cp -r /src/mdocml /build/mdocml-stage3 && \
    cd /build/mdocml-stage3 && \
    echo "PREFIX=/usr" > configure.local && \
    echo "MANDIR=/usr/share/man" > configure.local && \
    echo "CC=clang" >> configure.local && \
    echo "CFLAGS=\"-g0 -Os -fPIC\"" >> configure.local && \
    echo "LDFLAGS=\"-s\"" >> configure.local && \
    ./configure && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage3" install && \
    cd / && \
    rm -rf /build/mdocml-stage3

#stage3-less
RUN mkdir -p /build/less-stage3 && \
    cd /build/less-stage3 && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    /src/less/configure \
      --sysconfdir=/etc \
      --prefix=/usr && \
    make -j$(nproc) && \
    make DESTDIR="/opt/stage3" install && \
    ln -s less /opt/stage3/usr/bin/more && \
    cd / && \
    rm -rf /build/less-stage3

#stage3-perl
RUN cp -r /src/perl /build/perl-stage3 && \
    cd /build/perl-stage3 && \
    rm -f /usr/bin/readelf && \
    echo "#!/bin/sh" > /usr/bin/readelf && \
    echo "for last; do true; done" >> /usr/bin/readelf && \
    echo "exec /usr/bin/llvm-readobj -elf-output-style=GNU --symbols \"\$last\"" >> /usr/bin/readelf && \
    chmod +x /usr/bin/readelf && \
    CC="clang" \
    CXX="clang++" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    CXXFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    ./configure \
      --host="$(cat /src/vars/TARGET)" \
      --prefix=/usr && \
    make && \
    make DESTDIR="/opt/stage3" install && \
    cd / && \
    rm -rf /build/perl-stage3 && \
    rm -f /usr/bin/readelf


#stage3-vim
RUN cp -r /src/vim /build/vim && \
    cd /build/vim && \
    CC="clang" \
    CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" \
    LDFLAGS="-s" \
    ./configure \
      --disable-nls \
      --with-features=tiny \
      --prefix=/usr && \
    make CFLAGS="-g0 -Os -fPIC -include stdc-predef.h" && \
    make DESTDIR=/opt/stage3 install && \
    ln -s vim /opt/stage3/usr/bin/vi && \
    cd / && \
    rm -rf /build/vim

RUN rm -f /opt/stage3/usr/bin/cc  && \
    rm -f /opt/stage3/usr/bin/gcc && \
    rm -f /opt/stage3/usr/bin/c++ && \
    rm -f /opt/stage3/usr/bin/g++ && \
    rm -f /opt/stage3/usr/bin/ld  && \
    rm -f /opt/stage3/usr/bin/ar  && \
    rm -f /opt/stage3/usr/bin/nm  && \
    rm -f /opt/stage3/usr/bin/ranlib  && \
    rm -f /opt/stage3/usr/bin/strings  && \
    rm -f /opt/stage3/usr/bin/c++filt  && \
    rm -f /opt/stage3/usr/bin/objdump  && \
    rm -f /opt/stage3/usr/bin/size && \
    ln -s clang        /opt/stage3/usr/bin/cc  && \
    ln -s clang        /opt/stage3/usr/bin/gcc && \
    ln -s clang++      /opt/stage3/usr/bin/c++ && \
    ln -s clang++      /opt/stage3/usr/bin/g++ && \
    ln -s lld          /opt/stage3/usr/bin/ld  && \
    ln -s llvm-ar      /opt/stage3/usr/bin/ar  && \
    ln -s llvm-nm      /opt/stage3/usr/bin/nm  && \
    ln -s llvm-ranlib  /opt/stage3/usr/bin/ranlib  && \
    ln -s llvm-strings /opt/stage3/usr/bin/strings  && \
    ln -s llvm-cxxfilt /opt/stage3/usr/bin/c++filt  && \
    ln -s llvm-objdump /opt/stage3/usr/bin/objdump  && \
    ln -s llvm-size    /opt/stage3/usr/bin/size

RUN find /opt/stage3 -name '*.la' -exec rm {} \; ; \
    mv /opt/stage3/usr/lib64/* /opt/stage3/usr/lib || true

FROM scratch
COPY --from=3 /opt/stage3 /
RUN makewhatis
