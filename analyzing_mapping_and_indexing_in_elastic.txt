# analyzing mapping and indexing in elastic

/*

POST _analyze
{
  "text": "2 guys walk into    a bar, but the third... DUCKS! :-)",
  "analyzer": "standard"
}

POST _analyze
{
  "text": "2 guys walk into    a bar, but the third... DUCKS! :-)",
  "char_filter": [],
  "tokenizer": "standard",
  "filter": ["lowercase"]
}

//mappings
PUT reviews
{
  "mappings": {
    "properties": {
      "rating": { "type": "float" },
      "content": { "type": "text" },
      "product_id": { "type": "integer" },
      "author": {
        "properties": {
          "first_name": { "type": "text" },
          "last_name": { "type": "text" },
          "email": { "type": "keyword" }
        }
      }
    }
  }
}

GET reviews/_mapping

GET reviews/_mapping/field/content

Get reviews/_mapping/field/author.email

//editing a mapping
PUT reviews/_mapping
{
  "properties": {
    "created_at": {
      "type": "date"
    }
  }
}



POST _reindex
{
  "source": {
    "index": "reviews"
  },
  "dest": {
    "index": "reviews_new"
  }
}


POST _reindex
{
  "source": {
    "index": "reviews"
    "query": {
      "match_all": {}
    }
  },
  "dest": {
    "index": "reviews_new"
  }
  , "script": {
    "source": """
      if(ctx._source.product_id != null) {
        ctx._source.product_id = ctx._source.product_id.toString();
      }
    """
  }
}

//alias a field name
PUT reviews/_mapping
{
  "properties": {
    "comment": {
      "type": "alias",
      "path": "content"
    }
  }
}

//multi-field mappings

PUT multi_field_test
{
  "mappings": {
    "properties": {
      "description": {
        "type": "text"
      },
      "ingredients": {
        "type": "text",
        "fields": {
          "keyword": {
            "type": "keyword"
          }
        }
      }
    }
  }
}


POST multi_field_test/_doc
{
  "description": "To make this spaghetti carbonara, you first need to...",
  "ingredients": ["Spaghetti", "Bacon", "Eggs"]
}

GET multi_field_test/_search
{
  "query": {
    "match_all": {}
  }
}

GET multi_field_test/_search
{
  "query": {
    "match": {
      "ingredients": "Spaghetti"
    }
  }
}

GET multi_field_test/_search
{
  "query": {
    "term": {
      "ingredients.keyword": "Spaghetti"
    }
  }
}


//index templates -- settings/mappings automatically applied to matching indices
PUT _template/access-logs
{
  "index_patterns": ["access-logs-*"],
  "settings": {
    "number_of_shards": 2,
    "index.mapping.coerce": false
  },
  "mappings": {
    "properties": {
      "@timestamp": {
        "type": "date"
      },
      "url.original": {
        "type": "keyword"
      },
      "http.request.referrer": {
        "type": "keyword"
      },
      "http.response.status_code": {
        "type": "long"
      }
    }
  }
}

PUT access-logs-2020-01-01
GET access-logs-2020-01-01
PUT people
{
  "mappings": {
    "dynamic": false, (strict, true, false)
    "properties": {
      "first_name": {
        "type": "text"
      }
    }
  }
}
POST people/_doc
{
  "first_name": "Bo",
  "last_name": "Anderson"
}
GET people/_mapping

GET people/_search
{
  "query": {
    "match": {
      "first_name": "Bo"
    }
  }
}
GET people/_search
{
  "query": {
    "match": {
      "last_name": "Anderson"
    }
  }
}
DELETE people

PUT dynamic_template_test
{
  "mappings": {
    "dynamic_templates": [
      {
        "integers": {
          "match_mapping_type": "long",
          "mapping": {
            "type": "integer"
          }
        }
      }
    ]
  }
}
PUT analyzer_test
{
  "settings": {
    "analysis": {
      "analyzer": {
        "my_custom_analyzer": {
          "type": "custom",
          "char_filter": ["html_strip"],
          "tokenizer": "standard",
          "filter": [
            "lowercase",
            "stop",
            "asciifolding"
            ]
        }
      }
    }
  }
}

PUT analyzer_test
{
  "settings": {
    "analysis": {
      "filter": {
        "danish_stop": {
          "type": "stop",
          "stopwords": "_danish_"
        }
      },
      "char_filter": {},
      "tokenizer": {},
      "analyzer": {
        "my_custom_analyzer": {
          "type": "custom",
          "char_filter": ["html_strip"],
          "tokenizer": "standard",
          "filter": [
            "lowercase",
            "danish_stop",
            "asciifolding"
            ]
        }
      }
    }
  }
}

POST _analyze
{
  "char_filter": ["html_strip"],
  "text": "I&apos;m in a <em>good</em> mood&nbsp; -&nbsp;and I <strong>love</strong> açai!"
}

POST analyzer_test/_analyze
{
  "analyzer": "my_custom_analyzer",
  "text": "I&apos;m in a <em>good</em> mood&nbsp; -&nbsp;and I <strong>love</strong> açai!"
}

PUT analyzer_test/_settings
{
  "analysis": {
    "analyzer": {
      "my_second_analyzer": {
        "type": "custom",
        "char_filter": ["html_strip"],
        "tokenizer": "standard",
        "filter": [
          "lowercase",
          "stop",
          "asciifolding"
          ]
      }
    }
  }
}

POST analyzer_test/_close
POST analyzer_test/_open
GET analyzer_test/_settings




PUT analyzer_test/_mapping
{
  "properties": {
    "description": {
      "type": "text",
      "analyzer": "my_custom_analyzer"
    }
  }
}

POST analyzer_test/_doc
{
  "description": "Is that Peter's cute-looking dog?"
}


GET analyzer_test/_search
{
  "query": {
    "match": {
      "description": {
        "query": "that",
        "analyzer": "keyword"
      }
    }
  }
}

POST analyzer_test/_close
PUT analyzer_test/_settings
{
  "analysis": {
    "analyzer": {
      "my_custom_analyzer": {
        "type": "custom",
        "tokenizer": "standard",
        "char_filter": ["html_strip"],
        "filter": [
          "lowercase",
          "asciifolding"
        ]
      }
    }
  }
}

POST analyzer_test/_open
GET analyzer_test/_settings
POST analyzer_test/_update_by_query?conflicts=proceed
*/

