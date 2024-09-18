#!/bin/bash

curl -XPOST http://localhost:8082/invocations --data-binary @tmp/831.jpg --header "Content-Type:image/svg"
