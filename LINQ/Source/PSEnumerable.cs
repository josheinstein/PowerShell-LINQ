namespace Einstein.PowerShell.LINQ
{

    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;
    using System.Management.Automation;

    public static class PSEnumerable {

        private static Func<object, bool> CreatePredicate(ScriptBlock predicate) {
            if (predicate != null) {
                return x => {
                    var context = new List<PSVariable>() {
                        new PSVariable("_", x),
                        new PSVariable("this", x)
                    };
                    return LanguagePrimitives.IsTrue(predicate.InvokeWithContext(null, context, x));
                };
            }
            else {
                return new Func<object, bool>(x => true);
            }
        }
        
        private static Func<object, object> CreateSelector(ScriptBlock selector) {
            if (selector != null) {
                return x => {
                    var context = new List<PSVariable>() {
                        new PSVariable("_", x),
                        new PSVariable("this", x)
                    };
                    var values = selector.InvokeWithContext(null, context, x);
                    if (values.Count == 1) {
                        return values[0];
                    }
                    else {
                        var array = new PSObject[values.Count];
                        values.CopyTo(array,0);
                        return array;
                    }
                };
            }
            else {
                return new Func<object,object>(x => x);
            }
        }
        
        private static T ConvertTo<T>(object value) {
            return (T)LanguagePrimitives.ConvertTo(value, typeof(T));
        }

        private static object ConvertTo(object value, Type type) {
            return LanguagePrimitives.ConvertTo(value, type);
        }

        public static bool All(IEnumerable<object> items, ScriptBlock predicate) {
            return Enumerable.All( items, CreatePredicate(predicate) );
        }

        public static bool Any(IEnumerable<object> items, ScriptBlock predicate) {
            return Enumerable.Any( items, CreatePredicate(predicate) );
        }

        public static int Count(IEnumerable<object> items) {
            return Count(items, null);
        }

        public static int Count(IEnumerable<object> items, ScriptBlock predicate) {
            if (predicate != null) {
                return items.Count( CreatePredicate(predicate) );
            }
            else {
                return items.Count();
            }
        }

        public static object First(IEnumerable<object> items) {
            return First(items, null);
        }
        
        public static object First(IEnumerable<object> items, ScriptBlock predicate) {
            if (predicate != null) {
                return items.FirstOrDefault( CreatePredicate(predicate) );
            }
            else {
                return items.FirstOrDefault();
            }
        }

        public static object Last(IEnumerable<object> items) {
            return Last(items, null);
        }
        
        public static object Last(IEnumerable<object> items, ScriptBlock predicate) {
            if (predicate != null) {
                return items.LastOrDefault( CreatePredicate(predicate) );
            }
            else {
                return items.LastOrDefault();
            }
        }

        public static IEnumerable<object> Reverse(IEnumerable<object> items) {
            return items.Reverse();
        }

        public static IEnumerable<object> Take(IEnumerable<object> items, int count) {
            return items.Take(count);
        }

        public static IEnumerable<object> TakeWhile(IEnumerable<object> items, ScriptBlock predicate) {
            return items.TakeWhile( CreatePredicate(predicate) );
        }

        public static IEnumerable<object> Skip(IEnumerable<object> items, int count) {
            return items.Skip(count);
        }

        public static IEnumerable<object> SkipWhile(IEnumerable<object> items, ScriptBlock predicate) {
            return items.SkipWhile( CreatePredicate(predicate) );
        }

        public static int IndexOf(IEnumerable<object> items, ScriptBlock predicate) {
            var fPredicate = CreatePredicate(predicate);
            int i = 0;
            foreach (var x in items) {
                if (fPredicate(x)) {
                    return i;
                }
                i++;
            }
            return -1;
        }

        public static int IndexOf(IEnumerable<object> items, object value) {
            int i = 0;
            foreach (var x in items) {
                if (LanguagePrimitives.Equals(x, value, true) ) {
                    return i;
                }
                i++;
            }
            return -1;
        }
        
        public static object Single(IEnumerable<object> items) {
            return Single(items, null);
        }
        
        public static object Single(IEnumerable<object> items, ScriptBlock predicate) {
            if (predicate != null) {
                return items.SingleOrDefault(CreatePredicate(predicate));
            }
            else {
                return items.SingleOrDefault();
            }
        }
        
        public static decimal? Average(IEnumerable<object> items, ScriptBlock selector) {
            var fSelector = CreateSelector(selector);
            return items.Average( x => ConvertTo<decimal?>(fSelector(x)) );
        }
        
        public static decimal? Sum(IEnumerable<object> items, ScriptBlock selector) {
            var fSelector = CreateSelector(selector);
            return items.Sum( x => ConvertTo<decimal?>(fSelector(x)) );
        }

        public static decimal? Min(IEnumerable<object> items, ScriptBlock selector) {
            var fSelector = CreateSelector(selector);
            return items.Min( x => ConvertTo<decimal?>(fSelector(x)) );
        }

        public static decimal? Max(IEnumerable<object> items, ScriptBlock selector) {
            var fSelector = CreateSelector(selector);
            return items.Max( x => ConvertTo<decimal?>(fSelector(x)) );
        }
        
        public static IEnumerable<object> Concat(IEnumerable<object> items, IEnumerable<object> other) {
            return items.Concat(other);
        }

        public static IEnumerable<object> Except(IEnumerable<object> items, IEnumerable<object> other, bool? ignoreCase) {
            var comparer = default(IEqualityComparer<object>);
            if (ignoreCase.HasValue) {
                comparer = new Einstein.PowerShell.LINQ.PSObjectComparer(ignoreCase.Value);
            } 
            return items.Except(other, comparer);
        }

        public static IEnumerable<object> Union(IEnumerable<object> items, IEnumerable<object> other, bool? ignoreCase) {
            var comparer = default(IEqualityComparer<object>);
            if (ignoreCase.HasValue) {
                comparer = new Einstein.PowerShell.LINQ.PSObjectComparer(ignoreCase.Value);
            } 
            return items.Union(other, comparer);
        }

        public static IEnumerable<object> Intersect(IEnumerable<object> items, IEnumerable<object> other, bool? ignoreCase) {
            var comparer = default(IEqualityComparer<object>);
            if (ignoreCase.HasValue) {
                comparer = new Einstein.PowerShell.LINQ.PSObjectComparer(ignoreCase.Value);
            } 
            return items.Intersect(other, comparer);
        }

        public static bool SequenceEquals(IEnumerable<object> items, IEnumerable<object> other, bool? ignoreCase) {
            var comparer = default(IEqualityComparer<object>);
            if (ignoreCase.HasValue) {
                comparer = new Einstein.PowerShell.LINQ.PSObjectComparer(ignoreCase.Value);
            } 
            return items.SequenceEqual(other, comparer);
        }
        
        public static bool SetEquals(IEnumerable<object> items, IEnumerable<object> other, bool? ignoreCase) {
            var comparer = default(IEqualityComparer<object>);
            if (ignoreCase.HasValue) {
                comparer = new Einstein.PowerShell.LINQ.PSObjectComparer(ignoreCase.Value);
            } 
            var hashSet = new HashSet<object>(items, comparer);
            return hashSet.SetEquals(other);
        }
        
        public static Hashtable ToDictionary(IEnumerable<object> items, ScriptBlock keySelector, ScriptBlock valueSelector = null, bool force = false) {
            
            var keyFunction = CreateSelector(keySelector);
            var valFunction = CreateSelector(valueSelector);
            
            var table = new Hashtable();
            foreach (var item in items) {
                
                var key = keyFunction(item);
                var val = item;
                if (valueSelector != null) {
                    val = valFunction(item);
                }
                
                if (force) {
                    table[key] = val;
                }
                else {
                    table.Add(key, val);
                }
                
            }
            
            return table;
            
        }

        public static ISet<object> ToSet( IEnumerable<object> items, ScriptBlock selector, bool? ignoreCase )
        {

            var selectorFunc = CreateSelector(selector);
            var comparer = default(IEqualityComparer<object>);
            if ( ignoreCase.HasValue ) {
                comparer = new Einstein.PowerShell.LINQ.PSObjectComparer( ignoreCase.Value );
            }

            return new HashSet<object>( items.Select( selectorFunc ), comparer );

        }

    }

}