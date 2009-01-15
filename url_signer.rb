require 'uri'
require 'digest/sha1'

class UrlSigner
  
  SUFFIX = ".jpg"
  
  def self.sign(url)
    parsed_url = URI.parse(url)
    url_hash = Digest::SHA1.hexdigest(url)[0..5]
    parsed_url.merge(File.join(File.dirname(parsed_url.path) ,File.basename(parsed_url.path,SUFFIX) + "_#{url_hash}" + SUFFIX)).to_s
  end
  
  def self.valid?(url)
    parsed_url = URI.parse(url)
    given_hash = File.basename(parsed_url.path,".jpg")[-6..-1]
    original_url =  parsed_url.merge(File.join(File.dirname(parsed_url.path) ,File.basename(parsed_url.path,SUFFIX)[0..-8]  + SUFFIX)).to_s
    return Digest::SHA1.hexdigest(original_url)[0..5] == given_hash
  end
end