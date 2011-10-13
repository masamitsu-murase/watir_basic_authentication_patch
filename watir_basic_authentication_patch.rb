
require("rubygems")
require("watir")
require("watir/ie")

module Watir
  class IE

    XML_HTTP_REQUEST_JS_SOURCE = <<"EOS"
(function(){
    var creators = [ function(){ return new XMLHttpRequest(); },
                     function(){ return new ActiveXObject('Msxml2.XMLHTTP.6.0'); },
                     function(){ return new ActiveXObject('Msxml2.XMLHTTP.3.0'); } ]
    var xhr = null;
    for (var i=0; i<creators.length; i++){
        try{
            xhr = creators[i]();
            break;
        }catch(e){
        }
    }
    if (xhr){
        xhr.onreadystatechange = function(){};
        xhr.open("GET", "URL_TEXT", false, "USER_TEXT", "PASS_TEXT");
        xhr.setRequestHeader("If-Modified-Since", "Thu, 01 Jun 1970 00:00:00 GMT");
        xhr.send(null);
        location.href = "URL_TEXT";
    }
})();
EOS

    def goto_with_basic_authentication(url, user, pass)
      base64 = [ "#{user}:#{pass}" ].pack("m").gsub("\n", "")
      @ie.navigate(url, nil, nil, nil, "Authorization: Basic #{base64}\r\n")
      wait
      time1 = @down_load_time

      js = XML_HTTP_REQUEST_JS_SOURCE.gsub(Regexp.new("\\s+"), " ")
      [ [ url, "URL_TEXT" ], [ user, "USER_TEXT" ], [ pass, "PASS_TEXT" ] ].each do |item|
        escaped_str = item[0].gsub("\\"){ "\\\\" }.gsub("\""){ "\\\"" }
        js = js.gsub(item[1]){ escaped_str }
      end
      time2 = goto("javascript:#{js}")

      return time1 + time2
    end
  end
end

