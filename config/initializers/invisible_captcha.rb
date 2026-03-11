InvisibleCaptcha.setup do |config|
  config.timestamp_threshold = 5
  config.honeypots = ["nickname", "website_url", "company", "subject"]
  # `invisible_captcha` always logs spam blocks to log/development.log.
  # In development: run `tail -f log/development.log | grep "InvisibleCaptcha"` to monitor.
  # Refer to the gem README: https://github.com/markets/invisible_captcha
end
