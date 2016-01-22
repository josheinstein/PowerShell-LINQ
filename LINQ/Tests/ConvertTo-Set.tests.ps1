Import-Module ..\LINQ.psd1 -Force

Describe "ConvertTo-Set" {

    Context "Hashset - Numbers" {

        BeforeEach {

            $Numbers = @(1,2,2,3,4,4,5,6,7,1,8,9,10)

        }

        It "creates a Hashset" {
            $Set = $Numbers | ConvertTo-Set
            { $Set -is [System.Collections.Generic.Hashset[Object]] } | Should Be $true
        }

        It "contains 10 numbers" {
            $Set = $Numbers | ConvertTo-Set
            $Set | Should Be @(1..10)
        }

    }

    Context "Hashset - Strings" {

        BeforeEach {

            $Numbers = @(
                'one','one','two','two','three',
                'four','four','five','six','seven',
                'ONE','eight','nine','ten'
            )

        }

        It "creates a Hashset" {
            $Set = $Numbers | ConvertTo-Set
            { $Set -is [System.Collections.Generic.Hashset[Object]] } | Should Be $true
        }

        It "contains 10 strings" {
            $Set = $Numbers | ConvertTo-Set
            $Set | Should Be @('one','two','three','four','five','six','seven','eight','nine','ten')
        }

        It "contains 11 strings (case sensitive)" {
            $Set = $Numbers | ConvertTo-Set -CaseSensitive
            $Set | Should Be @('one','two','three','four','five','six','seven','ONE','eight','nine','ten')
        }

    }

}