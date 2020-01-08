[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
	[ValidateSet("dev", "qa", "uat", "prod")]
	[string]
	$environment
)

$ErrorActionPreference = "stop";
Set-StrictMode -Version "latest";

terraform apply -var-file=".\$environment\env.tfvar"

if($LASTEXITCODE -ne 0) {throw "terraform failed epically with exit code $LASTEXITCODE"};