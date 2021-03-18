import 'package:equatable/equatable.dart';

import 'contact_model.dart';

class ContactResponse extends Equatable {
  final Contacts contacts;

  ContactResponse({this.contacts});

  factory ContactResponse.fromJson(Map<String, dynamic> json) {
    return ContactResponse(
      contacts: json['contacts'] != null
          ? new Contacts.fromJson(json['contacts'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.contacts != null) {
      data['contacts'] = this.contacts.toJson();
    }
    return data;
  }

  @override
  List<Object> get props => [contacts];
}

class Contacts extends Equatable {
  final int currentPage;
  final List<ContactModel> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<Links> links;
  final String nextPageUrl;
  final String path;
  final String perPage;
  final String prevPageUrl;
  final int to;
  final int total;

  Contacts(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  factory Contacts.fromJson(Map<String, dynamic> json) {
    List<ContactModel> data;
    if (json['data'] != null) {
      data = new List<ContactModel>();
      json['data'].forEach((v) {
        data.add(new ContactModel.fromJson(v));
      });
    }
    List<Links> links;
    if (json['links'] != null) {
      links = new List<Links>();
      json['links'].forEach((v) {
        links.add(new Links.fromJson(v));
      });
    }
    return Contacts(
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
      currentPage: json['current_page'],
      links: links,
      data: data,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }

  @override
  List<Object> get props => [
        currentPage,
        data,
        firstPageUrl,
        from,
        lastPage,
        lastPageUrl,
        links,
        nextPageUrl,
        path,
        perPage,
        prevPageUrl,
        to,
        total,
      ];

  @override
  String toString() {
    return "$currentPage $data $firstPageUrl $from $lastPage $lastPageUrl $links $nextPageUrl $path $perPage $prevPageUrl $to $total";
  }
}

class Links extends Equatable {
  String url;
  String label;
  bool active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'].toString();
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }

  @override
  List<Object> get props => [url, label, active];

  @override
  String toString() {
    return "$url $label $active";
  }
}
