#!/bin/bash

echo "Preprocessing...";

cobc -E clntgui.cob clntbrws.cob enrol.cob dropclnt.cob clntio.cob contio.cob dates.cob;

echo "Translating...";

cobc -C clntgui.cob clntbrws.cob enrol.cob dropclnt.cob clntio.cob contio.cob dates.cob;

echo "Generating assembler...";

cobc -S clntgui.cob clntbrws.cob enrol.cob dropclnt.cob clntio.cob contio.cob dates.cob;

echo "Producing object code...";

cobc -c clntgui.cob clntbrws.cob enrol.cob dropclnt.cob clntio.cob contio.cob dates.cob;

echo "Building modules...";

cobc -m clntgui.cob clntbrws.cob enrol.cob dropclnt.cob clntio.cob contio.cob dates.cob;
cobc -b clntgui.cob clntbrws.cob enrol.cob dropclnt.cob clntio.cob contio.cob dates.cob;

#echo "Running module...";

#cobcrun contio;

#echo "Creating executable...";
#cobc -x chapter1.cob;
