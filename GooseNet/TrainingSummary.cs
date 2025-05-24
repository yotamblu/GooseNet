﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace GooseNet
{
    public class TrainingSummary
    {
        public string startDate { get; set; }
        public string endDate { get; set; }
        public double distanceInKilometers { get; set; }
        public double averageDailyInKilometers { get; set; }
        public double timeInSeconds { get; set; }
        public double averageDailyInSeconds { get; set; }
        public List<Workout> allWorkouts { get; set; }
    }
}