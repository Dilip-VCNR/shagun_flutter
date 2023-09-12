// To parse this JSON data, do
//
//     final ipLocationModel = ipLocationModelFromJson(jsonString);

import 'dart:convert';

IpLocationModel ipLocationModelFromJson(String str) =>
    IpLocationModel.fromJson(json.decode(str));

String ipLocationModelToJson(IpLocationModel data) =>
    json.encode(data.toJson());

class IpLocationModel {
  String? ip;
  String? type;
  dynamic hostname;
  Carrier? carrier;
  Company? company;
  Connection? connection;
  Currency? currency;
  Location? location;
  Map<String, bool>? security;
  TimeZone? timeZone;
  UserAgent? userAgent;

  IpLocationModel({
    this.ip,
    this.type,
    this.hostname,
    this.carrier,
    this.company,
    this.connection,
    this.currency,
    this.location,
    this.security,
    this.timeZone,
    this.userAgent,
  });

  factory IpLocationModel.fromJson(Map<String, dynamic> json) =>
      IpLocationModel(
        ip: json["ip"],
        type: json["type"],
        hostname: json["hostname"],
        carrier:
        json["carrier"] == null ? null : Carrier.fromJson(json["carrier"]),
        company:
        json["company"] == null ? null : Company.fromJson(json["company"]),
        connection: json["connection"] == null
            ? null
            : Connection.fromJson(json["connection"]),
        currency: json["currency"] == null
            ? null
            : Currency.fromJson(json["currency"]),
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        security: Map.from(json["security"]!)
            .map((k, v) => MapEntry<String, bool>(k, v)),
        timeZone: json["time_zone"] == null
            ? null
            : TimeZone.fromJson(json["time_zone"]),
        userAgent: json["user_agent"] == null
            ? null
            : UserAgent.fromJson(json["user_agent"]),
      );

  Map<String, dynamic> toJson() => {
    "ip": ip,
    "type": type,
    "hostname": hostname,
    "carrier": carrier?.toJson(),
    "company": company?.toJson(),
    "connection": connection?.toJson(),
    "currency": currency?.toJson(),
    "location": location?.toJson(),
    "security":
    Map.from(security!).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "time_zone": timeZone?.toJson(),
    "user_agent": userAgent?.toJson(),
  };
}

class Carrier {
  dynamic name;
  dynamic mcc;
  dynamic mnc;

  Carrier({
    this.name,
    this.mcc,
    this.mnc,
  });

  factory Carrier.fromJson(Map<String, dynamic> json) => Carrier(
    name: json["name"],
    mcc: json["mcc"],
    mnc: json["mnc"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "mcc": mcc,
    "mnc": mnc,
  };
}

class Company {
  String? domain;
  String? name;
  String? type;

  Company({
    this.domain,
    this.name,
    this.type,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    domain: json["domain"],
    name: json["name"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "domain": domain,
    "name": name,
    "type": type,
  };
}

class Connection {
  int? asn;
  String? domain;
  String? organization;
  String? route;
  String? type;

  Connection({
    this.asn,
    this.domain,
    this.organization,
    this.route,
    this.type,
  });

  factory Connection.fromJson(Map<String, dynamic> json) => Connection(
    asn: json["asn"],
    domain: json["domain"],
    organization: json["organization"],
    route: json["route"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "asn": asn,
    "domain": domain,
    "organization": organization,
    "route": route,
    "type": type,
  };
}

class Currency {
  String? code;
  String? name;
  String? nameNative;
  String? plural;
  String? pluralNative;
  String? symbol;
  String? symbolNative;
  Format? format;

  Currency({
    this.code,
    this.name,
    this.nameNative,
    this.plural,
    this.pluralNative,
    this.symbol,
    this.symbolNative,
    this.format,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    code: json["code"],
    name: json["name"],
    nameNative: json["name_native"],
    plural: json["plural"],
    pluralNative: json["plural_native"],
    symbol: json["symbol"],
    symbolNative: json["symbol_native"],
    format: json["format"] == null ? null : Format.fromJson(json["format"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "name_native": nameNative,
    "plural": plural,
    "plural_native": pluralNative,
    "symbol": symbol,
    "symbol_native": symbolNative,
    "format": format?.toJson(),
  };
}

class Format {
  Tive? negative;
  Tive? positive;

  Format({
    this.negative,
    this.positive,
  });

  factory Format.fromJson(Map<String, dynamic> json) => Format(
    negative:
    json["negative"] == null ? null : Tive.fromJson(json["negative"]),
    positive:
    json["positive"] == null ? null : Tive.fromJson(json["positive"]),
  );

  Map<String, dynamic> toJson() => {
    "negative": negative?.toJson(),
    "positive": positive?.toJson(),
  };
}

class Tive {
  String? prefix;
  String? suffix;

  Tive({
    this.prefix,
    this.suffix,
  });

  factory Tive.fromJson(Map<String, dynamic> json) => Tive(
    prefix: json["prefix"],
    suffix: json["suffix"],
  );

  Map<String, dynamic> toJson() => {
    "prefix": prefix,
    "suffix": suffix,
  };
}

class Location {
  Continent? continent;
  Country? country;
  Continent? region;
  String? city;
  String? postal;
  double? latitude;
  double? longitude;
  Language? language;
  bool? inEu;

  Location({
    this.continent,
    this.country,
    this.region,
    this.city,
    this.postal,
    this.latitude,
    this.longitude,
    this.language,
    this.inEu,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    continent: json["continent"] == null
        ? null
        : Continent.fromJson(json["continent"]),
    country:
    json["country"] == null ? null : Country.fromJson(json["country"]),
    region:
    json["region"] == null ? null : Continent.fromJson(json["region"]),
    city: json["city"],
    postal: json["postal"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    language: json["language"] == null
        ? null
        : Language.fromJson(json["language"]),
    inEu: json["in_eu"],
  );

  Map<String, dynamic> toJson() => {
    "continent": continent?.toJson(),
    "country": country?.toJson(),
    "region": region?.toJson(),
    "city": city,
    "postal": postal,
    "latitude": latitude,
    "longitude": longitude,
    "language": language?.toJson(),
    "in_eu": inEu,
  };
}

class Continent {
  String? code;
  String? name;

  Continent({
    this.code,
    this.name,
  });

  factory Continent.fromJson(Map<String, dynamic> json) => Continent(
    code: json["code"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
  };
}

class Country {
  int? area;
  List<String>? borders;
  String? callingCode;
  String? capital;
  String? code;
  String? name;
  int? population;
  double? populationDensity;
  Flag? flag;
  List<Language>? languages;
  String? tld;

  Country({
    this.area,
    this.borders,
    this.callingCode,
    this.capital,
    this.code,
    this.name,
    this.population,
    this.populationDensity,
    this.flag,
    this.languages,
    this.tld,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    area: json["area"],
    borders: json["borders"] == null
        ? []
        : List<String>.from(json["borders"]!.map((x) => x)),
    callingCode: json["calling_code"],
    capital: json["capital"],
    code: json["code"],
    name: json["name"],
    population: json["population"],
    populationDensity: json["population_density"]?.toDouble(),
    flag: json["flag"] == null ? null : Flag.fromJson(json["flag"]),
    languages: json["languages"] == null
        ? []
        : List<Language>.from(
        json["languages"]!.map((x) => Language.fromJson(x))),
    tld: json["tld"],
  );

  Map<String, dynamic> toJson() => {
    "area": area,
    "borders":
    borders == null ? [] : List<dynamic>.from(borders!.map((x) => x)),
    "calling_code": callingCode,
    "capital": capital,
    "code": code,
    "name": name,
    "population": population,
    "population_density": populationDensity,
    "flag": flag?.toJson(),
    "languages": languages == null
        ? []
        : List<dynamic>.from(languages!.map((x) => x.toJson())),
    "tld": tld,
  };
}

class Flag {
  String? emoji;
  String? emojiUnicode;
  String? emojitwo;
  String? noto;
  String? twemoji;
  String? wikimedia;

  Flag({
    this.emoji,
    this.emojiUnicode,
    this.emojitwo,
    this.noto,
    this.twemoji,
    this.wikimedia,
  });

  factory Flag.fromJson(Map<String, dynamic> json) => Flag(
    emoji: json["emoji"],
    emojiUnicode: json["emoji_unicode"],
    emojitwo: json["emojitwo"],
    noto: json["noto"],
    twemoji: json["twemoji"],
    wikimedia: json["wikimedia"],
  );

  Map<String, dynamic> toJson() => {
    "emoji": emoji,
    "emoji_unicode": emojiUnicode,
    "emojitwo": emojitwo,
    "noto": noto,
    "twemoji": twemoji,
    "wikimedia": wikimedia,
  };
}

class Language {
  String? code;
  String? name;
  String? native;

  Language({
    this.code,
    this.name,
    this.native,
  });

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    code: json["code"],
    name: json["name"],
    native: json["native"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "native": native,
  };
}

class TimeZone {
  String? id;
  String? abbreviation;
  DateTime? currentTime;
  String? name;
  int? offset;
  bool? inDaylightSaving;

  TimeZone({
    this.id,
    this.abbreviation,
    this.currentTime,
    this.name,
    this.offset,
    this.inDaylightSaving,
  });

  factory TimeZone.fromJson(Map<String, dynamic> json) => TimeZone(
    id: json["id"],
    abbreviation: json["abbreviation"],
    currentTime: json["current_time"] == null
        ? null
        : DateTime.parse(json["current_time"]),
    name: json["name"],
    offset: json["offset"],
    inDaylightSaving: json["in_daylight_saving"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "abbreviation": abbreviation,
    "current_time": currentTime?.toIso8601String(),
    "name": name,
    "offset": offset,
    "in_daylight_saving": inDaylightSaving,
  };
}

class UserAgent {
  String? header;
  String? name;
  String? type;
  String? version;
  String? versionMajor;
  Device? device;
  Engine? engine;
  Engine? os;

  UserAgent({
    this.header,
    this.name,
    this.type,
    this.version,
    this.versionMajor,
    this.device,
    this.engine,
    this.os,
  });

  factory UserAgent.fromJson(Map<String, dynamic> json) => UserAgent(
    header: json["header"],
    name: json["name"],
    type: json["type"],
    version: json["version"],
    versionMajor: json["version_major"],
    device: json["device"] == null ? null : Device.fromJson(json["device"]),
    engine: json["engine"] == null ? null : Engine.fromJson(json["engine"]),
    os: json["os"] == null ? null : Engine.fromJson(json["os"]),
  );

  Map<String, dynamic> toJson() => {
    "header": header,
    "name": name,
    "type": type,
    "version": version,
    "version_major": versionMajor,
    "device": device?.toJson(),
    "engine": engine?.toJson(),
    "os": os?.toJson(),
  };
}

class Device {
  dynamic brand;
  String? name;
  String? type;

  Device({
    this.brand,
    this.name,
    this.type,
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
    brand: json["brand"],
    name: json["name"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "brand": brand,
    "name": name,
    "type": type,
  };
}

class Engine {
  String? name;
  String? type;
  String? version;
  String? versionMajor;

  Engine({
    this.name,
    this.type,
    this.version,
    this.versionMajor,
  });

  factory Engine.fromJson(Map<String, dynamic> json) => Engine(
    name: json["name"],
    type: json["type"],
    version: json["version"],
    versionMajor: json["version_major"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "type": type,
    "version": version,
    "version_major": versionMajor,
  };
}
