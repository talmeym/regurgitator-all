# regurgitator

regurgitator is a modular, light-weight, extendable java-based processing framework designed to 'regurgitate' canned or clever responses to incoming requests; useful for mocking or prototyping services.

it provides a series of executable [``steps``] (https://github.com/talmeym/regurgitator-core#steps) and [``constructs``] (https://github.com/talmeym/regurgitator-core#constructs) that can be combined or configured to apply simple or complex processing logic (as you require) when a request [``message``] (https://github.com/talmeym/regurgitator-core#messages) is received.
you can also create your own steps, for whatever it doesn't do out of the box. 

it can be configured using [``xml``](http://github.com/talmeym/regurgitator-core-xml#xml-configuration-of-regurgitator) or [``json``](http://github.com/talmeym/regurgitator-core-json#json-configuration-of-regurgitator) files (or extended to use any other document format), allowing mocked logic to be provided without writing any code - simply configure the behaviour you want!

it can work with [``http``](https://github.com/talmeym/regurgitator-extensions-web#regurgitator-over-http) to mock/stub http services, or be embedded within any other request / response mechanism.

it is separated out into modules, so you only have to include the parts you need into your project, then configure it to do what you want, deploy it and go!

click on any highlighted ``term`` above to learn more.

## module structure

the main modules are as follows:

- [regurgitator-core](https://github.com/talmeym/regurgitator-core#regurgitator-core) provides the core steps and contructs to accept a request, process it and produce responses
- [regurgitator-extensions](https://github.com/talmeym/regurgitator-extensions#regurgitator-extensions) provides useful extension steps and construct implementations
- [regurgitator-extensions-web](https://github.com/talmeym/regurgitator-extensions-web#regurgitator-extensions-web) provides support for http, including the regurgitator servlet

each of the above modules has a separate configuration module for each way in which it can be configured, eg.

- [regurgitator-core-xml](https://github.com/talmeym/regurgitator-core-xml) allows configuration of core using a namespaced, schema validated xml document
- [regurgitator-extensions-json](https://github.com/talmeym/regurgitator-core-json) allows configuration of extensions using a json document

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
    <packaging>jar</packaging>
    <name>My Artifact</name>

    <repositories>
        <repository>
            <id>regurgitator-mvn-repo</id>
            <url>https://raw.github.com/talmeym/regurgitator-binaries/mvn-repo/</url>
        </repository>
    </repositories>

    <dependencies>
        <dependency>
            <groupId>com.emarte.regurgitator</groupId>
            <artifactId>regurgitator-all</artifactId>
            <version>0.0.1</version>
        </dependency>
    </dependencies>
</project>
```

### example configuration

below is an example xml configuration file for regurgitator:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<rg:regurgitator-configuration xmlns:rg="http://core.regurgitator.emarte.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://core.regurgitator.emarte.com regurgitatorCore.xsd">
	<rg:decision id="check-greeting">
		<rg:steps>
			<rg:create-response id="before-lunch" value="it is before lunch"/>
			<rg:create-response id="after-lunch" value="it is after lunch"/>
		</rg:steps>
		<rg:rules default-step="after-lunch">
			<rg:rule step="before-lunch">
				<rg:condition source="greeting" equals="good morning"/>
			</rg:rule>
		</rg:rules>
	</rg:decision>
</rg:regurgitator-configuration>
```

### example code

below is example code for loading a configuration file, creating a regurgitator instance, and processing a message:

```java
import com.emarte.regurgitator.core.*;

public class MyClass {
	public static void main(String[] args) throws RegurgitatorException {
		Step rootStep = ConfigurationFile.loadFile("classpath:/my_configuration.xml");
		Regurgitator regurgitator = new Regurgitator("my-regurgitator", rootStep);

		ResponseCallBack callBack = new ResponseCallBack() {
			@Override
			public void respond(Message message, Object response) {
				System.out.println(response);
			}
		};

		Message message = new Message(callBack);
		message.getParameters().setValue("greeting", "good afternoon");

		regurgitator.processMessage(message);
	}
}
```

the response - output to the console - would for the noddy example above be "it is after lunch"

## reference project

a reference project for using regurgitator can be found here: [rock-paper-scissors](http://github.com/talmeym/rock-paper-scissors) - mocks a service allowing you to play a game
