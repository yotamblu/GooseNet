using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace GooseNet
{
    public class PlannedWorkout
    {
        public string Date {  get; set; }
        public string WorkoutName { get; set; }
        public string Description { get; set; }
        public List<Interval> Intervals {  get; set; }
        public string CoachName { get; set; }
        public List<string>  AthleteNames {  get; set; }
        


    }
}