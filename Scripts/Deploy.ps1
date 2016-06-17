#Requires -Version 3.0
#Requires -Module AzureRM.Resources
#Requires -Module Azure.Storage

Param(
    [string] $ResourceGroupLocation = 'West US',
    [string] $ResourceGroupName = 'AzureResourceGroup2',
    [string] $TemplateFileUri = 'https://raw.githubusercontent.com/ltrain777/avARMDeploy/master/Templates/azuredeploy.json',
    [string] $TemplateParametersFile = '..\Templates\azuredeploy.parameters.json'
)

Import-Module Azure -ErrorAction SilentlyContinue

try {
    [Microsoft.Azure.Common.Authentication.AzureSession]::ClientFactory.AddUserAgent("VSAzureTools-$UI$($host.name)".replace(" ","_"), "2.9")
} catch { }

Set-StrictMode -Version 3

$TemplateParametersFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $TemplateParametersFile))

# Create or update the resource group using the specified template file and template parameters file
New-AzureRmResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation -Verbose -Force -ErrorAction Stop -WA SilentlyContinue

New-AzureRmResourceGroupDeployment -Name ($ResourceGroupName + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmmss')) `
                                   -ResourceGroupName $ResourceGroupName `
                                   -TemplateUri $TemplateFileUri `
                                   -TemplateParameterFile $TemplateParametersFile `
                                   -Force -Verbose