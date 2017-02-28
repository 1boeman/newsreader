module Putil 
  def Putil.url_name_to_file(url)
     url.gsub(/[^a-z|0-9]/i,'_')
  end
end
