VERSION?=dev-master
HTTP_VERSION?=dev-master
TAG?=latest

# example:
# $ make VERSION=dev-master TAG=latest nginx
# $ make TAG=latest push-all

.PHONY: default nginx ppm standalone push-all

default: nginx ppm standalone

nginx:
	docker build -t phppm/nginx:${TAG} -f build/Dockerfile-nginx build/ --build-arg version="${VERSION}" --build-arg http_version="${HTTP_VERSION}"
	docker tag phppm/nginx:${TAG} phppm/nginx:latest

ppm:
	docker build -t phppm/ppm:${TAG} -f build/Dockerfile-ppm build/ --build-arg version="${VERSION}" --build-arg http_version="${HTTP_VERSION}"
	docker tag phppm/ppm:${TAG} phppm/ppm:latest

standalone:
	docker build -t phppm/standalone:${TAG} -f build/Dockerfile-standalone build/ --build-arg version="${VERSION}" --build-arg http_version="${HTTP_VERSION}"
	docker tag phppm/standalone:${TAG} phppm/standalone:latest

push-all:
	docker push phppm/nginx:${TAG}
	docker push phppm/standalone:${TAG}
	docker push phppm/ppm:${TAG}
