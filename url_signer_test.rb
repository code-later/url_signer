require "test/unit"

require "url_signer"

class TestUrlSigner < Test::Unit::TestCase
  def test_should_sign_urls
    url = "http://images.pkw.de/audi_gebrauchtwagen_300.jpg"
    signed_url = UrlSigner.sign(url)
    assert_not_equal url, signed_url
  end
  
  def test_sould_validate_url
    signed_url = "http://images.pkw.de/audi_gebrauchtwagen_300_d97f0e.jpg"
    bad_signed_url = "http://images.pkw.de/audi_gebrauchtwagen_300_d97f0f.jpg"
    assert_equal true, UrlSigner.valid?(signed_url)
    assert_equal false, UrlSigner.valid?(bad_signed_url)
  end
end