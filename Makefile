BASEURL ?= "http://localhost"

docker/build:
	docker run --rm -v ${PWD}:/singular -w /singular \
		-e TZ=Asia/Tokyo \
		hugo \
		--minify

docker/server:
	docker run --rm -v ${PWD}:/blog -w /blog -p 1313:1313 \
		-e TZ=Asia/Tokyo \
		hugo server -D --bind 0.0.0.0 --disableFastRender \
		--baseURL ${BASEURL}
