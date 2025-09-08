using FireSharp.Config;
using FireSharp;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class sleepEndpoint : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(Request.HttpMethod == "POST")
            {
                string jsonPayload;
                using (StreamReader reader = new StreamReader(Request.InputStream))
                {
                    jsonPayload = reader.ReadToEnd();
                }

              

                Sleep sleep = JsonConvert.DeserializeObject<Root>(jsonPayload).Sleeps[0];
                FirebaseClient client = new FirebaseClient(FireBaseConfig.config);

                SleepData data = new SleepData {
                    AwakeDurationInSeconds = sleep.AwakeDurationInSeconds,
                    DeepSleepDurationInSeconds = sleep.DeepSleepDurationInSeconds,
                    LightSleepDurationInSeconds = sleep.LightSleepDurationInSeconds,
                    OverallSleepScore = sleep.OverallSleepScore,
                    RemSleepInSeconds = sleep.RemSleepInSeconds,
                    SleepDate = sleep.CalendarDate,
                    SleepDurationInSeconds = sleep.DurationInSeconds,
                    SleepScores = sleep.SleepScores,
                    SleepStartTimeInSeconds = sleep.StartTimeInSeconds,
                    SleepTimeOffsetInSeconds = sleep.StartTimeOffsetInSeconds,
                    SummaryID = sleep.SummaryId
                    
                
                };

                client.Set($"SleepData/{sleep.UserAccessToken}/{sleep.CalendarDate}", data);


            }
        }
        
    }

}