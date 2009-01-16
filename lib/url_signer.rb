require 'rubygems'
require 'activesupport'
require 'uri'
require 'digest/sha1'

class UrlSigner
  
  VERSION = "0.2.0"
  
  DEFAULT_HASH_LENGTH = 10
  DEFAULT_SEPARATOR = "_"
  
  # Initialize new url-signer
  #
  # == Parameter
  # secret (String):: secret for hashing
  # options (Hash):: possible options are:
  #                 - :hash_length (Integer):: set length of hash
  #                 - :separator (String):: set separator for hash in url
  # 
  def initialize(secret, options = {})
    self.secret = secret
    self.hash_length = options[:hash_length] || DEFAULT_HASH_LENGTH
    self.separator = options[:separator] || DEFAULT_SEPARATOR
  end
  
  # signs a given url
  # 
  # == Parameter
  # url (String):: whole URL to sign
  # 
  # == Returns
  # signed URL (url with inserted hash)
  #
  def sign(url)
    parsed_url = URI.parse(url)
    suffix = File.extname(parsed_url.path)
    parsed_url.to_s.gsub(/#{suffix}$/, "#{hash_with_separator(url)}#{suffix}")
  end
  
  # get url without hash (as it was before signing)
  # 
  # == Parameter
  # url (String):: url with inserted hash
  # 
  # == Returns
  # Returns a URL without hash (as it was before signing)
  def unsign(url)
    parsed_url = URI.parse(url)
    suffix = File.extname(parsed_url.path)
    # extract hash with separator from uri
    url_without_suffix = parsed_url.to_s.gsub(/#{suffix}$/, "")
    url_without_hash_and_suffix = url_without_suffix.gsub(/#{separator}.{#{hash_length}}$/, "")
    unsigned_url = "#{url_without_hash_and_suffix}#{suffix}"
    return unsigned_url
  end
  
  # validates a given URL
  # 
  # == Parameter
  # url (String):: url to validate
  # 
  # == Returns
  # true or false
  def valid?(url)
    hash(unsign(url)) == extract_hash(url)
  end
  
  private
    
    attr_accessor :secret, :hash_length, :separator
    
    def hash(string)
      Digest::SHA1.hexdigest(string+secret)[0..(hash_length-1)]
    end
    
    def extract_hash(url)
      parsed_url = URI.parse(url)
      suffix = File.extname(parsed_url.path)
      extracted_hash = File.basename(parsed_url.path,suffix)[-hash_length..-1]
      return extracted_hash
    end
    
    def hash_with_separator(url)
      "#{separator}#{hash(url)}"
    end
    
end