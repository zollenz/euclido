package dk.miosis.euclido.utility;

import luxe.Log.*;

class MiosisUtilities
{
	public static function clear(arr:Array<Dynamic>)
	{
        #if (cpp || php)
        arr.splice(0, arr.length);
        #else
        untyped arr.length = 0;
        #end
    }

    public static function bitmask_int_to_string(value:Int, size:Int = 64, spaced:Bool = false):String
    { // NOT TESTED
        var str = "";
        var i = size;

        while (i-- > 0)
        {
            if (spaced && i < size - 1 && (i + 1) % 4 == 0) 
            {
                str += " ";
            }

            if ((value & (1 << i)) > 0)
            {
                str += "1";
            }
            else
            {
                str += "0";
            }
        }

        return str;
    }

    public static function bitmask_string_to_int(str:String):Int
    {
        var value = 0;
        var i = 0;

        while (i < str.length)
        {
            if (str.charAt(i) == "1")
            {               
                value = value | (1 << (str.length - i - 1));              
            }

            ++i;
        }

        return value;
    }	
}