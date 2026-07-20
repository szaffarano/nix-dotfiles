_final: prev: {
  pass-secret-service = prev.pass-secret-service.overrideAttrs (old: {
    postPatch =
      old.postPatch
      + ''
        substituteInPlace pass_secret_service/pass_secret_service.py \
          --replace \
            "mainloop = asyncio.get_event_loop()" \
            "mainloop = asyncio.new_event_loop(); asyncio.set_event_loop(mainloop)"
      '';
  });
}
