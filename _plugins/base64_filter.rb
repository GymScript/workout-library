require "base64"

module Jekyll
  module Base64Filter
    # Encodes a string as URL-safe base64 without padding.
    # Compatible with gymscript's decodeImportedScript (handles - and _ chars).
    def base64_encode(input)
      Base64.urlsafe_encode64(input.to_s, padding: false)
    end
  end
end

Liquid::Template.register_filter(Jekyll::Base64Filter) if defined?(Liquid)
