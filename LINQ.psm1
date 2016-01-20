# Compile .NET helper classes into memory
&"$PSScriptRoot\Add-SourceFiles.ps1"

##############################################################################
# TYPEDATA
##############################################################################

$TypeDataArgs = @{
    TypeName = 'System.Array'
    MemberType = 'ScriptMethod'
    ErrorAction = 0
}

Update-TypeData @TypeDataArgs -MemberName All -Value {[Einstein.PowerShell.LINQ.PSEnumerable]::All($This, $Args[0])}
Update-TypeData @TypeDataArgs -MemberName Any -Value {[Einstein.PowerShell.LINQ.PSEnumerable]::Any($This, $Args[0])}
Update-TypeData @TypeDataArgs -MemberName CountWhere -Value {[Einstein.PowerShell.LINQ.PSEnumerable]::Count($This, $Args[0])}
Update-TypeData @TypeDataArgs -MemberName First -Value {[Einstein.PowerShell.LINQ.PSEnumerable]::First($This, $Args[0])}
Update-TypeData @TypeDataArgs -MemberName Last -Value {[Einstein.PowerShell.LINQ.PSEnumerable]::Last($This, $Args[0])}
Update-TypeData @TypeDataArgs -MemberName FindIndex -Value {[Einstein.PowerShell.LINQ.PSEnumerable]::IndexOf($This, $Args[0])}
Update-TypeData @TypeDataArgs -MemberName Reverse -Value {[Einstein.PowerShell.LINQ.PSEnumerable]::Reverse($This)}
Update-TypeData @TypeDataArgs -MemberName Single -Value {[Einstein.PowerShell.LINQ.PSEnumerable]::Single($This, $Args[0])}
Update-TypeData @TypeDataArgs -MemberName Skip -Value {[Einstein.PowerShell.LINQ.PSEnumerable]::Skip($This, $Args[0])}
Update-TypeData @TypeDataArgs -MemberName SkipWhile -Value {[Einstein.PowerShell.LINQ.PSEnumerable]::SkipWhile($This, $Args[0])}
Update-TypeData @TypeDataArgs -MemberName Take -Value {[Einstein.PowerShell.LINQ.PSEnumerable]::Take($This, $Args[0])}
Update-TypeData @TypeDataArgs -MemberName TakeWhile -Value {[Einstein.PowerShell.LINQ.PSEnumerable]::TakeWhile($This, $Args[0])}
Update-TypeData @TypeDataArgs -MemberName Average -Value {[Einstein.PowerShell.LINQ.PSEnumerable]::Average($This, $Args[0])}
Update-TypeData @TypeDataArgs -MemberName Sum -Value {[Einstein.PowerShell.LINQ.PSEnumerable]::Sum($This, $Args[0])}
Update-TypeData @TypeDataArgs -MemberName Min -Value {[Einstein.PowerShell.LINQ.PSEnumerable]::Min($This, $Args[0])}
Update-TypeData @TypeDataArgs -MemberName Max -Value {[Einstein.PowerShell.LINQ.PSEnumerable]::Max($This, $Args[0])}

Update-TypeData @TypeDataArgs -MemberName Concat -Value {param($Other) [Einstein.PowerShell.LINQ.PSEnumerable]::Concat($This, $Other)}
Update-TypeData @TypeDataArgs -MemberName Except -Value {param($Other,$IgnoreCase) [Einstein.PowerShell.LINQ.PSEnumerable]::Except($This, $Other, $IgnoreCase)}
Update-TypeData @TypeDataArgs -MemberName Intersect -Value {param($Other,$IgnoreCase) [Einstein.PowerShell.LINQ.PSEnumerable]::Intersect($This, $Other, $IgnoreCase)}
Update-TypeData @TypeDataArgs -MemberName Union -Value {param($Other,$IgnoreCase) [Einstein.PowerShell.LINQ.PSEnumerable]::Union($This, $Other, $IgnoreCase)}
Update-TypeData @TypeDataArgs -MemberName SequenceEquals -Value {param($Other,$IgnoreCase) [Einstein.PowerShell.LINQ.PSEnumerable]::SequenceEquals($This, $Other, $IgnoreCase)}
Update-TypeData @TypeDataArgs -MemberName SetEquals -Value {param($Other,$IgnoreCase) [Einstein.PowerShell.LINQ.PSEnumerable]::SetEquals($This, $Other, $IgnoreCase)}

Update-TypeData @TypeDataArgs -MemberName ToDictionary -Value {param([ScriptBlock]$KeySelector,[ScriptBlock]$ValueSelector,[Boolean]$Force) [Einstein.PowerShell.LINQ.PSEnumerable]::ToDictionary($This, $KeySelector, $ValueSelector, $Force)}

##############################################################################
#.SYNOPSIS
# Creates a Hashtable from a sequence according to specified key selector and
# element selector functions. 
#
#.EXAMPLE
# Get-Process | ComvertTo-Dictionary { $_.Id }
##############################################################################
function ConvertTo-Dictionary {

    [CmdletBinding()]
    param ( 
    
        # A function to extract a key from each element.
        [Alias('k')]
        [Parameter(Position=1,Mandatory=$true)]
        [ScriptBlock]$KeySelector,
    
        # A transform function to produce a result element value from each element.
        [Alias('v')]
        [Parameter(Position=2)]
        [ScriptBlock]$ValueSelector,        

        # A sequence that contains elements to be tested.
        [Parameter(ValueFromPipeline=$true)]
        [Object[]]$InputObject,
    
        # If set, duplicate keys in the sequence will overwrite existing keys in
        # the dictionary. The default behavior is to write an error if a duplicate
        # key is detected.
        [Parameter()]
        [Switch]$Force
    
    )

    begin {
        $Items = New-Object 'System.Collections.Generic.List[Object]'
    }
    process {
        if ($InputObject.Length) {
            $Items.AddRange($InputObject)
        }
    }
    end {
       [Einstein.PowerShell.LINQ.PSEnumerable]::ToDictionary($Items, $KeySelector, $ValueSelector, $Force.IsPresent) 
    }
}

Export-ModuleMember -Function *-*