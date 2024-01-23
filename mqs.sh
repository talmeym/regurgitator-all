#!/bin/sh
cd ../regurgitator-extensions-mq && pwd && $1 && cd ../regurgitator-extensions-mq-xml && pwd && $1 && cd ../regurgitator-extensions-mq-json && pwd && $1 && cd ../regurgitator-extensions-mq-yml && pwd && $1 && echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" && echo "%%%%%%%%%%% SUCCESS SUCCESS SUCCESS %%%%%%%%%%%" && echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
