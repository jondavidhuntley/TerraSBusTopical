[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
	[ValidateSet("dev", "qa", "uat", "prod")]
	[string]
	$environment
)

$ErrorActionPreference = "stop";
Set-StrictMode -Version "latest";

terraform plan -var-file=".\$environment\env.tfvar"  -refresh=true

if($LASTEXITCODE -ne 0) {throw "terraform failed epically with exit code $LASTEXITCODE"};