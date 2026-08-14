_final: prev: {
  waypipe = prev.waypipe.override {
    ffmpeg = prev.ffmpeg_6;
  };
}
