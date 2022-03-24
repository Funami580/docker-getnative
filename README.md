# Docker getnative
Dockerfile for [getnative](https://github.com/Infiziert90/getnative).

## Build Docker image
```bash
$ ./build.sh
```

## Run container
After building the image, you can do:
```bash
$ ./run.sh
```
A `data` directory will be created in the root path.
You can put there e.g. some file called `myimage.png`.
Then you can execute in the container:
```bash
$ getnative myimage.png
```
The results of getnative can be found in the `data` directory.

## Clean up
Deletes the images and containers used by getnative as well as the `data` directory.
```bash
$ ./cleanup.sh
```
