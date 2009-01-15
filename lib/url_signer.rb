require 'uri'
require 'digest/sha1'

class UrlSigner
  
  VERSION = "0.0.1"
  
  def self.sign(url)
    parsed_url = URI.parse(url)
    url_hash = hash(url)
    suffix = File.extname(parsed_url.path)
    parsed_url.merge(File.join(File.dirname(parsed_url.path) ,File.basename(parsed_url.path,suffix) + "_#{url_hash}" + suffix)).to_s
  end
  
  def self.valid?(url)
    parsed_url = URI.parse(url)
    suffix = File.extname(parsed_url.path)
    given_hash = File.basename(parsed_url.path,suffix)[-6..-1]
    original_url =  parsed_url.merge(File.join(File.dirname(parsed_url.path) ,File.basename(parsed_url.path,suffix)[0..-8]  + suffix)).to_s
    return hash(original_url) == given_hash
  end
  
  def self.hash(string)
    Digest::SHA1.hexdigest(string)[0..5]
  end
end