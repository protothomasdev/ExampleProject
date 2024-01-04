[![Tuist badge](https://img.shields.io/badge/Powered%20by-Tuist-blue)](https://tuist.io)
[![Generic badge](https://img.shields.io/badge/Swift-5.8-orange.svg)](https://shields.io/)
[![Generic badge](https://img.shields.io/badge/Xcode-14.3.1-blue.svg)](https://shields.io/)
[![Generic badge](https://img.shields.io/badge/iOS-15.0-blue.svg)](https://shields.io/)
[![Generic badge](https://img.shields.io/badge/Architecture-MVC-C-green.svg)](https://shields.io/)
[![Generic badge](https://img.shields.io/badge/UI%20Framework-UIKit-green.svg)](https://shields.io/)

## (AppIcon +) <App Name>

## Table of contents

[Project overview](#project-overview)
[Setup](#setup)
[Technical overview](#technical-overview)
[Release](#release)
[Project Guidelines](#project-guidelines)
[Dependencies and external Services](#dependencies-and-exernal-services)
[CI-Configuration](#ci-configuration)
[Additional documentation](#additional-documentation)

## Project overview
- A short description of the app. What does the app do?
- Add links to Confluence and Jira/Trello.
- Describe the main channels of communication of the project, link them here as well.
- How does a new developer get access to all the tools and services? (Jira, Trello, Confluence)
- Add links (or even better buttons) to the App Store Version and the Firebase version (invitation link).

## Setup
- Describe in clear and precise steps how to setup the project until the app can run in the Xcode simulator. This includes the installation of all required tools and dependencies, like Tuist, Gems and other Command Line Tools, as well as the provision of API-Secrets.
- Provide test accounts or describe, where the developer can find them, for example 1Password
- Link to the code signing guide for setting up certificates and profiles

## Technical overview

### Architecture and tech stack
- What architecture does the app use?
- Which UI-Framework is the app created with? Is it still using storyboards? If the app is build (partly) with UIKit, is it using Overture?
- Does the project make use of Async-Await and/or Combine? Are there technologies, other developers might not be familiar with?
- Are there other uncommon Frameworks used?

### Modules (if applicable)
- Is the app split up into modules?
- List (only) the most important modules here, sorted by relevance.

#### <Module name>
- Describe the function of the module
- Provide information about the most important classes and components of the module, so that the developer have a good entry point.

### Environments and configurations
- What environments are there? Debug, Beta, Staging/Pre-Prod, Prod?
- What configurations does the app provide and what environments do they use? If applicable, create a table like this:
```
| Configuration | Environment | Description |
|---|---|---|
||||
```
- Can the user change the environment from within the app?

## Release
- Describe in clear steps how to release a beta app to the testers. Describe how the beta app gets distributed and link to the services (Testflight, Firebase, etc.)
- Describe how to release an App Store app.
- Describe every step needed for the release, if it's not yet automated, for example manually increase version/build number, update changelog, uploading the .ipa via Transporter, etc.

## Project guidelines
- What are the processes the project team agreed upon?
- What Git workflow guidelines is the team following? Are there rules for commit messages or branch names? Is rebasing required before merging, etc.?
- Are there any code styles? Are they enforced with SwiftLint/SwiftFormat? If so, link the configuration files here.

## Dependencies and external services
- Which dependencies and external services (for example Phrase) are used? How can the developer get access to them (if needed)?

## CI/CD configuration
- How's the CI/CD configured?
- What are the most important lanes? (link to Fastfile)?
- Are there any pipeline triggers the developer needs to be aware of? For example Beta release Pipelines, that start when a merge request is merged into the develop branch.

## Additional documentation
- Add links to additional documentation and tools like Figma, Backend-Doku/Project etc.