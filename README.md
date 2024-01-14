# regurgitator

regurgitator is a lightweight, modular, extendable java framework that you configure to "regurgitate" canned or clever responses to incoming requests; useful for quickly mocking or prototyping services without writing any code.

it provides a series of executable [``steps``](https://talmeym.github.io/regurgitator-core#steps) and [``constructs``](https://talmeym.github.io/regurgitator-core#constructs) that you combine / configure to apply simple or complex processing logic (as required) when a request [``message``](https://talmeym.github.io/regurgitator-core#messages) is received. you can also create your own steps and constructs, for whatever it doesn't do out of the box. 

it can be configured using [``xml``](https://talmeym.github.io/regurgitator-core-xml#xml-configuration-of-regurgitator), [``json``](https://talmeym.github.io/regurgitator-core-json#json-configuration-of-regurgitator) or [``yml``](https://talmeym.github.io/regurgitator-core-yml#yml-configuration-of-regurgitator)  files (or extended to use any other document format), allowing mocked logic to be provided without writing any code - simply configure the behaviour you want!

it can work with [``http``](https://talmeym.github.io/regurgitator-extensions-web#regurgitator-over-http) to mock/stub http services, can work with [``mq``](https://talmeym.github.io/regurgitator-extensions-mq#regurgitator-over-mq), or can be embedded within any other request / response mechanism.

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
    <packaging>war</packaging>
    <name>My Artifact</name>

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
<rg:regurgitator-configuration xmlns:rg="http://core.regurgitator.emarte.uk" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://core.regurgitator.emarte.uk regurgitatorCore.xsd">
    <rg:decision id="check-greeting">
        <rg:steps>
            <rg:create-response id="before-lunch" value="it is before lunch"/>
            <rg:create-response id="after-lunch" value="it is after lunch"/>
        </rg:steps>
        <rg:rules default-step="after-lunch">
            <rg:rule step="before-lunch">
                <rg:condition source="greeting" contains="morning"/>
            </rg:rule>
        </rg:rules>
    </rg:decision>
</rg:regurgitator-configuration>
```

### example json configuration

below is an example json configuration file for regurgitator:

```json
{
    "kind": "decision",
    "id": "check-greeting",
    "steps": [
        {
            "kind": "create-response",
            "id": "before-lunch",
            "value": "it is before lunch"
        },
        {
            "kind": "create-response",
            "id": "after-lunch",
            "value": "it is after lunch"
        }
    ],
    "default-step": "after-lunch",
    "rules": [
        {
            "step": "before-lunch",
            "conditions": [
                {
                    "source": "greeting",
                    "contains": "morning"
                }
            ]
        }
    ]
}
```

### example yml configuration

below is an example yml configuration file for regurgitator:

```yml
decision:
 id: check-greeting
 steps:
 - create-response:
    id: before-lunch
    value: it is before lunch
 - create-response:
    id: after-lunch
    value: it is after lunch
 default-step: after-lunch
 rules:
 - step: before-lunch
   conditions:
   - source: greeting
     contains: morning
```

### example code

below is example code for loading a configuration file, creating a regurgitator instance, and processing a message:

```java
import uk.emarte.regurgitator.core.*;

public class MyClass {
    public static void main(String[] args) throws RegurgitatorException {
        Step rootStep = ConfigurationFile.loadFile("classpath:/my_configuration.xml");
        Regurgitator regurgitator = new Regurgitator("my-regurgitator", rootStep);

        ResponseCallBack callBack = (message,response)-> System.out.println(response);

        Message message = new Message(callBack);
        message.getParameters().setValue("greeting", "good afternoon");

        regurgitator.processMessage(message);
    }
}
```

the response, for this noddy example, would be "it is after lunch", output to the console.

(the above example shows programmatic use of [regurgitator-core](https://talmeym.github.io/regurgitator-core#regurgitator-core). to see how regurgitator can help you over http or mq, with or without writing code, see [web](https://talmeym.github.io/regurgitator-extensions-web#regurgitator-extensions-web) or [mq](https://talmeym.github.io/regurgitator-extensions-mq#regurgitator-extensions-mq) or follow links below to some reference projects)

## reference projects

reference projects for using regurgitator (over http) can be found below: 
- [rock-paper-scissors](https://github.com/talmeym/rock-paper-scissors) - mocks a service allowing you to play a famous game
- [primeable-mock-server](https://github.com/talmeym/primeable-mock-server) - a mock server you can prime for any http call
