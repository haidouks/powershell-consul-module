$ModuleManifestName = 'powershell-consul-module.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\$ModuleManifestName"
Import-Module $ModuleManifestPath -Force

#region Test Variables
$keyPath = "sample/consul/path"
$keyValue = @{key = "sampleValue"; key2 = "sampleValue2"} | ConvertTo-Json
#endregion


Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath | Should Not BeNullOrEmpty
        $? | Should Be $true
    }
}



Describe "Key operations" {
    Context "Adding a new key" {
        It "If key and path is valid, key will be created/updated with new value" {
            New-ConsulKey -keyPath $keyPath -json $keyValue | Should -Be $true
        }
        It "If consul server is unreachable, it should throw exception" {
            Set-consulServer -consulServer "http://Unreachable"
            {New-ConsulKey -keyPath $keyPath -json $keyValue} | Should -Throw
        }
    }
}