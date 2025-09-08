using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace GooseNet
{


    public class Summary
    {
        public long ActivityId { get; set; }
        public string ActivityName { get; set; }
        public int DurationInSeconds { get; set; }
        public long StartTimeInSeconds { get; set; }
        public int StartTimeOffsetInSeconds { get; set; }
        public string ActivityType { get; set; }
        public int AverageHeartRateInBeatsPerMinute { get; set; }
        public string DeviceName { get; set; }
        public int MaxHeartRateInBeatsPerMinute { get; set; }
        public bool IsWebUpload { get; set; }
    }


    public class ActivityDetail
        
    {

        // Root-level properties
        public string SummaryId { get; set; }
        public long ActivityId { get; set; }

        // Summary properties (flattened)
        public long SummaryActivityId { get; set; }
        public string ActivityName { get; set; }
        public int DurationInSeconds { get; set; }
        public long StartTimeInSeconds { get; set; }
        public int StartTimeOffsetInSeconds { get; set; }
        public string ActivityType { get; set; }
        public int AverageHeartRateInBeatsPerMinute { get; set; }
        public string DeviceName { get; set; }
        public int MaxHeartRateInBeatsPerMinute { get; set; }
        public bool IsWebUpload { get; set; }

        // Collections
        public List<Sample> Samples { get; set; }
        public List<Lap> Laps { get; set; }
    }


}