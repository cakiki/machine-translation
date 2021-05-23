VERSION := 0.0.1
NAME := machine-translation

build: clean
	docker build -t ${NAME}:${VERSION} .

run: build
	docker run --rm -it -p 8888:8888 -p 6006:6006 --gpus all --env PYTHONPATH=/tf/src --mount type=bind,source=${PWD},target=/tf ${NAME}:${VERSION} && make -s clean

clean:
	sudo chown -R 1000:1000 .