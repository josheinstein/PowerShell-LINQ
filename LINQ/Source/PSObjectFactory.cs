// SUMMARY
// A factory class that efficiently creates PSObject instances out of
// otherwise difficult to use types such as IDataRecord and C# dynamic
// objects.

namespace Einstein.PowerShell.LINQ
{

    using System;
    using System.Data;
    using System.Management.Automation;
    
    /// <summary>
    /// Efficiently converts objects of various types into new PSObject
    /// instances by copying the fields into note properties.
    /// </summary>
    public static class PSObjectFactory {

    	/// <summary>
    	/// Creates a PSObject from the specified IDataRecord implementation.
    	/// </summary>
    	/// <param name="record">The IDataRecord implementation such as the current row in a SqlDataReader.</param>
    	/// <param name="trimSpaces">True to remove leading/trailing spaces from string columns. The default is true.</param>
    	/// <returns>A new PSObject with properties corresponding to the columns of the IDataRecord.</returns>
    	public static PSObject FromDataRecord(IDataRecord record, bool trimSpaces) {

            // Cache the names of the fields
            string[] columnNames = new string[record.FieldCount];
            for ( int i = 0 ; i < record.FieldCount ; i++ ) {
                columnNames[i] = record.GetName( i );
            }

			PSObject obj = new PSObject();

			for (int i = 0; i < record.FieldCount; i++) {

                object value = null;

            	if ( !record.IsDBNull(i) ) {

            		value = record.GetValue(i);

        			// Trim leading and trailing spaces from the column?
	                if (trimSpaces) {
	                    string valueAsString = value as string;
	                    if (valueAsString != null) {
	                        value = valueAsString.Trim();
	                    }
	                }

            	}

                PSNoteProperty prop = new PSNoteProperty(columnNames[i], value);
                obj.Properties.Add(prop);

			}

			return obj;

    	}

    	/// <summary>
    	/// Creates a PSObject from the specified IDataRecord implementation.
    	/// </summary>
    	/// <param name="record">The IDataRecord implementation such as the current row in a SqlDataReader.</param>
    	/// <returns>A new PSObject with properties corresponding to the columns of the IDataRecord.</returns>
    	public static PSObject FromDataRecord(IDataRecord record) {
    		return FromDataRecord(record, true);
    	}

    }

}