BASEURL ?= "http://localhost"

server:
	hugo server -D -F --bind 0.0.0.0 --disableFastRender --baseURL ${BASEURL}

codespaces/server:
	hugo server -D -F --disableFastRender --baseURL=/ --appendPort=false

docker/image:
	DOCKER_BUILDKIT=1 docker build . -t hugo-code-server

docker/build:
	docker run --rm -v ${PWD}:/blog -w /blog \
		-e TZ=Asia/Tokyo \
		hugo-code-server \
		hugo --minify

docker/server:
	docker run --rm -v ${PWD}:/blog -w /blog -p 1313:1313 \
		-e TZ=Asia/Tokyo \
		hugo-code-server \
		hugo server -D --bind 0.0.0.0 --disableFastRender --baseURL ${BASEURL}
