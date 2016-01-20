namespace Einstein.PowerShell.LINQ
{

	using System;
	using System.Collections;
	using System.Collections.Generic;
	using System.ComponentModel;
	using System.Diagnostics.Contracts;
	using System.Globalization;
	using System.Linq;
	using System.Management.Automation;
	using System.Threading;

    /// <summary>
    /// Compares two objects using PowerShell language semantics.
    /// </summary>
    public class PSObjectComparer : IComparer, IEqualityComparer, IComparer<PSObject>, IEqualityComparer<PSObject>, IComparer<object>, IEqualityComparer<object>
    {

        private readonly StringComparer _StringComparer;
        private static readonly Lazy<PSObjectComparer> _Default = new Lazy<PSObjectComparer>();

        #region Constructors

        /// <summary>
        /// Initializes a new instance of the <see cref="T:PSObjectComparer"/> class.
        /// </summary>
        public PSObjectComparer( )
            : this( true, null )
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="T:PSObjectComparer"/> class.
        /// </summary>
        /// <param name="ignoreCase">True to ignore case when comparing strings, otherwise false.</param>
        /// <param name="ascending">True to sort in ascending order, otherwise false.</param>
        /// <param name="cultureInfo">The culture info.</param>
        public PSObjectComparer( bool ignoreCase, CultureInfo cultureInfo = null )
        {

            IgnoreCase = ignoreCase;
            CultureInfo = cultureInfo ?? Thread.CurrentThread.CurrentCulture;

            _StringComparer = StringComparer.Create( CultureInfo, IgnoreCase );

        }

        #endregion

        #region Properties

        /// <summary>
        /// A shared default case-insensitive instance of the comparer.
        /// </summary>
        public static PSObjectComparer Default
        {
        	get
        	{
        		return _Default.Value;
        	}
        }

        /// <summary>
        /// True to ignore case when comparing strings, otherwise false.
        /// </summary>
        public bool IgnoreCase
        {
            get;
            private set;
        }

        /// <summary>
        /// Culture information for the thread.
        /// </summary>
        public CultureInfo CultureInfo
        {
            get;
            private set;
        }

        #endregion

        #region Methods

        /// <summary>
        /// Compares two objects and returns a value indicating whether one is less than, equal to, or greater than the other.
        /// </summary>
        /// <param name="x">The first object to compare.</param>
        /// <param name="y">The second object to compare.</param>
        /// <returns>
        /// A signed integer that indicates the relative values of <paramref name="x"/> and <paramref name="y"/>, as shown in the following table.
        /// Less than zero <paramref name="x"/> is less than <paramref name="y"/>.
        /// Zero <paramref name="x"/> equals <paramref name="y"/>.
        /// Greater than zero <paramref name="x"/> is greater than <paramref name="y"/>.
        /// </returns>
        /// <exception cref="T:ArgumentException">
        /// Neither <paramref name="x"/> nor <paramref name="y"/> implements the <see cref="T:IComparable"/> interface.
        /// -or-
        /// <paramref name="x"/> and <paramref name="y"/> are of different types and neither one can handle comparisons with the other.
        /// </exception>
        public int Compare( object x, object y )
        {

            // Short circuit attempt
            if ( ReferenceEquals( x, y ) ) { return 0; }
            if ( ReferenceEquals( x, null ) ) { return -1; }
            if ( ReferenceEquals( y, null ) ) { return 1; }

            // Unwrap PSObject x
            var psX = x as PSObject;
            if ( psX != null ) { x = psX.BaseObject; }

            // Unwrap PSObject y
            var psY = y as PSObject;
            if ( psY != null ) { y = psY.BaseObject; }

            // Are these custom PSObject's with dynamic members?
            var pscX = x as PSCustomObject;
            var pscY = y as PSCustomObject;
            if ( pscX != null && pscY != null ) {

                // Compare each member individually.
                // If the two objects don't contain the exact same properties
                // in the set (order does not matter) then their equality
                // will be affected.
                var allProperties = psX.Properties.Select( p => p.Name ).Union( psY.Properties.Select( p => p.Name ), _StringComparer );
                foreach ( string propertyName in allProperties ) {

                    var propX = psX.Properties[propertyName];
                    var propY = psY.Properties[propertyName];

                    if ( propX == null ) { return -1; }
                    if ( propY == null ) { return 1; }

                    // Defer to the LanguagePrimitives class which can handle type coersion
                    // and powershell semantics for handling strings and other special cases
                    int c = LanguagePrimitives.Compare( propX.Value, propY.Value, IgnoreCase, CultureInfo );
                    if ( c != 0 ) {
                        return c;
                    }

                }

                return 0;

            }
            else {

                // Objects x and y are .NET objects or scalar types (as opposed to PSCustomObject)
                // Defer to the LanguagePrimitives class which can handle type coersion
                // and powershell semantics for handling strings and other special cases

                return LanguagePrimitives.Compare( x, y, IgnoreCase, CultureInfo );

            }

        }

        /// <summary>
        /// Determines whether the specified <see cref="T:Object"/> is equal to this instance.
        /// </summary>
        /// <param name="x">The <see cref="T:Object"/> to compare with this instance.</param>
        /// <param name="y">The y.</param>
        /// <returns>
        /// <c>true</c> if the specified <see cref="T:Object"/> is equal to this instance; otherwise, <c>false</c>.
        /// </returns>
        /// <exception cref="T:ArgumentException">
        /// <paramref name="x"/> and <paramref name="y"/> are of different types and neither one can handle comparisons with the other.
        /// </exception>
        public new bool Equals( object x, object y )
        {

            if ( ReferenceEquals( x, y ) ) {
                return true;
            }

            if ( ReferenceEquals( x, null ) ) {
                return false;
            }

            if ( ReferenceEquals( y, null ) ) {
                return false;
            }

            return Compare( x, y ) == 0;

        }

        /// <summary>
        /// Returns a hash code for this instance.
        /// </summary>
        /// <param name="obj">The obj.</param>
        /// <returns>
        /// A hash code for this instance, suitable for use in hashing algorithms and data structures like a hash table. 
        /// </returns>
        /// <exception cref="T:ArgumentNullException">The type of <paramref name="obj"/> is a reference type and <paramref name="obj"/> is null.</exception>
        public int GetHashCode( object obj )
        {

            // Unwrap PSObject
            var psObj = obj as PSObject;
            if ( psObj != null ) {
                obj = psObj.BaseObject;
            }

            if (obj == null) {
                return 0;
            }

            var strObj = obj as String;
            if (strObj != null) {
                return _StringComparer.GetHashCode(strObj);
            }

            var pscObj = obj as PSCustomObject;
            if ( pscObj != null ) {

                // Object is a custom PSObject.
                // Dynamic members, no GetHashCode implementation.

                // Seed the hash with a prime
                int hash = 13;

                // Include all properties in the hash
                foreach ( var prop in psObj.Properties ) {
                    hash = GetHashCode( hash, prop );
                }

                return hash;

            }
            
            // Object can provide its own hash code (we hope)
            return obj.GetHashCode( );

        }

        /// <summary>
        /// Gets the hash code of a PSPropertyInfo by hashing both its name and value.
        /// </summary>
        /// <param name="hashCode"></param>
        /// <param name="prop"></param>
        /// <returns></returns>
        private int GetHashCode( int hashCode, PSPropertyInfo prop )
        {

            // Hash the property name
            int nameHash = _StringComparer.GetHashCode( prop.Name );
            
            int valueHash = 0;

            if ( prop.IsGettable ) {

                object value = prop.Value;

                string valueAsString = value as String;
                if ( valueAsString != null ) {
                    
                    // Hash the string property value
                    valueHash = _StringComparer.GetHashCode( valueAsString );
                }
                else if ( value != null ) {
                    
                    // Hash other types
                    valueHash = value.GetHashCode( );

                }

            }

            // Combine the hashes along with any previously calculated hash
            int hash = hashCode;
            hash = ( hash * 7 ) + nameHash;
            hash = ( hash * 7 ) + valueHash;

            return hash;

        }

        #endregion

        #region IComparer<PSObject> Members

        /// <summary>
        /// Compares two objects and returns a value indicating whether one is less than, equal to, or greater than the other.
        /// </summary>
        /// <param name="x">The first object to compare.</param>
        /// <param name="y">The second object to compare.</param>
        /// <returns>
        /// Value
        /// Condition
        /// Less than zero
        /// <paramref name="x"/> is less than <paramref name="y"/>.
        /// Zero
        /// <paramref name="x"/> equals <paramref name="y"/>.
        /// Greater than zero
        /// <paramref name="x"/> is greater than <paramref name="y"/>.
        /// </returns>
        int IComparer<PSObject>.Compare( PSObject x, PSObject y )
        {
            return Compare( x, y );
        }

        #endregion

        #region IEqualityComparer<PSObject> Members

        /// <summary>
        /// Determines whether the specified objects are equal.
        /// </summary>
        /// <param name="x">The first object of type <paramref name="T"/> to compare.</param>
        /// <param name="y">The second object of type <paramref name="T"/> to compare.</param>
        /// <returns>
        /// true if the specified objects are equal; otherwise, false.
        /// </returns>
        bool IEqualityComparer<PSObject>.Equals( PSObject x, PSObject y )
        {
            return Equals( x, y );
        }

        /// <summary>
        /// Returns a hash code for this instance.
        /// </summary>
        /// <param name="obj">The obj.</param>
        /// <returns>
        /// A hash code for this instance, suitable for use in hashing algorithms and data structures like a hash table. 
        /// </returns>
        /// <exception cref="T:System.ArgumentNullException">
        /// The type of <paramref name="obj"/> is a reference type and <paramref name="obj"/> is null.
        ///   </exception>
        int IEqualityComparer<PSObject>.GetHashCode( PSObject obj )
        {
            return GetHashCode( obj );
        }

        #endregion

        #region IComparer<object> Members

        /// <summary>
        /// Compares two objects and returns a value indicating whether one is less than, equal to, or greater than the other.
        /// </summary>
        /// <param name="x">The first object to compare.</param>
        /// <param name="y">The second object to compare.</param>
        /// <returns>
        /// A signed integer that indicates the relative values of <paramref name="x"/> and <paramref name="y"/>, as shown in the following table.Value Meaning Less than zero <paramref name="x"/> is less than <paramref name="y"/>. Zero <paramref name="x"/> equals <paramref name="y"/>. Greater than zero <paramref name="x"/> is greater than <paramref name="y"/>.
        /// </returns>
        /// <exception cref="T:System.ArgumentException">Neither <paramref name="x"/> nor <paramref name="y"/> implements the <see cref="T:System.IComparable"/> interface.-or- <paramref name="x"/> and <paramref name="y"/> are of different types and neither one can handle comparisons with the other. </exception>
        int IComparer<object>.Compare( object x, object y )
        {
            return Compare( x, y );
        }

        #endregion

        #region IEqualityComparer<object> Members

        /// <summary>
        /// Determines whether the specified <see cref="System.Object"/> is equal to this instance.
        /// </summary>
        /// <param name="x">The <see cref="System.Object"/> to compare with this instance.</param>
        /// <param name="y">The y.</param>
        /// <returns>
        ///   <c>true</c> if the specified <see cref="System.Object"/> is equal to this instance; otherwise, <c>false</c>.
        /// </returns>
        /// <exception cref="T:System.ArgumentException">
        ///   <paramref name="x"/> and <paramref name="y"/> are of different types and neither one can handle comparisons with the other.</exception>
        bool IEqualityComparer<object>.Equals( object x, object y )
        {
            return Equals( x, y );
        }

        /// <summary>
        /// Returns a hash code for this instance.
        /// </summary>
        /// <param name="obj">The obj.</param>
        /// <returns>
        /// A hash code for this instance, suitable for use in hashing algorithms and data structures like a hash table. 
        /// </returns>
        /// <exception cref="T:System.ArgumentNullException">The type of <paramref name="obj"/> is a reference type and <paramref name="obj"/> is null.</exception>
        int IEqualityComparer<object>.GetHashCode( object obj )
        {
            return GetHashCode( obj );
        }

        #endregion

    }

}
