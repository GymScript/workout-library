require "minitest/autorun"
require "base64"

# Load plugin without Liquid in scope
module Liquid; module Template; def self.register_filter(_); end; end; end unless defined?(Liquid)
require_relative "../_plugins/base64_filter"

class TestBase64Filter < Minitest::Test
  include Jekyll::Base64Filter

  def test_roundtrips_ascii_script
    input = "Bench press 4x8 @ 60kg rest 2min\nOverhead press 3x10 rest 90s"
    encoded = base64_encode(input)
    padded  = encoded + "=" * ((4 - encoded.length % 4) % 4)
    assert_equal input, Base64.urlsafe_decode64(padded)
  end

  def test_output_is_url_safe
    input = "Squat 5x5 @ 100kg rest 3min"
    assert_match(/\A[A-Za-z0-9_-]*\z/, base64_encode(input))
  end

  def test_no_padding_characters
    refute_includes base64_encode("Push-ups 3x15 rest 60s"), "="
  end

  def test_roundtrips_utf8
    input = "Sentadillas 3x10 @ 60kg descanso 2min"
    encoded = base64_encode(input)
    padded  = encoded + "=" * ((4 - encoded.length % 4) % 4)
    assert_equal input, Base64.urlsafe_decode64(padded)
  end

  def test_empty_string
    assert_equal "", base64_encode("")
  end
end
