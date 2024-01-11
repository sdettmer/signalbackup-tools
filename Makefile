# Any variable can be overwritten on command line:
#  make CONFIG=default CXX="ccache g++" -j 5
CXX=g++
CXXSTD=-std=c++2a
CXXFLAGS=-Wall -Wextra -Wshadow -Wold-style-cast -Woverloaded-virtual -pedantic -O3 -flto $(CXXSTD) $(CXXFLAGSEXTRA)
LDFLAGS=-Wall -Wextra -Wl,-z,now -Wl,--as-needed -O3 -s -flto=auto
LDLIBS=-lcrypto -lsqlite3 -lstdc++
BIN=signalbackup-tools

ifeq ($(CONFIG),brew)
  CXXFLAGS=-Wall -Wextra -Wshadow -Woverloaded-virtual -pedantic -O3 -flto $(CXXSTD) $(CXXFLAGSEXTRA)
  LDFLAGS=-Wall -Wextra -O3 -flto=auto
endif
ifeq ($(CONFIG),darwin)
  LDFLAGS=-Wall -Wextra -flto -O3
endif
ifeq ($(CONFIG),nixpkgs-darwin)
  CXXFLAGS=-Wall -Wextra -Wshadow -Wold-style-cast -Woverloaded-virtual -pedantic -O3 $(CXXSTD) $(CXXFLAGSEXTRA)
  LDFLAGS=-Wall -Wextra -O3
endif
ifeq ($(CONFIG),windows)
  CXX=x86_64-w64-mingw32-g++
  CXXFLAGS=-Wall -Wextra -Wshadow -Wold-style-cast -Woverloaded-virtual -pedantic -D_WIN32_WINNT=0x600 -I/usr/x86_64-w64-mingw32/include/ -O3 -flto $(CXXSTD) $(CXXFLAGSEXTRA)
  LDFLAGS=-Wall -Wextra -Wl,--as-needed -static-libgcc -static-libstdc++ -static -L/usr/x86_64-w64-mingw32/lib/ -O3 -s -flto=auto
  LDLIBS=-lcrypto -lsqlite3 -lssp -luser32 -lcrypt32 -ladvapi32 -lgdi32 -lws2_32
  BIN=signalbackup-tools_win.exe
endif


SRC=$(wildcard */*.cc *.cc)
OBJ=$(SRC:cc=o)

# This is needed only because main.cc is not signalbackup-tools.cc:
$(BIN): $(OBJ)
	$(CXX) $(LDFLAGS) -o $@ $^ $(LDLIBS)

clean:
	rm -rf $(BIN) $(OBJ)

