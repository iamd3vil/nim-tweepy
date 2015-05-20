import httpclient, os, strutils, cgi, json

proc paramUrl(s: string): string = 
    var JsonParsed = parseJson(s)
    var paramurl = "?"
    for key, value in pairs(JsonParsed):
        paramurl &= "$#=$#&".format(encodeUrl(key), encodeUrl(getStr(value)))
    var paramurl2 = paramurl[0..len(paramurl) - 2]
    return paramurl2
var defUserAgent = "nim-tweepy"
proc getWithParams*(url: string, params: string, extraHeaders = "", maxRedirects = 5,timeout = -1, userAgent = defUserAgent,proxy: Proxy = nil): Response =  
    var realurl = url & paramUrl(params)
    echo(realurl)
    return get(realurl, extraHeaders=extraHeaders,maxRedirects=maxRedirects,timeout=timeout,userAgent=defUserAgent, proxy=proxy)

proc getWithParamsContent*(url: string, params: string, extraHeaders = "", maxRedirects = 5,timeout = -1,userAgent = defUserAgent,proxy: Proxy = nil): string =  
    var realurl = url & paramUrl(params)
    echo(realurl)
    var content = getContent(realurl, extraHeaders=extraHeaders,maxRedirects=maxRedirects,timeout=timeout,userAgent=defUserAgent, proxy=proxy)
    return content