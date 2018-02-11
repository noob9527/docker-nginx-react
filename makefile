selfsigned-cert:
	sudo openssl req -x509 \
		-nodes -days 365  \
		-newkey rsa:2048 \
		-keyout $$(pwd)/ssl/selfsigned.key \
		-out $$(pwd)/ssl/selfsigned.crt

build:
	docker build -t noob9527/docker-nginx-spa .

publish:
	docker image push noob9527/docker-nginx-spa

.PHONY: selfsigned-cert, build, publish
