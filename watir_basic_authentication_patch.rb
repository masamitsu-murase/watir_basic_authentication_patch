
require("rubygems")
require("watir")
require("watir/ie")

module Watir
  class IE

=begin
(function(){
    var i = 0, a = "ActiveXObject('Msxml2.XMLHTTP.", 
        n = [ "XMLHttpRequest()", a + "6.0')", a + "3.0')" ], x, u = "URL_TEXT";
    while(x = n[i++]){
        try{
            x = eval("new " + x);
            x.open("GET", u, !1, "USER_TEXT", "PASS_TEXT");
            x.setRequestHeader("If-Modified-Since", "Thu, 01 Jun 1970 00:00:00 GMT");
            x.send(null);
            location.href = u;
        }catch(e){}
    }
})();
=end

    XML_HTTP_REQUEST_JS_SOURCE = '(function(){var i=0,a="ActiveXObject(\'Msxml2.XMLHTTP.",n=["XMLHttpRequest()",a+"6.0\')",a+"3.0\')"],x,u="URL_TEXT";while(x=n[i++]){try{x=eval("new "+x);x.open("GET",u,!1,"USER_TEXT","PASS_TEXT");x.setRequestHeader("If-Modified-Since","Thu, 01 Jun 1970 00:00:00 GMT");x.send(null);location.href=u}catch(e){}}})();'

    def goto_with_basic_authentication(url, user, pass)
      base64 = [ "#{user}:#{pass}" ].pack("m").gsub("\n", "")
      @ie.navigate(url, nil, nil, nil, "Authorization: Basic #{base64}\r\n")
      wait
      time1 = @down_load_time

      js = XML_HTTP_REQUEST_JS_SOURCE
      [ [ url, "URL_TEXT" ], [ user, "USER_TEXT" ], [ pass, "PASS_TEXT" ] ].each do |item|
        escaped_str = item[0].gsub("\\"){ "\\\\" }.gsub("\""){ "\\\"" }
        js = js.gsub(item[1]){ escaped_str }
      end
      time2 = goto("javascript:#{js}")

      return time1 + time2
    end
  end
end

