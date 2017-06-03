#docker-nongnu

This is a Docker image for building a toolchain that is devoid of
any GNU (or GPL, for that matter) software.

## Why?

Mostly to see if it's do-able and to figure out how to do it. I'm not
gonna lie, this took a lot of researching and even more trial and
error to figure out.

I can think of a few uses for this image:

* you're looking to build a proprietary product and want to ensure
  there's no hint of GPL code in your output
* you want to test your code against BSD-style tools, alternative
  libraries, etc
* you want to distribute a statically-compiled program and use c++ - 
  it's fairly difficult to produce a truly static executable against
  the regular glibc/libstdc++/libgcc_s stack. This will let you do it
  without any fuss.

## Details

There's a *lot* of steps and this takes a long time to build.
I believe it's possible to reduce the time required, but I had a hard
time figuring out the exact required flags to say, cross-compile
LLVM when using a Clang that defaults to libstdc++.

1. Pre-stage0: build cross-compiler, download + extract sources
2. Stage 0 (introduce musl)
  * libc: musl
  * gcc: installed
  * binutils: installed
  * clang:
    * linked against libstdc++, libgcc_s
    * produces exe's linked against libstdc++, libgcc_s
3. Stage 1 (introduce libc++/compiler-rt)
  * libc: musl
  * gcc: installed
  * binutils: installed
  * clang:
    * linked against libstdc++, libgcc_s
    * produces exe's linked against libc++, compiler-rt
4. Stage 2 (remove gcc, binutils)
  * libc: musl
  * gcc: not installed
  * binutils: not installed
  * clang:
    * linked against libc++, compiler-rt
    * produces exe's linked against libc++, compiler-rt
5. Stage 3 (remove remaining GNU/GPL software, final output)
  * libc: musl
  * gcc: not installed
  * binutils: not installed
  * clang:
    * linked against libc++, compiler-rt
    * produces exe's linked against libc++, compiler-rt

The transitory images use some GNU packages, like coreutils, grep, sed, etc - the final output
image has no GNU or GPL'd software.

Installed packages and their type of license:

* musl (MIT)
* LLVM (University of Illinois/NCSA)
* netbsd-curses (BSD 3-clause)
* libedit (BSD 3-clause)
* file (BSD 2-clause)
* bmake (BSD 3-clause)
* mbed TLS (Apache)
* cURL (MIT)
* awk (MIT)
* byacc (Public Domain)
* zlib (zlib)
* bzip2 (BSD 4-clause)
* xz (Public Domain)
* libarchive (BSD 2-clause)
* dash (BSD 3-clause)
* sbase (MIT)
* libffi (MIT)
* pigz (BSD 3-clause)
* pathscale CRT (BSD 2-clause)
* linux headers (N/A license-wise, see http://elinux.org/Legal_Issues#Use_of_kernel_header_files_in_user-space)
* perl5 (Artistic License)
* python2 (PSFL)
* pkgconf (ISC)
* mdocml (ISC)
* less (BSD 2-clause)
* Mozilla CA Certs (Mozilla Public License)
* vim (vim license)

