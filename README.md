# axl-powershell-samples

## Overview

These samples demonstrates how to make Cisco Communications Manager AXL API requests using Powershell.

[https://developer.cisco.com/site/axl/](https://developer.cisco.com/site/axl/)

The concepts and techniques shown can be extended to enable automated management of virtually any configuration or setting in the CUCM admin UI.

## Requirements

Tested on:

* Windows 10
* Powershell 5.1

This project was developed using [Visual Studio Code](https://code.visualstudio.com/) and the [Powershell Extension](https://code.visualstudio.com/docs/languages/powershell), however the Windows Powershell ISE or Powershell itself is all that's needed to run the samples.

## Available samples

* `axl_addLine.ps1` - Add a line (`<addLine>`).

* `axl_addPhone.ps1` - Add a CSF device, associated with a line (`<addPhone>`).

* `axl_addUser.ps1` - Add an end user, associated with a phone, enabling IM&P and setting UC ServiceProfile (`<addUser>`).

* `axl_executeSQLQuery.ps1` - Query for all CSF devices not associated with an end user, then parse/output a simple report (`<executeSQLQuery>`).

## Getting started

* From a Powershell terminal, clone this repository:

  ```bash
  git clone https://github.com/CiscoDevNet/axl-powershell-samples.git
  ````

  and change into the project directory:

  ```bash
  cd axl-powershell-samples
  ```

* Set the [Powershell execution policy](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_scripts?view=powershell-7.2) to `Unrestricted`:

  ```bash
  Set-ExecutionPolicy -ExecutionPolicy Unrestricted
  ```

* Rename file `.env.ps1_example` to `.env.ps1` and edit to specify your CUCM and user configuration.

* This project was written against CUCM AXL v14.  

  If you'd like to use a different version, you may need to modify the `SOAPAction` header and `xmlns:ns` in the body to reflect the version and XML schema of the desired version.

    The AXL schema defination can be downloaded from the CUCM Administration UI under **Applications** / **Plugins** / **Cisco AXL Toolkit**

* To run a specific sample, in Visual Studio Code open the sample `.ps1` file you want to run, then press `F5`, or open the Debugging panel and click the green 'Launch' arrow.

  Or, to run from Powershell, be sure to include the required arguments:

  ```bash
  axl_addLine.ps1 -axlhost cucm_pub.example.com -user Administator -password ciscopsdt
  ```

## Hints

* The [SoapUI](https://www.soapui.org/) tool can be very helpful when developing with AXL, as you can import the AXL WSDL file, and SoapUI can autogenerate request templates including all required/optional elements.

  The tool can then execute requests and show the XML output.  Once you have created successful AXL requests in SoapUI, you can copy the XML into new requests based on these samples.

  [![published](https://static.production.devnetcloud.com/codeexchange/assets/images/devnet-published.svg)](https://developer.cisco.com/codeexchange/github/repo/CiscoDevNet/axl-powershell-samples)