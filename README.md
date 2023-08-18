[![RSpec Tests](https://github.com/arpanp1986/interviewTest/actions/workflows/rspec.yml/badge.svg)](https://github.com/arpanp1986/interviewTest/actions/workflows/rspec.yml)
# README

To run the application locally

* Install Ruby version 3.1.1

* Clone the repository

* Run command `bundle install` to install all the Gems.

* Run all the unit tests before testing the endpoints manually by running `bundle exec rspec`.

* Run command `bundle install` to install all the Gems

* Run all the unit tests before testing the endpoints manually by running `bundle exec rspec`

* Run command `bundle exec rails s` to start server on localhost:3000

* Make a curl request for smoke testing:
  `curl -X GET \
  -H "Authorization: Basic Zm9vOmJhcg==" \
  "http://localhost:3000/sorted_data?sort_by=population&order_by=desc&page=1&per=15"

# I have included two implementations
  * Using JMESPath search implementation
  * Using postgres DB with columntype as jsonb
    
Both are efficient and powerful for searching through JSON object.

## API endpoints for querying JSON using JMESPath search implementation under the hood.

Following is the list of all API endpoints with all possible status code and responses.

### Request `GET /countries`

```
localhost:3000/countries?expression=[?name.common == 'Iran']
```

#### Status Codes

| Status Code   | Comment                             |
| ------------- | ----------------------------------- |
| 200           | Successfully completed the request  |
| 401           | unauthorised request                |
| 422           | Unprocessable entiry                |
| 404           | Invalid route      |

#### Response
```
[
    {
        "name": {
            "common": "Iran",
            "official": "Islamic Republic of Iran",
            "nativeName": {
                "fas": {
                    "official": "جمهوری اسلامی ایران",
                    "common": "ایران"
                }
            }
        },
        "tld": [
            ".ir",
            "ایران."
        ],
        "cca2": "IR",
        "ccn3": "364",
        "cca3": "IRN",
        "cioc": "IRI",
        "independent": true,
        "status": "officially-assigned",
        "unMember": true,
        "currencies": {
            "IRR": {
                "name": "Iranian rial",
                "symbol": "﷼"
            }
        },
        ......
        "postalCode": {
            "format": "##########",
            "regex": "^(\\d{10})$"
        }
    }
]
```


#### Validations

* If you do not supply Bacis Authentication `username` and `password` your will receive 401 status.

* `expression` param is reuired. If you do not include it or misspell with your request then you will get following error.
```
{
    "Error": "param is missing or the value is empty: expression"
}
```
#### Few examples of valid JMESPath expressions

* ```[?population > `83992953`] || [?name.common == `Saudi Arabia`]```
* ```[?languages.eng == 'English']```
* ```[?area == `9706961.0`]```

Find more information about JMESPath here: https://jmespath.org/

### Request `GET /sorted_data`

```
localhost:3000/sorted_data?sort_by=population&order_by=desc&page=1&per=5
```

#### Status Codes

| Status Code   | Comment                             |
| ------------- | ----------------------------------- |
| 200           | Successfully completed the request  |
| 401           | unauthorised request                |
| 422           | Unprocessable entiry                |
| 404           | Invalid route      |

#### Response
```
[
    "China",
    "India",
    "United States",
    "Indonesia",
    "Pakistan"
]
```

#### Validations

* If you do not supply Bacis Authentication `username` and `password` your will receive 401 status.

* `sort_by` and `order_by` are reuired params. If you do not include it or misspell with your request then you will one of the following errors.
```
{
    "Error": "param is missing or the value is empty: sort_by"
}
```
```
{
    "Error": "param is missing or the value is empty: order_by"
}
```
* If you try to apply sorting on a key (ex: language) that is not an array of numbers or integers then JMESPath can not sort the data and   you will receive following error.
```
{
    "Error": "function sort() expects values to be an array of numbers or integers"
}
```





## API endpoints for querying JSON using postgres DB with columntype as jsonb.

Following is the list of all API endpoints with all possible status code and responses.

### Request `GET /countries_jsonb`

```
localhost:3000/countries_jsonb?country_name=India
```

#### Status Codes

| Status Code   | Comment                             |
| ------------- | ----------------------------------- |
| 200           | Successfully completed the request  |
| 401           | unauthorised request                |
| 422           | Unprocessable entiry                |
| 404           | Invalid route      |

#### Response
```
[
    {
        "id": 289,
        "data": {
            "car": {
                "side": "left",
                "signs": [
                    "IND"
                ]
            },
            "idd": {
                "root": "+9",
                "suffixes": [
                    "1"
                ]
            },
            "tld": [
                ".in"
            ],
            "area": 3287590.0,
            "cca2": "IN",
            "cca3": "IND",
            "ccn3": "356",
            "cioc": "IND",
            "fifa": "IND",
            "flag": "🇮🇳",
            "gini": {
                "2011": 35.7
            },
            "maps": {
                "googleMaps": "https://goo.gl/maps/WSk3fLwG4vtPQetp7",
                "openStreetMaps": "https://www.openstreetmap.org/relation/304716"
            },
            "name": {
                "common": "India",
                "official": "Republic of India",
                "nativeName": {
                    "eng": {
                        "common": "India",
                        "official": "Republic of India"
                    },
                    "hin": {
                        "common": "भारत",
                        "official": "भारत गणराज्य"
                    },
                    "tam": {
                        "common": "இந்தியா",
                        "official": "இந்தியக் குடியரசு"
                    }
                }
            },
            "flags": {
                "alt": "The flag of India is composed of three equal horizontal bands of saffron, white and green. A navy blue wheel with twenty-four spokes — the Ashoka Chakra — is centered in the white band.",
                "png": "https://flagcdn.com/w320/in.png",
                "svg": "https://flagcdn.com/in.svg"
            },
            "latlng": [
                20.0,
                77.0
            ],
            "region": "Asia",
            "status": "officially-assigned",
            "borders": [
                "BGD",
                "BTN",
                "MMR",
                "CHN",
                "NPL",
                "PAK"
            ],
          ....
        "created_at": "2023-08-17T11:07:11.043Z",
        "updated_at": "2023-08-17T11:07:11.043Z"
    }
]
```


#### Validations

* If you do not supply Bacis Authentication `username` and `password` your will receive 401 status.

* `country_name` param is reuired. If you do not include it or misspell with your request then you will get following error.
```
{
    "Error": "param is missing or the value is empty: country_name"
}
```

### Request `GET /search_sort_jsonb`

```
localhost:3000/search_sort_jsonb?data_type=integer&sort_by=population&order_by=desc&page=1&per=10
```

#### Status Codes

| Status Code   | Comment                             |
| ------------- | ----------------------------------- |
| 200           | Successfully completed the request  |
| 401           | unauthorised request                |
| 422           | Unprocessable entiry                |
| 404           | Invalid route      |

#### Response
```
[
    "China",
    "India",
    "United States",
    "Indonesia",
    "Pakistan",
    "Brazil",
    "Nigeria",
    "Bangladesh",
    "Russia",
    "Mexico"
]
```

#### Validations

* If you do not supply Bacis Authentication `username` and `password` your will receive 401 status.

* `data_type`, `sort_by` and `order_by` are reuired params. If you do not include it or misspell with your request then you will get one of thefollowing errors.
```
{
    "Error": "param is missing or the value is empty: data_type"
}
```
```
{
    "Error": "param is missing or the value is empty: sort_by"
}
```
```
{
    "Error": "param is missing or the value is empty: order_by"
}
```


### Use this as a sample CURL request 

```
curl -X GET \
  -H "Authorization: Basic Zm9vOmJhcg==" \
  "http://localhost:3000/sorted_data?sort_by=population&order_by=desc&page=1&per=15"
```
### Few useful screenshots if you are a Postman fan :) 

## Authorization

Use Bacic Auth under `Authorization` tab and add secrets (Please rechout to me if you are unable to find credential.)

<kbd>
  <img width="1235" alt="Screenshot 2023-08-18 at 9 49 11 AM" src="https://github.com/arpanp1986/interviewTest/assets/3536808/af670dca-c0a0-4692-a972-f62d0bf5c661">
</kbd>

## Headers

<kbd>
  <img width="1236" alt="Screenshot 2023-08-18 at 9 50 06 AM" src="https://github.com/arpanp1986/interviewTest/assets/3536808/b26fe8be-9170-43dc-8f00-2adcf00d588c">
</kbd>

### JMESPath implementation
<kbd>
<img width="1232" alt="Screenshot 2023-08-18 at 9 46 58 AM" src="https://github.com/arpanp1986/interviewTest/assets/3536808/73e7e871-316e-44d3-9ee0-0e090c026846">
</kbd>



<kbd>
<img width="1233" alt="Screenshot 2023-08-18 at 9 42 51 AM" src="https://github.com/arpanp1986/interviewTest/assets/3536808/21edb200-ae8b-40a7-85b1-f3636d25d4b9">
</kbd>


### Postgres and jsonb implementation
<kbd>
<img width="1234" alt="Screenshot 2023-08-18 at 9 41 03 AM" src="https://github.com/arpanp1986/interviewTest/assets/3536808/ade8f15e-d1e6-4341-b1b9-d0481d799ff8">
</kbd>



<kbd>
<img width="1235" alt="Screenshot 2023-08-18 at 9 39 12 AM" src="https://github.com/arpanp1986/interviewTest/assets/3536808/d2f211f9-d0a4-40dc-889c-80c2bf439de3">
</kbd>
