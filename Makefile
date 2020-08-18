BASEURL ?= "http://localhost"

docker/image:
	DOCKER_BUILDKIT=1 docker build . -t hugo

docker/build:
	docker run --rm -v ${PWD}:/blog -w /blog \
		-e TZ=Asia/Tokyo \
		hugo \
		--minify

docker/server:
	docker run --rm -v ${PWD}:/blog -w /blog -p 1313:1313 \
		-e TZ=Asia/Tokyo \
		hugo server -D --bind 0.0.0.0 --disableFastRender \
		--baseURL ${BASEURL}
