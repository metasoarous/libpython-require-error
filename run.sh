#!/usr/bin/env bash
# enable JDK 17
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
jenv enable-plugin export
jenv add /usr/lib/jvm/jdk-17
jenv global 17

# confirm jdk 17
echo $(java -version)

# run test with jvm opts alias enabled
clj -A:opts -m libpython-test.test
