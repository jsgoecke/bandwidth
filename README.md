Bandwidth
=========

Ruby gem for consuming the [Bandwidth REST API](https://my.bandwidth.com/portal/apidoc/welcome.htm).

Installation
------------

	gem install bandwidth

Example
-------

[API Docs](http://jsgoecke.github.com/bandwdith)

	require 'rubygems'
	require 'bandwidth'
	bandwidth = Bandwidth.new(:developer_key => 'your developer key')
	bandwidth.area_code_number_search :area_code => '720', :max_quantity => 1

Returns (using awesome_print gem):

	{
	       "body" => {
	        "numberSearchResponse" => {
	                   "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
	                    "quantity" => "1",
	                   "requestID" => "463f5cd2-e75d-4cc2-9ab1-1235a3dd283c",
	                "dateTimeSent" => "2011-03-18 19:48:04Z",
	                    "warnings" => nil,
	                      "errors" => nil,
	                   "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
	            "telephoneNumbers" => {
	                "telephoneNumber" => {
	                               "e164" => "+17205551212",
	                             "npaNxx" => "720555",
	                           "tenDigit" => "7205551212",
	                    "formattedNumber" => "1-720-555-1212",
	                           "numberID" => "6f37a640-0d9d-45cc-b97b-d6ad77f220b2",
	                             "status" => "Available",
	                         "rateCenter" => {
	                         "name" => "DENVERSLVN",
	                         "lata" => "656",
	                        "state" => "CO"
	                    }
	                }
	            },
	                     "message" => "Successfully executed specified number search.",
	                      "status" => "success",
	                       "xmlns" => "http://www.bandwidth.com/api/"
	        }
	    },
	       "code" => 200,
	    "headers" => {
	              "X-Powered-By" => "Bandwidth.com",
	        "X-API-SupportEmail" => "apifeedback@bandwidth.com",
	              "Content-Type" => "text/xml; charset=utf-8",
	                      "Date" => "Fri, 18 Mar 2011 19:48:04 GMT",
	            "Content-Length" => "825",
	                    "Server" => "Microsoft-IIS/7.0",
	             "Cache-Control" => "private",
	          "X-AspNet-Version" => "2.0.50727"
	    }
	}

Available Methods
-----------------

Full details of available methods [here](https://my.bandwidth.com/portal/apidoc/2-x-supported-operations.htm).

	[2.x] Supported Operations, Numbers - getTelephoneNumber
	[2.x] Supported Operations, Numbers - getNumberOrder
	[2.x] Supported Operations, Numbers - getNumberOrders (developer, account)
	[2.x] Supported Operations, Numbers - areaCodeNumberSearch
	[2.x] Supported Operations, Numbers - npaNxxNumberSearch
	[2.x] Supported Operations, Numbers - rateCenterNumberSearch
	[2.x] Supported Operations, Numbers - rateCenterNumberOrder
	[2.x] Supported Operations, Numbers - tollfreeNumberSearch
	[2.x] Supported Operations, Numbers - tollfreeNumberOrder
	[2.x] Supported Operations, Numbers - basicNumberOrder
	[2.x] Supported Operations, Numbers - changeNumber
	[2.x] Supported Operations, Numbers - sipTrunkOrder
	[2.x] Supported Operations, Cdr - getCdrArchive
	(restricted use)
	[2.x] Restricted Operations, Numbers - consumedNumbers
	[2.x] Restricted Operations, Numbers - reserveNumbers
	[2.x] Restricted Operations, Numbers - pbod
	[2.x] Restricted Operations, Numbers - rateCenterBlockOrder
	[2.x] Restricted Operations, Numbers - getRateCenterBlockOrder
	[2.x] Restricted Operations, Numbers - getRateCenterBlockOrders

Copyright
---------

Copyright (c) 2011 Jason Goecke. See LICENSE.txt for
further details.
