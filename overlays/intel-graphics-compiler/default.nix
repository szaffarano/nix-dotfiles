_final: prev: {
  intel-graphics-compiler = prev.intel-graphics-compiler.overrideAttrs (_: {
    patches = [
      # Raise minimum CMake version to 3.5
      # https://github.com/intel/intel-graphics-compiler/commit/4f0123a7d67fb716b647f0ba5c1ab550abf2f97d
      # https://github.com/intel/intel-graphics-compiler/pull/364
      ./bump-cmake.patch
    ];
  });
}
