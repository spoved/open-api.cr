class Open::Api
  VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify }}
end
