require "test/unit"

$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))

require File.dirname(__FILE__) + '/../lib/url_signer'

class TestUrlSigner < Test::Unit::TestCase
  def test_should_sign_urls
    url = "http://images.pkw.de/audi_gebrauchtwagen_300.jpg"
    signed_url = UrlSigner.sign(url)
    assert_not_equal url, signed_url
  end
  
  def test_round_trip
    url = "http://images.pkw.de/audi_gebrauchtwagen_300.jpg"
    assert_equal true, UrlSigner.valid?(UrlSigner.sign(url))
  end
  
  def test_sould_validate_url
    signed_url = "http://images.pkw.de/audi_gebrauchtwagen_300_d97f0e.jpg"
    bad_signed_url = "http://images.pkw.de/audi_gebrauchtwagen_300_d97f0f.jpg"
    assert_equal true, UrlSigner.valid?(signed_url)
    assert_equal false, UrlSigner.valid?(bad_signed_url)
  end
end