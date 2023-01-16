class GetUserListOnline {
  final String responseStatus;

  const GetUserListOnline({
    required this.responseStatus,
  });

  factory GetUserListOnline.fromJson(dynamic json) {
    return GetUserListOnline(
      responseStatus: json['s:Envelope']['s:Body']
                  ['AuthenticateUserOnlineResponse']
              ['AuthenticateUserOnlineResult']['\$']
          .toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['responseStatus'] = responseStatus;

    return map;
  }
}
