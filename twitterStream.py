import tweepy

consumer_key = 'your API key'
consumer_key_secret = 'your API key secret'
access_token = 'your access token'
access_token_secret = 'your access token secret'

class TweetListener(tweepy.StreamListener):
  def on_status(self, status):
    print('Tweet text: ' + status.text)
    return True

  def on_error(self, status_code):
    print('Got an error with status code: ' + str(status_code))
    return True

  def on_timeout(self):
      print('Timeout...')
      return True
if __name__ == '__main__':
  listener = TweetListener()
  auth = tweepy.OAuthHandler('Pd6fOyysQZPop0nQv4NGAHSog', 'TRIhVP5s0kodqBbHcavvuTrdhu3apYLTMWKX4QJ39kIP9qjO30')
  auth.set_access_token('2990416419-tp7NwSZUwWYpYq2zoHR2wIkIiOcUzztL4VCHd5W', 'UdILoZI8qudhMBA8bufQ7xN82BaACILZ6RkZIzdKc9bwS')
  stream = tweepy.Stream(auth, listener)
  stream.filter(follow =[], track=['#SFGiants', '#Athletics'])
