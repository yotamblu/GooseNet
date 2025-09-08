using GooseNet;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace GooseNet
{
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
        public Dictionary<string, Dictionary<string, string>> SleepScores { get; set; }
        public SleepScore OverallSleepScore { get; set; }
        public string SleepScoreQualifier;

    }
}