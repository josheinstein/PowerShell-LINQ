Import-Module $PSScriptRoot\..\LINQ -Force

Describe 'ConvertTo-Set' {

    Context 'Number Sets' {

        $Numbers = @(1,2,2,3,4,4,5,6,7,1,8,9,10)

        It 'creates a Hashset' {
            $Set = $Numbers | ConvertTo-Set
            { $Set -is [System.Collections.Generic.Hashset[Object]] } | Should Be $true
        }

        It 'contains 10 numbers' {
            $Set = $Numbers | ConvertTo-Set
            $Set | Should Be @(1..10)
        }

    }

    Context 'String Sets' {

        $Numbers = @(
            'one','one','two','two','three',
            'four','four','five','six','seven',
            'ONE','eight','nine','ten'
        )

        It 'creates a Hashset' {
            $Set = $Numbers | ConvertTo-Set
            { $Set -is [System.Collections.Generic.Hashset[Object]] } | Should Be $true
        }

        It 'contains 10 strings' {
            $Set = $Numbers | ConvertTo-Set
            $Set | Should BeExactly @('one','two','three','four','five','six','seven','eight','nine','ten')
        }

        It 'contains 11 strings (case sensitive)' {
            $Set = $Numbers | ConvertTo-Set -CaseSensitive
            $Set | Should BeExactly @('one','two','three','four','five','six','seven','ONE','eight','nine','ten')
        }

    }

    Context 'Object Sets' {

        $Objects = @(
            [PSCustomObject]@{Name='Axl'; DOB=[DateTime]'1962-02-06'}
            [PSCustomObject]@{Name='Slash'; DOB=[DateTime]'1965-07-23'}
            [PSCustomObject]@{Name='Axl'; DOB=[DateTime]'1962-02-06'}
            [PSCustomObject]@{Name='Duff'; DOB=[DateTime]'1964-02-05'}
            [PSCustomObject]@{Name='Izzy'; DOB=[DateTime]'1962-04-08'}
            [PSCustomObject]@{Name='Steven'; DOB=[DateTime]'1965-01-22'}
            [PSCustomObject]@{Name='AXL'; DOB=[DateTime]'1962-02-06'}
        )

        It 'creates a Hashset' {
            $Set = $Objects | ConvertTo-Set
            { $Set -is [System.Collections.Generic.Hashset[Object]] } | Should Be $true
        }

        It 'contains 5 objects' {
            $Set = $Objects | ConvertTo-Set
            $Set.Name | Should BeExactly @('Axl','Slash','Duff','Izzy','Steven')
        }

        It 'contains 6 objects (case sensitive)' {
            $Set = $Objects | ConvertTo-Set -CaseSensitive
            $Set.Name | Should BeExactly @('Axl','Slash','Duff','Izzy','Steven', 'AXL')
        }

    }

    Context 'Selector Sets' {

        $Objects = @(
            [PSCustomObject]@{Name='Axl'; DOB=[DateTime]'1962-02-06'}
            [PSCustomObject]@{Name='Slash'; DOB=[DateTime]'1965-07-23'}
            [PSCustomObject]@{Name='Axl'; DOB=[DateTime]'1962-02-06'}
            [PSCustomObject]@{Name='Duff'; DOB=[DateTime]'1964-02-05'}
            [PSCustomObject]@{Name='Izzy'; DOB=[DateTime]'1962-04-08'}
            [PSCustomObject]@{Name='Steven'; DOB=[DateTime]'1965-01-22'}
            [PSCustomObject]@{Name='AXL'; DOB=[DateTime]'1962-02-06'}
        )

        It 'creates a Hashset' {
            $Set = $Objects | ConvertTo-Set {$_.Name}
            { $Set -is [System.Collections.Generic.Hashset[Object]] } | Should Be $true
        }

        It 'contains 5 strings' {
            $Set = $Objects | ConvertTo-Set {$_.Name}
            $Set | Should BeExactly @('Axl','Slash','Duff','Izzy','Steven')
        }

        It 'contains 6 strings (case sensitive)' {
            $Set = $Objects | ConvertTo-Set {$_.Name} -CaseSensitive
            $Set | Should BeExactly @('Axl','Slash','Duff','Izzy','Steven', 'AXL')
        }

    }

}

Describe 'Array.ToSet' {

    Context 'Number Sets' {

        $Numbers = @(1,2,2,3,4,4,5,6,7,1,8,9,10)

        It 'creates a Hashset' {
            $Set = $Numbers.ToSet()
            { $Set -is [System.Collections.Generic.Hashset[Object]] } | Should Be $true
        }

        It 'contains 10 numbers' {
            $Set = $Numbers.ToSet()
            $Set | Should Be @(1..10)
        }

    }

    Context 'String Sets' {

        $Numbers = @(
            'one','one','two','two','three',
            'four','four','five','six','seven',
            'ONE','eight','nine','ten'
        )

        It 'creates a Hashset' {
            $Set = $Numbers.ToSet()
            { $Set -is [System.Collections.Generic.Hashset[Object]] } | Should Be $true
        }

        It 'contains 10 strings' {
            $Set = $Numbers.ToSet()
            $Set | Should BeExactly @('one','two','three','four','five','six','seven','eight','nine','ten')
        }

        It 'contains 10 strings (case insensitive)' {
            $Set = $Numbers.ToSet($Null, $True)
            $Set | Should BeExactly @('one','two','three','four','five','six','seven','eight','nine','ten')
        }

        It 'contains 11 strings (case sensitive)' {
            $Set = $Numbers.ToSet($Null, $False)
            $Set | Should BeExactly @('one','two','three','four','five','six','seven','ONE','eight','nine','ten')
        }

    }

    Context 'Object Sets' {

        $Objects = @(
            [PSCustomObject]@{Name='Axl'; DOB=[DateTime]'1962-02-06'}
            [PSCustomObject]@{Name='Slash'; DOB=[DateTime]'1965-07-23'}
            [PSCustomObject]@{Name='Axl'; DOB=[DateTime]'1962-02-06'}
            [PSCustomObject]@{Name='Duff'; DOB=[DateTime]'1964-02-05'}
            [PSCustomObject]@{Name='Izzy'; DOB=[DateTime]'1962-04-08'}
            [PSCustomObject]@{Name='Steven'; DOB=[DateTime]'1965-01-22'}
            [PSCustomObject]@{Name='AXL'; DOB=[DateTime]'1962-02-06'}
        )

        It 'creates a Hashset' {
            $Set = $Objects.ToSet()
            { $Set -is [System.Collections.Generic.Hashset[Object]] } | Should Be $true
        }

        It 'contains 5 objects' {
            $Set = $Objects.ToSet()
            $Set.Name | Should BeExactly @('Axl','Slash','Duff','Izzy','Steven')
        }

        It 'contains 5 objects (case insensitive)' {
            $Set = $Objects.ToSet($Null, $True)
            $Set.Name | Should BeExactly @('Axl','Slash','Duff','Izzy','Steven')
        }

        It 'contains 6 objects (case sensitive)' {
            $Set = $Objects.ToSet($Null, $False)
            $Set.Name | Should BeExactly @('Axl','Slash','Duff','Izzy','Steven', 'AXL')
        }

    }

    Context 'Selector Sets' {

        $Objects = @(
            [PSCustomObject]@{Name='Axl'; DOB=[DateTime]'1962-02-06'}
            [PSCustomObject]@{Name='Slash'; DOB=[DateTime]'1965-07-23'}
            [PSCustomObject]@{Name='Axl'; DOB=[DateTime]'1962-02-06'}
            [PSCustomObject]@{Name='Duff'; DOB=[DateTime]'1964-02-05'}
            [PSCustomObject]@{Name='Izzy'; DOB=[DateTime]'1962-04-08'}
            [PSCustomObject]@{Name='Steven'; DOB=[DateTime]'1965-01-22'}
            [PSCustomObject]@{Name='AXL'; DOB=[DateTime]'1962-02-06'}
        )

        It 'creates a Hashset' {
            $Set = $Objects.ToSet({$_.Name})
            { $Set -is [System.Collections.Generic.Hashset[Object]] } | Should Be $true
        }

        It 'contains 5 strings' {
            $Set = $Objects.ToSet({$_.Name})
            $Set | Should BeExactly @('Axl','Slash','Duff','Izzy','Steven')
        }

        It 'contains 5 strings (case insensitive)' {
            $Set = $Objects.ToSet({$_.Name}, $True)
            $Set | Should BeExactly @('Axl','Slash','Duff','Izzy','Steven')
        }

        It 'contains 6 strings (case sensitive)' {
            $Set = $Objects.ToSet({$_.Name}, $False)
            $Set | Should BeExactly @('Axl','Slash','Duff','Izzy','Steven', 'AXL')
        }

    }

}