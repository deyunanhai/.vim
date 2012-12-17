#/bin/bash

#Get the required tools.
#See Getting Started with the LLVM System - Requirements.
#Note also that Python is needed for running the test suite. Get it at: http://www.python.org/download
#Checkout LLVM:
#Change directory to where you want the llvm directory placed.
mkdir clang_temp
cd clang_temp
svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm
#Checkout Clang:
cd llvm/tools
svn co http://llvm.org/svn/llvm-project/cfe/trunk clang
cd ../..
#Checkout extra Clang Tools: (optional)
cd llvm/tools/clang/tools
svn co http://llvm.org/svn/llvm-project/clang-tools-extra/trunk extra
cd ../../../..
#Checkout Compiler-RT:
cd llvm/projects
svn co http://llvm.org/svn/llvm-project/compiler-rt/trunk compiler-rt
cd ../..
#Build LLVM and Clang:
mkdir build
cd build
../llvm/configure
make
make install
if [ $? -ne 0 ] ; then
    echo "install failed please do it manual"
else
    cd .. &&  rm -rf clang_temp
fi
#This builds both LLVM and Clang for debug mode.
#Note: For subsequent Clang development, you can just do make at the clang directory level.
#It is also possible to use CMake instead of the makefiles. With CMake it is possible to generate project files for several IDEs: Xcode, Eclipse CDT4, CodeBlocks, Qt-Creator (use the CodeBlocks generator), KDevelop3.
#If you intend to work on Clang C++ support, you may need to tell it how to find your C++ standard library headers. In general, Clang will detect the best version of libstdc++ headers available and use them - it will look both for system installations of libstdc++ as well as installations adjacent to Clang itself. If your configuration fits neither of these scenarios, you can use the --with-gcc-toolchain configure option to tell Clang where the gcc containing the desired libstdc++ is installed.
#Try it out (assuming you add llvm/Debug+Asserts/bin to your path):
#clang --help
#clang file.c -fsyntax-only (check for correctness)
#clang file.c -S -emit-llvm -o - (print out unoptimized llvm code)
#clang file.c -S -emit-llvm -o - -O3
#clang file.c -S -O3 -o - (output native machine code)
