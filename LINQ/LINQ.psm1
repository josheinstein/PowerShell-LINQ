# Compile .NET helper classes into memory
&"$PSScriptRoot\Add-SourceFiles.ps1"

##############################################################################
# TYPEDATA
##############################################################################

$TypeDataArgs = @{
    TypeName = 'System.Array'
    MemberType = 'ScriptMethod'
    Force = $true
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

Update-TypeData @TypeDataArgs -MemberName ToDictionary -Value {param([ScriptBlock]$KeySelector,[ScriptBlock]$ValueSelector,[Boolean]$Force) [Einstein.PowerShell.LINQ.PSEnumerable]::ToDictionary($This, $KeySelector, $ValueSelector, $Force, $True)}
Update-TypeData @TypeDataArgs -MemberName ToDictionaryC -Value {param([ScriptBlock]$KeySelector,[ScriptBlock]$ValueSelector,[Boolean]$Force) [Einstein.PowerShell.LINQ.PSEnumerable]::ToDictionary($This, $KeySelector, $ValueSelector, $Force, $False)}
Update-TypeData @TypeDataArgs -MemberName ToSet -Value {param($Selector) [Einstein.PowerShell.LINQ.PSEnumerable]::ToSet($This, $Selector, $True)}
Update-TypeData @TypeDataArgs -MemberName ToSetC -Value {param($Selector) [Einstein.PowerShell.LINQ.PSEnumerable]::ToSet($This, $Selector, $False)}

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
        [Switch]$Force,

        # If this switch is specified, key comparisons will be case-sensitive.
        [Parameter()]
        [Switch]$CaseSensitive
    
    )

    begin {
        # Buffers all of the pipeline input into a collection before
        # converting to a set
        $Items = New-Object 'System.Collections.Generic.List[Object]'
    }
    process {
        if ($InputObject.Length) {
            $Items.AddRange($InputObject)
        }
    }
    end {
        
        $Dictionary = [Einstein.PowerShell.LINQ.PSEnumerable]::ToDictionary($Items, $KeySelector, $ValueSelector, $Force.IsPresent, !$CaseSensitive.IsPresent) 

        Write-Output $Dictionary -NoEnumerate

    }
}

##############################################################################
#.SYNOPSIS
# Creates a HashSet from an input sequence. A set is a collection where each
# value appears only once and it can be compared for equality against another
# set without regard to the order of the values.
#
#.EXAMPLE
# 1,2,1,3,1,4,1,5 | ConvertTo-Set  # produces 1,2,3,4,5
#
#.EXAMPLE
# $ProcessNames = Get-Process | ConvertTo-Set {$_.Name}
##############################################################################
function ConvertTo-Set {

    [CmdletBinding()]
    [OutputType([System.Collections.Generic.HashSet[Object]])]
    param(

        # An optional selector. If specified, this expression produces the value
        # to be included in the set. If this parameter is not specified, the
        # input value itself will be used.
        [Parameter(Position=1)]
        [ScriptBlock]$Selector,

        # An array of values to include in the set. These values may come from
        # the pipeline or be specified directly.
        [Parameter(ValueFromPipeline=$true)]
        [Object[]]$InputObject,

        # If this switch is specified, string comparisons will be case-sensitive.
        # This applies to sets of strings as well as sets of objects (which are
        # compared member by member) when comparing string members.
        [Parameter()]
        [Switch]$CaseSensitive

    )

    begin {
        # Buffers all of the pipeline input into a collection before
        # converting to a set
        $Items = New-Object 'System.Collections.Generic.List[Object]'
    }

    process {
        if ($InputObject.Length) {
            $Items.AddRange($InputObject)
        }
    }

    end {

        $Set = [Einstein.PowerShell.LINQ.PSEnumerable]::ToSet($Items, $Selector, !$CaseSensitive.IsPresent) 

        # -NoEnumerate must be used to avoid unrolling the collection
        Write-Output $Set -NoEnumerate

    }

}
