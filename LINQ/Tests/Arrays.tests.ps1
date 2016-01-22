Import-Module LINQ

$Numbers = @(1..10)

Describe 'Array.Any' {

    It 'returns $true' {
        $Numbers.Any({$_ -eq 1}) | Should Be $true
    }

    It 'returns $false' {
        $Numbers.Any({$_ -eq 0}) | Should Be $false
    }

}

Describe 'Array.All' {

    It 'returns $true' {
        $Numbers.All({$_ -gt 0}) | Should Be $true
    }

    It 'returns $false' {
        $Numbers.All({$_ -lt 10}) | Should Be $false
    }

}

Describe 'Array.CountWhere' {

    It 'counts odd numbers' {
        $Numbers.CountWhere({$_ % 2}) | Should Be 5
    }

    It 'counts without predicate' {
        $Numbers.CountWhere() | Should Be 10
    }

}

Describe 'Array.First' {

    It 'gets first item' {
        $Numbers.First() | Should Be 1
    }

    It 'gets first item matching predicate' {
        $Numbers.First({$_ -gt 5}) | Should Be 6
    }

}

Describe 'Array.Last' {

    It 'gets last item' {
        $Numbers.Last() | Should Be 10
    }

    It 'gets last item matching predicate' {
        $Numbers.Last({$_ -lt 5}) | Should Be 4
    }

}

Describe 'Array.FindIndex' {

    It 'gets index by value' {
        $Numbers.FindIndex(5) | Should Be 4
    }

    It 'gets index by predicate' {
        $Numbers.FindIndex({$_ -eq 5}) | Should Be 4
    }

    It 'cannot find value' {
        $Numbers.FindIndex(0) | Should Be -1
    }

    It 'cannot find predicate' {
        $Numbers.FindIndex({$_ -eq 0}) | Should Be -1
    }

}

Describe 'Array.Single' {

    It 'gets single item matching predicate' {
        $Numbers.Single({$_ -eq 1}) | Should Be 1
    }

    It 'gets null on empty array' {
        @().Single() | Should Be $Null
    }

    It 'throws on multiple results' {
        { $Numbers.Single() } | Should Throw
        { $Numbers.Single({$_ -lt 3}) } | Should Throw
    }

}

Describe 'Array.Skip' {

    It 'skips some items' {
        $Numbers.Skip(5) | Should Be @(6..10)
    }

    It 'skips all items' {
        $Numbers.Skip(10) | Should Be $Null
    }

    It 'skips no items' {
        $Numbers.Skip(0) | Should Be $Numbers
    }

}

Describe 'Array.Take' {

    It 'takes some items' {
        $Numbers.Take(5) | Should Be @(1..5)
    }

    It 'takes all items' {
        $Numbers.Take(10) | Should Be $Numbers
    }

    It 'takes no items' {
        $Numbers.Take(0) | Should Be $Null
    }

}

Describe 'Array.SkipWhile' {

    It 'skips some items' {
        $Numbers.SkipWhile({$_ -le 5}) | Should Be @(6..10)
    }

    It 'skips all items' {
        $Numbers.SkipWhile({$_ -le 10}) | Should Be $Null
    }

    It 'skips no items' {
        $Numbers.SkipWhile({$_ -gt 10}) | Should Be $Numbers
    }

}

Describe 'Array.TakeWhile' {

    It 'takes some items' {
        $Numbers.TakeWhile({$_ -le 5}) | Should Be @(1..5)
    }

    It 'takes all items' {
        $Numbers.TakeWhile({$_ -le 10}) | Should Be $Numbers
    }

    It 'takes no items' {
        $Numbers.TakeWhile({$_ -gt 10}) | Should Be $Null
    }

}

Describe 'Array.Average' {

    It 'averages numbers' {
        $Numbers.Average() | Should Be 5.5
    }

    It 'averages numbers with selector' {
        $Numbers.Average({$_ * 2}) | Should Be 11
    }

}

Describe 'Array.Sum' {

    It 'sums numbers' {
        $Numbers.Sum() | Should Be 55
    }

    It 'sums numbers with selector' {
        $Numbers.Sum({$_ * 2}) | Should Be 110
    }

}

Describe 'Array.Min' {

    It 'gets min value' {
        $Numbers.Min() | Should Be 1
    }

    It 'gets min value with selector' {
        $Numbers.Min({$_ * 2}) | Should Be 2
    }

    It 'gets null from empty set' {
        @().Min() | Should Be $Null
    }

}

Describe 'Array.Max' {

    It 'gets max value' {
        $Numbers.Max() | Should Be 10
    }

    It 'gets max value with selector' {
        $Numbers.Max({$_ * 2}) | Should Be 20
    }

    It 'gets null from empty set' {
        @().Max() | Should Be $Null
    }

}
