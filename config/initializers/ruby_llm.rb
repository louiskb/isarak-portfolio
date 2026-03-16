RubyLLM.configure do |config|
  # Add keys ONLY for the providers you intend to use.
  # Using environment variables is highly recommended.
  # 
  # config.anthropic_api_key = ENV.fetch('ANTHROPIC_API_KEY', nil)
  #
  # !!!! IF PUSHING TO PRODUCTION: Uncomment code `config.openai_api_key = ...` below. Also uncomment `OPEN_API_KEY` and comment out `GITHUB_TOKEN` in `.env` file. !!!!
  #
  config.openai_api_key = ENV.fetch('OPENAI_API_KEY', nil)

  # !!!! IF TESTING IN DEVELOPMENT: Uncomment code below if testing AI Blog Features in development. Also uncomment `GITHUB_TOKEN` and comment out OPENAI_API_KEY` in `.env` file. !!!!
  #
  # config.openai_api_key = ENV.fetch('GITHUB_TOKEN', nil) || ENV.fetch('OPENAI_API_KEY', nil)
  # config.openai_api_base = "https://models.inference.ai.azure.com"
  #
  # Add `Rails.application.credentials.dig(:openai_api_key)` if using Rails credentials. FYI Run `rails credentials:edit` to open and decrypt YAML file where you'd add and edit credentials e.g. `openai_api_key: your-api-key-here`. It's decrypted at runtime using a master key `config/master.key`, which is never committed to Git. Rails credentials work well in development without needing a `.env` file.
  #
  # If you want to add a default model.
  # config.default_model = "gpt-5-nano"

  # Use the new association-based acts_as API (recommended)
  config.use_new_acts_as = true
end
