# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# `Rails.application.config.assets.precompile` is the Sprockets precompile array (e.g. precompile = ["application.js", "application.css"])
# `+=` append to existing array
# `%w(bootstrap.min.js popper.js)` == ["bootstrap.min.js", "popper.js"]
# Final result after `+=` is e.g. precompile += %w(bootstrap.min.js popper.js) == ["application.js", "application.css", "bootstrap.min.js", "popper.js"]
Rails.application.config.assets.precompile += %w(bootstrap.min.js popper.js)
