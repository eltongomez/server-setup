source "https://rubygems.org"

gem "jekyll", "~> 4.3.0"
gem "jekyll-theme-minimal"
gem "jekyll-feed", "~> 0.17.0"
gem "jekyll-sitemap", "~> 1.4.0"
gem "jekyll-seo-tag", "~> 2.8.0"

# Windows and JRuby does not include zoneinfo files
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", "~> 2.0"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.1", :install_if => Gem.win_platform?

# Lock `http_parser.rb` to `v0.6.x` on JRuby builds
gem "http_parser.rb", "~> 0.6.0", :platforms => [:jruby]
