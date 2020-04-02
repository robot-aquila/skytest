# Requirements:

- git
- bash
- curl
- docker


# Build:

git clone https://github.com/robot-aquila/skytest.git
cd skytest
./build.sh


# Run:

docker-compose up -d


# Test:

./test.sh

or

./test.sh <HOST>

or

./test.sh <HOST> [PORT]

Note, that tests will pass just once because autoincrement.


# Shutdown:

docker-compose down


# TODO:

- Entity clsss & repository service
- Better tests, new test cases
- Error handling & logging
