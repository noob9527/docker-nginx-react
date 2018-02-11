# docker-nginx-spa
> simply add ssl feature to [docker-nginx-react](https://github.com/zzswang/docker-nginx-react). and the original name of this repo does drive me crazy since it does nothing with react at all...

## Features
- [x] proxy_pass
- [x] pushState friendly
- [x] https: 
  docker run commands may look like this
  ```bash
	docker run -d \
		-p 443:443 \
		-p 80:80 \
		-v your-cert-location:/etc/ssl/certs/server.crt \
		-v your-key-location:/etc/ssl/private/server.key \
    your-image
  ```

## Envrionments
* APP_DIR: the root direactory of your app running in the docker container,
  usally you do not need to change it.
* APP_HTTPS_PORT: redirect http request to specify port, `return 301 https://$host:${APP_HTTPS_PORT}$request_uri;`
* APP_PATH_PREFIX: some times you would want to put several sites under one
  domain, then sub path prefix is required.
* APP_API_PLACEHOLDER: An api call start with a specific path, then the server
  will redirect the request to APP_API_GATEWAY.
* APP_API_GATEWAY: work together with APP_API_PLACEHOLDER.
* CLIENT_BODY_TIMEOUT: body timeout.
* CLIENT_HEADER_TIMEOUT: header timeout.
* CLIENT_MAX_BODY_SIZE: maximum request body size.

## examples

#### APP_API_PLACEHOLDER && APP_API_GATEWAY

**note:** we suggest you call api with a full url with domain, make your api
server independently. But we need to take care of cross domain and https issues.

If your app calls api without domain, and not deploy behind a **Well
Structured** haproxy(or other forward proxy), you can turn on this option.

```sh
APP_API_PLACEHOLDER="/api/v1"
APP_API_GATEWAY="http://api.your.domain"
```

Then all url match `/api/v1` will redirect to `http://api.your.domain`. Please
notice that the `/api/v1` is stripped.

#### APP_PATH_PREFIX

Suppose you have a domain

```sh
www.books.com
```

You have two apps Computer and Math, want put them under the same domain.

```sh
http://www.books.com/computer
http://www.books.com/math
```

For App computer, setting

```sh
APP_PATH_PREFIX=/computer
```

You also need to take care about this path prefix in your APP. Like react
router(3.x), it could take a prefix option. We strongly suggest to use the same
envrionment in your source code. So this image will take care of it for you. For
example, in your router.js file:

```js
import useBasename from "history/lib/useBasename";
import { browserHistory } from "react-router";

export const myHistory = useBasename(() => browserHistory)({
  basename: `/${APP_PATH_PREFIX}`
});
```

## License

[MIT](LICENSE.txt)
