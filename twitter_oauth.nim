import strutils, os, requests, json, cgi, base64, httpclient
type 
    TwitterAuth = ref object of RootObj
        CONSUMER_KEY*: string
        CONSUMER_SECRET*: string
        bearertoken*: string
var twitter = TwitterAuth(CONSUMER_KEY:"hvRziQJMWZeTqkDZNsscvQCRO",CONSUMER_SECRET:"nsutC9oDapbBUSxQb7sKSAO5m7X7HrojXT3x7gBt8VEuUFFMvI")
proc bearerToken(twitter: TwitterAuth): string = 
    var consumer_credentials = encodeUrl(twitter.CONSUMER_KEY) & ":" & encodeUrl(twitter.CONSUMER_SECRET)
    var encodedkeys = encode(consumer_credentials, lineLen=200)
    var extraheaders = "Authorization: Basic $#\c\LContent-Type: application/x-www-form-urlencoded;charset=UTF-8".format(encodedkeys)
    var body = "grant_type=client_credentials"
    var url = "https://api.twitter.com/oauth2/token"
    var response = postContent(url=url, extraheaders=extraheaders, body=body)
    var response_json = parseJson(response)
    return getStr(response_json["access_token"])
twitter.bearertoken = bearerToken(twitter)
echo(twitter.bearertoken)
proc userTimeline(twitter: TwitterAuth, screenName: string, count: string = "3") = 
    var 
        extraheaders = "Authorization: Bearer $#".format(twitter.bearertoken)
        params = """{"screen_name": "$#", "count": "$#"}""".format(screenName, count)
        url = "https://api.twitter.com/1.1/statuses/user_timeline.json"
    echo(params)
    var response = getWithParams(url= url, params=params, extraheaders=extraheaders)
    echo(response.body)
    echo(response.status)
userTimeline(twitter, "twitterapi")

proc searchTwitter(searchterm:string, count: string = "20") = 
    var
        extraheaders = "Authorization: Bearer $#".format(twitter.bearertoken)
        params = """{ "count": "$#", "q": "$#"}""".format(count,encodeUrl(searchterm))
        url = "https://api.twitter.com/1.1/search/tweets.json"
    echo(params)
    echo(extraheaders)
    var response = getWithParams(url= url, params=params, extraheaders=extraheaders)
    echo(response.body)
    echo(response.status)
searchTwitter("Narendramodi foreign")