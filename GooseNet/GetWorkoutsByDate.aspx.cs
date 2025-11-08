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
            int index = 1;
            foreach (Workout currentWorkout in workouts)
            {

                bool isTreadmill = currentWorkout.WorkoutCoordsJsonStr == "[]";
                string hideString = "Style=\"display:none\"";
                Response.Write($@"
        <div class=""workout-box rounded-xl p-6 mb-6"">
            <div class=""workout-header flex items-center justify-between mb-4"">
                <div class=""flex items-center space-x-3"">
                    <img class=""rounded-full w-12 h-12 object-cover"" src=""{GooseNetUtils.GetUserPicStringByUserName(Session["requestedAthlete"].ToString())}"" alt=""User Avatar""/>
                    <div>
                        <h2 class=""text-xl font-semibold text-white"">{Session["requestedAthlete"].ToString()}</h2>
                        <p class=""text-sm text-gray-300"">Ran on {currentWorkout.WorkoutDate}</p>
                    </div>
                </div>
                <!-- Optional: Add a share button here if needed for each workout box -->
            </div>
            
            <a href=""Workout.aspx?userName={Session["requestedAthlete"]}&activityId={currentWorkout.WorkoutId}"" class=""block mb-4"">
                <div class=""workout-title text-2xl font-bold text-white hover:text-blue-300 transition-colors duration-200"">{currentWorkout.WokroutName}</div>
            </a>
            
            <div class=""workout-stats grid grid-cols-2 sm:grid-cols-4 gap-4 mb-6"">
                <div class=""text-center p-2 border-r border-gray-700 last:border-r-0 sm:border-r"">
                    <p class=""value text-2xl font-bold text-blue-300"">{(currentWorkout.WorkoutDistanceInMeters / 1000.0):F2}</p>
                    <p class=""text-sm text-gray-300"">Distance (km)</p>
                </div>
                <div class=""text-center p-2 border-r border-gray-700 last:border-r-0 sm:border-r"">
                    <p class=""value text-2xl font-bold text-blue-300"">{ConvertFromSecondsToDurationString(currentWorkout.WorkoutDurationInSeconds)}</p>
                    <p class=""text-sm text-gray-300"">Time</p>
                </div>
                <div class=""text-center p-2 border-r border-gray-700 last:border-r-0 sm:border-r"">
                    <p class=""value text-2xl font-bold text-blue-300"">{GooseNetUtils.ConvertMinutesToTimeString(currentWorkout.WorkoutAvgPaceInMinKm)}</p>
                    <p class=""text-sm text-gray-300"">Avg Pace (/km)</p>
                </div>
                <div class=""text-center p-2"">
                    <p class=""value text-2xl font-bold text-blue-300"">{currentWorkout.WorkoutAvgHR} bpm</p>
                    <p class=""text-sm text-gray-300"">Avg Heart Rate</p>
                </div>
            </div>
            
            <div class=""map-container rounded-xl overflow-hidden"" {(isTreadmill ? hideString : "")}>
                <div class=""map w-full h-64 bg-gray-800 rounded-xl"" id=""map-{index}""></div>
            </div>
        </div>");
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