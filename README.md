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
`

# API endpoints

Following is the list of all API endpoints with all possible status code and responses.

### Request `GET /countries`

```
localhost:3001/countries?expression=[?name.common == 'Iran']
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
  "param is missing or the value is empty: expression"
```
#### Few examples of valid JMESPath expressions

* ```[?population > `83992953`] || [?name.common == `Saudi Arabia`]```
* ```[?languages.eng == 'English']```
* ```[?area == `9706961.0`]```

Find more information about JMESPath here: https://jmespath.org/

### Request `GET /sorted_data`

```
localhost:3001/sorted_data?sort_by=population&order_by=desc&page=1&per=5
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

* `sort_by` and `order_by` are reuired params. If you do not include it or misspell with your request then you will get following error.
```
  "param is missing or the value is empty: sort_by"
```
* If you try to apply sorting on a key (ex: language) that is not an array of numbers or integers then JMESPath can not sort the data and   you will receive following error.
```
  "function sort() expects values to be an array of numbers or integers"
```

## Use this if you are a CURL fan :) 

```
curl -X GET \
  -H "Authorization: Basic Zm9vOmJhcg==" \
  "http://localhost:3001/sorted_data?sort_by=population&order_by=desc&page=1&per=15"
```
## Few useful screenshots if you are a Postman fan :) 

Use Bacic Auth under `Authorization` tab and add secrets (Please rechout to me if you are unable to find credential.)

<kbd><img width="1269" alt="Screenshot 2023-08-17 at 11 53 35 AM" src="https://github.com/arpanp1986/interviewTest/assets/3536808/d1e05aa4-027f-4b78-ac16-755e76e09688"></kbd>

Make sure to include necessary `Headers`

<kbd>
  <img width="1265" alt="Screenshot 2023-08-17 at 11 58 23 AM" src="https://github.com/arpanp1986/interviewTest/assets/3536808/87796411-6490-4bf3-9b9f-931fd5eafe19">
</kbd>

