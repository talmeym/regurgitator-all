#!/bin/sh
cd ../regurgitator-core && pwd && $1 && cd ../regurgitator-core-config && pwd && $1 && cd ../regurgitator-core-xml && pwd && $1 && cd ../regurgitator-core-json && pwd && $1 && cd ../regurgitator-core-yml && pwd && $1 && cd ../regurgitator-extensions && pwd && $1 && cd ../regurgitator-extensions-config && pwd && $1 && cd ../regurgitator-extensions-xml && pwd && $1 && cd ../regurgitator-extensions-json && pwd && $1 && cd ../regurgitator-extensions-yml && pwd && $1 && cd ../regurgitator-extensions-web && pwd && $1 && cd ../regurgitator-extensions-web-config && pwd && $1 && cd ../regurgitator-extensions-web-xml && pwd && $1 && cd ../regurgitator-extensions-web-json && pwd && $1 && cd ../regurgitator-extensions-web-yml && pwd && $1 && cd ../regurgitator-extensions-jetty && pwd && $1 && cd ../regurgitator-extensions-mq && pwd && $1 && cd ../regurgitator-extensions-mq-xml && pwd && $1 && cd ../regurgitator-extensions-mq-json && pwd && $1 && cd ../regurgitator-extensions-mq-yml && pwd && $1 && cd ../regurgitator-all && pwd && $1 && echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" && echo "%%%%%%%%%%% SUCCESS SUCCESS SUCCESS %%%%%%%%%%%" && echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
