#!/bin/bash

curl -XPOST http://localhost:8080/invocations --data-binary @tmp/831.jpg --header "Content-Type:image/jpeg"
