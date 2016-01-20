Import-Module LINQ

Describe "Array.Any" {

	It "returns $true" {
		@(1..10).Any({$_ -eq 1}) | Should Be $true
	}

	It "Returns False" {
		@(1..10).Any({$_ -eq 0}) | Should Be $false
	}

}

Describe "Array.All" {

	It "returns $true" {
		@(1..10).All({$_ -gt 0}) | Should Be $true
	}

	It "Returns False" {
		@(1..10).All({$_ -lt 10}) | Should Be $false
	}

}