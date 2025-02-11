using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace GooseNet
{
    public class WorkoutData
    {
        public string workoutName { get; set; }
        public string description { get; set; }

        public string sport = "RUNNING";

        public List<Interval> steps = new List<Interval>();



    }

    public class Interval
    {
        public int stepOrder { get; set; }
        public int repeatValue { get; set; }
        public string type { get; set; }
        public List<Interval> steps { get; set; }
        public string description { get; set; }

        public string durationType { get; set; }
        public double durationValue { get; set; }
        public string intensity { get; set; }

        public string targetType = "PACE";

        public double targetValueLow { get; set; }
        public double targetValueHigh { get; set; }


        public string repeatType { get; set; }

    }



  
}