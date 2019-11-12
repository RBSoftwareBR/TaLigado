import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:taligado/Objetos/Tweet.dart';
import 'package:http/http.dart' as http;

class TwitterController extends BlocBase {
  BehaviorSubject<List<Tweet>> tweetsController =
      BehaviorSubject<List<Tweet>>();
  Stream<List<Tweet>> get outTweets => tweetsController.stream;
  Sink<List<Tweet>> get inTweets => tweetsController.sink;

  List<Tweet> tweets;

  String BRAZIL_WOE_ID = '23424768';

  TwitterController() {
    http.get('https://api.twitter.com/1.1/trends/place.json?id=1', headers: {
      'authorization': 'OAuth oauth_consumer_key=GNEPutnMbOHDNwgN7L50cWnhX',
      'oauth_nonce': "generated-nonce",
      'oauth_signature': "generated-signature",
      'oauth_signature_method': "HMAC-SHA1",
      'oauth_timestamp': "generated-timestamp",
      'oauth_token': "access-token-for-authed-user",
      'oauth_version': "1.0"
    }).then((v) {
      print('AQUI RESPOSTA ${v.body}');
    });
  }

  @override
  void dispose() {
    tweetsController.close();
  }
}
