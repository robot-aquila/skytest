# Requirements:

- git
- bash
- curl
- docker


# Build:
<pre>
git clone https://github.com/robot-aquila/skytest.git
cd skytest
./build.sh
</pre>

# Run:
<pre>
docker-compose up -d
</pre>

# Test:
<pre>
./test.sh

or

./test.sh &lt;HOST&gt;

or

./test.sh &lt;HOST&gt; [PORT]
</pre>

Note, that tests will pass just once because autoincrement.


# Shutdown:
<pre>
docker-compose down
</pre>

# TODO:

- Entity clsss & repository service
- Better tests, new test cases
- Error handling & logging
