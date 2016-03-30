    package dk.miosis.euclido.utility;

    import luxe.Log.*;

    import dk.miosis.euclido.utility.MiosisUtilities;

    class EuclidianRhythmGenerator
    {
        var _bitmask_string:String;
        var _counts:Array<Int>;
        var _remainders:Array<Int>;

        public function new() 
        {
            _debug("---------- EuclidianRhythmGenerator.new ----------");

            _counts = new Array<Int>();
            _remainders = new Array<Int>();
        }

        public function get_bitmask()
        {
            _debug(_bitmask_string);
            return MiosisUtilities.bitmask_string_to_int(_bitmask_string);
        }

        public function get_bitmask_string()
        {
            return _bitmask_string;
        }

        public function generate(steps:Int, pulses:Int):Void
        {
            _debug("---------- EuclidianRhythmGenerator.generate ----------");

            if (pulses > steps)
            {
                _debug("AAAAAAAAAAAAAAAKAÆLAKJÆALKJAL");
            }

            Constants.clear(_counts);
            Constants.clear(_remainders);

            _bitmask_string = "";  

            var divisor = steps - pulses;

            _remainders.push(pulses);
            
            var level = 0;

            do 
            {
                _counts.push(Std.int(divisor / _remainders[level]));
                _remainders.push(divisor % _remainders[level]);
                divisor = _remainders[level];
                ++level;
            }
            while (_remainders[level] > 1); 

            _counts.push(divisor);

            build(level);

            // _debug("********* RESULT : " + _bitmask_string);

            var index = _bitmask_string.indexOf("1");
            _bitmask_string = _bitmask_string.substring(index) + _bitmask_string.substring(0, index);

            _debug("********* RESULT : " + _bitmask_string);
        }

        function build(level:Int):Void
        {
            // _debug("---------- Bjorklund.build ----------" + " level : " + level);

            if (level == -1)
            {
                _bitmask_string += 0;
            }
            else if (level == -2)
            {
                _bitmask_string += 1;
            }                
            else
            {
                for (i in 0..._counts[level])
                {
                    build(level - 1);
                }
                if (_remainders[level] != 0)
                {
                    build(level - 2);
                }
            }
        }
    }
