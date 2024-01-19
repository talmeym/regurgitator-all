# regurgitator

regurgitator is a lightweight, modular, extendable java framework that you configure to "regurgitate" canned or clever responses to incoming requests; useful for quickly mocking or prototyping services without writing any code.

it provides a series of executable [``steps``](https://talmeym.github.io/regurgitator-core#steps) and [``constructs``](https://talmeym.github.io/regurgitator-core#constructs) that you can combine / configure to apply simple or complex logic (as required) to a request [``message``](https://talmeym.github.io/regurgitator-core#messages) that comes in, including generating and returning a response. you can even create your own steps and constructs, for whatever it doesn't do out of the box. 

it can be configured using [``xml``](https://talmeym.github.io/regurgitator-core-xml#xml-configuration-of-regurgitator), [``json``](https://talmeym.github.io/regurgitator-core-json#json-configuration-of-regurgitator) or [``yml``](https://talmeym.github.io/regurgitator-core-yml#yml-configuration-of-regurgitator)  files (or extended to use any other document format), allowing mocked logic to be created without writing any code - simply configure the behaviour you want!

it can work with [``http``](https://talmeym.github.io/regurgitator-extensions-web#regurgitator-over-http) to mock/stub http services, can work with [``mq``](https://talmeym.github.io/regurgitator-extensions-mq#regurgitator-over-mq) to mock jms services, or can be embedded within any other request / response mechanism. 

it can work with [``jetty``](https://talmeym.github.io/regurgitator-extensions-web#jetty) to package configurations as containerized deployables, that you can stand up alongside your own, allowing you to test interactions between components that may not exist yet.

it is separated out into modules, so you only have to include the parts you need into your project, then configure it to do what you want, deploy it and go!

click on the highlighted [``terms``](https://talmeym.github.io/regurgitator-all#regurgitator) above to learn more, or see the reference projects [here](https://talmeym.github.io/regurgitator-all#reference-projects).

## module structure

the main modules are as follows:

- [regurgitator-core](https://talmeym.github.io/regurgitator-core#regurgitator-core) provides the core steps and constructs to accept a request, process it and produce responses
- [regurgitator-extensions](https://talmeym.github.io/regurgitator-extensions#regurgitator-extensions) provides useful extension steps and construct implementations
- [regurgitator-extensions-web](https://talmeym.github.io/regurgitator-extensions-web#regurgitator-extensions-web) provides support for http, including the regurgitator servlet
- [regurgitator-extensions-mq](https://talmeym.github.io/regurgitator-extensions-mq#regurgitator-extensions-mq) provides support for mocking services reached over mq

each of the above has an accompanying module for each document type from which it can be configured, e.g.

- [regurgitator-core-xml](https://talmeym.github.io/regurgitator-core-xml) allows configuration of core using a namespaced, schema validated xml document
- [regurgitator-extensions-web-json](https://talmeym.github.io/regurgitator-core-web-json) allows configuration of web extensions using a json document
- [regurgitator-extensions-mq-yml](https://talmeym.github.io/regurgitator-extensions-mq-yml) allows configuration of mq extensions using a yml document

## getting started

### example pom

below is an example pom.xml for a maven project that includes regurgitator:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">

    <modelVersion>4.0.0</modelVersion>
    <groupId>my.group.id</groupId>
    <artifactId>my-artifact</artifactId>
    <version>0.0.1</version>
    <name>My Regurgitator Example</name>

    <dependencies>
        <dependency>
            <groupId>uk.emarte.regurgitator</groupId>
            <artifactId>regurgitator-all</artifactId>
            <version>0.1.1</version>
        </dependency>
    </dependencies>
</project>
```

### example xml configuration

below is an example xml configuration file for regurgitator:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<rg:regurgitator-configuration xmlns:rg="http://core.regurgitator.emarte.uk" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://core.regurgitator.emarte.uk regurgitatorCore.xsd" id="rock-paper-scissors">
    <rg:decision id="determine-result">
        <rg:steps>
            <rg:sequence id="draw">
                <rg:create-response id="return-draw-result" value="a draw"/>
            </rg:sequence>
            <rg:sequence id="player-win">
                <rg:create-response id="return-player-win-result" value="player wins"/>
            </rg:sequence>
            <rg:sequence id="computer-wins">
                <rg:create-response id="set-computer-wins-result" value="computer wins"/>
            </rg:sequence>
        </rg:steps>
        <rg:rules default-step="computer-wins">
            <rg:rule id="is-draw" step="draw">
                <rg:condition id="player-got-same-as-computer" source="player-choice" equals-param="computer-choice"/>
            </rg:rule>
            <rg:rule id="rock-beats-paper" step="player-win">
                <rg:condition id="player-rock" source="player-choice" equals="rock"/>
                <rg:condition id="comp-scissors" source="computer-choice" equals="scissors"/>
            </rg:rule>
            <rg:rule id="paper-beats-rock" step="player-win">
                <rg:condition id="player-paper" source="player-choice" equals="paper"/>
                <rg:condition id="comp-rock" source="computer-choice" equals="rock"/>
            </rg:rule>
            <rg:rule id="scissors-beats-paper" step="player-win">
                <rg:condition id="player-scissors" source="player-choice" equals="scissors"/>
                <rg:condition id="comp-paper" source="computer-choice" equals="paper"/>
            </rg:rule>
        </rg:rules>
    </rg:decision>
</rg:regurgitator-configuration>
```

### example java code

below is example code for loading a configuration file, creating a regurgitator instance, and processing a message:

```java
import uk.emarte.regurgitator.core.*;

public class MyRegurgitatorExample {
    public static void main(String[] args) throws RegurgitatorException {
        Step rootStep = ConfigurationFile.loadFile("classpath:/rock-paper-scissors.xml");
        Regurgitator regurgitator = new Regurgitator("my-regurgitator", rootStep);

        ResponseCallBack callBack = (message,response) -> System.out.println("The result was " + response);

        Message message = new Message(callBack);
        message.getParameters().setValue("player-choice", "paper");
        message.getParameters().setValue("computer-choice", "rock");

        regurgitator.processMessage(message);
    }
}
```

the output from this example would be ```"The result was player wins"```.

(the above shows programmatic use of [regurgitator-core](https://talmeym.github.io/regurgitator-core#regurgitator-core). to see how regurgitator can help you over http or jms, with or without writing code, see [web](https://talmeym.github.io/regurgitator-extensions-web#regurgitator-extensions-web) or [mq](https://talmeym.github.io/regurgitator-extensions-mq#regurgitator-extensions-mq) or follow links below to some reference projects)

## reference projects

reference projects for using regurgitator (over http) can be found below: 
- [rock-paper-scissors](https://github.com/talmeym/rock-paper-scissors){:target="_blank"}  - mocks a service allowing you to play the famous game
- [primeable-mock-server](https://github.com/talmeym/primeable-mock-server){:target="_blank"}  - a mock server you can prime for any http call
