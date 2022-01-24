# searching in elastic

/*
 curl -XGET -u elastic:JDkhDy6vgmKWMWqZT67lqjQm "https://elasticsearchplayground.es.eastus2.azure.elastic-cloud.com:9243/recipe/_search?format=json" -H 'Content-Type: application/json' -d
GET products/_search?q=*
GET products/_search?q=name:Lobster
GET products/_search?q=tags:Meat AND name:Tuna

GET products/_search
{
  "query": {
    "match_all": {}
  }
}

GET products/_search?explain
{
  "query": {
    "term": {
      "name": "Lobster"
    }
  }
}

GET products/_search
{
  "query": {
    "match": {
      "name": "Lobster"
    }
  }
}

GET products/_search
{
  "query": {
    "terms": {
      "tags.keyword": [
        "Soup",
        "Cake"
      ]
    }
  }
}

GET products/_search
{
  "query": {
    "ids": {
      "values": [1, 2, 3]
    }
  }
}


GET products/_search
{
  "query": {
    "range": {
      "in_stock": {
        "gte": 1,
        "lte": 5
      }
    }
  }
}

GET products/_search
{
  "query": {
    "range": {
      "created": {
        "gte": "01-01-2010",
        "lte": "31-12-2010",
        "format": "dd-MM-yyyy"
      }
    }
  }
}
GET products/_search
{
  "query": {
    "range": {
      "created": {
        "gte": "2010/01/01||-1y/M"
      }
    }
  }
}

GET products/_search
{
  "query": {
    "range": {
      "created": {
        "gte": "now"
      }
    }
  }
}

GET products/_search
{
  "query": {
    "exists": {
      "field": "tags"
    }
  }
}

GET products/_search
{
  "query": {
    "prefix": {
      "tags.keyword": "Vege"
    }
  }
}

GET products/_search
{
  "query": {
    "wildcard": {
      "tags.keyword":"Veg*ble"
    }
  }
}

GET products/_search
{
  "query": {
    "wildcard": {
      "tags.keyword":"Veget?ble"
    }
  }
}

GET products/_search
{
  "query": {
    "regexp": {
      "tags.keyword": "Veget[a-zA-Z]+ble"
    }
  }
}

products where sold is < 10

GET products/_search
{
  "query": {
    "range": {
      "sold": {
        "gte": 0,
        "lte": 9
      }
    }

  }
}

sold < 30
sold >= 10

GET products/_search
{
  "query": {
    "range": {
      "sold": {
        "gte": 10
        , "lte": 29
      }
    }
  }
}

tags == 'Meat'

GET products/_search
{
  "query": {
    "term": {
      "tags.keyword": "Meat"
    }
  }
}

name == 'Tomato' or name == "Paste"

GET products/_search
{
  "query": {
    "terms": {
      "tags.keyword": [
        "Tomato",
        "Paste"
      ]
    }
  }
}

name == 'Pasta' or name == "Paste" or similar

GET products/_search
{
  "query": {
    "wildcard": {
      "name": {
        "value": "past?"
      }
    }
  }
}

name field containing a number (regexp)

GET products/_search
{
  "query": {
    "regexp": {
      "name": "[0-9]+"
    }
  }
}

GET recipe/_search
{
  "query": {
    "match": {
      "title": "Recipes with pasta or spaghetti"
    }
  }
}

GET recipe/_search
{
  "query": {
    "match": {
      "title": {
        "query": "pasta spaghetti",
        "operator": "and"
      }
    }
  }
}

GET recipe/_search
{
  "query": {
    "match_phrase": {
      "title": "spaghetti puttanesca"
    }
  }
}

GET recipe/_search
{
  "query": {
    "multi_match": {
      "query": "pasta",
      "fields": ["title", "description"]
    }
  }
}

GET recipe/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "ingredients.name": "parmesan"
          }
        },
        {
          "range": {
            "preparation_time_minutes": {
              "lte": 15
            }
          }
        }
      ]
    }
  }
}

GET recipe/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "ingredients.name": "parmesan"
          }
        }
      ],
      "filter": [
        {
          "range": {
            "preparation_time_minutes": {
              "lte": 15
            }
          }
        }
      ]
    }
  }
}

GET recipe/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "ingredients.name": "parmesan"
          }
        }
      ],
      "must_not": [
        {
          "match": {
            "ingredients.name": "tuna"
          }
        }
      ],
      "should": [
        {
          "match": {
            "ingredients.name": "parsely"
          }
        }
      ],
      "filter": [
        {
          "range": {
            "preparation_time_minutes": {
              "lte": 15
            }
          }
        }
      ]
    }
  }
}

// SHOULD is optional and only boosts relevance score

GET recipe/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "ingredients.name": "pasta"
          }
        }
      ],
      "should": [
        {
          "match": {
            "ingredients.name": "parmesan"
          }
        }
      ]
    }
  }


}
// at least one SHOULD must match

GET recipe/_search
{
  "query": {
    "bool": {
      "should": [
        {
          "match": {
            "ingredients.name": "parmesan"
          }
        }
      ]
    }
  }
}

GET recipe/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "ingredients.name": {
              "query": "parmesan",
              "_name": "parmesan_must"
            }
          }
        }
      ],
      "must_not": [
        {
          "match": {
            "ingredients.name": {
              "query": "tuna",
              "_name": "tuna_must_not"
            }
          }
        }
      ],
      "should": [
        {
          "match": {
            "ingredients.name": {
              "query": "parsley",
              "_name": "parsley_should"
            }
          }
        }
      ],
      "filter": [
        {
          "range": {
            "preparation_time_minutes": {
              "lte": 15,
              "_name": "prep_time_filter"
            }
          }
        }
      ]
    }
  }
}


GET recipe/_search
{
  "query": {
    "match": {
      "title": "pasta carbonara"
    }
  }
}


GET recipe/_search
{
  "query": {
    "bool": {
      "should": [
        {
          "term": {
            "title": "pasta"
          }
        },
        {
          "term": {
            "title": "carbonara"
          }
        }
      ]
    }
  }
}





GET recipe/_search
{
  "query": {
    "match": {
      "title": {
        "query": "pasta carbonara",
        "operator": "and"
      }
    }
  }
}

GET recipe/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "term": {
            "title": "pasta"
          }
        },
        {
          "term": {
            "title": "carbonara"
          }
        }
      ]
    }
  }
}

PUT department
{
  "mappings": {
    "properties": {
      "name": {
        "type": "text"
      },
      "employees": {
        "type": "nested"
      }
    }
  }
}

POST department/_doc/1
{
  "name": "Development",
  "employees": [
    {
      "name": "Eric Green",
      "age": 39,
      "gender": "M",
      "position": "Big Data Specialist"
    },
    {
      "name": "James Taylor",
      "age": 27,
      "gender": "M",
      "position": "Software Developer"
    },
    {
      "name": "Gary Jenkins",
      "age": 21,
      "gender": "M",
      "position": "Intern"
    },
    {
      "name": "Julie Powell",
      "age": 26,
      "gender": "F",
      "position": "Intern"
    },
    {
      "name": "Benjamin Smith",
      "age": 46,
      "gender": "M",
      "position": "Senior Software Engineer"
    }
  ]
}

POST department/_doc/2
{
  "name": "HR & Marketing",
  "employees": [
    {
      "name": "Patricia Lewis",
      "age": 42,
      "gender": "F",
      "position": "Senior Marketing Manager"
    },
    {
      "name": "Maria Anderson",
      "age": 56,
      "gender": "F",
      "position": "Head of HR"
    },
    {
      "name": "Margaret Harris",
      "age": 19,
      "gender": "F",
      "position": "Intern"
    },
    {
      "name": "Ryan Nelson",
      "age": 31,
      "gender": "M",
      "position": "Marketing Manager"
    },
    {
      "name": "Kathy Williams",
      "age": 49,
      "gender": "F",
      "position": "SEM Specialist"
    }
  ]
}

look for postion:intern and gender:F


GET department/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "employees.position": "intern"
          }
        },
        {
          "term": {
            "employees.gender.keyword": {
              "value": "F"
            }
          }
        }
      ]
    }
  }
}

GET department/_search
{
  "query": {
    "nested": {
      "path": "employees",
      "query": {
        "bool": {
          "must": [
            {
              "match": {
                "employees.position": "intern"
              }
            },
            {
              "term": {
                "employees.gender.keyword": {
                  "value": "F"
                }
              }
            }
          ]
        }
      }
    }
  }
}

 curl -XGET -u elastic:JDkhDy6vgmKWMWqZT67lqjQm "https://elasticsearchplayground.es.eastus2.azure.elastic-cloud.com:9243/recipe/_search?format=json" -H 'Content-Type: application/json' -d'
{
  "query": {
    "match": {
      "title": "pasta"
    }
  }
}'

GET recipe/_search?pretty
{
  "query": {
    "match": {
      "title": "pasta"
    }
  }
}

GET /recipe/_search
{
  "_source": ["ingredients.*", "servings"],
  "query": {
    "match": {
      "title": "pasta"
    }
  }
}

GET /recipe/_search
{
  "_source": {
    "includes": "ingredients.*",
    "excludes": "ingredients.name"
  },
  "query": {
    "match": {
      "title": "pasta"
    }
  }
}

GET /order/_search
{
  "size": 0,
  "aggs": {
    "filtered_results": {
      "filter": {
        "term": { "status" : "completed" }
      }
    }
  }
}

GET /order/_search
{
  "size": 0,
  "query": {
    "term": {
      "status": "completed"
    }
  }
}

GET /order/_search
{
  "size": 0,
  "aggs": {
    "low_value": {
      "filter": {
        "range": {
          "total_amount": {
            "lt": 50
          }
        }
      }
    }
  }
}

GET /order/_search
{
  "size": 0,
  "query": {
    "bool": {
      "filter": {
        "range": {
          "total_amount": {
            "lte": 50
          }
        }
      }
    }
  }
}

GET /recipe/_search
{
  "size": 0,
  "aggs": {
    "a_filter_of_some_kind": {
      "filters": {
        "filters": {
          "bitch_pasta_is_here": {
            "match": {
              "title": "pasta"
            }
          },
          "hungry_hippo_meals": {
            "range": {
              "servings.min": {
                "gte": 4
              }
            }
          }
        }
      }
    },
    "not_hungry_hippo_meals": {
      "filter": {
        "range": {
          "servings.max": {
            "gte": 5
          }
        }
      }
    }
  }
}

GET /order/_search
{
  "size": 0,
  "aggs": {
    "amount_distribution": {
      "range": {
        "field": "total_amount",
        "ranges": [
          {
            "to": 50
          },
          {
            "from": 50,
            "to": 100
          },
          {
            "from": 100
          }
        ]
      }
    }
  }
}

*/
