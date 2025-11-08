using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
namespace GooseNet
{
    public partial class Workout1 : System.Web.UI.Page
    {
        protected bool isTreadmill;
        protected Workout workoutData;
        protected string workoutLapsJsonString;

        protected void Page_Load(object sender, EventArgs e)
        {
            string userAccessToken = GooseNetUtils.GetUserAccessToken(Request.QueryString["userName"]);
            workoutData = GooseNetUtils.GetWorkoutByUATAndID(userAccessToken, Request.QueryString["activityId"]);
            isTreadmill = workoutData.WorkoutCoordsJsonStr == "[]";
            workoutLapsJsonString = GetWorkoutLapsJsonStr();

        }


        protected string GetWorkoutLapsJsonStr()
        {
            string jsonStr = "[";

            foreach (FinalLap currnentLap in workoutData.WorkoutLaps)
            {
                jsonStr += $"{{duration:{currnentLap.LapDurationInSeconds}, pace:{currnentLap.LapPaceInMinKm}}},";
            }


            jsonStr += "]";
            jsonStr.Remove(jsonStr.Length - 2);
            return jsonStr;
        }


        protected string GetDataSamplesJson() => JsonConvert.SerializeObject(workoutData.DataSamples);

        protected string GetLapTableRowsHTML()
        {
            string rowStr = string.Empty;
            if (workoutData.DataSamples == null)
            {
                for (int i = 0; i < workoutData.WorkoutLaps.Count; i++)
                {
                    FinalLap currentLap = workoutData.WorkoutLaps[i];
                    rowStr += $"<tr>" +
                        $"<td>{i + 1}</td>" +
                        $"<td>{currentLap.LapDistanceInKilometers:F2}</td>" +
                        $"<td>{GooseNetUtils.ConvertMinutesToTimeString((float)currentLap.LapDurationInSeconds / 60)}</td>" +
                        $"<td>{GooseNetUtils.ConvertMinutesToTimeString(currentLap.LapPaceInMinKm)}</td>" +
                        $"</tr>";
                }
            }
            else
            {
                for (int i = 0; i < workoutData.WorkoutLaps.Count; i++)
                {
                    FinalLap currentLap = workoutData.WorkoutLaps[i];
                    rowStr += $"<tr>" +
                        $"<td>{i + 1}</td>" +
                        $"<td>{currentLap.LapDistanceInKilometers:F2}</td>" +
                        $"<td>{GooseNetUtils.ConvertMinutesToTimeString((float)currentLap.LapDurationInSeconds / 60)}</td>" +
                        $"<td>{GooseNetUtils.ConvertMinutesToTimeString(currentLap.LapPaceInMinKm)}</td>" +
                        $"<td>{currentLap.AvgHeartRate}</td>" +
                        $"</tr>";
                }
            }
          
            return rowStr;
        }

    }
}