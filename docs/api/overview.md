---
description: "Using the Nextflow Tower API."
---

Tower exposes a public API with all the necessary endpoints to manage Nextflow workflows programmatically, allowing organizations to incorporate Tower seamlessly into their existing processes.

## Overview

The Tower API can be accessed from `https://api.tower.nf`. All API endpoints use HTTPS, and all request and response payloads use [JSON](https://www.json.org/) encoding. All timestamps use the [ISO 8601](https://www.iso.org/iso-8601-date-and-time-format.html) date-time standard format: `YYYY-MM-DDTHH:MM:SSZ`.

### OpenAPI

The Tower API uses the [OpenAPI](https://swagger.io/specification/) standard. The current OpenAPI schema for Tower can be found [here](https://tower.nf/openapi/nextflow-tower-api-latest.yml).

### Endpoints

You can find a detailed list of all Tower endpoints [here](https://tower.nf/openapi/index.html). This page also includes request and response payload examples, and the ability to test each endpoint interactively.

### Programmatic API

You can use tools such as [openapi-python-client](https://github.com/openapi-generators/openapi-python-client) to generate a programmatic API for a particular language (e.g. Python) based on the OpenAPI schema. However, we do not guarantee that any OpenAPI client generator will work with Tower API; use them at your own risk.

## Authentication

Tower API requires an authentication token to be specified in each API request using the
[Bearer](https://swagger.io/docs/specification/authentication/bearer-authentication) HTTP header.

Your personal authorization token can be found in your settings, at the top-right corner of the page under the
[Your tokens](https://tower.nf/tokens) section.

![](_images/your_tokens.png)

To create a new access token, just provide a name for the token. This will help to identify it later.

![](_images/token_form.png)

Once created, the token can only be seen once, when it is initially created. It is important you keep this token at a safe place.

![](_images/personal_access_token.png)

Once created, use the token to authenticate via cURL, Postman, or within your code against the Nextflow API to perform the necessary calls for completing your tasks.
Please remember that, as any other Bearer token, this token must be included in every API call.

### cURL example

```bash
curl -H "Authorization: Bearer eyJ...YTk0" https://tower.nf/api/workflow
```

!!! hint "Use your token in every API call"
Please remember that, as any other Bearer token, this token must be included in every API call. You can find at the following link more details about the [Bearer token authentication](https://swagger.io/docs/specification/authentication/bearer-authentication). scheme.

## Parameters

Some API `GET` methods will accept standard `query` parameters, which are defined in the documentation; `querystring` optional
parameters such as page size, number (when available) and file name; and body parameters, mostly used for `POST`, `PUT` and `DELETE` requests.

Additionally, several head parameters are accepted such as `Authorization` for bearer access token or `Accept-Version` to indicate the desired API version to use (default to version 1)

```bash
curl -H "Authorization: Bearer QH..E5M="
     -H "Accept-Version:1"
     -X POST https://tower.nf/api/domain/{item_id}?queryString={value}
     -d { params: { "key":"value" } }

```

## Client errors

There exists two typical standard errors, or non `200` or `204` status responses, to expect from the API.

### Bad Request

The request payload is not properly defined or the query parameters are invalid.

```json
{
  "message": "Oops... Unable to process request - Error ID: 54apnFENQxbvCr23JaIjLb"
}
```

### Forbidden

Your access token is invalid or expired. This response may also imply that the entry point you are trying to access is not available; in such a case, it is recommended you check your request syntax.

```bash
Status: 403 Forbidden
```

## Rate limiting

For all API requests, there is a limit of 20 calls per second (72000 calls per hour) and access key.
