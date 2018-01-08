VERSION?=dev-master
TAG?=latest

# example:
# $ make VERSION=dev-master TAG=latest nginx

nginx:
	docker build -t phppm/nginx:${TAG} -f build/Dockerfile-nginx build/ --build-arg version=${VERSION}

ppm:
	docker build -t phppm/ppm:${TAG} -f build/Dockerfile-ppm build/ --build-arg version=${VERSION}

standalone:
	docker build -t phppm/standalone:${TAG} -f build/Dockerfile-standalone build/ --build-arg version=${VERSION}

