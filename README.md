# Docker getnative
Dockerfile for [getnative](https://github.com/Infiziert90/getnative).

## Build Docker image
```bash
$ ./build.sh
```
A `data` directory will be created in the root path.
You can put there e.g. some file called `myimage.png`.

## Run container
After building the image, you can do:
```bash
$ ./run.sh getnative myimage.png
```
The results of getnative can be found in the `data` directory.

It is also possible to enter the container with:
```bash
$ ./run.sh
```

## Clean up
Deletes the images and containers used by getnative as well as the `data` directory.
```bash
$ ./cleanup.sh
```
