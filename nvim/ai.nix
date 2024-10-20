{...}: {

  plugins = {

    # Some AI bs
    avante = {
      enable = true;
      settings = {
        provider = "gemini";
        gemini = {
          # @see https://ai.google.dev/gemini-api/docs/models/gemini
          model = "gemini-1.5-flash-latest";
          # model = "gemini-1.5-flash",
          temperature = 0;
          max_tokens = 4096;
        };
      };
    };
    dressing.enable = true;

    # luasnip is a depdenency for copilot I guess?
    luasnip.enable = true;
    copilot-lua = {
      panel.enabled = false;
      suggestion.enabled = false;
    };

    copilot-cmp = {
      enable = true;
    };
  };

}
