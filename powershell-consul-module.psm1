$Script:consulServer = "http://localhost:8500/v1/kv/"
# Implement your module commands in this script.
function New-ConsulKey {
    [CmdletBinding()]
    param (
        # Path of the key in Consul
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $keyPath,

        # Key value
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $json
    )

    begin {

    }

    process {
        try {
            $consulUrl = $Script:consulServer + $keyPath
            $result = Invoke-RestMethod -Uri $consulUrl -Method Put -Body $json -NoProxy -ContentType "application/json"
            return [bool]$result
        }
        catch {
            $exception = $($PSItem | select-object * |Format-Custom -Property * -Depth 1 | Out-String)
            Write-Error -Message $exception -ErrorAction Stop
        }
    }

    end {
    }
}

function Set-ConsulServer {
    [CmdletBinding()]
    param (
        # Base url of consul kv store
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]
        $consulServer
    )

    begin {
    }

    process {
        $Script:consulServer = $consulServer
    }

    end {
    }
}

# Export only the functions using PowerShell standard verb-noun naming.
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.
Export-ModuleMember -Function *-*
