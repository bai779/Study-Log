## CMake

+ 跨平台自动化构建系统，用来管理软件建置的程序，并不依赖于某特定编译器，并可支持多层目录，多个应用程序与多个函数库 
+ CMake本身不是构建工具，而是生成构建系统的工具，它生成的构建系统可以使用不同的编译器和工具链

### 构建配置

+ CMakeLists.txt文件：CMake的配置文件，用于定义项目的构建规则、依赖关系、编译选项等。每个CMake项目通常包含一个或多个CMakeLists.txt文件
+ 构建目录：为了保持源代码的整洁，CMake鼓励使用独立的构建目录（out-of-source构建）。这样构建生成的文件和源代码分开存放。

### 基本工作流程

1. **编写CMakeLists.txt文件**:定义项目的构建规则和依赖关系
2. **生成构建文件**:使用CMake生成适合当前平台的构建系统文件(Makefile,Visual Studio工程文件)
3. **执行构建**:使用生成的构建系统文件(make,ninja,msbuild)来编译项目

----

### CMake工作流程

1. 创建项目结构
   ```ruby
   MyProject/
   ├── CMakeLists.txt            # 项目的 CMake 配置文件,包含项目的基本信息和CMake配置
   ├── src/                      # 源代码目录
   │   ├── main.cpp              # 主程序文件
   │   └── module.cpp            # 其他模块的源代码文件
   ├── include/                  # 头文件目录
   │   └── module.h              # 模块头文件
   ├── build/                    # 构建目录（通常是空的）
   └── README.md                 # 项目的文档说明
   ```

   + 为了分离源代码和构建文件,通常创建一个**构建目录**,`build/`保证源代码目录中不会产生不必要的文件

2. 编写CMakeLists.txt

   + 在项目的根目录下创建CMakeLists.txt文件,告诉CMake如何构建项目

   ```cmake
   cmake_minimum_required(VERSION 3.10)  # 设置最低 CMake 版本要求
   project(MyProject)                    # 设置项目名称
   
   # 设置 C++ 标准
   set(CMAKE_CXX_STANDARD 11)
   
   # 指定源文件
   set(SOURCES
       src/main.cpp
       src/module.cpp
   )
   
   # 创建可执行文件
   add_executable(MyProject ${SOURCES})
   
   # 如果有需要链接的库，可以使用 target_link_libraries
   # target_link_libraries(MyProject some_library)
   ```

3. 运行CMake配置项目

   + 在`build/`目录中,执行`cmake`命令,指定CMakeLists.txt文件所在的根目录
     ```cmake
     cmake ..
     ```

4. 构建项目

   + 在`build/`目录中,CMake配置完成后,可以运行`make`或其他构建工具来编译项目

### 高级使用

#### 1.查找并链接外部库

+ 在CMake中,如果使用外部库,可以使用`find_paceage`命令查找库并将其链接到项目
  ````cmake
  find_package(<PackageName> [<version>][REQUIRED|OPTIONAL])
  <PackageName>：指定要查找的库或软件包名称。
  <version>：可选，指定所需版本（例如：find_package(OpenCV 4.5 REQUIRED)）。
  REQUIRED：如果找不到库，CMake 会报错并停止配置过程。
  OPTIONAL：如果找不到库，CMake 不会报错。
  ````

  

  ```cmake
  find_package(OpenCV REQUIRED) #查找OpenCV库
  target_link_libraries(MyProject OpenVC::Core)
  ```

#### 2.添加子目录

+ 如果项目由多个模块组成,建议分成不同的子目录,使用`add_subdirctory`命令将子目录添加到构建中

  ```cmake
  add_subdirectory(<dir> [binary_dir] [EXCLUDE_FROM_ALL]
  <dir>：要添加的子目录路径，通常是相对于当前 CMakeLists.txt 文件的路径。
  binary_dir：可选参数，指定构建目录。如果不指定，CMake 会使用默认的构建目录（即与源目录相同）。
  EXCLUDE_FROM_ALL：如果指定，CMake 不会将该子目录的构建目标加入到顶层构建中，适用于只想局部构建某个模块的情况。
  ```

  

  ```camke
  add_subdirctory(src)#这行代码告诉 CMake 在 src 子目录中寻找 CMakeLists.txt 文件，并将 src 目录包含到项目构建中。src 通常用于存放项目的源代码（如 .cpp 和 .c 文件）。
  add_subdirectory(test)
  ```

  + 每个子目录可以有自己的 `CMakeLists.txt` 文件，独立管理自己的构建过程。
  + 当需要添加更多模块或测试时，只需创建新目录并使用 `add_subdirectory()` 添加到顶层 `CMakeLists.txt` 文件中。

#### 3.安装项目

+ 可以给项目定义安装规则,让CMake在构建后将项目文件安装到系统中的指定目录

  ```cmake
  install(<TARGETS|FILES|DIRECTORIES> <name> DESTINATION <dir> [<options])
  TARGETS:安装目标(可执行文件,库等)
  FILES:安装文件
  DIRECTORIES：安装目录。
  DESTINATION：目标安装目录，即将文件、目标或目录安装到哪里
  ```

  

  ```cmake
  install(TARGETS myProject DESTINATION /usr/loval/bin)
  该命令将安装 MyProject 目标（通常是可执行文件）到 /usr/local/bin 目录中。
  ```

  

#### 4.创建和管理自定义命令

+ CMake允许创建自定义的构建命令,通常执行一些特殊任务,比如文件生成,脚本执行等
  ```cmake
  add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/generated_file.cpp
    COMMAND python ${CMAKE_SOURCE_DIR}/generate_code.py
    DEPENDS ${CMAKE_SOURCE_DIR}/generate_code.py
    COMMENT "Generating source file"
  )
  ```

#### 5.自动下载和集成外部项目

+ `FetchContent`模块可以在CMake配置时下载外部项目并将其包含进来,而不需要预先手动安装依赖

  ```cmake
  include(FetchContent)
  FetchContent_Declare(
    fmt
    GIT_REPOSITORY https://github.com/fmtlib/fmt.git
    GIT_TAG 7.1.3
  )
  FetchContent_MakeAvailable(fmt)
  
  add_executable(MyProject main.cpp)
  target_link_libraries(MyProject fmt::fmt)
  ```

