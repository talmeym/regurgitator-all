regurgitator
============
regurgitator is a modular, light-weight, extendable java-based processing framework designed to 'regurgitate' canned or clever responses to incoming requests.

it provides a series of executable java ``steps`` and ``constructs`` that can be combined or configured to apply simple or complex processing logic (as you require) when a request is received.
you can also create your own steps, for whatever it doesn't do out of the box. 

it can be configured using [``xml``](http://github.com/talmeym/regurgitator-core-xml) or [``json``](http://github.com/talmeym/regurgitator-core-json) files or extended to use any other document format.

it can work with [``http``](http://github.com/talmeym/regurgitator-extensions-web) to mock/stub http services, or be embedded within any other request / response mechanism.

it is separated out into modules, so you only have to include the parts you need into your project, then configure it to do what you want, deploy it and go!

steps
-----

regurgitator-core provides the following basic steps:
- ``sequence`` a collection of steps, run one after another.
- ``decision`` a collection of steps where ``rules`` and ``conditions`` dictate which steps are run.
- ``create-parameter`` store a piece of information, with a name and a type, to be used in a response.
- ``build-paramerer`` build a parameter using a ``value builder``, incorporating other parameters.
- ``generate-parameter`` create a parameter from scratch, using a ``value generator``.
- ``create-response`` return a response from regurgitator; either a static value or from a parameter.
- ``identify-session`` use the value of a parameter to identify / look up a session object, to hold information between requests.

regurgitator-core provides the basics of regurgitator; usable with minimal dependencies. other steps and constructs that do have dependencies are provided in [regurgitator-extensions](https://github.com/talmeym/regurgitator-extensions).

constructs
----------

regurgitator uses the following set of constructs / concepts to provide it's processing:
- ``parameter type`` each parameter has a type, which dictates how it is represented, as well as how it can be merged with another parameter. provided types include ``STRING`` ``NUMBER`` and ``DECIMAL`` along with list and set types.
- ``value builder`` aggregates the values of many parameters into one. provided builders include support for popular templating engines. 
- ``value generator`` create parameter values from scratch, such as random numbers.
- ``value processor`` all steps that involve parameters can have extra processing wired in, to alter their initial value after it has been created, built or generated.
- ``rules behaviour`` while rules determine how ``decision`` steps choose which child step to execute, ``rules behaviour`` govern what to do if more than rule passes.
- ``condition behaviour`` all conditions for a rule must be met for it to pass. each condition evaluates a parameter; its behaviour governs the kind of evaluation performed.

just as custom steps can be added to extend regurgitator to meet your needs, you can also provide your own construct implementations to further extend the capabilities of the framework. 

modules
-------

some important modules:

- [regurgitator-core](https://github.com/talmeym/regurgitator-core) provides the core steps and contructs to accept a request, process it and produce responses.
- [regurgitator-extensions](https://github.com/talmeym/regurgitator-extensions) provides useful extension steps and construct implementations.
- [regurgitator-extensions-web](https://github.com/talmeym/regurgitator-extensions-web) provides support for http, including the regurgitator servlet.

each of the above modules has a separate configuration module for each way in which it can be configured, eg.

- [regurgitator-core-xml](https://github.com/talmeym/regurgitator-core-xml) allows configuration of core using a namespaced, schema validated xml document.
- [regurgitator-extensions-json](https://github.com/talmeym/regurgitator-core-json) allows configuration of extensions using a json document.

messages
--------

an incoming request is modelled as a ``message``, given to regurgitator for processing. A message may be pre-populated with data, each data item being stored as a ``parameter``. each parameter is stored in the message under a ``context``, which holds a group of related parameters together. the default context is simply 'parameters'. some more specific contexts (for [http](http://github.com/talmeym/regurgitator-extensions-web)) include 'request-headers', 'response-payload' and 'global-metadata'. the message also provides a ``response-callback`` through which responses can be given. 

getting started
---------------

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

reference project
-----------------

a reference project for using regurgitator can be found here: [rockpaperscissors](http://github.com/talmeym/rockpaperscissors)
