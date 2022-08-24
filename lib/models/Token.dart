class Token {
  final String _access_token;
  final int _expires_in;
  final String _scope;
  final String _token_type;
  Token(this._access_token, this._expires_in, this._scope, this._token_type);
  get accesstoken => _access_token;
  get expires_in => _expires_in;
  get scop => _scope;
  get token_type => token_type;
}
