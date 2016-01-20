Import-Module LINQ

Describe "ConvertTo-Dictionary" {

    Context "Hashtables" {

        BeforeEach {

            $Objects = @(
                [PSCustomObject]@{Name='Axl'; DOB=[DateTime]"1962-02-06"}
                [PSCustomObject]@{Name='Slash'; DOB=[DateTime]"1965-07-23"}
                [PSCustomObject]@{Name='Duff'; DOB=[DateTime]"1964-02-05"}
                [PSCustomObject]@{Name='Izzy'; DOB=[DateTime]"1962-04-08"}
                [PSCustomObject]@{Name='Steven'; DOB=[DateTime]"1965-01-22"}
            )

        }

        It "creates a Hashtable" {
            $Dictionary = $Objects | ConvertTo-Dictionary {$_.Name}
            { $Dictionary -is [Hashtable] } | Should Be $true
        }

        It "has key/object pair" {
            $Dictionary = $Objects | ConvertTo-Dictionary {$_.Name}
            $Dictionary.Axl | Should Not Be $Null
            $Dictionary.Axl.DOB | Should Be ([DateTime]"1962-02-06")
        }

        It "has key/value pair" {
            $Dictionary = $Objects | ConvertTo-Dictionary {$_.Name}	{$_.DOB}
            $Dictionary.Axl | Should Not Be $Null
            $Dictionary.Axl | Should Be ([DateTime]"1962-02-06")
        }

    }

    Context "Duplicate Keys" {

        BeforeEach {

            $Objects = @(
                [PSCustomObject]@{Name='Axl'; DOB=[DateTime]"1962-02-06"}
                [PSCustomObject]@{Name='Slash'; DOB=[DateTime]"1965-07-23"}
                [PSCustomObject]@{Name='Duff'; DOB=[DateTime]"1964-02-05"}
                [PSCustomObject]@{Name='Izzy'; DOB=[DateTime]"1962-04-08"}
                [PSCustomObject]@{Name='Steven'; DOB=[DateTime]"1965-01-22"}
                [PSCustomObject]@{Name='Axl'; DOB=[DateTime]"1900-01-01"}
            )

        }

        It "throws without -force" {
            { $Objects | ConvertTo-Dictionary {$_.Name} } | Should Throw
        }

        It "doesn't throw on duplicate key with -force" {
            { $Objects | ConvertTo-Dictionary {$_.Name} -Force } | Should Not Throw
        }

    }

}