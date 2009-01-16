require "test/unit"

$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))

require File.dirname(__FILE__) + '/../lib/url_signer'

class TestUrlSigner < Test::Unit::TestCase
  def test_should_sign_urls
    UrlSigner.secret="secret"
    url = "http://images.pkw.de/audi_gebrauchtwagen_300.jpg"
    signed_url = UrlSigner.sign(url)
    assert_not_equal url, signed_url
  end
  
  def test_round_trip
    UrlSigner.secret="secret"
    url = "http://images.pkw.de/audi_gebrauchtwagen_300.jpg"
    assert_equal true, UrlSigner.valid?(UrlSigner.sign(url))
  end
  
  def test_should_validate_url
    UrlSigner.secret="secret"
    signed_url = "http://images.pkw.de/audi_gebrauchtwagen_300_c1ed2a.jpg"
    bad_signed_url = "http://images.pkw.de/audi_gebrauchtwagen_300_d97f0f.jpg"
    assert_equal true, UrlSigner.valid?(signed_url)
    assert_equal false, UrlSigner.valid?(bad_signed_url)
  end
  
  def test_should_use_secret_for_hashing
    UrlSigner.secret="secret"
    url1 = "http://images.pkw.de/audi_gebrauchtwagen_300.jpg"
    signed_url1 = UrlSigner.sign(url1)
    UrlSigner.secret="secret2"
    url2 = "http://images.pkw.de/audi_gebrauchtwagen_300.jpg"
    signed_url2 = UrlSigner.sign(url2)
    assert_equal false, signed_url1 == signed_url2
  end
end