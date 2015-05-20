import strutils, os, requests, json, cgi, base64, httpclient
type 
    TwitterAuth = ref object of RootObj
        CONSUMER_KEY*: string
        CONSUMER_SECRET*: string

var twitter = TwitterAuth(CONSUMER_KEY:"vRCOy7UloVA9UKCHF3dfY2ZFR",CONSUMER_SECRET:"TpcXmHFo4Cio8wFyQTpXaE4RQbXOnfqDfzn45gO3H13CHee15t")
proc bearerToken(twitter: TwitterAuth): string = 
    var consumer_credentials = encodeUrl(twitter.CONSUMER_KEY) & ":" & encodeUrl(twitter.CONSUMER_SECRET)
    var encodedkeys = encode(consumer_credentials, lineLen=200)
    var extraheaders = "Authorization: Basic $#\c\LContent-Type: application/x-www-form-urlencoded;charset=UTF-8".format(encodedkeys)
    var body = "grant_type=client_credentials"
    var url = "https://api.twitter.com/oauth2/token"
    var response = postContent(url=url, extraheaders=extraheaders, body=body)
    var response_json = parseJson(response)
    return getStr(response_json["access_token"])
