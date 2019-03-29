$ErrorActionPreference = 'Stop'

function Add-SourceFile([String[]]$Path) {

    $CompilationUnit = New-Object System.Text.StringBuilder

    $AddTypeArgs = @{}
    $AddTypeArgs.Language = 'CSharpVersion3'
    $AddTypeArgs.ReferencedAssemblies = {@('System.Data', 'System.Xml')}.Invoke()

    if ($PSVersionTable.PSVersion.Major -ge 3) {
        $AddTypeArgs.Language = 'CSharp'
        $AddTypeArgs.ReferencedAssemblies.Add('System.Core')
    }              
    if($PSVersionTable.PSVersion.Major -ge 6){
        $AddTypeArgs.ReferencedAssemblies.Add(
            @(
                'System.Management.Automation',
                'System.Diagnostics.Contracts',
                'System.Data.Common',
                'System.Runtime.Extensions',
                'System.Collections',
                'System.Threading.Thread',
                'System.Linq'
            )
        )
    }

    foreach ($SourcePath in $Path) {

        if ($SourcePath -notlike '*.cs') { throw 'Add-SourceFile only supports the C# language.' }

        $FullSourcePath = Join-Path $PSScriptRoot Source $SourcePath

        [Void]$CompilationUnit.AppendLine([IO.File]::ReadAllText("$FullSourcePath"))
        [Void]$CompilationUnit.AppendLine()

    }

    $AddTypeArgs.TypeDefinition = $CompilationUnit.ToString()

    Add-Type @AddTypeArgs

}

Add-SourceFile @(
    'PSEnumerable.cs'
    'PSObjectComparer.cs'
    'PSObjectFactory.cs'
)
