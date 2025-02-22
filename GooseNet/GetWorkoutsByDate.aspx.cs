using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Security.Cryptography.X509Certificates;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class GetWorkoutsByDate : System.Web.UI.Page
    {

        FirebaseService firebaseService;

        protected List<Workout> workouts;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!GooseNetUtils.IsConnectedToUser(Session, Session["requestedAthlete"].ToString()))
            {
                Response.Redirect("NoAccess.aspx");
            }

            firebaseService = new FirebaseService();

            workouts = GetRelevantWorkouts(Request.QueryString["date"]);
            string UAT = GetUserAccessToken();


            AddWorkoutBoxes();
            

        }


        public void AddWorkoutBoxes()
        {
            //dont want to change to reqular for
            int index = 1;
            foreach(Workout currentWorkout in workouts)
            {
                Response.Write($"<div class=\"workout-box\">\r\n" +
                    $"    <div class=\"workout-header\">\r\n  " +
                    $"    <img src=\"{GooseNetUtils.GetUserPicStringByUserName(Session["requestedAthlete"].ToString())}\" alt=\"User Avatar\">\r\n " +
                    $"     <div>\r\n             <h2>{Session["requestedAthlete"].ToString()}</h2>\r\n " +
                    $"       <p>Ran on {currentWorkout.WorkoutDate}</p>\r\n      </div>\r\n    </div>\r\n" +
                    $"     <a href=\"Workout.aspx?userName={Session["requestedAthlete"]}&activityId={currentWorkout.WorkoutId}\"><div class=\"workout-title\">{currentWorkout.WokroutName}</div></a>\r\n    <div class=\"workout-stats\">\r\n " +
                    $"     <div>\r\n        <p class=\"value\">{(currentWorkout.WorkoutDistanceInMeters / 1000.0):F2}</p>\r\n  " +
                    $"      <p>Distance</p>\r\n " +
                    $"     </div>\r\n " +
                    $"     <div>\r\n  " +
                    $"      <p class=\"value\">{ConvertFromSecondsToDurationString(currentWorkout.WorkoutDurationInSeconds)}</p>\r\n" +
                    $"        <p>Time</p>\r\n " +
                    $"     </div>\r\n" +
                    $"      <div>\r\n    " +
                    $"    <p class=\"value\">{ConvertMinutesToTimeString(currentWorkout.WorkoutAvgPaceInMinKm)}</p>\r\n " +
                    $"       <p>Avg Pace</p>\r\n" +
                    $"      </div>\r\n      <div>\r\n" +
                    $"        <p class=\"value\">{currentWorkout.WorkoutAvgHR} bpm</p>\r\n " +
                    $"       <p>Avg Heart Rate</p>\r\n" +
                    $"      </div>\r\n" +
                    $"    </div>\r\n" +
                    $"    <div class=\"map-container\">\r\n " +
                    $"       <div class=\"map\" id=\"map-{index}\"></div>\r\n\r\n " +
                    $"       \r\n    </div>" +
                    $"  </div>");
                index++;
            }
           

        }


        public string GetUserAccessToken() {

            GarminData userData = firebaseService.GetData<GarminData>($"GarminData/{Session["requestedAthlete"]}");
            return userData.userAccessToken;
        } 
        

        // to convert Total workoutDuration from Seconds to a readable duration String
        protected string ConvertFromSecondsToDurationString(int seconds)
        {
         
           if(seconds >= 3600)
           {
                return $"{seconds / 3600}:{(seconds / 60) - (60 * (seconds / 3600))}:{seconds % 60}";
           }

           return $"{seconds / 60}:{seconds % 60}";


        } 
        //to convert pace in minutes double into a string
        protected string ConvertMinutesToTimeString(float minutes)
        {
            // Convert the float minutes to total seconds
            int totalSeconds = (int)(minutes * 60);

            // Calculate minutes and seconds
            int mm = totalSeconds / 60;
            int ss = totalSeconds % 60;

            // Return formatted string in mm:ss format
            return $"{mm:D2}:{ss:D2}";
        }






        public List<Workout> GetRelevantWorkouts(string date)
        {
            
            List<Workout> workouts = new List<Workout>();
            if (!GooseNetUtils.IsGarminConnected(Session["requestedAthlete"].ToString())) Response.Redirect("NoWorkouts.aspx");
            Dictionary<string,Workout> allWorkouts = firebaseService.GetData<Dictionary<string,Workout>>($"Activities/{GetUserAccessToken()}");
           if(allWorkouts == null) Response.Redirect("noWorkouts.aspx");
            foreach(KeyValuePair<string,Workout> workoutKVP in allWorkouts)
            {
                Workout workout = workoutKVP.Value;
                if(workout.WorkoutDate.Replace(" ","") == date)
                {
                    workouts.Add(workout);
                }
            }

            return workouts;
        }
    }
}