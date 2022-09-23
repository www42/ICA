# Topic 15 Automation: Cloudformation & Infrastructure management

## Infrastructure as Code

* mehr Sicherheit: keine Fehler durch Klicken in der Management Console, vorab Validierung der Templates fehleranfällig
* Infrastruktur wie Quelltext
* Automatisierung durch Wiederholbarkeit
* Wiederverwendbarkeit
* Soll-Ist-Vergleich (Drift Detection)
* Zentrales Change Management: Update einmal in dem Template - Änderung wird in allen Environments durchgeführt

### Vergleich: Wunschzettel zu Weihnachten

## AWS Cloudformation

* vollstädiger Stack der Applikation (VPC, Instance, Security Group etc)
* Import zusätzlicher Resources
* multiple templates, cross stack references

**unklar Slide 11: Drei Stacks haben verschiedene Resources, die Stacks kommen aber aus demselben Template.**


## AWS Elastic Beanstalk

* Konzentration auf Applikation, nicht auf Infrastruktur
* automatische Skalierung

## AWS Solutions Library

* Komplettlösungen ready to deploy, Best practises, Security, Kostenabschätzung

## AWS CDK

* Cloudformation Templates generieren mit meiner Lieblings-Programmiersprache

## AWS Systems Manager

* Application Management
    * zentrales AppConfig Management
    * Parameter store
* Change Management
* Node Management
    * Session Manager EC2
    * Run Command
* Operations Management

