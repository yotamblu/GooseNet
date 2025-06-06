﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace GooseNet
{
    public class SleepScore
    {

        public string qualifierKey { get; set; }
        public string value { get; set; }
    }

    public class SleepScoreKVP
    {

        public string Key { get; set; }
        public SleepScore Value { get; set; }
    }


    public class SleepData
    {
        public string SummaryID { get; set; }
        public int SleepDurationInSeconds { get; set; }
        public long SleepStartTimeInSeconds { get; set; }
        public int SleepTimeOffsetInSeconds { get; set; }
        public string SleepDate { get; set; }
        public int DeepSleepDurationInSeconds { get; set; }
        public int LightSleepDurationInSeconds { get; set; }
        public int RemSleepInSeconds { get; set; }
        public int AwakeDurationInSeconds { get; set; }
        public List<SleepScoreKVP> SleepScores { get; set; }
        public SleepScore OverallSleepScore { get; set; }
        public string SleepScoreQualifier;

    }

}