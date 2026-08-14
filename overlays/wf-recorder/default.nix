_final: prev: {
  wf-recorder = prev.wf-recorder.override {
    ffmpeg = prev.ffmpeg_6;
  };
}
