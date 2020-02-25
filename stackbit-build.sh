#!/usr/bin/env bash

set -e
set -o pipefail
set -v

initialGitHash=$(git rev-list --max-parents=0 HEAD)
node ./studio-build.js $initialGitHash &

curl -s -X POST https://api.stackbit.com/project/5e558e06153502001bbb4010/webhook/build/pull > /dev/null
npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://api.stackbit.com/pull/5e558e06153502001bbb4010
curl -s -X POST https://api.stackbit.com/project/5e558e06153502001bbb4010/webhook/build/ssgbuild > /dev/null
hugo
wait

curl -s -X POST https://api.stackbit.com/project/5e558e06153502001bbb4010/webhook/build/publish > /dev/null
echo "Stackbit-build.sh finished build"
