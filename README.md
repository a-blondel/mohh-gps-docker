# Medal of Honor Heroes GPS in Docker
A docker wrapper for the [User Hosted Server](https://planetmedalofhonor.gamespy.com/View5e40.html?view=MoHHeroesFiles.Detail&id=1) ([backup](https://www.mediafire.com/file/gdx9eglhjfv1wfn/MOHHServerSetupNA.rar/file)) binary on its **persistent game spawn service** (GPS) configuration (using the `-easerver` option).

It features a way to run multiple instances of the server on a docker container. The instances will automatically restart when it crashes or when the container is restarted.

## Usage
The image is available on the [GitHub packages](https://github.com/a-blondel/mohh-gps-docker/packages) of this repository, so you can pull it directly from there and you don't need to build the image.

When running the container, you need to specify the following environment variables:
- `GPS_NAME`: The name of the account used to run the server
- `GPS_PWD`: The password of the account used to run the server
- `GPS_ADMIN_PWD`: The password to access the admin menu in the game
- `GPS_PORT`: The base port of the server, defaults to 3658. Every instance will use a port starting from this one
- `GPS_INSTANCE`: The number of instances to run, defaults to 1

## Build the image manually
In order to do so, you need to create a `bin` folder at the root of this project and put the installation files from the UHS installer in it (which includes `mohz.exe`, ...).
