class Noticia {
    String author;
    String content;
    String description;
    String publishedAt;
    Source source;
    String title;
    String url;
    String urlToImage;


    @override
    String toString() {
        return 'Noticia{author: $author, content: $content, description: $description, publishedAt: $publishedAt, source: $source, title: $title, url: $url, urlToImage: $urlToImage}';
    }

    Noticia({this.author, this.content, this.description, this.publishedAt, this.source, this.title, this.url, this.urlToImage});

    factory Noticia.fromJson( json) {
        return Noticia(
            author: json['author'] != null ? json['author'] : null,
            content: json['content'] != null ? json['content'] : null,
            description: json['description'],
            publishedAt: json['publishedAt'],
            source: json['source'] != null ? Source.fromJson(json['source']) : null,
            title: json['title'],
            url: json['url'],
            urlToImage: json['urlToImage'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['description'] = this.description;
        data['publishedAt'] = this.publishedAt;
        data['title'] = this.title;
        data['url'] = this.url;
        data['urlToImage'] = this.urlToImage;
        if (this.author != null) {
            data['author'] = this.author;
        }
        if (this.content != null) {
            data['content'] = this.content;
        }
        if (this.source != null) {
            data['source'] = this.source.toJson();
        }
        return data;
    }
}

class Source {
    String id;
    String name;

    Source({this.id, this.name});

    factory Source.fromJson(json) {
        return Source(
            id: json['id'] != null ? json['id'] : null,
            name: json['name'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['name'] = this.name;
        if (this.id != null) {
            data['id'] = this.id;
        }
        return data;
    }
}