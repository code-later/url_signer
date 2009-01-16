require "test_helper"

class TestUrlSigner < Test::Unit::TestCase
  
  def test_should_set_length_of_hash_in_initializer
    url_signer = UrlSigner.new("secret", :hash_length => 16)
    url = "http://images.pkw.de/audi_gebrauchtwagen_300.jpg"
    signed_url = url_signer.sign(url)
    UrlSigner.publicize_methods do
      assert_equal 16, url_signer.extract_hash(signed_url).length
    end
    assert url_signer.valid?(url_signer.sign(url))
  end
  
  def test_should_sign_urls
    url_signer = UrlSigner.new("secret")
    url = "http://images.pkw.de/audi_gebrauchtwagen_300.jpg"
    signed_url = url_signer.sign(url)
    assert_not_equal url, signed_url
  end
  
  def test_round_trip
    url_signer = UrlSigner.new("secret")
    url = "http://images.pkw.de/audi_gebrauchtwagen_300.jpg"
    assert url_signer.valid?(url_signer.sign(url))
  end
  
  def test_should_validate_url
    url_signer = UrlSigner.new("secret")
    signed_url = "http://images.pkw.de/audi_gebrauchtwagen_300_c1ed2a4c21.jpg"
    bad_signed_url = "http://images.pkw.de/audi_gebrauchtwagen_300_d97f0fef87.jpg"
    assert url_signer.valid?(signed_url)
    assert !url_signer.valid?(bad_signed_url)
  end
  
  def test_should_use_secret_for_hashing
    url_signer1 = UrlSigner.new("secret1")
    url1 = "http://images.pkw.de/audi_gebrauchtwagen_300.jpg"
    signed_url1 = url_signer1.sign(url1)
    url_signer2 = UrlSigner.new("secret2")
    url2 = "http://images.pkw.de/audi_gebrauchtwagen_300.jpg"
    signed_url2 = url_signer2.sign(url2)
    assert_equal false, signed_url1 == signed_url2
  end
  
  def test_should_not_be_able_to_reset_secret
    url_signer = UrlSigner.new("secret")
    assert_raise(NoMethodError) { url_signer.secret = "new secret" }
  end
  
  def test_should_unsign_url
    url_signer = UrlSigner.new("secret")
    url = "http://images.pkw.de/audi_gebrauchtwagen_300.jpg"
    assert_equal url, url_signer.unsign(url_signer.sign(url))
  end
  
  def test_should_extract_hash_from_url
    url_signer = UrlSigner.new("secret", :hash_length => 10)
    url = "http://images.pkw.de/audi_gebrauchtwagen_300.jpg"
    UrlSigner.publicize_methods do
      assert_equal "c1ed2a4c21", url_signer.extract_hash(url_signer.sign(url))
    end
  end
  
  def test_should_have_hash_with_separator
    url_signer = UrlSigner.new("secret")
  end
  
  def test_should_be_able_to_set_separator_in_initializer
    url_signer = UrlSigner.new("secret", :separator => "~")
    url = "http://images.pkw.de/audi_gebrauchtwagen_300.jpg"
    assert_match /http\:\/\/images\.pkw\.de\/audi_gebrauchtwagen_300\~.{#{UrlSigner::DEFAULT_HASH_LENGTH}}\.jpg/, url_signer.sign(url)
  end
  
end